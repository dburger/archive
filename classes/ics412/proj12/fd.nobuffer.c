#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <ctype.h>
#include <stdlib.h>
#include <sys/time.h>
#include <time.h>

#include "fd.h"

#define MAX(A, B) ((A) > (B) ? (A) : (B))
#define MIN(A, B) ((A) < (B) ? (A) : (B))

#define FILES 10
#define MAX_PATH 255
#define BYTES_PER_DIR_ENTRY 32

#define READ_ONLY 0x01
#define HIDDEN 0x02
#define SYSTEM 0x04

/* constants for the locate_entry call */
#define ENTRY_MATCH 0
#define ENTRY_FREE 1

/*
 * The following are used as special sentinels that allow functions that
 * operate on clusters to also work with the root directory entries and the
 * FAT.  This can be done because in cluster space 0 and 1 are not valid
 * cluster numbers.
 */
#define ROOT_DIR_CLUSTER 0
#define FAT_CLUSTER 1

struct disk_geometry {
  unsigned short bytes_per_sect;
  char sects_per_clust;
  char num_fats;
  unsigned short num_root_entries;
  unsigned short num_log_sects;
  unsigned short sects_per_fat;
  unsigned short sects_per_track;
  unsigned short num_heads;
  unsigned short num_hid_sects;
  /* the calculated fields */
  unsigned int base_root_sect;
  unsigned int base_data_sect;
  unsigned int base_fat_sect;
  unsigned int bytes_per_clust;
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

struct file_descriptor {
  int active;
  char name[MAX_PATH];
  int mode;
  char attributes;
  int cluster;
  int next_cluster;
  int size;
  int pos;
  struct dir_entry de;
  int de_offset;
};

/* global to module */
static char *fat_cache;
static char pwd[MAX_PATH] = "/";
static int fd = -1; /* negative means not open */
static struct disk_geometry dg;
static struct file_descriptor fd_table[FILES];

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
 * Stamps the passed in *date and *time variables with the current date and
 * time in the dos format.
 *
 * @param *date    variable to place dos date in
 * @param *time    variable to place dos time in
 */
static void stamp_datetime(unsigned short *date, unsigned short *time) {
  struct timeval tv;
  struct tm *ptm;

  gettimeofday(&tv, NULL);
  ptm = localtime(&tv.tv_sec);
  *time = (ptm->tm_hour << 11) | (ptm->tm_min << 5) | (ptm->tm_sec >> 1);
  *date = (((ptm->tm_year - 80) << 9) | ((1 + ptm->tm_mon) << 5) |
	   (ptm->tm_mday));
}

/*
 * These are the obvious date/time functions that take an unsigned short of
 * date or time in the dos format and return the associated numeric value.
 */
static int extract_year(unsigned short date) { return 1980 + (date >> 9); }
static int extract_month(unsigned short date) { return (date >> 5) & 0xf; }
static int extract_day(unsigned short date) { return date & 0x1f; }
static int extract_hours(unsigned short time) { return time >> 11; }
static int extract_minutes(unsigned short time) { return (time >> 5) & 0x3f; }
static int extract_seconds(unsigned short time) { return (time & 0x1f) * 2; }

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
  dg.sects_per_clust = 0xff & buf[0x0d];
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
  dg.base_fat_sect = 1;
  dg.bytes_per_clust = dg.sects_per_clust * dg.bytes_per_sect;

  return 0;
}

/*
 * Takes a cluster and returns the byte position of that cluster.  Note
 * sentinel usage.
 *
 * @param cluster    cluster to return the byte position of
 *
 * @return    byte position corresponding to cluster
 */
static int ctobpos(int cluster) {
  if (cluster == ROOT_DIR_CLUSTER) {
    return dg.base_root_sect * dg.bytes_per_sect;
  } else if (cluster == FAT_CLUSTER) {
    return 1 * dg.bytes_per_sect;
  } else {
    return (dg.base_data_sect + (cluster - 2) * dg.sects_per_clust) *
      dg.bytes_per_sect;
  }
}

/*
 * Returns the size of cluster in bytes.  Note special sentinel usage.
 *
 * @param cluster    cluster to return the size of
 * 
 * @return    size of the cluster
 */
static int cluster_size(int cluster) {
  if (cluster == ROOT_DIR_CLUSTER) {
    return dg.num_root_entries * BYTES_PER_DIR_ENTRY;
  } else if (cluster == FAT_CLUSTER) {
    return dg.sects_per_fat * dg.bytes_per_sect;
  } else {
    return dg.bytes_per_clust;
  }
}

/*
 * Reads cluster into buf, buf should be a buffer large enough to hold
 * a cluster, that is it should have been allocated to size
 * cluster_size(cluster).
 *
 * @param cluster    cluster to read
 * @param *buf       buffer to hold bytes from cluster
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
 * Determines whether or not name is a legal dos file/dir name.
 *
 * @param name    name to check
 * 
 * @return    1 if valid, 0 otherwise
 */
