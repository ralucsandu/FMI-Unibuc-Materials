//Rescrieti programul helloworld din lab1 folosind numai functii sistem

#include <unistd.h>
#include <string.h>
#include <stdio.h>


int main()
{
    const char* hello = "Hello World!\n";
    write(1, hello, strlen(hello));
    return 0;
}