#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <ctype.h>
#include <stdlib.h>

#define MAX_PATH 255
#define CMD_BUF_SIZE 100
#define BYTES_PER_DIR_ENTRY 32

#define READ_ONLY 0x01
#define HIDDEN 0x02
#define SYSTEM 0x04

struct disk_geometry {
  unsigned short bytes_per_sect;
  char sects_per_cluster;
  char num_fats;
  unsigned short num_root_entries;
  unsigned short num_log_sects;
  unsigned short sects_per_fat;
  unsigned short sects_per_track;
  unsigned short num_heads;
  unsigned short num_hid_sects;
  unsigned int base_root_sect;
  unsigned int base_data_sect;
}; 

struct dir_entry {
  char filename[8];
  char extension[3];
  char attributes;
  char reserved[10];
  unsigned short time;
  unsigned short date;
  unsigned short cluster;
  unsigned int size;
};

/*
 * Converts a c string to upper case.
 *
 * @param *s    string to convert
 *
 * @return    pointer to converted string
 */
char *strupper(char *s) {
  int i;
  for (i=0; i<strlen(s); i++)
    s[i] = toupper(s[i]);
  return s;
}

/*
 * Takes a cluster and returns the byte position of that cluster.
 * Note that clusters start with cluster 2 in the data space of the
 * disk.  NOTE: 0 is being used as a sentinel to indicate the root
 * diretory, which is not in a cluster in data space.
 *
 * @param dg       disk geometry of disk
 * @param cluster  cluster to return the byte position of
 *
 * @return    byte position corresponding to cluster
 */
int ctob(struct disk_geometry *dg, int cluster) {
  /* first check for the sentinel for the root directory */
  if (cluster == 0) return dg->base_root_sect * dg->bytes_per_sect;
  /* now regular calculation */
  return (dg->base_data_sect + (cluster - 2) * dg->sects_per_cluster) *
    dg->bytes_per_sect;
}

/*
 * Merges a DOS filename stored in an 8 byte name buffer and
 * 3 byte extension buffer into a full filename.
 *
 * @param *full   buffer to fill in, must be at least 13 bytes long
 * @param *name   buffer holding name, 8 bytes long
 * @param *ext    buffer holding extension, 3 bytes long
 *
 * @return    puts the full filename in full and returns a pointer
 *            to it
 */
char *merge_filename(char *full, char *name, char *ext) {
  int i, j;

  /* first the name part */
  for (i=0; i<8 && name[i]!=' '; i++) {
    full[i] = name[i];
  }

  full[i] = '.';

  /* now the extension */
  for (j=0; j<3 && ext[j]!=' '; j++) {
    full[i + j + 1] = ext[j];
  }

  full[i + j + 1] = 0;

  /* remove the . if no extension */
  if (full[i + j] == '.') full[i + j] = 0;

  return full;

}

/*
 * Reads the disk geometry and fills in dg accordingly.
 *
 * @param fd    open file descriptor of disk
 * @param *dg   disk_geometry structure to fill in
 *
 * @return    negative if unable to read, otherwise 0
 */
int read_geometry(int fd, struct disk_geometry *dg) {
  char buf[0x1e];
  if (read(fd, buf, 0x1e) < 0x1e) return -1;

  dg->bytes_per_sect = ((0xff & buf[0x0c]) << 8) | (0xff & buf[0x0b]);
  dg->sects_per_cluster = 0xff & buf[0x0d];
  dg->num_fats = 0xff & buf[0x10];
  dg->num_root_entries = ((0xff & buf[0x12]) << 8) | (0xff & buf[0x11]);
  dg->num_log_sects = ((0xff & buf[0x14]) << 8) | (0xff & buf[0x13]);
  dg->sects_per_fat = ((0xff & buf[0x17]) << 8) | (0xff & buf[0x16]);
  dg->sects_per_track = ((0xff & buf[0x19]) << 8) | (0xff & buf[0x18]);
  dg->num_heads = ((0xff & buf[0x1b]) << 8) | (0xff & buf[0x1a]);
  dg->num_hid_sects = ((0xff & buf[0x1d]) << 8) | (0xff & buf[0x1c]);
  dg->base_root_sect = 1 + (dg->num_fats * dg->sects_per_fat);
  dg->base_data_sect = dg->base_root_sect +
    (dg->num_root_entries * BYTES_PER_DIR_ENTRY) / dg->bytes_per_sect;

  return 0;

}

/*
 * Determines whether or not a directory entry is valid based upon the
 * first byte in the filename portion.
 *
 * @param c    first byte of filename
 *
 * @return    1 if valid, 0 otherwise
 */
int entry_valid(int c) {
  /* never been used, released, and long filename respectively */
  return (c != 0x00 && c != 0xe5 && c != 0x41);
}

