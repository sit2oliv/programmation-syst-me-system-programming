/* veuillez 'sudo apt install indent' et 'sudo apt install valgrind' avant de 'make' */
#include "MY_FILE.h"
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

MY_FILE *my_open(const char *pathname, const char *mode)
{
    int mode_mask = 0;
    int fd = -1;
    if (strcmp(mode, "r") == 0)
    {
        mode_mask = O_RDONLY;
        fd = open(pathname, mode_mask);
    }
    else if (strcmp(mode, "w") == 0)
    {
        mode_mask = O_WRONLY | O_TRUNC | O_CREAT;
        fd = open(pathname, mode_mask, 0600);
    }
    else
        return NULL;

    if (fd < 0)
        return NULL;
    MY_FILE *res = (MY_FILE *)(malloc(sizeof(MY_FILE)));
    res->file_des = fd;
    res->current_read_size = 0;
    res->current_write_size = 0;
    return res;
}
int my_getc(MY_FILE *stream)
{
    if (!stream)
        return MY_EOF;
    if (stream->current_read_size > 0)
    {
        return stream->read_buffer[--(stream->current_read_size)];
    }
    else
    {
        char inner_buffer[BUFFER_MAX_SIZE_INNER] = {};
        int count = read(stream->file_des, inner_buffer, BUFFER_MAX_SIZE_INNER);
        if (count <= 0)
        {
            return MY_EOF;
        }
        else
        {
            int i = 0;
            for ( i = 0; i < count; i++)
            {
                stream->read_buffer[count - 1 - i] = inner_buffer[i];
            }
            stream->current_read_size = count;
            return my_getc(stream);
        }
    }
}

static int flush_inner(MY_FILE *stream)
{
    if (stream->current_write_size <= 0)
        return 0;
    do
    {
        int count = write(stream->file_des, stream->write_buffer, stream->current_write_size);
        if (count < 0)
            return MY_EOF;
        stream->current_write_size -= count;
    } while (stream->current_write_size > 0);
    return 0;
}

int my_putc(int c, MY_FILE *stream)
{
    if (!stream)
    {
        return MY_EOF;
    }
    if (stream->current_write_size < BUFFER_MAX_SIZE_INNER)
    {
        stream->write_buffer[stream->current_write_size] = c;
        stream->current_write_size++;
        return c;
    }
    else
    {
        if(flush_inner(stream) == MY_EOF)
            return MY_EOF;
        return my_putc(c, stream);
    }
}
int my_close(MY_FILE *stream)
{
    if (!stream)
    {
        return MY_EOF;
    }

    if(flush_inner(stream) == MY_EOF)
        return MY_EOF;

    int res = close(stream->file_des);
    if (res != 0)
    {
        free(stream);
        return MY_EOF;
    }
    free(stream);
    return 0;
}
