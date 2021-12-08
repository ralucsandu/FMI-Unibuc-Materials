#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <sys/types.h>
#include <sys/errno.h>

int main(int argc, char *argv[])
{
    printf("Starting parent %d\n", getpid());
    for(int i=1; i<=argc; ++i)
    {
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
                printf("%d: %d ", n, n);
                while (n!=1)
                {
                    if (n%2==0)
                        n=n/2;
                    else
                        n=3*n+1;
                
                printf("%d ", n);
                }   
            printf("\nDone Parent %d Me %d\n", getppid(), getpid());
            return 1;
            }
        }
    }
    for(int i=1; i<=argc; ++i)
        wait(NULL);
    
    printf("Done Parent %d Me %d\n", getppid(), getpid());
    return 0;
}