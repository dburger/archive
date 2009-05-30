/*=============================================================================
Assignment: Project 3, websearch
Author:     David J. Burger
Language:   ANSI C running on UHUNIX2 (Solaris)
Compile:    by running "make" with included makefile
Class:      ICS 651
Instructor: Edo Biagioni
Due Date:   Apr. 19, 2002
===============================================================================
File:         websearch.c
Description:  this program does a "webgrep" following links to a specified
              depth
              
Exceution:    websearch [OPTION...] pattern URL+
              valid options are:
              -i   specifies case-independent matching
              -l   specifies show matching URLs, not lines
              -v   specifies show non-matching lines or URLs
              -d=N specifies search depth, default=0
              -t=N specifies timeout in secs, default=0
=============================================================================*/
#include <stdio.h>
#include <string.h>
#include <errno.h>

#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <arpa/inet.h>

#include <signal.h>

#include "list.h" /* list functionality */
#include "trie.h" /* trie functionality */

#define MAX_PORT 65535            /* max acceptable port */
#define MAX_URL 255               /* max URL string length handled */
#define MAX_BUF 5000              /* buffer size used for reading */
#define DEFAULT_SEARCH_DEPTH 0    /* this is, only the provided URL */
#define DEFAULT_CONNECT_TIMEOUT 0 /* that is, doesn't time out */

/* represents a URL to process for matches */
struct url_entry {
  char *url; /* the URL */
  int depth; /* the search depth of the URL */
};

/* global list, used as a queue for BFS style processing of URLs to spider */
struct list *url_entries;

/* global trie, used to reject duplicates URLs*/
struct trie *url_trie;

/* global variables for storing command line parameter values with defaults */
int case_independent = 0;
int only_show_url = 0;
int show_non_matching = 0;
int search_depth = DEFAULT_SEARCH_DEPTH;
int connect_timeout = DEFAULT_CONNECT_TIMEOUT;
char *pattern = NULL;

/* functions alphabetical order for easier location, forward declares here */
int send_all(int sd, char *buf, int len);
char *strcasestr(char *haystack, char *needle);
int url_content_ok(struct sockaddr *sad, char *url,char *host, int port,
                   char *fullpath);
struct url_entry *url_entry_init(char *url, int depth);
void url_report(char *url, int matches);

/*=============================================================================
Function connect_alarm

Purpose: used as the callback for interrupt during connect
          
Parameters:
    signo (IN) - signal number of signal causing interrupt, not used
        
Returns: nothing, lets the connect timeout
=============================================================================*/
void connect_alarm(int signo) {
  return;
}

/*=============================================================================
Function line_report

Purpose: prints out feedback for the given line
          
Parameters:
    *url (IN) - URL containing the line
    line (IN) - line number of the file that we are reporting on
    *buf (IN) - the line data
    matches (IN) - 1 if the line had a match, 0 otherwise
        
Returns: prints out the appropriate report
=============================================================================*/
void line_report(char *url, int line, char *buf, int matches) {
  if (only_show_url) return;
  if ((matches && !show_non_matching) || (!matches && show_non_matching))
    printf("%s(%d): %s\n",url,line,buf);
}

/*=============================================================================
Function my_connect

Purpose: wrapper around the connect call that includes a timeout
          
Parameters:
    sd (IN) - socket descriptor to connect
    *sad (IN) - sockaddr structure for connection
    sad_size (IN) - size of the sockaddr parameter
    timeout (IN) - timeout in seconds for connection or 0 if none
        
Returns: regular connect return with the possiblity of timeout
=============================================================================*/
int my_connect(int sd, struct sockaddr *sad, int sad_size, int timeout) {
  int result;
  void (*old_sig_handler)(int);
  if (timeout>0) {
    old_sig_handler = signal(SIGALRM, connect_alarm); /* replace interrupt */
    alarm(timeout); /* set timeout value */
  }
  result = connect(sd, sad, sad_size);
  if (timeout>0) {
    alarm(0); /* clear timeout */
    signal(SIGALRM, old_sig_handler); /* original interrupt */
  }
  return result;
}

