/*=============================================================================
Assignment: Project 1, Random Web Server/Proxy
Author:     David J. Burger
Language:   ANSI C running on UHUNIX2 (Solaris)
Compile:    by running "make" with included makefile

Class:      ICS 451
Instructor: Edo Biagioni
Due Date:   Sep. 21, 2001
===============================================================================
File:         wserv.c

Description:  This file contains functions that that can be used in the
              operation of a web server.  These functions were designed for use
              with the webselect program.
              
Functions:    void proxySend(int sd, char *url) - used to act as a proxy by
                  forwarding the web page reference by url to the socket sd
                  
              void localSend(int sd, char *filename) - used to act as a web
                  sever by sending the file indicated by filename to socket sd
                  
              void extractHost(char *buff, char* url) - extracts the host name
                  from an http:// style url and places it in buff
                  
              char *extractFilepath(char *url) - returns a char * to the path
                  and file portion of an http:// style url, if none exists it
                  returns null
                                    
              int extractPort(char *s) - extracts and returns the port value
                  from an http:// style url                  
=============================================================================*/
#include <stdio.h>
#include <string.h>
#include <errno.h>

/* for the socket api */
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <arpa/inet.h>

#include "defs.h"

#include "wserv.h"

/*=============================================================================
Function proxySend

Purpose:  This function acts as a proxy, retreiving the resource from the
          passed in url, and sending it through the socket sd.
          
Parameters:
    sd (IN) - the already connected socket that the request will be forwared to
    *url (IN) - the url to forward
    
Returns:  Nothing
=============================================================================*/
void proxySend(int sd, char *url) {
    int sd2,       /* the socket used to connect to *url */
        bytesRead; /* the number of bytes read on a recv call */
    struct sockaddr_in sad; /* to hold the ip address */
    struct hostent *ptrh;   /* pointer to host table entry */
    struct protoent *ptrp;  /* pointer to protocol table entry */
    char buffer[WEB_BUFF_SIZE]; /* for reading in recv/send calls */
    char request[WEB_BUFF_SIZE];  /* used to set up and send the request */
    char host[MAX_REF_LEN];       /* holds the name of the extracted host */
    char *filepath;  /* points to the file/path portion of the url */

    #ifdef DEBUG
        printf("proxySend:  %s\n",url);
    #endif

    memset((char *)&sad,0,sizeof(sad));  /* clear the sockaddr structure */
    sad.sin_family = AF_INET;            /* setting family to Internet */
    sad.sin_port = htons((u_short)extractPort(url)); /* port from the url */

    /* copy host portion into host */
    extractHost(host,sizeof(host),url);
    
    /* get the IP address from the host */
    ptrh = gethostbyname(host);
    if (ptrh==NULL) {
        /* either dns lookup failed or no host information was extracted */
        send(sd,STATUS_404,strlen(STATUS_404),0);  /* not found */
        return;
    }

    /* set up the IP address in the sockaddr */
    memcpy(&sad.sin_addr, ptrh->h_addr, ptrh->h_length);

    /* map the tcp transport protocol name to protocol number */
    if (((int)(ptrp = getprotobyname("tcp"))) == 0) {
        /* unable to map tcp to protocol number report Internal server error */
        send(sd,STATUS_500,strlen(STATUS_500),0);
        return;
    }
    
    /* attempt to create the socket */
    if ((sd2 = socket(PF_INET, SOCK_STREAM, ptrp->p_proto))<0) {
        /* unable to create socket, report Internal server error */
        send(sd,STATUS_500,strlen(STATUS_500),0);
        return;
    }

    /* attempt to connect */
    if ((connect(sd2, (struct sockaddr *)&sad, sizeof(sad)))<0) {
        /* unable to connect, report Not found */
        send(sd,STATUS_404,strlen(STATUS_404),0);
        return;
    }

    /* get the filepath from the url */
    filepath = extractFilepath(url);
    if (filepath==NULL)
        sprintf(request, "GET / HTTP/1.0\r\n\r\n"); /* server default */
    else
        sprintf(request,"GET %s HTTP/1.0\r\n\r\n",filepath);

    #ifdef DEBUG
        printf("sending request:  %s\n",request);
    #endif

    /* initiate the request */
    send(sd2,request,strlen(request),0);    

    /* read all incoming data and proxy it to the client */
    while ((bytesRead=recv(sd2,buffer, sizeof(buffer),0))>0)
        send(sd,buffer,bytesRead,0);
    
    close(sd2); /* close the spawned client socket */
}


