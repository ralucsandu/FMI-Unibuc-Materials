#include <stdio.h>
#include <unistd.h>
#include <sys/stat.h>
#include <errno.h>
#include <fcntl.h>
#include <stdlib.h>
#include <string.h>

int main(int arg, char* argv[])
{
    char* src_path = argv[1];
    char* dst_path = argv[2];

    //informatii despre fisierul sursa
    struct stat stat_buf;
    if (stat(src_path, &stat_buf) == -1)
    {
        perror("Stat failed at src!");
        return errno;
    }

    //deschidem fisierul sursa
    int f_src = open(src_path, O_RDONLY);
    if (f_src == -1)
    {
        perror("Open src file failed! File may not exist");
        return errno;
    }
    
    //alocam memorie pentru fisierul sursa
    char* buf = (char*)malloc(1 + stat_buf.st_size * sizeof(char));
    if (buf == NULL)
    {
        perror("Failed to allocate memory!");
        return errno;
    }

    //stocam continutul fisierului sursa in buf
    int offset;
    size_t nr_bytes_read;
    for (offset = 0; offset < stat_buf.st_size; offset += nr_bytes_read)
        {
            nr_bytes_read = read(f_src, buf + offset, stat_buf.st_size - offset);

            if(nr_bytes_read == -1)
            {
                perror("Failed to read!");
                return errno;
            }   
        }

    buf[stat_buf.st_size] = '\0';

    //deschidem fisierul destinatie
    int f_dst = open(dst_path, O_WRONLY| O_CREAT, S_IRWXU);
    if (f_dst == -1)    
    {
        perror("Open dst file failed! File may not exist!");
        return errno;
    }

    //scriem continutul din buf in fisierul sursa
    size_t nr_bytes_written;
    for ( offset = 0; offset < strlen(buf); offset += nr_bytes_written)
    {
        nr_bytes_written = write(f_dst, buf + offset, strlen(buf) - offset);

        if (nr_bytes_written == -1)
        {
            perror("Failed to write!");
            return errno;
        }
    }
    free(buf);
    close(f_src);
    close(f_dst);
    return 0;
}