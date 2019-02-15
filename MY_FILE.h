#ifndef __MY_FILE_h_
#define __MY_FILE_h_

#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>

#define BUFFER_MAX_SIZE_INNER 128
struct MY_FILE_INNER{
    int file_des;
    unsigned char read_buffer[BUFFER_MAX_SIZE_INNER];
    int current_read_size;
    unsigned char write_buffer[BUFFER_MAX_SIZE_INNER];
    int current_write_size;
};
typedef struct MY_FILE_INNER MY_FILE;


#define MY_EOF -1
MY_FILE * my_open(const char *pathname, const char *mode);
int my_getc(MY_FILE *stream);
int my_putc(int c, MY_FILE *stream);
int my_close(MY_FILE *stream);


#endif 