#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/errno.h>
#include <sys/types.h>
#include <sys/errno.h>
#include <sys/mman.h>
#include <sys/wait.h>
#include <string.h>

int main(int argc, char *argv[])
{
    int i;
    printf("Starting parent %d\n", getpid());

    const char *shm_name = "RalucaSharedFile";

    int shm_fd = shm_open(shm_name, O_CREAT | O_RDWR, S_IRUSR | S_IWUSR);
    
    if (shm_fd < 0)
    {
        perror(NULL);
        return errno;
    }

    size_t shm_size = getpagesize() * argc;

    if (ftruncate(shm_fd, shm_size) == -1)
    {
        perror(NULL);
        shm_unlink(shm_name);
        return errno;
    }

    int offset = 100;

    char *shm_ptr_child;
    for(i=0; i<argc; i++)
    {
        shm_ptr_child = mmap(0, getpagesize(), PROT_READ | PROT_WRITE, MAP_SHARED, shm_fd, getpagesize()*i);

        if (shm_ptr_child == MAP_FAILED)
        {
            perror(NULL);
            shm_unlink(shm_name);
            return errno;
        }

        pid_t pid = fork();

        if(pid<0)
        {
            perror("Invalid PID!\n");
            return errno;
        }
        else if (pid == 0)
        {
            if(argc < 2)
            {
                printf("Invalid number of arguments!\n");
                perror(NULL);
            }

            else
            {
                int n = atoi(argv[i]);
                shm_ptr_child += sprintf(shm_ptr_child, "%d: %d ",n,n);

                while (n!=1)
                {
                    if (n%2==0)
                        n=n/2;
                    else
                        n=3*n+1;

                shm_ptr_child += sprintf(shm_ptr_child, "%d ",n);
                }

                printf("\nDone Parent %d Me %d\n", getppid(), getpid());
                return 1;
            }
        }
        munmap(shm_ptr_child, getpagesize());
    }

    for(i=1; i<argc; i++) //parintele asteapta
        wait(NULL);
    
    for (i=0; i<argc; i++)
    {
        shm_ptr_child = mmap(0, getpagesize(), PROT_READ | PROT_WRITE, MAP_SHARED, shm_fd, getpagesize()*i);

        printf("%s\n", shm_ptr_child);
        munmap(shm_ptr_child, getpagesize());
    }

    shm_unlink(shm_name);

printf("Done Parent %d Me %d\n", getppid(), getpid());
return 0;
}