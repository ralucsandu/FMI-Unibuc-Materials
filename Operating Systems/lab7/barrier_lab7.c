#include <stdlib.h>
#include <pthread.h>
#include <string.h>
#include <errno.h>
#include <stdio.h>
#include <semaphore.h>

sem_t sem;
pthread_mutex_t mutex;
int nr_processes;

void barrier_point()
{
    static int visited = 0;

    pthread_mutex_lock(&mutex);

    visited = visited + 1;


    if (nr_processes == visited)
    {   
        pthread_mutex_unlock(&mutex);
        sem_post(&sem);
        return;
    }
    pthread_mutex_unlock(&mutex);

    sem_wait(&sem);

    sem_post(&sem);
}

void* tfun(void* v)
{
    int *tid = (int*)v;

    printf("%d reached the barrier\n", *tid);

    barrier_point();

    printf("%d passed the barrier\n", *tid);

    free(tid);

    return NULL;
}

int main()
{
    sem_init(&sem, 0, 0);
    if(pthread_mutex_init(&mutex, NULL))
    {
        perror(NULL);
        return errno;
    }
    printf("NTHRS = ");
    scanf("%d", &nr_processes);
    
    pthread_t* threads = malloc(sizeof(threads)*nr_processes);

    for(int i=0; i<nr_processes; ++i)
    {
        int* arg = malloc (sizeof arg);
        *arg = i;
        
        if(pthread_create(threads+i, NULL, tfun, arg))
        {
            perror(NULL);
            return errno;
        }
    }

    for(int i=0; i<nr_processes; ++i)
    {
        if(pthread_join(threads[i], NULL))
        {
            perror(NULL);
            return errno;
        }
    }
    sem_destroy(&sem);
    pthread_mutex_destroy(&mutex);
    free(threads);
    return 0;
}