/*=============================================================================
Function parse_url

Purpose: parses a URL into host, port, and path, returns 1 if successful,
          otherwise returns 0
          
Parameters:
    *url (IN)  - the URL to parse
    *host (OUT) - host part of URL
    *port (OUT) - port of URL
    *path (OUT) - path part of URL
    *fullpath (OUT) - fullpath of URL, meaning includes filename
        
Returns: if the parse was successful 1 is returned and the associated values
         are filled, otherwise 0 is returned
=============================================================================*/
int parse_url(char *url, char *host, int *port, char *path, char *fullpath) {
  int i;
  char *q, *p = url + strlen("http://");
  if (strncmp(url,"http://",strlen("http://"))) return 0;
  i = strcspn(p,":/"); /* find the length of the host part */
  host[0] = 0;
  strncat(host,p,i); /* copy host part to host */
  p+=i; /* advance p past the host */
  if (*p==':') {
    /* we have a port number */
    p++; /* point at the port number */
    *port = strtol(p,&q,0);
    if (p==q || *port<0 || *port > MAX_PORT) return 0;
    p = q;
  } else
    *port = 80; /* default port number */
  /* now process the path part */
  if (*p==0) {
    strcpy(fullpath,"/");
    strcpy(path,"/");
  } else if (*p!='/') {
    return 0; /* invalid path */
  } else {
    strcpy(path,p);
    strcpy(fullpath,p);
    /* last part of fullpath is directory or file??? used to set path */
    p = path + strlen(path) - 1; /* point at end */
    if (*p=='/') return 1; /* it's all path */
    while (*p!='/') p--; /* find last / */
    /* now see if there is a period in the part past the last / */
    if ((q = strpbrk(p,"."))==NULL) {
      /* no peroid in remaining string, must be all path */
      strncat(path,"/",1);
    } else {
      /* period in remaining string, must be file, truncate path */
      p[1] = 0;
    }
  }
  return 1;
}

/*=============================================================================
Function process_hrefs

Purpose: processes the hrefs on a page adding them to the end of the queue
          
Parameters:
    *line (IN) - line to process for hrefs
    *server_context (IN) - server part of URL containing line
    *full_context (IN) - server and path part of URL containing line
    context_depth (IN) - the depth in the spider of the page containing line
        
Returns: adds found URLs from href tags to the end of the queue
=============================================================================*/
void process_hrefs(char *line, char *server_context, char *full_context,
                   int context_depth) {
  int len;
  char *p = line;
  char url[MAX_URL];
  while ((p = strcasestr(p,"a href="))) {
    p += strlen("a href=");
    p += strspn(p," '\""); /* skip anything before the URL */
    len = strcspn(p," '\">"); /* find the termination of the URL */
    if (*p=='#' || strncasecmp(p,"mailto:",strlen("mailto:"))==0) return;
    url[0] = 0; /* prepare for strncat */
    /* three cases for URL, full, relative to server, relative to context */
    if (strncasecmp(p,"http://",strlen("http://"))==0 && len+1<MAX_URL) {
      /* full URL and length OK */
      strncat(url,p,len);
    } else if (*p=='/' && strlen(server_context)+len+1<MAX_URL) {
      /* relative to server URL and length OK */
      strncat(url,server_context,strlen(server_context));
      strncat(url,p,len);
    } else if (strlen(full_context)+len+1<MAX_URL) {
      /* relative to context URL and length OK */
      strncat(url,full_context,strlen(full_context));
      strncat(url,p,len);
    } else {
      /* URL too long for our MAX_URL */
      return;
    }
    /* try to put URL in the trie with allow duplicates = false */
    if (trie_insert(url_trie,url,0)) {
      list_insert_back(url_entries,url_entry_init(url,context_depth+1));
#ifdef DEBUG
      printf("process_hrefs: inserting new URL: %s\n",url);
#endif
    } else {
#ifdef DEBUG
      printf("process_hrefs: rejecting duplicate URL: %s\n",url);
#endif
    }
  }
}

