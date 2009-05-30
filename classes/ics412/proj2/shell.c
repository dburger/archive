#include <stdio.h>
#include <string.h>
#include <signal.h>
#include <sys/types.h>

#define CMD_BUF_SIZE 500
#define HOST_BUF_SIZE 50

char host[HOST_BUF_SIZE] = "\0";

void print_prompt() {
  printf("%s@%s>",getlogin(),host);
}

/*
 * Used in a first pass to count the number of separate commands in a string
 * and a second pass to set **cmdv to point at the separate commands.
 *
 * @param *buf    string holding the commands
 * @param **cmdv  NULL on first pass to get a count of the commands, second
 *                pass array of strings to set to the commands
 *
 * @return        the number of commands found in buf
 */
int iterate_cmds(char *buf, char **cmdv) {
  int i=0, in_arg=0, cmdc=1, escaped=0;

  /* the start of buf is the start of the first command string */
  if (cmdv) cmdv[cmdc-1] = buf;

  /* loop looking for pipes outside quotes to indicate more commands */
  while(buf[i]!=0) {
    if (in_arg) {
      if (escaped) {
        escaped = 0;
      } else if (buf[i]=='\\') {
        escaped = 1;
      } else if (buf[i]=='|' && in_arg==' ') {
        /* a pipe breaks a non-quoted argument */
        cmdc++;
	if (cmdv) {
          buf[i] = 0;
          cmdv[cmdc-1] = buf + i + 1;
        }
        in_arg = 0;
      } else if (buf[i]==in_arg) {
        in_arg = 0;
      }
    } else if (buf[i]!=' ') {
      switch(buf[i]) {
        case '|':
          cmdc++;
          if (cmdv) {
            buf[i] = 0;
            cmdv[cmdc-1] = buf + i + 1;
          }
          break;
        case '"':
          /* fall through */
        case '\'':
          in_arg = buf[i];
          break;
        default:
          in_arg = ' ';
      }
    }
    i++;
  }
  return cmdc;
}

/*
 * Used in a first pass to count the number of arguments in a string and
 * a second pass to set **argv to point at the separate arguments.
 *
 * @param *buf    string holding the arguments
 * @param **argv  NULL on first pass to get a count of the arguments, second
 *                pass array of strings to set to the commands
 *
 * @return        the number of arguments found in buf, or -1 if the buf
 *                contains a non-terminated quoted argument
 */
int iterate_args(char *buf, char **argv) {
  int i=0, in_arg=0, argc=0, escaped=0;

  /* looking for arguments, regular, single-quoted, double-quoted */
  while(buf[i]!=0) {
    if (in_arg) {
      if (escaped) {
        escaped = 0;
      } else if (buf[i]=='\\') {
        escaped = 1;
      } else if (buf[i]==in_arg) {
        if (argv) buf[i] = 0;
        in_arg = 0;
      }
    } else if (buf[i]!=' ') {
      switch(buf[i]) {
        case '"':
          /* fall through */
        case '\'':
          in_arg = buf[i];
          if (argv) argv[argc] = buf + i + 1;
          break;
        default:
          in_arg = ' ';
          if (argv) argv[argc] = buf + i;
      }
      argc++;
    }
    i++;
  }
  /* non-terminated quoted argument results in error */
  if (in_arg=='"' || in_arg=='\'')
    return -1;
  else
    return argc;
}

/*
 * Unescapes strings.  Characters ", ', \, and space.
 *
 * @param *buf    string to unescape
 */
void unescape(char *buf) {
  int i=0, j=0, escaped=0;
  while (buf[i]!=0) {
    if (escaped) {
      switch (buf[i]) {
        case '\\':
          /* fall through */
        case '\'':
          /* fall through */
        case '\"':
          /* fall through */
        case ' ':
          /* fall through */
        default:
          /* if not standard escape, give them the character anyway */
          buf[j++] = buf[i];
          break;
      }
      escaped = 0;
    } else if (buf[i]=='\\') {
      escaped = 1;
    } else {
      buf[j++] = buf[i];
    }
    i++;
  }
  buf[j] = 0;
}

/*
 * Main entry point to program containing loop that accepts, parses, and
 * executes the commands.
 *
 * @param argc    the number of command line parameters - not used
 * @param *argv[] array of command line parameters - not used
 *
 * @return        value not used
 */
