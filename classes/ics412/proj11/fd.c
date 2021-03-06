#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <ctype.h>
#include <stdlib.h>

#define MAX_PATH 255
#define BYTES_PER_DIR_ENTRY 32

#define READ_ONLY 0x01
#define HIDDEN 0x02
#define SYSTEM 0x04

#define MAX(A, B) ((A) > (B) ? (A) : (B))

/*
 * The following is used as a special sentinel that allows functions
 * that operate on directories to be generalized and work with the
 * root directory as well as other directories in spite of the fact
 * that the root directory is not in regular cluster space (the data
 * area of the disk).  Since 0 and 1 are not valid clusters, 0 can
 * be safely used as a sentinel for the root.
 */
#define ROOT_DIR_CLUSTER 0

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

/* global to module */
static char pwd[MAX_PATH] = "/";
static int fd = -1; /* negative means not open */
static struct disk_geometry dg;

/*
 * Converts a c string to upper case.
 *
 * @param *s    string to convert
 *
 * @return    pointer to converted string
 */
static char *strupper(char *s) {
  int i;
  for (i=0; i<strlen(s); i++)
    s[i] = toupper(s[i]);
  return s;
}

/*
 * Reads the disk geometry and fills in dg accordingly.
 *
 * @param *dg   disk_geometry structure to fill in
 *
 * @return    negative if unable to read, otherwise 0
 */
static int read_disk_geometry() {
  char buf[0x1e];
  if (read(fd, buf, 0x1e) < 0x1e) return -1;

  dg.bytes_per_sect = ((0xff & buf[0x0c]) << 8) | (0xff & buf[0x0b]);
  dg.sects_per_cluster = 0xff & buf[0x0d];
  dg.num_fats = 0xff & buf[0x10];
  dg.num_root_entries = ((0xff & buf[0x12]) << 8) | (0xff & buf[0x11]);
  dg.num_log_sects = ((0xff & buf[0x14]) << 8) | (0xff & buf[0x13]);
  dg.sects_per_fat = ((0xff & buf[0x17]) << 8) | (0xff & buf[0x16]);
  dg.sects_per_track = ((0xff & buf[0x19]) << 8) | (0xff & buf[0x18]);
  dg.num_heads = ((0xff & buf[0x1b]) << 8) | (0xff & buf[0x1a]);
  dg.num_hid_sects = ((0xff & buf[0x1d]) << 8) | (0xff & buf[0x1c]);
  dg.base_root_sect = 1 + (dg.num_fats * dg.sects_per_fat);
  dg.base_data_sect = dg.base_root_sect +
    (dg.num_root_entries * BYTES_PER_DIR_ENTRY) / dg.bytes_per_sect;

  return 0;
}

/*
 * Takes a cluster and returns the byte position of that cluster.
 *
 * @param cluster  cluster to return the byte position of
 *
 * @return    byte position corresponding to cluster
 */
static int ctobpos(int cluster) {
  if (cluster == ROOT_DIR_CLUSTER)
    return dg.base_root_sect * dg.bytes_per_sect;
  return (dg.base_data_sect + (cluster - 2) * dg.sects_per_cluster) *
    dg.bytes_per_sect;
}

/*
 * Returns the size of cluster in bytes  Note that this function
 * is used with the special sentinel ROOT_DIR_CLUSTER and in that
 * case returns the size of the root directory entries table.
 *
 * @param cluster    cluster to return the size of
 * 
 * @return    size of the cluster or root directory entries
 */
static int cluster_size(int cluster) {
  if (cluster == ROOT_DIR_CLUSTER)
    return dg.num_root_entries * BYTES_PER_DIR_ENTRY;
  return dg.sects_per_cluster * dg.bytes_per_sect;
}

/*
 * Reads cluster into buf, buf should be a buffer large enough to hold
 * a cluster, that is it should have been allocated to size
 * cluster_size(cluster).
 *
 * @param cluster  cluster to read
 * @param *buf     buffer to hold bytes from cluster
 *
 * @return    0 if successful, -1 otherwise
 */
static int ll_fd_read(int cluster, char *buf) {
  int offset = ctobpos(cluster);
  int size = cluster_size(cluster);
  if (lseek(fd, offset, SEEK_SET) != offset) return -1;
  if (read(fd, buf, size) != size) return -1;
  return 0;
}

