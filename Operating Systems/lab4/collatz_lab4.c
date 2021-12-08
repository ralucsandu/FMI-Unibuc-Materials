#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/wait.h>
#include <sys/errno.h>
#include <sys/types.h>

int main(int argc, char *argv[]) //argc numarul de argumente = length(argv)
{
    pid_t pid = fork(); //generam un proces nou

    if (pid < 0)
    {
        perror("Invalid PID!\n");
        return errno;
    }
    else if (pid == 0) //suntem in procesul copil
    {
        if (argc != 2 )
        {
            printf("Invalid number of arguments!\n");
            perror(NULL);
        }
        else     //testam ipoteza lui Collatz
        {
            int n = atoi(argv[1]);
            printf("%d: %d ", n, n);
            while(n!=1)
            {
                if (n%2 == 0)
                    n=n/2;
                else
                    n=3*n+1;
                printf("%d ", n);
            }
            printf("\n");
        }
    }
    else
    {
        wait(NULL);
        printf("Child %d finished\n", getpid());
    }
    return 0;
}