/*=============================================================================
Function process_page

Purpose: to search the given page for matches as specified in the command line
         parameters.
          
Parameters:
    *sad (IN) - prepared sockaddr structure
    *host (IN) - the host we are connecting to
    port (IN) - the port we are connecting to
    *fullpath (IN) - the path to the resource we are requesting from host
    *url - URL for page
    *server_context - server part of URL for relative hyperlinks
    *full_context - server and path part of URL for relative hyperlinks
    depth - search depth of page

Returns: nothing, processes the page giving proper reports and adding links
         to the pages to be spidered if under specified depth
=============================================================================*/
void process_page(struct sockaddr *sad, char *host, char *fullpath, char *url,
                  char *server_context, char *full_context, int depth) {
  int sd, done, line, new_bytes, num_bytes, line_match, page_match, start, end;
  char get_request[MAX_URL + strlen("GET  HTTP/1.0\r\n\r\n")];
  char buf[MAX_BUF+1]; /* +1 to let us read MAX_BUF and still null terminate */

  if ((sd=socket(PF_INET, SOCK_STREAM, 0))==-1) {
    printf("unable to create socket\n");
    exit(1);
  }

  if (my_connect(sd,sad,sizeof(*sad),connect_timeout)<0) {
    close(sd);
    if (errno==EINTR)
      printf("connect to %s timed out\n",host);
    else
      printf("unable to connect to %s\n",host);
    return;
  }

  sprintf(get_request,"GET %s HTTP/1.0\r\n\r\n",fullpath);

#ifdef DEBUG
  printf("  sending request: %s",get_request);
#endif

  if (send_all(sd,get_request,strlen(get_request))<strlen(get_request)) {
    printf("problem sending GET request\n");
    close(sd);
    return;
  }

  done = line = num_bytes = page_match = 0;

  while(!done) {

    /* try to get a full buffer of data */
    do {
      new_bytes = recv(sd,buf+num_bytes,MAX_BUF-num_bytes,0);
      if (new_bytes>0)
        num_bytes+=new_bytes;
      else if (new_bytes==0)
        done = 1;
      else if (new_bytes==-1) {
        printf("problem encountered on recv call\n");
        done = 1;
      }
    } while (num_bytes<MAX_BUF && !done);

    buf[num_bytes] = 0; /* terminate for string processing */
    line = start = 0;

    /* process the buffer of data */
    while ((end = strcspn(buf+start,"\n"))+start!=num_bytes) {
      buf[start+end] = 0; /* null terminate */
      if (case_independent)
        line_match = strcasestr(buf+start,pattern) != NULL;
      else
        line_match = strstr(buf+start,pattern) != NULL;
      if (line_match) page_match = 1;
      if (depth < search_depth)
        process_hrefs(buf+start, server_context, full_context, depth);
      line_report(url,line++,buf+start,line_match);
      start+=end+1; /* position for next search */
    }
    /* calculate bytes left over in buf without /n */
    num_bytes -= start;
    if (done) {
      /* process the last line, in MOST cases this is </html> */
      if (case_independent)
        line_match = strcasestr(buf+start,pattern) != NULL;
      else
        line_match = strstr(buf+start,pattern) != NULL;
      if (line_match) page_match = 1;
      if (depth < search_depth)
        process_hrefs(buf+start, server_context, full_context, depth);
      line_report(url,line++,buf+start,line_match);
    } else if (num_bytes==MAX_BUF) {
      /* full buffer with no \n */
      num_bytes = 0; /* allow full buffer read on next pass */
      line--; /* adjust line counter back to proper line */
    } else if (num_bytes) {
      /* bytes left in buffer with no \n, reposition */
      memmove(buf,buf+start,num_bytes);
    } else {
      /* last byte read was \n */
      num_bytes = 0;
    }

  }

  close(sd);
  url_report(url, page_match);
}

