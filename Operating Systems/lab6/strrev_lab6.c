#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>

void* string_reverse(void* sir)
{
    char* str = (char*)sir;
    int len = strlen(str);
    char* result = malloc(sizeof(char) * len);
    int i;
    for (i=0; i<len; ++i)
        result[len-1-i] = str[i];
    
    return result;
}

int main(int argc, char* argv[])
{
    if (argc !=2)
    {
        perror(NULL);
        return errno;
    }
    char* initial_string = argv[1];
    pthread_t thr; //creez si lansez noul fir de executie

    if (pthread_create(&thr, NULL, string_reverse, initial_string))
    {
        perror(NULL);
        return errno;
    }

    //astept finalizarea executiei unui thread
    char* result = NULL;
    if(pthread_join(thr, (void**)&result))
    {
        perror(NULL);
        return errno;
    }

    printf("%s\n", result);
    free(result);
    return 0;
}
