/*=============================================================================
Assignment: Project 1, Random Web Server/Proxy
Author:     David J. Burger
Language:   ANSI C running on UHUNIX2 (Solaris)
Compile:    by running "make" with included makefile

Class:      ICS 451
Instructor: Edo Biagioni
Due Date:   Sep. 21, 2001
===============================================================================
File:         webselect.c

Description:  This program functions as a random web server/proxy server.  The
              program works by parsing a requested file for hrefs, and then
              randomly returns one of them to the client. The returned file may
              either be local on the system or it may be relayed in a proxy
              fashion.  The program is launched with the command
              ./webselect port [selection]
              The required port parameter indicates the port that the server
              should listen on.  This number must be from 1025 to 65536
              inclusive or the program will terminate.  The selection parameter
              is an optional parameter.  The selection parameter, when present,
              will determine which hyperlink reference is returned the first
              time the server serves a request.  If the selection is out of
              range the server will terminate.  In cases where the selection
              parameter is not present and after the first usage of selection
              the server returns to a random mode.
              
Functions:    int main(int argc, char *argv[]) - main entry point to program
                  and contains the main server loop.
=============================================================================*/
#include <stdio.h>
#include <string.h>
#include <errno.h>

/* for socket functionality */
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <arpa/inet.h>

/* using to ignore SIGPIPE */
#include <signal.h>

/* general definitions */
#include "defs.h"

/* contains helper functions for use with sockets and web servers */
#include "wserv.h"

/* the min and max port allowed for this server to listen on */
#define MIN_PORT 1025
#define MAX_PORT 65536

/* the maximum number of references to be parsed from a page */
#define MAX_REFS 50

/* this defines the maximum queue available for client requests */
#define QUEUE_SIZE 5

/* server requests are parsed in relation to the HOME directory */
#define HOME "/home/1/esb/public_html"
/* #define HOME "/home/23/dburger/public_html" */