int main(int argc, char *argv[]) {
  char prev,*p, **cmdv, **cmdargv, buf[CMD_BUF_SIZE];
  int i, j, cmdc, cmdargc, concurrent, (*pipes)[2];
  pid_t pid;
  FILE *fp;

  /* retrieve hostname for use in command prompt */
  gethostname(host,HOST_BUF_SIZE);

  /* prevent the shell from being killed with CTRL-C */
  signal(SIGINT, SIG_IGN);

  /* allow children to clean up without wait */
  signal(SIGCHLD, SIG_IGN);

  print_prompt();

  /* keep reading commands until EOF */
  while ((fgets(buf,CMD_BUF_SIZE,stdin))!=NULL) {

    if (buf[strlen(buf)-1] != '\n') {
      printf("The command did not fit in the command buffer, "
             "it will be discarded.\n");
      while (buf[strlen(buf)-1] != '\n') {
        if ((fgets(buf,CMD_BUF_SIZE,stdin))==NULL) exit(0);
      }
      print_prompt();
      continue;
    }

    /* get rid of the \n that fgets includes */
    buf[strlen(buf)-1] = 0;

    /* count the number of commands separated by pipes */
    cmdc = iterate_cmds(buf, NULL);

    /* malloc a string array to hold the commands */
    cmdv = (void *)malloc(cmdc*sizeof(char *));

    /* make the array slots point at the commands */
    iterate_cmds(buf, cmdv);

    /* malloc the number of necessary pipes for the commands */
    pipes = (void *)malloc(2*(cmdc-1)*sizeof(int));

    /* loop through executing each command */
    for (i=0;i<cmdc;i++) {

      /* count the number of arguments in the command */
      if ((cmdargc = iterate_args(cmdv[i], NULL))==-1) {
        printf("Unterminated quoted argument.\n");
        break;
      }

      /* malloc an array to hold the command arguments  */
      /* the +1 is for the required null pointer at end */
      cmdargv = (void *)malloc((cmdargc+1)*sizeof(char *));

      /* make the array slots point at the arguments */
      iterate_args(cmdv[i], cmdargv);

      /* the required NULL pointer at end */
      cmdargv[cmdargc]=NULL;

      /* unescape the arguments */
      for (j=0;j<cmdargc;j++) {
        unescape(cmdargv[j]);
      }

      /* check for the presence of & to indicate concurrent execution */
      concurrent = (cmdargc>1 && strcmp(cmdargv[cmdargc-1],"&")==0);
      if (concurrent) {
        /* don't send the & as a parameter and adjut cmdargc back down */
        cmdargv[cmdargc-1] = NULL;
        cmdargc--;
      }

      if (cmdargc==1 && strcmp(cmdargv[0],"exit")==0) exit(0);

      /* create the pipe, pipe not made on last round */
      if (i+1<cmdc) pipe(pipes[i]);

      /* fork a child process to execute the command */
      switch (pid=fork()) {
        case 0: /* child process */
          /* before launching the command check for redirection */
          while (cmdargc>2 && (strcmp(cmdargv[cmdargc-2],"<")==0 ||
                               strcmp(cmdargv[cmdargc-2],">")==0)) {
            switch (*cmdargv[cmdargc-2]) {
              case '<': /* indirection */
                /* close stdin and replace it with the input file */
                fclose(stdin);
                if ((fp=fopen(cmdargv[cmdargc-1],"r"))==NULL) {
                  fprintf(stderr,"Unable to open input file %s.\n",
                          cmdargv[cmdargc-1]);
                  exit(1);
                }
                /* truncate available arguments */
                cmdargc -= 2;
                cmdargv[cmdargc] = NULL;
                break;
              case '>': /* redirection */
                /* close stdout and replace it with the output file */
                fclose(stdout);
                if ((fp=fopen(cmdargv[cmdargc-1],"w"))==NULL) {
                  fprintf(stderr,"Unable to open output file %s.\n",
                          cmdargv[cmdargc-1]);
                  exit(1);
                }
                /* truncate available arguments */
                cmdargc -= 2;
                cmdargv[cmdargc] = NULL;
                break;
            }
          }

          /* pipes are handled after redirects so will override */
          if (i>0) {
            /* this command needs to read from a previous command */
	    fclose(stdin);
            dup(pipes[i-1][0]);
          }
          if (i+1<cmdc) {
            /* this command needs to write to the next command */
            fclose(stdout);
            dup(pipes[i][1]);
          }

          /* the read end of the current pipe not used by child */
          if (cmdc>1 && i+1<cmdc) close(pipes[i][0]);

          /* only returns on error and sets -1 if info */
          if (execvp(cmdargv[0],cmdargv)==-1) perror("");
          exit(0);
        case -1: /* error has occured, memory too tight ??? */
          perror("");
          free(cmdargv);
          break;
        default: /* parent process */
          /* close the read end of previous pipe */
          if (i>0) close(pipes[i-1][0]);
          /* close the write end of the current pipe */
          if (cmdc>1) close(pipes[i][1]);
          if (i+1==cmdc && !concurrent) waitpid(pid,NULL,0);
          free(cmdargv);
      }

    }

    /* free up resources */
    free(cmdv);
    if (cmdc>1) free(pipes);

    /* prompt for the next round */
    print_prompt();

  }

}
