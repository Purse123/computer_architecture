CC=gcc
CFLAGS= -Wall -Wextra
LIBS= -lm

q1: 1-conversion.c
	$(CC) 1-conversion.c -o 1-conversion $(CFLAGS) $(LIBS)
q2: 2-add_sub_bin.c
	$(CC) 2-add_sub_bin.c -o 2-add_sub_bin $(CFLAGS) $(LIBS)
clean:
	rm 1-conversion 2-add_sub_bin