/*=============================================================================
Function localSend

Purpose:  This function does the work of acting like a web server.  It attempts
          to open the file represented by filename, and sends and appropriate
          headers through socket descriptor sd.
          
Parameters:
    sd (IN) - the already connected socket that the file will be sent to
    *filename (IN) - the file to be sent to sd
    
Returns:  Nothing
=============================================================================*/
void localSend(int sd, char *filename) {
    char lofilename[MAX_FILE_NAME]; /* to hold a low case vers. of filename */
    char buffer[WEB_BUFF_SIZE]; /* used to send data to the client */
    FILE *fp;  /* FILE * for opening file to send */
    int bytesRead; /* keeps track of the bytes read from the file */
    char headerField[MAX_HEADER_RESPONSE_STR]; /* used for pass header flds*/

    #ifdef DEBUG
        printf("localSend:  %s\n",filename);
    #endif

    /* make a lower case copy of the filename for easier string comparison */
    strcpy(lofilename,filename);
    locase(lofilename);

    /* figure out and set up the Content-type note that if we don't recognize*/
    /* the extension we send a 501 Not implemented                           */
    if (extMatch(lofilename,".html") || extMatch(lofilename,".htm")) {
        sprintf(headerField,CON_TYPE_HTML);
    } else if (extMatch(lofilename,".text") || extMatch(lofilename,".txt")) {
        sprintf(headerField,CON_TYPE_TEXT);
    } else if (extMatch(lofilename,".jpeg") || extMatch(lofilename,".jpg")) {
        sprintf(headerField,CON_TYPE_JPEG);
    } else if (extMatch(lofilename,".gif")) {
        sprintf(headerField,CON_TYPE_GIF);
    } else {
        send(sd,STATUS_400,strlen(STATUS_400),0); /* bad request */
        return;
    }

    /* now try to open the requested file */
    if ((fp = fopen(filename,"r"))==NULL) {
        if (errno==EACCES)
            send(sd,STATUS_403,strlen(STATUS_403),0); /* forbidden */
        else
            send(sd,STATUS_404,strlen(STATUS_404),0); /* not found */
        return;
    }

    send(sd,STATUS_200,strlen(STATUS_200),0);   /* OK */
    send(sd,headerField,strlen(headerField),0); /* Content-type */

    /* set up and send a Content-length */
    sprintf(headerField,"Content-length: %d\r\n\r\n",filesize(filename));
    send(sd,headerField,strlen(headerField),0);

    /* now read and send the entire file */
    while (!feof(fp)) {
       bytesRead = fread(buffer,1,sizeof(buffer),fp);
       send(sd,buffer,bytesRead,0);
    }

    close(fp); /* close the file */
}
/*=============================================================================
Function extractHost

Purpose:  This function extracts the host from an
              http://host:port/filepath
          style string.
          
Parameters:
    *buff (OUT) - the extracted host is placed in this buffer
    length (IN) - the length of buff
    *url (IN) - the http:// style url to pull the host from.  NOTE:  this
                function requires an http:// style string
        
Returns:  The extracted host string is placed in buff
=============================================================================*/
void extractHost(char *buff, int length, char* url) {
    char *cp = url; /* char * for string operations */
    int skip; /* the length of the found host */
    /* point past the http:// */
    cp+=7;
    /* now find the distance to the end of the host indicated by a : or a /  */
    /* or to the end of the string                                           */
    skip = strcspn(cp,":/");
    buff[0] = 0;
    strncat(buff,cp,skip < length - 1 ? skip : length - 1);
}