/*
 * Fills in a dir_entry structure from the data at offset.
 *
 * @param fd     open file descriptor
 * @param offset location on disk to acquire data from
 * @param *de    dir_entry structure to fill in
 *
 * @return    -1 if unable to read, otherwise 0
 */
int read_dir_entry(int fd, int offset, struct dir_entry *de) {

  if (lseek(fd,offset,SEEK_SET)!=offset) return -1;

  if (read(fd, de, BYTES_PER_DIR_ENTRY) < BYTES_PER_DIR_ENTRY) return -1;

  return 0;

}

/*
 * Returns the value in the FAT at position cluster.  This is either
 * the next cluster in the chain of clusters allocated to a file, or
 * in the range of 0xff8 to 0xfff if the passed in cluster is the
 * last cluster in the chain.  Because this is for FAT 12, 2 cluster
 * entries are packed into 3 bytes.  See Kernel Projects for Linux
 * p. 197 if the extraction math is not clear.
 *
 * @param fd      open file descriptor of disk
 * @param *dg     disk geometry of disk
 * @param cluster cluster to determine next cluster in chain
 *
 * @return    value at FAT[cluster] which is the next cluster in the
 *            chain or 0xff8 to 0xfff if cluster is last in chain or
 *            -1 if an error occurs
 */
int get_next_cluster(int fd, struct disk_geometry *dg, int cluster) {
  char buf[2];
  /* the 1 in the following causes reads from the first FAT */
  int next_cluster, offset = 1 * dg->bytes_per_sect +
                             3 * (cluster / 2) + (cluster % 2);

  if (cluster == 0) return 0xff8;

  if (lseek(fd,offset,SEEK_SET)!=offset) return -1;

  if (read(fd, buf, 2) < 2) return -1;

  next_cluster = ((0xff & buf[1]) << 8) | (0xff & buf[0]);

  if (cluster % 2) {
    return next_cluster >> 4;
  } else {
    return next_cluster & 0xfff;
  }

}

/*
 * Writes val at position cluster in the FAT table.
 *
 * @param fd      open file descriptor of disk
 * @param *dg     disk geometry of disk
 * @param cluster FAT position to write at
 * @param val     value to write at position cluster
 *
 * @return    0 if the write is successful, otherwise -1
 */
int write_fat_cluster(int fd, struct disk_geometry *dg, int cluster, int val) {
  char buf[2];
  /* the 1 in the following causes reads from the first FAT */
  int offset = 1 * dg->bytes_per_sect + 3 * (cluster / 2) + (cluster % 2);

  if (lseek(fd,offset,SEEK_SET)!=offset) return -1;

  if (read(fd, buf, 2) < 2) return -1;

  /* once again see KPfL p. 197 for explaination of FAT packing */
  if (cluster % 2) {
    buf[0] = (0x0f & buf[0]) | (val << 4);
    buf[1] = (val >> 4);
  } else {
    buf[0] = (0xff & val);
    buf[1] = (0xf0 & buf[1]) | (val >> 8);
  }

  if (lseek(fd,offset,SEEK_SET)!=offset) return -1;

  if (write(fd, buf, 2) < 2) return -1;

  return 0;

}

/*
 * Prints the header for a listing output.
 */
void print_ls_header() {
  printf("%-15s %10s %5s\n", "name", "size", "clust");
  printf("%-15s %10s %5s\n", "===============", "==========", "=====");
}

/*
 * Prints a listing style output for a dir_entry structure.
 *
 * @param *de    dir_entry to print output for
 */
void print_dir_entry(struct dir_entry *de) {
  char fullname[13];
  merge_filename(fullname, de->filename, de->extension);
  printf("%-15s %10d %5d\n",fullname,de->size,de->cluster);
}

/*
 * Shows a directory listing from the directory entries starting in
 * cluster.  NOTE: 0 is a special sentinel used to indicate the root
 * directory.
 *
 * @param fd       open file descriptor for disk
 * @param *dg      disk geometry of disk
 * @param cluster  starting cluster for directory entries
 *
 * @return    nothing, but a directory listing is shown
 */
void show_ls(int fd, struct disk_geometry *dg, int cluster) {
  int i, entries, cluster_offset, entry_offset;
  struct dir_entry de;

  print_ls_header();

  do {

    if (cluster == 0) {
      entries = dg->num_root_entries;
    } else {
      entries = dg->bytes_per_sect * dg->sects_per_cluster /
        BYTES_PER_DIR_ENTRY;
    }

    cluster_offset = ctob(dg, cluster);

    for (i=0; i < entries; i++) {

      entry_offset = cluster_offset + (i * BYTES_PER_DIR_ENTRY);

      if(read_dir_entry(fd, entry_offset, &de) < 0) {
        printf("Error reading directory entry!\n");
        return;
      } else if (entry_valid(0xff & de.filename[0])) {
        print_dir_entry(&de);
      }

    }

    cluster = get_next_cluster(fd, dg, cluster);

  } while ((cluster & 0xff8) != 0xff8);

}

