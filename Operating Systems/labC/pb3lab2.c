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

char* replace(const char* initial_text, const char* to_replace, const char* with)
{
    int aux = 0; 
    int length = strlen(initial_text) + count_occurrences(initial_text, to_replace) * strlen(with);
    char* final_text = (char*)malloc(sizeof(char) * length);

    while (*initial_text)
    {
        if(strstr(initial_text, to_replace) == initial_text)
        {

            strcpy(&final_text[aux], with);
            aux = aux + strlen(with);
            initial_text = initial_text + strlen(to_replace);
        }
        else
            final_text[aux++] = *initial_text++;

    }

    final_text[aux] = '\0';
    
    return final_text;
}

int main()
{
    char *initial_text = (char*)malloc(100*sizeof(char));
    char *to_replace = (char*)malloc(45*sizeof(char));
    char *with = (char*)malloc(45*sizeof(char));
    char *final_text = NULL;

    printf("Introduceti textul initial:\n");
    scanf("%[^\n]s", initial_text);

    printf("Introduceti cuvantul pe care doriti sa il inlocuiti:\n");
    scanf("%s", to_replace);

    printf("Introduceti cuvantul cu care doriti sa il inlocuiti:\n");
    scanf("%s", with);

    final_text = replace(initial_text, to_replace, with);

    printf("Noul text este: %s\n", final_text);
    
    free(initial_text);
    free(to_replace);
    free(with);
    free(final_text);
    
    return 0;

}