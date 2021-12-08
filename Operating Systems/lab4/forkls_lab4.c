#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <sys/errno.h>
#include <sys/types.h>
#include <sys/wait.h>

int main()
{
    pid_t pid = fork(); //creez proces nou
    if (pid < 0)
    {
        perror("Invalid PID!\n");
        return errno;               
    }
    else if (pid == 0) //procesul copil
    {
        char *argv[] = {"ls", NULL};
        const char *path = "/usr/bin/ls";
        execve(path, argv, NULL);
        perror(NULL); //execve nu mai revine in procesul initial decat daca intampina o eroare 
    }
    else //procesul parinte
    {
        printf("My PID = %d, Child PID = %d\n", getppid(), getpid());
        wait(NULL); //parintele isi suspenda activitatea pentru a astepta finalizarea executiei unui proces copil
        printf("Child %d finished \n", getpid());
    }
    return 0;
}