/*
 * Determines and returns the byte position on the disk of the directory
 * entry within the the set of directory entries that begin in cluster.
 *
 * @param fd       open file descriptor of disk
 * @param *dg      disk geometry of disk
 * @param cluster  starting cluster of directory entries to search
 * @param *file    file we are looking for in path, could be directory!
 *
 * @return    byte position on disk of the corresponding directory entry, or
 *            -1 if it is invalid
 */
int locate_dir_entry(int fd, struct disk_geometry *dg, struct dir_entry *de,
		     int cluster, char *file) {
  int i, entries, cluster_offset, entry_offset;
  char fullname[13];

  do {

    if (cluster == 0) {
      entries = dg->num_root_entries;
    } else {
      entries = dg->bytes_per_sect * dg->sects_per_cluster /
        BYTES_PER_DIR_ENTRY;
    }

    cluster_offset = ctob(dg, cluster);

    for (i=0; i<entries; i++) {

      entry_offset = cluster_offset + (i * BYTES_PER_DIR_ENTRY);

      if(read_dir_entry(fd, entry_offset, de) < 0) {
        printf("Error reading disk!\n");
        return -1;
      } else if (entry_valid(0xff & de->filename[0])) {
        merge_filename(fullname, de->filename, de->extension);
        if (strcmp(file, fullname) == 0) return entry_offset;
      }

    }

    cluster = get_next_cluster(fd, dg, cluster);

  } while ((cluster & 0xff8) != 0xff8);

  return -1;

}

/*
 * Determines and returns the starting cluster for the directory
 * entries associated with path.  NOTE: 0 is a special sentinel
 * for the root directory.
 *
 * @param fd     open file descriptor of disk
 * @param *dg    disk geometry of disk
 * @param *path  dir path we are locating the starting cluster for
 *
 * @return    starting cluster of directory entries for path, 0 if
 *            path is root, or -1 if path is invalid
 */
int locate_dir_cluster(int fd, struct disk_geometry *dg, char *path) {
  int i, offset;
  /* starting at the root on each invocation */
  int cluster = 0;
  int entries = dg->num_root_entries;
  /* a copy of path is made because strtok is destructive */
  char *tok, *path_copy = strdup(path), fullname[13];
  struct dir_entry de;

  /*
   * looking for one tok of the path at a time starting in the root
   * directory.
   */
  for (tok = strtok(path_copy,"/"); tok != NULL; tok = strtok(NULL, "/")) {

    offset = ctob(dg, cluster);

    for (i=0; i<entries; i++) {
      if (read_dir_entry(fd, offset +
                             i * BYTES_PER_DIR_ENTRY, &de) < 0) {
	fprintf(stderr, "Error reading disk!\n");
        free(path_copy);
        return -1;
      } else if (((0xff & de.filename[0]) != 0x00) && /* never been used */
                 ((0xff & de.filename[0]) != 0xe5)) { /* has been released */
        merge_filename(fullname, de.filename, de.extension);
        if (strcmp(tok, fullname)==0) {
          if (de.attributes == 0x10) { /* directory */
            cluster = de.cluster;
            entries = dg->bytes_per_sect * dg->sects_per_cluster /
	      BYTES_PER_DIR_ENTRY;
            break;
          } else { /* file */
            free(path_copy);
            return -1;
	  }
        }
      }
    }

    /*
     * Out of the inner for loop we check if all the entries have been
     * exhausted without finding directory tok, if they have, then we
     * check to see if there is a next cluster.  Note that if
     * i < entries then the break statement above was called when the
     * tok was located as a directory in the cluster.
     */
    if (i==entries) {
      cluster = get_next_cluster(fd, dg, cluster);
      if ((cluster & 0xff8) == 0xff8) {
        free(path_copy);
        return -1;
      }
      entries = dg->bytes_per_sect * dg->sects_per_cluster /
        BYTES_PER_DIR_ENTRY;
      i = 0; /* to reset the for loop */
    }

  }

  /* out of the outer for loop, the last tok has been found as a valid path */ 
  free(path_copy);
  return cluster;

}

/*
 * Main entry point for program.  Opens the disk, determines the geometry,
 * and begins a loop for user command processing.
 *
 * @param argc    count of the number of command line arguments
 * @param *argv[] vector of command line arguments, for this program
 *                the disk to open, for example /dev/fd0, should be
 *                argv[1]
 */
