CC=gcc
CFLAGS= -Wall -Wextra
LIBS= -lm

q1: 1-conversion.c
	$(CC) 1-conversion.c -o 1-conversion $(CFLAGS) $(LIBS)
q2: 2-add_sub_bin.c
	$(CC) 2-add_sub_bin.c -o 2-add_sub_bin $(CFLAGS) $(LIBS)
q3: 3-mult_div.c
	$(CC) 3-mult_div.c -o 3-mult_div $(CFLAGS) $(LIBS)
q15: 15-pipelining.c
	$(CC) 15-pipelining.c -o 15-pipelining $(CFLAGS) $(LIBS)
q16: 16-booth_add_sub.c
	$(CC) 16-booth_add_sub.c -o 16-booth_add_sub $(CFLAGS) $(LIBS)
q17: 17-booth_mult_div.c
	$(CC) 17-booth_mult_div.c -o 17-booth_mult_div $(CFLAGS) $(LIBS)

clean:
	rm 1-conversion 2-add_sub_bin 3-mult_div 15-pipelining 16-booth_add_sub 17-booth_mult_div