/*=============================================================================
Function process_url_entry

Purpose: processes a URL entry for matches as specified in input args
          
Parameters:
    *ue (IN) - a pointer to the url_entry to process
        
Returns: nothing, processes the url_entry
=============================================================================*/
void process_url_entry(struct url_entry *ue) {
  int port;
  char host[MAX_URL], path[MAX_URL], fullpath[MAX_URL], full_context[MAX_URL],
       server_context[MAX_URL], buf[MAX_URL];
  struct hostent *he;
  struct sockaddr_in sad;

  if (!parse_url(ue->url,host,&port,path,fullpath)) {
    printf("error parsing URL: %s, URL discarded\n",ue->url);
    return;
  }

  strcpy(full_context,"http://");
  strncat(full_context, host, strlen(host));
  if (port!=80) {
    strncat(full_context,":",1);
    sprintf(buf,"%d",port);
    strncat(full_context,buf,strlen(buf));
  }
  strcpy(server_context,full_context);
  strncat(full_context, path, strlen(path));

#ifdef DEBUG
  printf("\nProcessing(%d) %s\n", ue->depth, ue->url);
  printf("  host:           %s\n",host);
  printf("  port:           %d\n",port);
  printf("  path:           %s\n",path);
  printf("  fullpath:       %s\n",fullpath);
  printf("  full context:   %s\n",full_context);
  printf("  server context: %s\n",server_context);
#endif

  if ((he=gethostbyname(host))==NULL) {
    printf("unable to resolve host %s\n",host);
    return;
  }

  memset((char *)&sad,0,sizeof(sad));
  sad.sin_family = AF_INET;
  sad.sin_port = htons(port);
  memcpy(&sad.sin_addr,he->h_addr,he->h_length);

  if (url_content_ok((struct sockaddr *)&sad,ue->url, host,port,fullpath))
    process_page((struct sockaddr *)&sad,host,fullpath,ue->url,server_context,
                 full_context,ue->depth);
}

/*=============================================================================
Function send_all

Purpose: send does not necessarily send the entire buffer in one call, this
          wrapper function continues sending until len bytes have been sent
          
Parameters:
    sd  (IN) - socket descriptor to send on
    *buf (IN) - buffer containing data to send
    len (IN) - length of the buffer
        
Returns: the number of bytes send, which will be less than len if problem
=============================================================================*/
int send_all(int sd, char *buf, int len) {
  int i, bytes_sent = 0;
  while (bytes_sent<len) {
    if ((i = send(sd,buf+bytes_sent,len-bytes_sent,0))==-1)
      return bytes_sent;
    bytes_sent+=i;
  }
  return bytes_sent;
}

/*=============================================================================
Function strcasestr

Note: contributed to ICS 451 student by Edo Biagioni, Fall 2001, thanks Edo!

Purpose: case independent strstr
          
Parameters:
    *haystack (IN) - string searching in
    *needle (IN) - string searching for
        
Returns: pointer to found needle or NULL if not found
=============================================================================*/
char *strcasestr(char *haystack, char *needle) {
  int i;
  int nlength = strlen (needle);
  int hlength = strlen (haystack);
  if (nlength > hlength) return NULL;
  if (hlength <= 0) return NULL;
  if (nlength <= 0) return haystack;
  /* hlength and nlength > 0, nlength <= hlength */
  for (i = 0; i <= (hlength - nlength); i++) {
    if (strncasecmp (haystack + i, needle, nlength) == 0) {
      return haystack + i;
    }
  }
  /* substring not found */
  return NULL;
}

