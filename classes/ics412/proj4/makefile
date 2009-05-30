CC=gcc
MODCFLAGS := -Wall -DMODULE -D__KERNEL__ -DLINUX

my_xtime.o: my_xtime.c /usr/include/linux/version.h
	$(CC) my_xtime.c -c $(MODCFLAGS)