/*=============================================================================
Function main

Purpose:  The main entry point of the program.  This function contains the
          major server accept/process cycle for the program.
          
Parameters:
    argc (IN) - number of command line arguments passed to program.
    *argv[] (IN) - array of char *'s to the arguments.
    
Returns:  Since this is a server it operates indefinitely and isn't expected to
          return.  It will however, exit with an error code if an unrecoverable
          error condition results.
=============================================================================*/
int main(int argc, char *argv[]) {

    int sd,   /* server socket */
        sd2,  /* spawned socket */
        addlen, /* length of sockaddr */
        bytesRead,  /* holds bytes read from a recv call */
        buffLeft,   /* used to keep track of space left in buffer */
        useSelection = F; /* keeps track of whether or not we use selection */

    long selection, /* the passed in selection parameter, if present */
         port;  /* port that server listens on */

    struct sockaddr_in sad; /* server sockaddr */
    struct sockaddr_in cad; /* client sockaddr */

    struct protoent *ptrp;  /* pointer to protocol table entry */

    char inBuffer[WEB_BUFF_SIZE]; /* buffer for recv calls */
    char request[WEB_BUFF_SIZE];  /* buffer to hold the request */

    char command[MAX_CMD]; /* command from request */
    char path[MAX_FILE_NAME]; /* path of requested page */
    char version[MAX_VERS]; /* version of request */

    char filename[MAX_FILE_NAME]; /* full path to requested file */
    char filepath[MAX_FILE_NAME]; /* path to requested file      */
    char *p; /* char pointer used in string processing */

    FILE *fp; /* used to open the requested file */

    char urls[MAX_REFS][MAX_REF_LEN]; /* holds the references parsed from
                                         requested page */
    char lo_url[MAX_REF_LEN];         /* used to hold a low case copy of a
                                         reference */
    int numRefs;   /* number of references parsed from the requested page */

    /* ignoring the SIGPIPE signal for this program */
    signal(SIGPIPE, SIG_IGN);

    /* set up the sad structure */
    memset((char *)&sad,0,sizeof(sad)); /* clear the sockaddr structure */
    sad.sin_family = AF_INET;           /* family is internet           */
    sad.sin_addr.s_addr = INADDR_ANY;   /* set the local IP address     */

    /* check for the passed in port number */
    if (argc<2) {
        fprintf(stderr,"Proper usage is %s port [selection]\n");
        exit(1);
    }
     
    /* need to check for non integer and out of range here */
    port = strtol(argv[1],&p,0);
    if (p==argv[1]) {
        fprintf(stderr,"Port number must be numeric.\n");
        exit(1);
    } else if (port<MIN_PORT || port>MAX_PORT) {
        fprintf(stderr,"Port out of range.\n");
        exit(1);
    }

    sad.sin_port = htons((u_short)port);

    /* check for the passed in selection */
    if (argc>2) {
        /* checking for non integer and out of range       */
        selection = strtol(argv[2],&p,0);
        if (p==argv[2]) {
            fprintf(stderr,"Selection must be numeric.\n");
            exit(1);
        } else if (errno==ERANGE) {
            fprintf(stderr,"Selection is an invalid value.\n");
            exit(1);
        } else {
            useSelection = T;
            selection-=1; /* our array is 0 based */
        }
    }

    /* map the tcp transport protocol name to protocol number */
    if (((int)(ptrp = getprotobyname("tcp"))) == 0) {
        /* unable to map tcp to protocol number report Internal server error */
        fprintf(stderr,"Unable to map tcp to protocol number.\n");
        exit(1);
    }

    /* attempt to create the socket */
    if ((sd = socket(PF_INET, SOCK_STREAM, ptrp->p_proto)) < 0) {
        fprintf(stderr,"An error occured creating the socket.\n");
        exit(1);
    }  
        
    /* try to bind to a chosen port */
    if (bind(sd, (struct sockaddr *)&sad, sizeof(sad)) < 0) {
        fprintf(stderr,"An error occured binding to a port.\n");
        close(sd);
        exit(1);
    }

    /* sets the size of the queue */
    if (listen(sd, QUEUE_SIZE) < 0) {
        fprintf(stderr,"An error occured on listen.\n");
        close(sd);
        exit(1);
    }

    /* main loop */
    while (1) {
        addlen = sizeof(cad);
        if ((sd2=accept(sd, (struct sockaddr *)&cad, &addlen)) < 0) {
            /* check for Solaris interrupted by signal failure */
            /* or connection aborted,if this is the case continue loop */
            if (sd2==-1 && (errno==EINTR || errno==ECONNABORTED)) continue;
            fprintf(stderr,"An error occured on accept:  %d.\n",errno);
            close(sd);
            exit(1);
        }

        /* blank out the request buffer */
        request[0] = 0;
        /* a while loop to read the request header of a size up to           */
        /* WEB_BUFF_SIZE                                                     */
        while ((strstr(request,"\r\n\r\n")==NULL)
               && (strlen(request)<WEB_BUFF_SIZE-1)
               && (bytesRead=recv(sd2,inBuffer,sizeof(inBuffer),0))>0) {
            /* null terminate if room, makes the strncat below do less work */
            if (bytesRead<WEB_BUFF_SIZE) inBuffer[bytesRead] = 0;
            /* leave one space for the null character */
            buffLeft = WEB_BUFF_SIZE - strlen(request) - 1;
            strncat(request,inBuffer,buffLeft);
        }

        #ifdef DEBUG
            /* print the request header that has been received */
            printf("request received:\n%s\n",request);
        #endif

        /* parse the command, filename, and version out of the request */
        if ((sscanf(request, "%s %s %s", command, path, version))<3) {
            send(sd2,STATUS_400,strlen(STATUS_400),0); /* bad request */
            close(sd2);
            continue;
        }

        #ifdef DEBUG
            printf("command:  %s\n",command);
            printf("path:     %s\n",path);
            printf("version:  %s\n",version);        
        #endif

        if (strcmp(command,"GET")!=0) {
            send(sd2,STATUS_501,strlen(STATUS_501),0); /* not implemented */
            close(sd2);
            continue;
        }
        
        /* set up the filename with full path to file to load for parsing */
        strcpy(filename,HOME);
        strncat(filename,path,sizeof(filename)-strlen(filename)-1);
        /* set up the filepath with the path to file to load for parsing */
        strcpy(filepath,filename);
        p = strrchr(filepath,'/');
        if (p==NULL) { /* this actually should never happen */
            send(sd2,STATUS_400,strlen(STATUS_400),0); /* bad request */
            close(sd2);
            continue;
        }
        *p = 0; /* chop off the string at that point */

        #ifdef DEBUG
            /* print out the name of the file/path used on the inital read */
            printf("requested file:  %s\n",filename);
            printf("requested path:  %s\n",filepath);
        #endif

        if (!extMatch(filename,".html") && !extMatch(filename,".htm")) {
            /* this is a fix to keep Netscape 4.7 happy by sending a "fake" */
            /* .css or .js file */
            if (extMatch(filename,".css"))
                send(sd2,CSS,strlen(CSS),0);
            else if (extMatch(filename,".js"))
                send(sd2,JS,strlen(JS),0);
            else
                send(sd2,STATUS_400,strlen(STATUS_400),0); /* bad request*/
        } else {
            /* now try to open the requested file */
            if ((fp = fopen(filename,"r"))==NULL) {
                if (errno==EACCES)
                    send(sd2,STATUS_403,strlen(STATUS_403),0); /* forbidden */
                else
                    send(sd2,STATUS_404,strlen(STATUS_404),0); /* not found */
            } else {
                /* parse the refs out of the file and return them in urls */
                numRefs = parseRefs(fp,urls,MAX_REFS);
                fclose(fp);
                if (numRefs==0)
                    send(sd2,STATUS_404,strlen(STATUS_404),0); /* not found */
                else {
                    if (useSelection)
                        useSelection = F; /* only use select once! */
                    else
                        selection = random() % numRefs;
                    if (selection<0 || selection>numRefs-1) {
                        /* select out of range */
                        send(sd2,STATUS_404,strlen(STATUS_404),0); /* ~ found*/
                        close(sd2);
                        close(sd);
                        #ifdef DEBUG
                            printf("Closing - selection out of range.\n");
                        #endif
                        exit(0); /* and then shutdown if out of range */
                    } else {
                        /* make a lower case copy of the url so that we can */
                        /* do all lower case string comparisons             */
                        strcpy(lo_url,urls[selection]);
                        locase(lo_url);
                        if (strncmp(lo_url,"http://",7)==0) {
                            proxySend(sd2, urls[selection]);
                        } else {
                            /* if not http://, must be a path on the server */
                            /* find out if absolute or relative reference */
                            /* and then set up filename with the proper name */
                            if (urls[selection][0]=='/')
                                strcpy(filename,urls[selection]); /* absolute*/
                            else {
                                strcpy(filename,filepath); /* relative */
                                /* making sure not to overflow on these */
                                strncat(filename,"/",
                                        sizeof(filename)-strlen(filename)-1);
                                strncat(filename,
                                        urls[selection],
                                        sizeof(filename)-strlen(filename)-1);
                            }
                            localSend(sd2, filename);
                        }
                    }
                }
            }
        }
        /* close the spawned socket */
        #ifdef DEBUG
            printf("closing spawned socket.\n");
        #endif
        close(sd2);
    }
}