/*=============================================================================
Function url_content_ok

Purpose: determines if the content at the given URL is ok for processing, that
         is it is text/plain or text/html with no content encoding
          
Parameters:
    *sad (IN) - prepared sockaddr structure
    *url (IN) - the URL we are checking
    *host (IN) - the host we are connecting to
    port (IN) - the port we are connecting to
    *fullpath (IN) - the path to the resource we are requesting from host
        
Returns: 1 if ok to process, 0 otherwise
=============================================================================*/
int url_content_ok(struct sockaddr *sad, char *url, char *host, int port,
                   char *fullpath) {
  int sd, content_ok, done, new_bytes, num_bytes, line, start, end;
  char head_request[MAX_URL + strlen("HEAD  HTTP/1.0\r\n\r\n")];
  char buf[MAX_BUF+1]; /* +1 to let us read MAX_BUF and still null terminate */

  if ((sd=socket(PF_INET, SOCK_STREAM, 0))==-1) {
    printf("unable to create socket\n");
    exit(1);
  }

  if (my_connect(sd,sad,sizeof(*sad),connect_timeout)<0) {
    close(sd);
    if (errno==EINTR)
      printf("connect to %s timed out\n",host);
    else
      printf("unable to connect to %s\n",host);
    return 0;
  }

  sprintf(head_request,"HEAD %s HTTP/1.0\r\n\r\n",fullpath);

#ifdef DEBUG
  printf("  sending request: %s",head_request);
#endif

  if (send_all(sd,head_request,strlen(head_request))<strlen(head_request)) {
    printf("could not send entire HEAD request\n");
    close(sd);
    return 0;
  }

  done = num_bytes = 0;

  /* try to get a buffer of data, we assume HEAD will fit in MAX_BUF bytes */
  do {
    new_bytes = recv(sd,buf+num_bytes,MAX_BUF-num_bytes,0);
    if (new_bytes>0)
      num_bytes+=new_bytes;
    else if (new_bytes==0)
      done = 1;
    else if (new_bytes==-1) {
      printf("problem encountered on recv call\n");
      done = 1;
    }
  } while (num_bytes<MAX_BUF && !done);

  buf[num_bytes] = 0; /* null terminate what was read */
  content_ok = line = start = 0;

  /* process the HEAD buffer */
  while ((end = strcspn(buf+start,"\n"))+start!=num_bytes) {
    buf[start+end] = 0; /* null terminate */
    if (line==0) {
      if (strcasestr(buf+start,"200") == NULL) {
        printf("URL rejected(%s): %s\n",url,buf+start);
        content_ok = 0;
        break;
      }
    } else {
      if (strcasestr(buf+start,"Content-Type:")) {
        if (strcasestr(buf+start,"Content-Type: text/html") ||
            strcasestr(buf+start,"Content-Type: text/plain"))
          content_ok = 1;
        else {
          printf("URL rejected(%s): %s\n",url,buf+start);
          content_ok = 0;
          break;
        }
      }
      if (strcasestr(buf+start,"Content-Encoding:")) {
        printf("URL rejected(%s): %s\n",url,buf+start);
        content_ok = 0;
        break;
      }
    }
    /* some, like www.yahoo.com, send more than HEAD ??? so we break */
    if (strcmp(buf+start,"\r")==0) break;
    start+=end+1; /* position for next search */
    line++;
  }

  close(sd);

  return content_ok;
}

/*=============================================================================
Function url_entry_free

Purpose: frees a url_entry and the memory associated with a url_entry
          
Parameters:
    *ue (IN) - a pointer to the url_entry to free
        
Returns: nothing, the memory associated is freed
=============================================================================*/
void url_entry_free(struct url_entry *ue) {
  if (ue->url!=NULL) free(ue->url);
  free(ue);
}

/*=============================================================================
Function url_entry_init
Purpose: creates a new url_entry structure and returns a pointer to it

Parameters:
     *url (IN) - the URL
     depth (IN) - search depth of url_entry

Returns: a pointer to a new url_entry structure
=============================================================================*/
struct url_entry *url_entry_init(char *url, int depth) {
  struct url_entry *ue =
    (struct url_entry *)malloc(sizeof(struct url_entry));
  ue->url = (char *)malloc(strlen(url)+1);
  strcpy(ue->url,url);
  ue->depth = depth;
  return ue;
}

