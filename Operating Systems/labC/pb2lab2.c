#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int count_occurrences(const char* text, const char* word) ///abordare: vom folosi functia strstr().
{
    int i;
    int k = 0; //k va retine numarul de aparitii ale cuvantului in textul dat

    for ( i = 0; i < strlen(text) - strlen(word) + 1; i++)
    {
        if(strstr(text + i, word) == text + i)
        {
            k=k+1;
            i = i + strlen(word) - 1;
        }
    }
    
    return k;
}

int main()
{
    char *text = (char*)malloc(100*sizeof(char));
    char *word = (char*)malloc(45*sizeof(char));
    int k = 0;

    printf("Introduceti textul:\n");
    scanf("%[^\n]s", text);

    printf("Introduceti cuvantul cautat:\n");
    scanf("%s", word);

    k = count_occurrences(text, word);

    printf("Numarul de aparitii ale cuvantului in textul dat este: %d.\n", k);
    
    free(text);
    free(word);
    
    return 0;

}