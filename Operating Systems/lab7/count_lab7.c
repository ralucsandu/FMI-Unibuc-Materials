#include <stdio.h>
#include <pthread.h>
#include <errno.h>
#include <stdlib.h>

#define MAX_RESOURCES 5
int available_resources = MAX_RESOURCES;
pthread_mutex_t mutex;

int decrease_count(int count)
{
    pthread_mutex_lock(&mutex);
    if(available_resources<count)
    {
        pthread_mutex_unlock(&mutex);
        return -1;
    }
    else
    {
        available_resources -= count;
        printf("Got %d resources %d remaining\n", count, available_resources);
    }
    pthread_mutex_unlock(&mutex);
    return 0;
}

int increase_count(int count)
{
    pthread_mutex_lock(&mutex);
    available_resources += count;
    printf("Released %d resources %d remaining\n", count, available_resources);
    pthread_mutex_unlock(&mutex);
    return 0;
}

void* thread_routine(void* arg)
{
    int index = *((int*) arg);
    if (index>0)
        increase_count(index);
    else
        decrease_count(-index);
    free(arg);
    return NULL;
}

int main()
{
    if (pthread_mutex_init(&mutex, NULL))
    {
        perror(NULL);
        return errno;
    }
    printf("MAX_RESOURCES = %d\n", available_resources);
    pthread_t * tid = malloc(sizeof(tid)*10);

    for(int i=0; i<10; ++i)
    {
        int* add = malloc(sizeof(int));
        *add = rand()%10-5;

        if(pthread_create(tid+i, NULL, thread_routine, add))
        {
            perror(NULL);
            return errno;
        }
    }

    for(int i=0; i<10; ++i)
    {
        if(pthread_join(tid[i], NULL))
        {
            perror(NULL);
            return errno;
        }
    }
    free(tid);
    pthread_mutex_destroy(&mutex);
    return 0;
}