/*=============================================================================
Function url_report

Purpose: prints out feedback for the given URL  
          
Parameters:
    *url (IN) - URL
    matches (IN) - 1 if the URL had matches, 0 otherwise
        
Returns: prints out the appropriate report
=============================================================================*/
void url_report(char *url, int matches) {
  if (!only_show_url) return;
  if ((matches && !show_non_matching) || (!matches && show_non_matching))
    printf("%s\n",url);
}

/*=============================================================================
Function main

Purpose: main entry point of program, processes input and starts search
          
Parameters:
    argc (IN) - count of command line arguments
    *argv (IN) - array of pointers to command line arguments
        
Returns: nothing
=============================================================================*/
int main(int argc, char *argv[]) {
  int c;
  char *p;
  struct url_entry *ue; /* used for processing url_entries */
  /* first process command line optional arguments */
  while(--argc>0 && (*++argv)[0]=='-')
    while((c = *++argv[0]))
      switch(c) {
        case 'i':
          case_independent = 1;
          break;
        case 'l':
          only_show_url = 1;
          break;
        case 'v':
          show_non_matching = 1;
          break;
        case 'd':
          if (*++argv[0]!='=') {
            fprintf(stderr,"Illegal depth value, argument will be ignored\n");
            break;
          }
          search_depth = strtol(++argv[0],&p,0);
          if (search_depth<0 || errno==ERANGE || p==argv[0]) {
            fprintf(stderr,"Illegal depth value, argument will be ignored\n");
            search_depth = DEFAULT_SEARCH_DEPTH;
            argv[0] = p-1; /* above ++ will point to first unconverted */
            break;
          }
          argv[0] = p-1; /* so above ++ will point to first unconverted */
          break;
        case 't':
          if (*++argv[0]!='=') {
            fprintf(stderr,"Illegal connect timeout value, "
                           "argument will be ignored\n");
            break;
          }
          connect_timeout = strtol(++argv[0],&p,0);
          if (connect_timeout<0 || errno==ERANGE || p==argv[0]) {
            fprintf(stderr,"Illegal connect timeout value, "
                           "argument will be ignored\n");
            connect_timeout = DEFAULT_CONNECT_TIMEOUT;
            argv[0] = p-1; /* above ++ will point to first unconverted */
            break;
          }
          argv[0] = p-1; /* so above ++ will point to first unconverted */
          break;
        default:
          fprintf(stderr,"Unknown option %c ignored\n",c);
      }

  /* now process pattern URL+ if they are present */
  if (argc<2) {
    fprintf(stderr, "Usage: websearch [OPTION...] pattern URL+\n"
                    "valid options:\n"
                    "  -i\tspecifies case-independent matching\n"
                    "  -l\tspecifies show matching URLs, not lines\n"
                    "  -v\tspecifies show non-matching lines or URLs\n"
                    "  -d=N\tspecifies search depth, default = 0\n"
                    "  -t=N\tspecifies timeout in secs, default = 0 (no timeout)\n");
    exit(1);
  }

  pattern = argv[0]; /* store pattern */

  url_entries = list_init(); /* create url entries list */
  url_trie = trie_init(); /* create url trie */

  /* add all URLs to the URL entries with depth 0 */
  while (*++argv) {
    ue = url_entry_init(argv[0],0);
    list_insert_back(url_entries,ue);
  }

#ifdef DEBUG
  printf("Case independence: %d\n",case_independent);
  printf("Only show url:     %d\n",only_show_url);
  printf("Show non mathcing: %d\n",show_non_matching);
  printf("Search depth:      %d\n",search_depth);
  printf("Connect timeout:   %d\n",connect_timeout);
  printf("Pattern:           %s\n",pattern);
  printf("URL Count:         %d\n",url_entries->size);
#endif

  /* keep processing an entry at a time until the list is empty */
  while(url_entries->size>0) {
    ue = list_remove_front(url_entries);
    process_url_entry(ue);
    url_entry_free(ue);
  }

  return 0;

}