static int is_dosname(char *name) {
  char *p;
  int ext_len, name_len;

  /*
   * The illegal characters per:
   * http://ou800doc.caldera.com/DOS_others/DOS_filenames.html
   */
  if (strcspn(name, "\"/:*<>|?[]+=;, ") < strlen(name)) return 0;

  ext_len = 0;
  name_len = strlen(name);

  /* split the string at the . */
  if ((p = strchr(name, '.')) != NULL) {
    name_len = p - name;
    p++;
    /* when extension, zero length extension not valid */
    if ((ext_len = strlen(p)) == 0) return 0;
    /* no period in the extension */
    if (strchr(p, '.') != NULL) return 0;
  }

  /* name length valid?, extension length valid? */
  return (name_len > 0) && (name_len <= 8) && (ext_len <= 3);
}

/*
 * Splits a DOS filename stored in a string into an 8 byte buffer for
 * the name and a 3 byte buffer for the extension.  NOTE: Must have
 * been validated with is_dosname!
 *
 * @param full    buffer containing full name
 * @param name    buffer that will hold name portion, 8 bytes long
 * @param ext     buffer that will hold extension, 3 bytes long
 *
 * @return    splits the name into name and ext
 */
static void split_filename(char *full, char *name, char *ext) {
  int ext_len, name_len;
  char *p = strchr(full, '.');

  /* the leftovers is the directory entry should be spaces */
  memset(name, 0x20, 8);
  memset(ext, 0x20, 3);

  ext_len = 0;
  name_len = strlen(full);

  if (p) {
    name_len = p - full;
    ext_len = strlen(++p);
  }
  
  memcpy(name, full, name_len);
  memcpy(ext, p, ext_len); /* if p == NULL, ext_len == 0, no problem */
}

/*
 * Merges a DOS filename stored in an 8 byte name buffer and
 * 3 byte extension buffer into a full filename.
 *
 * @param *full    buffer to fill in, must be at least 13 bytes long
 * @param *name    buffer holding name, 8 bytes long
 * @param *ext     buffer holding extension, 3 bytes long
 *
 * @return    puts the full filename in full and returns a pointer to it
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
  /* never been used or released */
  return (c != 0x00 && c != 0xe5);
}

/*
 * Fills in a dir_entry structure from position entry in buf.  buf
 * would presumably be either the root directory entries or a clusters
 * worth of directory entries from a sub-directory.
 *
 * @param entry    entry to get data from
 * @param *buf     buffer holding directory entry data
 * @param *de      dir_entry structure to fill in
 *
 * @return    nothing, but fills in *de
 */
static void read_dir_entry(int entry, char *buf, struct dir_entry *de) {
  memcpy(de, buf + (entry * BYTES_PER_DIR_ENTRY), BYTES_PER_DIR_ENTRY);
}

/*
 * Returns the value from the passed in fat at position cluster.
 * As per FAT 12 the return value could be:
 *   0x000           unused cluster
 *   0xff0 to 0xff6  reserved cluster
 *   0xff7           bad cluster
 *   0xff8 to 0xfff  last cluster in chain
 *   anything else   number of next cluster in file
 * 
 * Because this is for FAT 12, 2 cluster entries are packed into 3 bytes.  See
 * Kernel Projects for Linux p. 197 if the extraction math is not clear.
 *
 * @param *fat       fat to read from
 * @param cluster    cluster position to read
 *
 * @return    value at FAT[cluster]
 */
static int read_fat(char *fat, int cluster) {
  char *buf;
  int next_cluster, offset = 3 * (cluster / 2) + (cluster % 2);

  if (cluster == ROOT_DIR_CLUSTER) return 0xff8;

  buf = fat + offset;

  next_cluster = ((0xff & buf[1]) << 8) | (0xff & buf[0]);

  if (cluster % 2) {
    return next_cluster >> 4;
  } else {
    return next_cluster & 0xfff;
  }
}

/*
 * Writes val at position cluster in the passed in fat.
 *
 * @param *fat       fat to read from
 * @param cluster    position to write at
 * @param val        value to write at position cluster
 */
static void write_fat(char *fat, int cluster, int val) {
  char *buf;
  int offset = 3 * (cluster / 2) + (cluster % 2);

  buf = fat + offset;

  /* once again see KPfL p. 197 for explaination of FAT packing */
  if (cluster % 2) {
    buf[0] = (0x0f & buf[0]) | (val << 4);
    buf[1] = (val >> 4);
  } else {
    buf[0] = (0xff & val);
    buf[1] = (0xf0 & buf[1]) | (val >> 8);
  }
}

/*
 * Determines the number of free clusters indicated in the passed in fat,
 * that is, those clusters entries with the value 0.
 *
 * @param *fat    fat to read from
 * @return    the number of free clusters
 */
static int fat_free_cnt(char *fat) {
  int i, free = 0, size = cluster_size(FAT_CLUSTER) * 8 / 12;

  for (i = 2; i < size; i++) {
    if (read_fat(fat, i) == 0) free++;
  }
  return free;
}

/*
 * Determines the cluster entry of the first free cluster in the passed in fat
 * and marks it with mark.
 *
 * @param *fat    fat to read from and mark
 * @param mark    value to put at the found first free cluster
 *
 * @return    number of first free cluster, or -1 if no such cluster
 */
static int fat_free_first(char *fat, int mark) {
  int i, size = cluster_size(FAT_CLUSTER);

  for (i = 2; i < size; i++) {
    if (read_fat(fat, i) == 0) {
      write_fat(fat, i, mark);
      return i;
    }
  }
  return -1;
}

