#include <stdio.h>
#include <errno.h>
#include <time.h>
#include <string.h>
#include <sys/time.h>

#define err(s,v) { fprintf(stderr,s,v) ; exit(1); }
#define BUF_SIZE 100
enum report_types { ERR, BASIC, SHORT, LONG };

/* forward declares */
void do_basic_report();
void do_short_report();
void do_long_report(int interval, int duration);

int main(int argc, char *argv[]) {

  int load_interval, load_duration;
  char *p, buf[BUF_SIZE];
  struct timeval now;
  FILE *fp;

  enum report_types report_type = ERR;

  if (argc==1)
    report_type = BASIC;
  else if (argc==2 && strcmp(argv[1],"-s")==0)
    report_type = SHORT;
  else if (argc==4 && strcmp(argv[1],"-l")==0) {
    report_type = LONG;
    load_interval = strtol(argv[2],&p,0);
    if (load_interval<0 || errno==ERANGE || p==argv[2])
      report_type = ERR;
    load_duration = strtol(argv[3],&p,0);
    if (load_duration<0 || errno==ERANGE || p==argv[2])
      report_type = ERR;
  }

  if (report_type==ERR)
    err("Proper usage is %s [-s]|[-l interval duration]\n"
        "Where interval is how often to sample load,\n"
        "and duration is how long to continue sampling.\n",argv[0]);

  /* start with a greeting about this run of the program */
  gettimeofday(&now,NULL);
  switch (report_type) {
    case BASIC:
      printf("Basic");
      break;
    case SHORT:
      printf("Short");
      break;
    default:
      printf("Long");
  }
  printf(" operating system status report at %s",ctime(&(now.tv_sec)));

  /* now print hostname */
  if ((fp=fopen("/proc/sys/kernel/hostname","r"))!=NULL)
    if (fgets(buf,sizeof(buf),fp)!=NULL)
      printf("Machine hostname: %s",buf);

  do_basic_report();

  if (report_type == BASIC) exit(0);

  do_short_report();

  if (report_type == SHORT) exit(0);

  do_long_report(load_interval, load_duration);

}

void expand_secs(int secs, int *d, int *h, int *m, int *s) {
  *d = secs / (60 * 60 * 24);
  secs %= (60 * 60 * 24);
  *h = secs / (60 * 24);
  secs %= (60 * 24);
  *m = secs / (60);
  secs %= (60);
  *s = secs;
}

void do_basic_report() {
  char buf[BUF_SIZE];
  FILE *fp;
  int i, days, hours, minutes, seconds, uptime;

  printf("CPU Information ==========================================\n");
  if ((fp=fopen("/proc/cpuinfo","r"))==NULL) {
    printf("Unable to open cpuinfo\n");
  } else {
    while (fgets(buf,sizeof(buf),fp)!=NULL) {
      if (strncmp(buf,"model",strlen("model"))==0 ||
          strncmp(buf,"model name",strlen("model name"))==0 ||
          strncmp(buf,"cpu MHz",strlen("cpu MHz"))==0)
        printf("%s",buf);
    }
  }

  fclose(fp);

  printf("Kernel Information =======================================\n");
  if ((fp=fopen("/proc/version","r"))==NULL) {
    printf("Unable to open version\n");
  } else {
    if (fgets(buf,sizeof(buf),fp)!=NULL) {
      i = 0;
      while (buf[i]<'0' || buf[i]>'9' && buf[i]!=0) i++; /* find first digit */
      while (buf[i]!=' ' && buf[i]!=0) i++; /* space after digit string */
      buf[i] = 0; /* null terminate */
      printf("%s\n",buf);
    } else
      printf("Error reading version\n");
  }

  fclose(fp);

  printf("Uptime Information =======================================\n");
  if ((fp=fopen("/proc/uptime","r"))==NULL) {
    printf("Unable to open uptime\n");
  } else {
    if (fscanf(fp,"%d",&uptime)<1)
      printf("Error reading uptime\n");
    else {
      expand_secs(uptime, &days, &hours, &minutes, &seconds);
      printf("Time since last reboot: %02d:%02d:%02d:%02d\n",
             days,hours,minutes,seconds);
    }
  }

  fclose(fp);

}