/*
 * Writes buf into cluster, buf should be holding a cluster's worth of data,
 * that is it should have been allocated to size cluster_size(cluster).
 *
 * @param cluster  cluster to write to
 * @param *buf     buffer holding the data to write
 *
 * @return    0 if successful, otherwise -1
 */
static int ll_fd_write(int cluster, char *buf) {
  int offset = ctobpos(cluster);
  int size = cluster_size(cluster);
  if (lseek(fd, offset, SEEK_SET) != offset) return -1;
  if (write(fd, buf, size) != size) return -1;
  return 0;
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
static char *merge_filename(char *full, char *name, char *ext) {
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
 * Determines whether or not a directory entry is valid based upon the
 * first byte in the filename portion.
 *
 * @param c    first byte of filename
 *
 * @return    1 if valid, 0 otherwise
 */
static int entry_valid(int c) {
  /* never been used, released, and long filename respectively */
  return (c != 0x00 && c != 0xe5 && c != 0x41);
}

/*
 * Fills in a dir_entry structure from position entry in buf.
 *
 * @param entry  entry to get data from
 * @param *buf   buffer holding directory entry data
 * @param *de    dir_entry structure to fill in
 *
 * @return    nothing, but fills in *de
 */
static void read_dir_entry(int entry, char *buf, struct dir_entry *de) {
  memcpy(de, buf + (entry * BYTES_PER_DIR_ENTRY), BYTES_PER_DIR_ENTRY);
}

/*
 * Returns the value in the FAT at position cluster.  This is either
 * the next cluster in the chain of clusters allocated to a file, or
 * in the range of 0xff8 to 0xfff if the passed in cluster is the
 * last cluster in the chain.  Because this is for FAT 12, 2 cluster
 * entries are packed into 3 bytes.  See Kernel Projects for Linux
 * p. 197 if the extraction math is not clear.
 *
 * @param cluster cluster to determine next cluster in chain
 *
 * @return    value at FAT[cluster] which is the next cluster in the
 *            chain or 0xff8 to 0xfff if cluster is last in chain or
 *            -1 if an error occurs
 */
static int read_fat(int cluster) {
  char buf[2];
  /* the 1 in the following causes reads from the first FAT */
  int next_cluster, offset = 1 * dg.bytes_per_sect +
                             3 * (cluster / 2) + (cluster % 2);

  if (cluster == ROOT_DIR_CLUSTER) return 0xff8;
  if (lseek(fd, offset, SEEK_SET) != offset) return -1;
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
 * @param cluster FAT position to write at
 * @param val     value to write at position cluster
 *
 * @return    0 if the write is successful, otherwise -1
 */
static int write_fat(int cluster, int val) {
  char buf[2];
  /* the 1 in the following causes reads from the first FAT */
  int offset = 1 * dg.bytes_per_sect + 3 * (cluster / 2) + (cluster % 2);

  if (lseek(fd, offset, SEEK_SET) != offset) return -1;
  if (read(fd, buf, 2) < 2) return -1;

  /* once again see KPfL p. 197 for explaination of FAT packing */
  if (cluster % 2) {
    buf[0] = (0x0f & buf[0]) | (val << 4);
    buf[1] = (val >> 4);
  } else {
    buf[0] = (0xff & val);
    buf[1] = (0xf0 & buf[1]) | (val >> 8);
  }

  if (lseek(fd, offset, SEEK_SET) != offset) return -1;
  if (write(fd, buf, 2) < 2) return -1;

  return 0;
}

/*
 * Prints the header for a listing output.
 */
static void print_ls_header() {
  printf("%-15s %10s %5s\n", "name", "size", "clust");
  printf("%-15s %10s %5s\n", "===============", "==========", "=====");
}

/*
 * Prints a listing style output for a dir_entry structure.
 *
 * @param *de    dir_entry to print output for
 */
static void print_dir_entry(struct dir_entry *de) {
  char fullname[13];
  merge_filename(fullname, de->filename, de->extension);
  printf("%-15s %10d %5d\n",fullname,de->size,de->cluster);
}

/*
 * Shows a directory listing from the directory entries starting in
 * cluster.  NOTE: 0 is a special sentinel used to indicate the root
 * directory.
 *
 * @param cluster  starting cluster for directory entries
 *
 * @return    0 if successful, -1 otherwise
 */
static int show_ls(int cluster) {
  char *buf;
  int i, entries;
  struct dir_entry de;

  print_ls_header();

  if (cluster == ROOT_DIR_CLUSTER) {
    entries = dg.num_root_entries;
  } else {
    entries = dg.bytes_per_sect * dg.sects_per_cluster /
      BYTES_PER_DIR_ENTRY;
  }

  buf = (char *)malloc(entries * BYTES_PER_DIR_ENTRY);

  do {

    if (ll_fd_read(cluster, buf) < 0) {
      free(buf);
      return -1;
    }

    for (i=0; i < entries; i++) {
      read_dir_entry(i, buf, &de);
      if (entry_valid(0xff & de.filename[0])) print_dir_entry(&de);
    }

    cluster = read_fat(cluster);

  } while ((cluster & 0xff8) != 0xff8);

  free(buf);
  return 0;
}

/*
 * Determines and returns the cluster OR offset for the directory entry
 * identified by *name from within the set of directory entries that
 * BEGINS in cluster, that is it follows the next cluster if the directory
 * occupies more than one cluster.
 *
 * @param cluster  starting cluster of directory entries to search
 * @param *name    directory entry we are searching for
 * @param *de      on success will contain the found directory entry
 * @param offset   true if you want offset, false if you want cluster
 *
 * @return    cluster or offset of directory entry, or -1 if it is invalid
 */
static int locate_entry(int cluster, char *name, struct dir_entry *de,
                        int offset) {
  char *buf, fullname[13];
  int i, entries;

  if (cluster == ROOT_DIR_CLUSTER) {
    entries = dg.num_root_entries;
  } else {
    entries = dg.bytes_per_sect * dg.sects_per_cluster /
      BYTES_PER_DIR_ENTRY;
  }

  buf = (char *)malloc(entries * BYTES_PER_DIR_ENTRY);

  do {

    if (ll_fd_read(cluster, buf) < 0) {
      free(buf);
      return -1;
    }

    for (i=0; i < entries; i++) {
      read_dir_entry(i, buf, de);
      if (entry_valid(0xff & de->filename[0])) {
        merge_filename(fullname, de->filename, de->extension);
        if (strcmp(name, fullname) == 0) {
          free(buf);
          if (offset) {
            return ctobpos(cluster) + (i * BYTES_PER_DIR_ENTRY);
          } else {
            return cluster;
          }
        }
      }

    }

    cluster = read_fat(cluster);

  } while ((cluster & 0xff8) != 0xff8);

  return -1;

}

/*
 * Determines and returns the starting cluster for the directory
 * entries associated with path by attempting to walk the full path.
 * Note the special sentinel usage for indicating the root
 * directory.
 *
 * @param *path  dir path we are locating the starting cluster for
 *
 * @return    starting cluster of directory entries for path,
 *            ROOT_DIR_CLUSTER if path is root, or -1 if path invalid
 */
static int locate_dir_cluster(char *path) {
  char *buf, fullname[13], path_copy[MAX_PATH], *tok;
  int i;
  /* starting in the root */
  int cluster = ROOT_DIR_CLUSTER, entries = dg.num_root_entries;
  struct dir_entry de;

  /*
   * this will start in root and go through clusters as needed, buf
   * needs to be the larger of the two
   */
  buf = (char *)malloc(MAX(cluster_size(ROOT_DIR_CLUSTER), cluster_size(2)));

  /* strtok is destructive, make a copy */
  strcpy(path_copy, path);

  /*
   * looking for one tok of the path at a time starting in the root
   * directory.
   */
  for (tok = strtok(path_copy,"/"); tok != NULL; tok = strtok(NULL, "/")) {

    if (ll_fd_read(cluster, buf) < 0) {
      free(buf);
      return -1;
    }

    for (i=0; i<entries; i++) {
      read_dir_entry(i, buf, &de);
      if (((0xff & de.filename[0]) != 0x00) && /* never been used */
          ((0xff & de.filename[0]) != 0xe5)) { /* has been released */
        merge_filename(fullname, de.filename, de.extension);
        if (strcmp(tok, fullname)==0) {
          if (de.attributes == 0x10) { /* directory */
            cluster = de.cluster;
            entries = dg.bytes_per_sect * dg.sects_per_cluster /
                      BYTES_PER_DIR_ENTRY;
            break;
          } else { /* file */
            free(buf);
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
      cluster = read_fat(cluster);
      if ((cluster & 0xff8) == 0xff8) {
        free(buf);
        return -1;
      }
      entries = dg.bytes_per_sect * dg.sects_per_cluster /
        BYTES_PER_DIR_ENTRY;
      i = 0; /* to reset the for loop */
    }

  }

  /* out of the outer for loop, the last tok has been found as a valid path */ 
  free(buf);
  return cluster;

}

/*
 * Loads the drive.  Internally this opens a file descriptor to the drive
 * and reads the disk geometry.
 *
 * @param drive    drive to load such as /dev/fd0
 *
 * @return    0 if successful, otherwise -1
 */
int fd_load(char *drive) {
  if (fd > 0) close(fd);
  if ((fd = open(drive, O_RDWR)) < 0) return -1;
  if (read_disk_geometry() < 0) return -1;
  return 0;
}

/*
 * Closes the drive.  Internally this closes the file descriptor and sets
 * it to negative to indicate not open.
 */
void fd_close() {
  if (fd > 0) close(fd);
  fd = -1;
}

/*
 * Shows a directory listing for the present working directory.
 *
 * @return    0 if successful, -1 if an error occurs
 */
int fd_ls() {
  int cluster;
  if (fd < 0) return - 1;
  if ((cluster = locate_dir_cluster(pwd)) < 0) return -1;
  return show_ls(cluster);
}

/*
 * Changes from present working directory in pwd to directory.
 *
 * @param directory    directory to change to
 *
 * @return    0 if successful, otherwise -1
 */
int fd_cd(char *directory) {
  int cluster;
  char *p, pwd_copy[MAX_PATH];
  if (fd < 0) return -1;
  if (strcmp(directory, ".") == 0) return 0;
  /* FAT12 system case insensitive, stored in UPPERCASE */
  strupper(directory);
  /* make pwd_copy contain what would be new directory if cd successful */
  memcpy(pwd_copy, pwd, MAX_PATH);
  if (directory[0] == '/') {  /* absolute */
    memcpy(pwd_copy, directory, MAX_PATH);
  } else if (strcmp(directory, "..") == 0) {  /* backup one */
    p = strrchr(pwd_copy, '/');
    *p = 0;
    if (strlen(pwd_copy) == 0) strcpy(pwd_copy, "/");
  } else {  /* within the current directory, we don't handle relative */
    if (strlen(pwd_copy) > 1) strncat(pwd_copy, "/", 1);
    strncat(pwd_copy, directory, strlen(directory));
  }

  if ((cluster = locate_dir_cluster(pwd_copy)) < 0) return -1;
  memcpy(pwd, pwd_copy, MAX_PATH);

  return 0;
}

/*
 * Removes the file name from the present working directory.
 *
 * @param name    file to remove
 *
 * @return    0 if successful, -1 if an error occurs
 */
int fd_rm(char *name) {
  char buf[] = "\xe5"; /* used to do write for releasing file / directory */
  int cluster, offset, temp;
  struct dir_entry de;
  if (fd < 0) return -1;
  if (strcmp(name, "..") == 0 || strcmp(name, ".") ==0) return -1;
  if ((cluster = locate_dir_cluster(pwd)) < 0) return -1;
  if ((offset = locate_entry(cluster, name, &de, 1)) < 0) return -1;
  if (de.attributes == 0x10) return -1;
  if (de.attributes & READ_ONLY) return -1;
  if (de.attributes & HIDDEN) return -1;
  if (de.attributes & SYSTEM) return -1;
  if (lseek(fd, offset, SEEK_SET) != offset) return -1;
  if (write(fd, buf, 1) != 1) return -1;

  /* now free up all the clusters involved in the file */
  cluster = de.cluster;
  while (cluster != 0 && (0xff8 & cluster) != 0xff8) {
    if ((temp = read_fat(cluster)) < 0) return -1;
    if (write_fat(cluster, 0xff8) < 0) return -1;
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

  return 0;
}

/*
 * Prints the present working directory.
 */
void fd_pwd() {
  if (fd < 0) {
    printf("No drive open.\n");
  } else {
    printf("%s\n", pwd);
  }
}