/*
 * Determines the cluster entry of the first free cluster after the passed in
 * cluster in linear cluster order ands marks it in passed in fat with mark.
 * This is useful to avoid searching the same clusters over and over when
 * grabbing several clusters in a linear fashion.
 *
 * @param *fat       fat to read from and mark
 * @param cluster    cluster to begin search after
 * @param mark       value to put at the next found free cluster
 *
 * @return    number of first free cluster after passed in cluster
 */
static int fat_free_next(char *fat, int cluster, int mark) {
  int size = cluster_size(FAT_CLUSTER);

  for (cluster++; cluster < size; cluster++) {
    if (read_fat(fat, cluster) == 0) {
      write_fat(fat, cluster, mark);
      return cluster;
    }
  }
  return -1;
}

/*
 * Loads the FAT in to fat_cache off the disk.
 *
 * @return    0 if successful, otherwise -1
 */
static int load_fat() {
  return ll_fd_read(FAT_CLUSTER, fat_cache);
}

/*
 * Commits the passed in fat to disk.
 *
 * @param *fat    fat to write to disk
 *
 * @return    0 if successful, otherwise -1
 */
static int commit_fat(char *fat) {
  return ll_fd_write(FAT_CLUSTER, fat);
  /* the 2nd copy of the fat will only be written on close */
}

/*
 * Prints the header for a listing output.
 */
static void print_ls_header() {
  printf("%s %-15s %10s %5s ", "t", "name", "size", "clust");
  printf("%10s %8s\n", "date", "time");
  printf("%s %-15s %10s %5s ", "=", "===============", "==========", "=====");
  printf("%10s %8s\n", "==========", "========");
}

/*
 * Prints a listing style output for a dir_entry structure.
 *
 * @param *de    dir_entry to print output for
 */
static void print_dir_entry(struct dir_entry *de) {
  char fullname[13];
  int c;

  if (de->attributes == 0x10) {
    c = 'd';
  } else {
    c = 'f';
  }

  merge_filename(fullname, de->filename, de->extension);

  printf("%c %-15s %10d %5d ",c, fullname, de->size,de->cluster);
  printf("%02d/%02d/%04d ", extract_month(de->date),
	 extract_day(de->date), extract_year(de->date));
  printf("%02d:%02d:%02d\n", extract_hours(de->time),
	 extract_minutes(de->time), extract_seconds(de->time));
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

  entries = cluster_size(cluster) / BYTES_PER_DIR_ENTRY;

  if ((buf = (char *)malloc(entries * BYTES_PER_DIR_ENTRY)) == NULL)
    return - 1;

  do {

    if (ll_fd_read(cluster, buf) < 0) {
      free(buf);
      return -1;
    }

    for (i=0; i < entries; i++) {
      read_dir_entry(i, buf, &de);
      if (entry_valid(0xff & de.filename[0])) print_dir_entry(&de);
    }

    cluster = read_fat(fat_cache, cluster);

  } while ((cluster & 0xff8) != 0xff8);

  printf("=====================\n");
  printf("Free clusters: %5d\n",fat_free_cnt(fat_cache));
  printf("First free:    %5d\n",fat_free_first(fat_cache, 0));
  printf("Next free:     %5d\n",
         fat_free_next(fat_cache, fat_free_first(fat_cache, 0), 0));

  free(buf);
  return 0;
}

/*
 * Changes all the dir entries in buf corresponding to cluster as
 * released (0xe5) if not unused (0x00).
 *
 * @param cluster    cluster number corresponding buf, this is used to
 *                   determine cluster size
 * @param *buf       data corresponding to cluster
 */
static void wipe_dir_cluster(int cluster, char *buf) {
  int entry, offset;
  int num_entries = cluster_size(cluster) / BYTES_PER_DIR_ENTRY;

  for (entry = 0; entry < num_entries; entry++) {
    offset = entry * BYTES_PER_DIR_ENTRY;
    if (buf[offset] != 0x00) buf[offset] = 0xe5;
  }
}

/*
 * Adds a cluster to a chain of clusters by adjusting the fat accordingly.
 *
 * @param *fat       fat to read from and add the cluster in
 * @param cluster    a cluster in the chain of clusters that is to be added
 *                   to
 *
 * @return    cluster number of new cluster in chain, or -1 if failed
 */
static int add_cluster(char *fat, int cluster) {
  int next_cluster;

  if (cluster == ROOT_DIR_CLUSTER || cluster == FAT_CLUSTER) return -1;

  while (((next_cluster = read_fat(fat, cluster)) & 0xff8) != 0xff8) {
    cluster = next_cluster;
  }

  /* cluster now holds the last cluster in the chain, look for free cluster */
  if ((next_cluster = fat_free_first(fat, 0xff8)) < 0) return -1;

  write_fat(fat, cluster, next_cluster);

  return next_cluster;
}

/*
 * Determines and returns the cluster for the directory entry
 * identified by *name from within the set of directory entries that
 * BEGINS in cluster, that is it follows the next cluster if the directory
 * occupies more than one cluster.
 *
 * @param *fat      fat to use for locating linked clusters
 * @param cluster   starting cluster of directory entries to search
 * @param *name     directory entry we are searching for
 * @param *de       on success will contain the found directory entry
 * @param clustbuf  contents of the located cluster are copied into this buf,
 *                  should have been allocated to hold a cluster
 * @param entry     entry offset within the cluster is placed into this var
 * @param flag      ENTRY_MATCH or ENTRY_FREE depending on what you want to
 *                  locate
 *
 * @return    cluster or offset of directory entry, or -1 if it is invalid
 */
