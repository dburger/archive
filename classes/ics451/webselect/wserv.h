/* standard status messages */
#define STATUS_200 "HTTP/1.0 200 OK\r\n"

/* used to fool Netscape 4.7 into thinking it got a proxied css or js file */
#define CSS "HTTP/1.0 200 OK\r\nContent-type: application/x-pointplus\r\nContent-length: 7\r\n\r\nBODY{;}"
#define JS "HTTP/1.0 200 OK\r\nContent-type: application/x-javascript\r\nContent-length: 25\r\n\r\nfunction nothing{return;}"

/* bodies added because IE was flakey when they weren't here */
#define STATUS_400 "HTTP/1.0 400 Bad request\r\nContent-type: text/html\r\nContent-length: 41\r\n\r\n<html><body>400 Bad Request</body></html>"
#define STATUS_403 "HTTP/1.0 403 Forbidden\r\nContent-type: text/html\r\nContent-length: 39\r\n\r\n<html><body>403 Forbidden</body></html>"
#define STATUS_404 "HTTP/1.0 404 Not found\r\nContent-type: text/html\r\nContent-length: 39\r\n\r\n<html><body>404 Not Found</body></html>"
#define STATUS_500 "HTTP/1.0 500 Internal server error\r\nContent-type: text/html\r\nContent-length: 51\r\n\r\n<html><body>500 Internal Server Error</body></html>"
#define STATUS_501 "HTTP/1.0 501 Not implemented\r\nContent-type: text/html\r\nContent-length: 45\r\n\r\n<html><body>501 Not Implemented</body></html>"


/* standard Content-types */
#define CON_TYPE_HTML "Content-type: text/html\r\n"
#define CON_TYPE_TEXT "Content-type: text/plain\r\n"
#define CON_TYPE_JPEG "Content-type: image/jpeg\r\n"
#define CON_TYPE_GIF "Content-type: image/gif\r\n"

/* buffer size for sending/reading with sockets */
#define WEB_BUFF_SIZE 1500

/* the maximum string length for a reference */
#define MAX_REF_LEN 100

/* the maximum length of the command and version in the request string */
#define MAX_CMD 20
#define MAX_VERS 20

/* the maximum string length for the above header values */
#define MAX_HEADER_RESPONSE_STR 200

/* used for acting as a proxy */
void proxySend(int sd, char *url);

/* used for sending a file local to the system */
void localSend(int sd, char *filename);

/* used for extracting the host from a url */
void extractHost(char *buff, int length, char* url);

/* used for extracting the port from a url */
int extractPort(char *s);

/* used for extracting the filepath from a url */
char *extractFilepath(char *url);

/* used for parsing the hrefs out of a file */
int parse_refs(FILE *fp, char urls[][100], int max);