void do_short_report() {
  char *p, buf[BUF_SIZE];
  FILE *fp;
  int days, hours, minutes, seconds, uptime;
  int val1, val2, val3; /* bad variable names...but are reused many times */
  time_t boot_time;
  printf("Expanded Information =====================================\n");
  if ((fp=fopen("/proc/stat","r"))!=NULL) {
    while ((fgets(buf,sizeof(buf),fp))!=NULL) {
      if (strncmp(buf,"cpu0",strlen("cpu0"))==0) {
        if (sscanf(buf,"%*s %d %*d %d %d",&val1,&val2,&val3)==3) {
          /* dividing by 100 because the values are stored in 100ths */
          expand_secs(val1/100, &days, &hours, &minutes, &seconds);
          printf("Time spent in user mode:    %02d:%02d:%02d:%02d\n",
                 days,hours,minutes,seconds);
          expand_secs(val2/100, &days, &hours, &minutes, &seconds);
          printf("Time spent in system mode:  %02d:%02d:%02d:%02d\n",
                 days,hours,minutes,seconds);
          expand_secs(val3/100, &days, &hours, &minutes, &seconds);
          printf("Time spent in idle process: %02d:%02d:%02d:%02d\n",
                 days,hours,minutes,seconds);
        } else {
          printf("Unable to read cpu mode times\n");
        }
      } else if (strncmp(buf,"disk_io:",strlen("disk_io:"))==0) {
        if ((p=strstr(buf,":("))!=NULL) {
          p++; /* now pointing at the opening paren */
	  if (sscanf(p,"(%*d,%d,%*d,%d",&val1,&val2)==2) {
            printf("Disk reads:  %d\n",val1);
            printf("Disk writes: %d\n",val2);
          }
        }
      } else if (strncmp(buf,"ctxt",strlen("ctxt"))==0) {
        if (sscanf(buf,"%*s %d",&val1)==1) {
          printf("Context switches: %d\n",val1);
        } else {
          printf("Unable to read context switches\n");
        }
      } else if (strncmp(buf,"btime",strlen("btime"))==0) {
        if (sscanf(buf,"%*s %d",&val1)==1) {
          boot_time = val1;
          printf("Boot time: %s",ctime(&boot_time));
        } else {
          printf("Unable to read boot time\n");
        }
      } else if (strncmp(buf,"processes",strlen("processes"))==0) {
        if (sscanf(buf,"%*s %d",&val1)==1) {
          printf("Processes spawned: %d\n",val1);
        } else {
          printf("Unable to read processes spawned\n");
        }
      }
    }
  } else
    printf("Error reading stat\n");

  fclose(fp);
}

void do_long_report(int interval, int duration) {
  char buf[BUF_SIZE];
  FILE *fp;
  double load, load_total = 0;
  int iteration = 0, elapsed = 0;
  printf("Memory Information =======================================\n");
  if ((fp=fopen("/proc/meminfo","r"))!=NULL) {
    while((fgets(buf,sizeof(buf),fp))!=NULL) {
      if (strncmp(buf,"MemTotal:",strlen("MemTotal"))==0 ||
          strncmp(buf,"MemFree:",strlen("MemFree:"))==0)
        printf("%s",buf);
    }
  } else {
    printf("Error reading meminfo\n");
  }

  fclose(fp);

  printf("Load Information =========================================\n");
  while (elapsed<duration) {
    sleep(interval);
    elapsed+=interval;
    if ((fp=fopen("/proc/loadavg","r"))!=NULL &&
        (fgets(buf,sizeof(buf),fp))!=NULL) {
      load_total+=load;
      iteration++;
      printf("%d) load average: %s",iteration,buf);
      fclose(fp);
    } else {
      printf("Error reading loadavg\n");
      break;
    }
  }

}