/*=============================================================================
Function extractFilepath

Purpose:  This function returns a pointer to the filepath portion of an http://
          style url including the leading /
          
          http://host:port/filepath
          
Parameters:
    *url (IN) - the http:// style url to pull the filepath from
    
Returns:  a pointer to the filepath portion of the url or null if it can't be
          found
=============================================================================*/
char *extractFilepath(char *url) {
    char *cp = url; /* char * for string operations */
    /* point past the http:// */
    cp+=7;
    if (cp=='\0') return NULL; /* if that is the end of string return NULL */
    /* filepath will start with first /  or NULL if not found */
    return strchr(cp,'/');
}

/*=============================================================================
Function extractPort

Purpose:  This function determines a port number from a passed in http:// style
          URL.  Since most http:// style URLs do not include a port, function
          returns 80 if the port number is not present or an error occurs in
          extracting the port number
          
          http://host:port/filepath
          
Parameters:
    *url (IN) - the http:// style URL to extract the port from, NOTE: this
                function requires *url to point at an http:// style string
    
Returns:  The port number extracted from the http:// style URL or 80 if it is
          not present or can't be determined
=============================================================================*/
int extractPort(char *url) {
    char *cp = url; /* char * for string operations */
    int port; /* holds conversion of string to numeric */
    /* look for the first : */
    cp = strchr(cp,':');
    if (cp==NULL)
        return 80;  /* no colon, assume 80 */
    /* skip over the first : */
    cp++; 
    if (cp=='\0')
        return 80; /* we are at the end of the string assume 80 */
    /* look for the second : */
    cp = strchr(cp,':');
    if (cp==NULL)
        return 80; /* second colon not found, assume 80 */
    cp++;
    if (cp=='\0')
        return 80; /* we are at the end of the string assume 80 */
    port = strtol(cp,NULL,0);
    if (errno==ERANGE)
        return 80;  /* error getting the port, assume 80 */
    else
        return port;
}

/*=============================================================================
Function parseRefs

Purpose:  This function parses href= values out of a file.
          
Parameters:
    *fp (IN) - a pointer to the open file to extract references out of
    urls (OUT) - a two dimensional array to put the references in
    max (IN) - the maximum number of references we can store in the array
    
Returns:  the number of references returned in urls[][]
=============================================================================*/
int parseRefs(FILE *fp, char urls[][MAX_REF_LEN], int max) {

    char buffer[WEB_BUFF_SIZE];  /* buffers used for reading from the file */
    char lobuffer[WEB_BUFF_SIZE];/* making a low case copy for parsing */
    int start, length;  /* to track start and length of a reference */
    char *cp;      /* used as the pointer into the buffer when parsing */
    int urlcount = 0;/* used to keep track of the number of references found */

    /* main parsing loop, loops through the contents of  */
    /* the file, on line at a time, looking for href=    */
    while((fgets(buffer,sizeof(buffer),fp))!=NULL) {
        /* make a lo case copy of the input */
        strcpy(lobuffer,buffer);
        locase(lobuffer);
        /* find the first href= */
        cp = strstr(lobuffer,"href=");
        while (cp!=NULL) {
            /* point past the href= */
            cp+=5;
            cp+=strspn(cp," \'\""); /* point past spaces or quoting */
            start = cp - lobuffer; /* keep track of the start position */
            length = strcspn(cp," \'\">"); /* length to end character */
            if (length>0) {
                /* make sure we don't overflow urls */
                if (length<MAX_REF_LEN) {
                    urls[urlcount][0] = 0;
                    strncat(urls[urlcount++],buffer+start,length);
                    #ifdef DEBUG
                        printf("parsed:  %s\n",urls[urlcount-1]);
                    #endif
                    if (urlcount==max) return max;
                }
            }
            /* find the next href= for the next loop   */
            cp = strstr(cp,"href=");
        }
    }
    return urlcount;
}