int main(int argc, char *argv[]) {
  char *p, cmdbuf[CMD_BUF_SIZE], pwd[MAX_PATH] = "/\0", pwd_copy[MAX_PATH];
  char buf[1] = "\xe5";
  int fd, cluster, offset, temp;
  struct dir_entry de;
  struct disk_geometry dg;

  if (argc < 2) {
    fprintf(stderr, "Proper usage is %s disk\n", argv[0]);
    exit(1);
  }

  if ((fd = open(argv[1],O_RDWR)) < 0) {
    fprintf(stderr, "Unable to open disk %s.\n", argv[1]);
    exit(1);
  }

  if (read_geometry(fd, &dg) < 0) {
    fprintf(stderr, "Unable to read disk geometry.\n");
    exit(1);
  }

  printf(">");

  while ((fgets(cmdbuf,CMD_BUF_SIZE,stdin))!=NULL) {
    /* truncate the \n that fgets will put at the end */
    cmdbuf[strlen(cmdbuf)-1] = 0;
    strupper(cmdbuf);
    if (strcmp(cmdbuf,"LS") == 0) {

      /* LS command */
      if ((cluster = locate_dir_cluster(fd, &dg, pwd)) < 0) {
        printf("Unable to locate current directory,\n"
               "directory will be set to /.\n");
        strcpy(pwd, "/");
      } else {
        show_ls(fd, &dg, cluster);
      }

    } else if (strncmp(cmdbuf, "CD ", strlen("CD ")) == 0) {

      /* CD command */
      memcpy(pwd_copy, pwd, MAX_PATH);
      p = cmdbuf + strlen("CD ");
      /* formulate pwd_copy to what the new directory would be */
      if (strcmp(p, ".") == 0) {
	/* leave pwd alone */
      } else if (strcmp(p, "..") == 0) { /* backing up a directory */
        p = strrchr(pwd_copy, '/');
        *p = 0;
        if (strlen(pwd_copy) == 0) strcpy(pwd_copy, "/");
      } else {
        if (strlen(pwd_copy) > 1) strncat(pwd_copy, "/", 1);
        strncat(pwd_copy, p, strlen(p));
      }
      /* now try to locate directory specified in pwd_cpy */
      if ((cluster = locate_dir_cluster(fd, &dg, pwd_copy)) < 0) {
        printf("Unable to cd to %s\n", pwd_copy);
      } else {
        memcpy(pwd, pwd_copy, MAX_PATH);
      }

    } else if (strncmp(cmdbuf, "RM ", strlen("RM ")) == 0) {

      /* RM command */
      p = cmdbuf + strlen("RM ");
      if (strcmp(p, "..") == 0 || strcmp(p, ".") ==0) {
        printf("%s is a directory, it will not be removed.\n", p);
      } else if ((cluster = locate_dir_cluster(fd, &dg, pwd)) < 0) {
        printf("Unable to locate the current directory.\n");
      } else if ((offset = locate_dir_entry(fd, &dg, &de, cluster, p)) < 0) {
        printf("Unable to locate %s\n", p);
      } else if (de.attributes == 0x10) {
        printf("%s is a directory, it will not be removed.\n", p);
      } else if (de.attributes & READ_ONLY) {
        printf("%s is read only, it will not be removed.\n", p);
      } else if (de.attributes & HIDDEN) {
        printf("%s is a hidden file, it will not be removed.\n", p);
      } else if (de.attributes & SYSTEM) {
        printf("%s is a system file, it will not be removed.\n", p);
      } else {
        /* the file has passed all the tests, now remove it */
        if (lseek(fd, offset, SEEK_SET) != offset) {
          printf("Error seeking disk!\n");
        } else if (write(fd, buf, 1) != 1) {
          printf("Error writing disk!\n");
        } else {
          /* now free up all the clusters involved in the file */
          cluster = de.cluster;
          while (cluster != 0 && (0xff8 & cluster) != 0xff8) {
            if ((temp = get_next_cluster(fd, &dg, cluster)) < 0) {
              printf("An error occurred while freeing file clusters!\n");
              break;
            }
            if (write_fat_cluster(fd, &dg, cluster, 0xff8) < 0) {
              printf("An error occurred while freeing file clusters!\n");
              break;
	    }
            cluster = temp;
	  }

          /*
           * here a real program would need to check the cluster that had
           * the corresponding directory entry removed from it...if it had
           * no directory entries, the links in the fat should be fixed so
           * that the cluster is no longer involved in the group of
           * directory entry clusters for this directory and is free to the
           * rest of the system.
           */

        }
      }

    } else if (strcmp(cmdbuf, "PWD") == 0) {

      /* PWD command */
      printf("%s\n", pwd);

    } else if (strcmp(cmdbuf, "EXIT") == 0) {

      /* EXIT command */
      break;

    } else {

      /* HUH? */
      printf("Unknown command.\n");

    }

    printf(">");

  }

  close(fd);
  return 0;

}