static int locate_entry(char *fat, int cluster, char *name,
                        struct dir_entry *de, char *clustbuf, int *entry,
                        int flag) {
  char *buf, fullname[13];
  int i, entries;

  entries = cluster_size(cluster) / BYTES_PER_DIR_ENTRY;

  if ((buf = (char *)malloc(entries * BYTES_PER_DIR_ENTRY)) == NULL) return -1;

  do {

    if (ll_fd_read(cluster, buf) < 0) {
      free(buf);
      return -1;
    }

    for (i=0; i < entries; i++) {
      read_dir_entry(i, buf, de);

      switch (flag) {
        case ENTRY_MATCH:
          if (entry_valid(0xff & de->filename[0])) {
            merge_filename(fullname, de->filename, de->extension);
            if (strcmp(name, fullname) == 0) {
              memcpy(clustbuf, buf, cluster_size(cluster));
              *entry = i;
              free(buf);
              return cluster;
            }
          }
          break;
        case ENTRY_FREE:
          if (!entry_valid(0xff & de->filename[0])) {
            memcpy(clustbuf, buf, cluster_size(cluster));
            *entry = i;
            free(buf);
            return cluster;
          }
          break;
      }
    }

    cluster = read_fat(fat, cluster);

  } while ((cluster & 0xff8) != 0xff8);

  return -1;

}

/*
 * Determines and returns the starting cluster for the directory
 * entries associated with path by attempting to walk the full path.
 * Note the special sentinel usage for indicating the root
 * directory.
 *
 * @param *fat   fat to use for locating linked clusters
 * @param *path  dir path we are locating the starting cluster for
 *
 * @return    starting cluster of directory entries for path,
 *            ROOT_DIR_CLUSTER if path is root, or -1 if path invalid
 */
static int locate_dir_cluster(char *fat, char *path) {
  char *buf, fullname[13], path_copy[MAX_PATH], *tok;
  int i;
  /* starting in the root */
  int cluster = ROOT_DIR_CLUSTER, entries;
  struct dir_entry de;

  if ((buf =
      (char *)malloc(MAX(cluster_size(ROOT_DIR_CLUSTER), dg.bytes_per_clust)))
      == NULL) return -1;

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

    /* will be ROOT_DIR_CLUSTER sentinel on first pass */
    entries = cluster_size(cluster) / BYTES_PER_DIR_ENTRY;

    for (i=0; i<entries; i++) {

      read_dir_entry(i, buf, &de);

      if (((0xff & de.filename[0]) != 0x00) && /* never been used */
          ((0xff & de.filename[0]) != 0xe5)) { /* has been released */
        merge_filename(fullname, de.filename, de.extension);
        if (strcmp(tok, fullname)==0) {
          if (de.attributes == 0x10) { /* directory */
            cluster = de.cluster;
            break;
          } else { /* file */
            free(buf);
            return -1;
          }
        }
      }

      /*
       * If next iteration goes out of the loop then check to see if we
       * should move on to the next cluster.
       */
      if (i + 1 == entries) {
        cluster = read_fat(fat, cluster);
        if ((cluster & 0xff8) == 0xff8) {
          free(buf);
          return -1;
        }
        /* read the next cluster into buf */
        if (ll_fd_read(cluster, buf) < 0) {
          free(buf);
          return -1;
        }
        /* reset the inner for loop */
        i = -1;
      }

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
  int i;

  if (fd > 0) close(fd);
  if ((fd = open(drive, O_RDWR)) < 0) return -1;

  if (read_disk_geometry() < 0) {
    close(fd);
    fd = -1;
    return -1;
  }

  if ((fat_cache =
       (char *)malloc(dg.sects_per_fat * dg.bytes_per_sect)) == NULL) {
    close(fd);
    fd = -1;
    return -1;
  }

  if (load_fat() < 0) {
    close(fd);
    free(fat_cache);
    fd = -1;
    return -1;
  }

  for (i = 0; i < FILES; i++) {
    fd_table[i].active = 0;
  }

  return 0;
}

/*
 * Closes the drive.  Internally this closes the file descriptor and sets
 * it to negative to indicate not open.
 */
void fd_close() {
  int offset, size;

  if (fd < 0) return;
  /* only writing FAT copy on close */
  if (dg.num_fats == 2) {
    size = dg.sects_per_fat * dg.bytes_per_sect;
    offset = 1 * dg.bytes_per_sect + size;
    if (lseek(fd, offset, SEEK_SET) == offset) {
      write(fd, fat_cache, size);
    }
  }

  free(fat_cache);

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
  if ((cluster = locate_dir_cluster(fat_cache, pwd)) < 0) return -1;
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

  if ((cluster = locate_dir_cluster(fat_cache, pwd_copy)) < 0) return -1;
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
  char *buf, release_byte[] = { 0xe5 };
  int cluster, de_offset, dir_cluster, entry, entry_cluster, next_cluster;
  struct dir_entry de;

  if (fd < 0) return -1;
  if (strcmp(name, "..") == 0 || strcmp(name, ".") ==0) return -1;

  /* locate the directory entry for name */
  if ((dir_cluster = locate_dir_cluster(fat_cache, pwd)) < 0) return -1;
  if ((buf = (char *)malloc(cluster_size(dir_cluster))) == NULL)
    return -1;
  entry_cluster =
    locate_entry(fat_cache, dir_cluster, name, &de, buf, &entry, ENTRY_MATCH);

  free(buf);

  if (entry_cluster < 0) return -1;

  if (de.attributes == 0x10 || de.attributes & READ_ONLY ||
      de.attributes & HIDDEN || de.attributes & SYSTEM) return -1;

  de_offset = ctobpos(entry_cluster) + (entry * BYTES_PER_DIR_ENTRY);
  
  /* mark the file as released */
  if (lseek(fd, de_offset, SEEK_SET) != de_offset) return -1;
  if (write(fd, release_byte, 1) != 1) return -1;

  /*
   * Now mark the clusters used by the file as free.  If the file is empty,
   * then its first cluster entry will be 0 and there are no clusters to free.
   */
  if (de.cluster != 0) {
    cluster = de.cluster;
    do {
      next_cluster = read_fat(fat_cache, cluster);
      write_fat(fat_cache, cluster, 0);
      cluster = next_cluster;
    } while ((cluster & 0xff8) != 0xff8);
  }

  return commit_fat(fat_cache);
}

/*
 * Attempts to make a directory named name in the present working 
 * directory.  The call will fail if 1) not enough space, 2) illegal
 * dos name, or 3) disk error.
 *
 * @param name    name of new directory to make
 *
 * @return    0 if successful, otherwise -1
 */
int fd_mkdir(char *name) {
  char *buf, *fat_copy;
  int dir_cluster, entry, entry_cluster, new_dir_cluster;
  struct dir_entry de;

  if (fd < 0) return -1;
  if (!is_dosname(name)) return -1;

  if ((dir_cluster = locate_dir_cluster(fat_cache, pwd)) < 0) return -1;
  if ((buf = (char *)malloc(cluster_size(dir_cluster))) == NULL) return -1;

  if (locate_entry(fat_cache, dir_cluster, name, &de, buf, &entry,
                   ENTRY_MATCH) >= ROOT_DIR_CLUSTER) {
    /* already exists */
    free(buf);
    return -1;
  }

  /*
   * From this point on we will be modifying the fat so we will work
   * with a copy of the actual fat_cache so that to "undo" anything
   * in case of error is simply a matter of not accepting the new fat.
   */
  if ((fat_copy =
       (char *)malloc(dg.sects_per_fat * dg.bytes_per_sect)) == NULL) {
    free(buf);
    return -1;
  }
  memcpy(fat_copy, fat_cache, dg.sects_per_fat * dg.bytes_per_sect);

  /*
   * Get a new cluster to point our new dir entry at, load, wipe,
   * and initialize.
   */
  if ((new_dir_cluster = fat_free_first(fat_copy, 0xff8)) < 0) {
    free(buf);
    free(fat_copy);
    return -1;
  }

  if (ll_fd_read(new_dir_cluster, buf) < 0) {
    free(buf);
    free(fat_copy);
    return -1;
  }
  wipe_dir_cluster(new_dir_cluster, buf);

  /* set up . and .. directory entries */
  memset(&de, 0x20, sizeof(de));
  de.filename[0] = '.';
  de.attributes = 0x10;
  stamp_datetime( &de.date, &de.time);
  de.cluster = new_dir_cluster;
  de.size = 0;
  memcpy(buf, &de, sizeof(de));

  de.filename[1] = '.';
  de.cluster = dir_cluster;
  memcpy(buf + BYTES_PER_DIR_ENTRY, &de, sizeof(de));

  /* write it back to the disk */
  if (ll_fd_write(new_dir_cluster, buf) < 0) {
    free(buf);
    free(fat_copy);
    return -1;
  }

  /* find a place to put the directory entry to point at this next cluster */
  if ((entry_cluster =
       locate_entry(fat_copy, dir_cluster, NULL, &de, buf, &entry,
                    ENTRY_FREE)) < 0) {

    /* No free entry, we must add a cluster to the set of dir entry clusters */
    if ((entry_cluster = add_cluster(fat_copy, dir_cluster)) < 0) {
      free(buf);
      free(fat_copy);
      return -1;
    }

    /* load the new cluster and wipe residual entries */
    if (ll_fd_read(entry_cluster, buf) < 0) {
      free(buf);
      free(fat_copy);
      return -1;
    }
    /*
     * The reason that we write the entire buffer and not just the directory
     * entry below is that we may be wiping all the old entries in the new
     * cluster if we had to allocate a cluster to make room for the new entry.
     */
    wipe_dir_cluster(entry_cluster, buf);

    /* in a new cluster all the entries are free so we can use the one at 0 */
    entry = 0;
  }

  split_filename(name, de.filename, de.extension);
  de.attributes = 0x10;
  de.cluster = new_dir_cluster;
  de.size = 0;
  memcpy(buf + (entry * BYTES_PER_DIR_ENTRY), &de, sizeof(de));

  /* and write the modfied dir entry cluster to disk */
  if (ll_fd_write(entry_cluster, buf) < 0) {
    free(buf);
    free(fat_copy);
    return -1;
  }

  memcpy(fat_cache, fat_copy, dg.sects_per_fat * dg.bytes_per_sect);
  free(fat_copy);
  free(buf);

  return commit_fat(fat_cache);
}

/*
 * Attempts to copy the file indicated by *src from the current directory to
 * a new file to be named *dst in the current directory.
 *
 * @param *src    name of source file
 * @param *dst    name for destination file
 *
 * @return    0 if successful, otherwise -1
 */
int fd_cp(char *src, char *dst) {
  char *buf, *fat_copy;
  int clusters_needed, dir_cluster, entry, entry_cluster;
  struct dir_entry src_de, dst_de;

  if (fd < 0) return -1;
  if (!is_dosname(dst)) return -1;

  if ((dir_cluster = locate_dir_cluster(fat_cache, pwd)) < 0) return -1;

  if ((buf = (char *)malloc(cluster_size(dir_cluster))) == NULL) return -1;

  /* checking for valid source and destination */
  if (locate_entry(fat_cache, dir_cluster, dst, &dst_de, buf, &entry,
                   ENTRY_MATCH) >= ROOT_DIR_CLUSTER) {
    /* destination already exists */
    free(buf);
    return -1;
  }

  if (locate_entry(fat_cache, dir_cluster, src, &src_de, buf, &entry,
                   ENTRY_MATCH) < 0) {
    /* can't find source */
    free(buf);
    return -1;
  }

  if (src_de.attributes == 0x10) {
    /* we don't do directories */
    free(buf);
    return -1;
  }

  clusters_needed = src_de.size / dg.bytes_per_clust;
  if (src_de.size % dg.bytes_per_clust) clusters_needed++;

  if (clusters_needed > fat_free_cnt(fat_cache)) {
    free(buf);
    return -1;
  }

  /*
   * From this point on we will be modifying the fat so we will work
   * with a copy of the actual fat_cache so that to "undo" anything
   * in case of error is simply a matter of not accepting the new fat.
   */
  if ((fat_copy =
       (char *)malloc(dg.sects_per_fat * dg.bytes_per_sect)) == NULL) {
    free(buf);
    return -1;
  }
  memcpy(fat_copy, fat_cache, dg.sects_per_fat * dg.bytes_per_sect);

  /* now find a place to put the directory entry to point at this new file */
  if ((entry_cluster =
       locate_entry(fat_copy, dir_cluster, NULL, &dst_de, buf, &entry,
                    ENTRY_FREE)) < 0) {

    /*
     * No free entry, we need to get a cluster for a new entry, check to make
     * sure enough space for the entry cluster and the file.
     */
    clusters_needed++;
    if (clusters_needed > fat_free_cnt(fat_copy)) {
      free(buf);
      free(fat_copy);
      return -1;
    }

    /* get a new cluster and add it to the set of directory entries */
    if ((entry_cluster = add_cluster(fat_copy, dir_cluster)) < 0) {
      free(buf);
      free(fat_copy);
      return -1;
    }

    /* load the new cluster and wipe residual entries */
    if (ll_fd_read(entry_cluster, buf) < 0) {
      free(buf);
      free(fat_copy);
      return -1;
    }
    wipe_dir_cluster(entry_cluster, buf);

    /* in a new cluster all the entries are free so we can use the one at 0 */
    entry = 0;
  }

  /* set up the desination dir entry */
  memcpy(&dst_de, &src_de, sizeof(src_de));
  split_filename(dst, dst_de.filename, dst_de.extension);
  stamp_datetime(&dst_de.date, &dst_de.time);

  if (clusters_needed == 0) {
    dst_de.cluster = 0;
  } else {
    /* lots of vars used right here, so we'll define locally */
    char *cluster_buf = (char *)malloc(dg.bytes_per_clust);
    int dst_cluster, prev_cluster, src_cluster;
    if (cluster_buf == NULL) {
      free(buf);
      free(fat_copy);
      return -1;
    }
    prev_cluster = 0;
    src_cluster = src_de.cluster;
    dst_cluster = dst_de.cluster = fat_free_first(fat_copy, 0xff8);
    do {
      if (ll_fd_read(src_cluster, cluster_buf) < 0 ||
          ll_fd_write(dst_cluster, cluster_buf) <0) {
        free(cluster_buf);
        free(buf);
        free(fat_copy);
        return -1;
      }
      if (prev_cluster) write_fat(fat_copy, prev_cluster, dst_cluster);
      prev_cluster = dst_cluster;
      dst_cluster = fat_free_next(fat_copy, dst_cluster, 0xff8);
      src_cluster = read_fat(fat_copy, src_cluster);
    } while ((src_cluster & 0xff8) != 0xff8);
    write_fat(fat_copy, prev_cluster, 0xff8);
    free(cluster_buf);
  }

  /* now the new directory entry has the proper cluster, so write it */
  memcpy(buf + entry * BYTES_PER_DIR_ENTRY, &dst_de, sizeof(dst_de));

  /* write the new directory entry to disk */
  if (ll_fd_write(entry_cluster, buf) < 0) {
    free(buf);
    free(fat_copy);
    return -1;
  }

  memcpy(fat_cache, fat_copy, dg.sects_per_fat * dg.bytes_per_sect);
  free(fat_copy);
  free(buf);
  return commit_fat(fat_cache);
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

/*
 * Opens the file within the present working directory indicated by *name
 * with mode.
 *
 * @param *name    name of file to open in pwd
 * @param mode     O_READ or O_WRITE
 *
 * @return    file handle on success, otherwise -1
 */
int fd_fopen(char *name, int mode) {
  char *buf, *fat_copy;
  int de_offset, dir_cluster, entry, entry_cluster, i;
  struct dir_entry de;

  if (fd < 0) return -1;
  if (mode != O_READ && mode != O_WRITE) return -1;

  if ((dir_cluster = locate_dir_cluster(fat_cache, pwd)) < 0) return -1;

  if ((buf =
      (char *)malloc(MAX(cluster_size(ROOT_DIR_CLUSTER), dg.bytes_per_clust)))
      == NULL) return -1;

  /*
   * From this point on we will be modifying the fat so we will work
   * with a copy of the actual fat_cache so that to "undo" anything
   * in case of error is simply a matter of not accepting the new fat.
   */
  if ((fat_copy =
       (char *)malloc(dg.sects_per_fat * dg.bytes_per_sect)) == NULL) {
    free(buf);
    return -1;
  }
  memcpy(fat_copy, fat_cache, dg.sects_per_fat * dg.bytes_per_sect);

  if ((entry_cluster = locate_entry(fat_copy, dir_cluster, name, &de, buf,
                                    &entry, ENTRY_MATCH)) < 0) {
    /*
     * The file doesn't exist, if O_READ, failure, if OWRITE then create the
     * file.
     */
    if (mode == O_READ) {
      free(buf);
      free(fat_copy);
      return -1;
    }

    if (!is_dosname(name)) {
      free(buf);
      free(fat_copy);
      return -1;
    }

    if ((entry_cluster = locate_entry(fat_copy, dir_cluster, name, &de, buf,
                                      &entry, ENTRY_FREE)) < 0) {

      /* needs a new cluster for the new entry */
      if ((entry_cluster = add_cluster(fat_copy, dir_cluster)) < 0) {
        free(buf);
        free(fat_copy);
        return -1;
      }

      /* load the new cluster and wipe residual entries */
      if (ll_fd_read(entry_cluster, buf) < 0) {
        free(buf);
        free(fat_copy);
        return -1;
      }
      wipe_dir_cluster(entry_cluster, buf);

      /* in a new cluster all the entries are free so use the one at 0 */
      entry = 0;
    }

    /* set up the dir entry for the new file */
    memset(&de, 0x20, sizeof(de));
    split_filename(name, de.filename, de.extension);
    stamp_datetime(&de.date, &de.time);
    de.size = 0;
    de.cluster = 0;

    de_offset = ctobpos(entry_cluster) + (entry * BYTES_PER_DIR_ENTRY);

    /* now write the new dir entry to disk */
    if (lseek(fd, de_offset, SEEK_SET) != de_offset ||
        write(fd, &de, sizeof(de)) != sizeof(de)) {
      free(buf);
      free(fat_copy);
      return -1;
    }

  }

  free(buf);

  if (de.attributes == 0x10) {
    free(fat_copy);
    return -1;
  }

  for (i = 0; i < FILES; i++) {
    if (fd_table[i].active == 0) break;
  }

  if (i == FILES) {
    free(fat_copy);
    return -1;
  }
  
  /* file descriptor at i is available */
  fd_table[i].active = 1;
  strcpy(fd_table[i].name, pwd);
  strncat(fd_table[i].name, name, strlen(name));  
  fd_table[i].mode = mode;
  fd_table[i].attributes = de.attributes;
  fd_table[i].cluster = fd_table[i].next_cluster = de.cluster;
  fd_table[i].size = de.size;
  fd_table[i].pos = 0;
  memcpy(&fd_table[i].de, &de, sizeof(de));

  fd_table[i].de_offset = ctobpos(entry_cluster) +
                          (entry * BYTES_PER_DIR_ENTRY);

  memcpy(fat_cache, fat_copy, dg.sects_per_fat * dg.bytes_per_sect);
  free(fat_copy);
  commit_fat(fat_cache);

  return i;
}

/*
 * Reads from the file associated with fhandle placing up to len
 * available characters into *buf.
 *
 * @param fhandle    handle to file
 * @param *buf       buffer to place read data in
 * @param len        maximum number of characters to be placed in
 *                   *buf
 *
 * @return    number of characters read and placed in *buf or -1
 *            on error
 */
int fd_fread(int fhandle, char *buf, int len) {
  char *clust_buf;
  int data_read = 0, size, start;
  struct file_descriptor *fdp;

  if (fd < 0) return -1;
  if (fhandle < 0 || fhandle >= FILES) return -1;

  fdp = &fd_table[fhandle];
  if (fdp->active == 0 || fdp->mode != O_READ) return -1;

  if ((clust_buf = (char *)malloc(dg.bytes_per_clust)) == NULL)
    return -1;

  while (data_read < len && fdp->pos < fdp->size) {

    if (ll_fd_read(fdp->next_cluster, clust_buf) < 0) {
      free(clust_buf);
      return -1;
    }

    start = fdp->pos % dg.bytes_per_clust;
    /*
     * Most that can be read the smallest of:
     * 1) space left in users buffer
     * 2) space left in rest of cluster
     * 3) space left in rest of file
     */
    size = MIN(len - data_read, dg.bytes_per_clust - start);
    size = MIN(size, fdp->size - fdp->pos);

    memcpy(buf + data_read, clust_buf + start, size);
    data_read += size;
    fdp->pos += size;

    if (start + size == dg.bytes_per_clust) {
      fdp->next_cluster = read_fat(fat_cache, fdp->next_cluster);
    }

  }

  free(clust_buf);
  return data_read;
  
}

/*
 * Writes to the file associated with fhandle using len characters
 * from *buf.
 *
 * @param fhandle    handle to file
 * @param *buf       buffer where characters to write reside
 * @param len        number of characters to write from *buf
 *
 * @return    number of characters written or -1 if error
 */
int fd_fwrite(int fhandle, char *buf, int len) {
  char *clust_buf, *fat_copy;
  int data_written = 0, size, start;
  struct file_descriptor *fdp;

  if (fd < 0) return -1;
  if (fhandle < 0 || fhandle >= FILES) return -1;

  fdp = &fd_table[fhandle];
  if (fdp->active == 0 || fdp->mode != O_WRITE) return -1;

  if ((clust_buf = (char *)malloc(dg.bytes_per_clust)) == NULL)
    return -1;

  /*
   * From this point on we will be modifying the fat so we will work
   * with a copy of the actual fat_cache so that to "undo" anything
   * in case of error is simply a matter of not accepting the new fat.
   */
  if ((fat_copy =
       (char *)malloc(dg.sects_per_fat * dg.bytes_per_sect)) == NULL) {
    free(clust_buf);
    return -1;
  }
  memcpy(fat_copy, fat_cache, dg.sects_per_fat * dg.bytes_per_sect);

  while (data_written < len) {

    /*
     * A cluster will have to be allocated to the file in two cases:
     * 1) the first write to an empty file, indicated by cluster = 0
     * 2) every time we hit the end of the last cluster in the file
     *    indicated by next_cluster = 0xff8
     */
    if (fdp->cluster == 0) { /* empty file first write */
      if ((fdp->cluster = fdp->next_cluster =
           fat_free_first(fat_copy, 0xff8)) < 0) {
        free(clust_buf);
        free(fat_copy);
        return -1;
      }
    } else if ((fdp->next_cluster & 0xff8) == 0xff8) { /* last cluster */
      if ((fdp->next_cluster = add_cluster(fat_copy, fdp->cluster)) < 0) {
        free(clust_buf);
        free(fat_copy);
        return -1;
      }
    }

    if (ll_fd_read(fdp->next_cluster, clust_buf) < 0) {
      free(clust_buf);
      free(fat_copy);
      return -1;
    }

    start = fdp->pos % dg.bytes_per_clust;
    size = MIN(len - data_written, dg.bytes_per_clust - start);

    memcpy(clust_buf + start, buf + data_written, size);

    if (ll_fd_write(fdp->next_cluster, clust_buf) < 0) {
      free(clust_buf);
      free(fat_copy);
      return -1;
    }

    data_written += size;
    fdp->pos += size;
    if (fdp->pos > fdp->de.size) fdp->de.size = fdp->pos;

    if (start + size == dg.bytes_per_clust) {
      fdp->next_cluster = read_fat(fat_copy, fdp->next_cluster);
    }

  }

  free(clust_buf);

  fdp->de.cluster = fdp->cluster;
  stamp_datetime(&fdp->de.date, &fdp->de.time);

  if (lseek(fd, fdp->de_offset, SEEK_SET) != fdp->de_offset) {
    free(fat_copy);
    return -1;
  }

  if (write(fd, &fdp->de, sizeof(fdp->de)) != sizeof(fdp->de)) {
    free(fat_copy);
    return -1;
  }

  memcpy(fat_cache, fat_copy, dg.sects_per_fat * dg.bytes_per_sect);
  free(fat_copy);

  if (commit_fat(fat_cache) < 0) return -1;

  return data_written;
}

/*
 * Sets the current position within the file associated with fhandle.
 *
 * @param fhandle    handle to file
 * @param offset     position to set to
 *
 * @return    new position or -1 if error
 */
int fd_fseek(int fhandle, int offset) {
  int cluster_offset;
  struct file_descriptor *fdp;

  if (fd < 0) return -1;
  if (fhandle < 0 || fhandle >= FILES) return -1;

  fdp = &fd_table[fhandle];
  if (fdp->active == 0) return -1;

  /* only sequential, can't go backwards, as per instructions */
  if (offset < fdp->pos || offset >= fdp->size)
    return -1;

  fdp->pos = offset;

  fdp->next_cluster = fdp->cluster;

  /* next cluster is adjust to be the cluster that holds offset */
  cluster_offset = offset / dg.bytes_per_clust;
  while (cluster_offset) {
    fdp->next_cluster = read_fat(fat_cache, fdp->next_cluster);
  }

  return offset;
}

/*
 * Closes the file associated with fhandle and frees any associated
 * resources.
 *
 * @param fhandle    handle to file
 */
void fd_fclose(int fhandle) {
  if (fhandle >= 0 && fhandle < FILES) fd_table[fhandle].active = 0;
}
