#include <stdio.h>
#include <stdlib.h>

int main()
{
    int n;
    printf("Introduceti n:\n");
    scanf("%d", &n);
    int **matrice;
    matrice = (int**) malloc(n*sizeof(int*)); //alocare linii
    int i;
    int j;
    for(i=0; i<n; i++)
    {    
        matrice[i] = (int*) malloc(n*sizeof(int)); //alocare coloane
    }
    printf("Introduceti elementele matricei:\n");
    for(i=0; i<n; i++)
    {
        for(j=0; j<n; j++)
        {
            scanf("%d", &matrice[i][j]);
        }
    }

    printf("a) Afisare matrice: \n");
    for(i=0; i<n; i++)
    {
        for(j=0; j<n; j++)
        {
            printf("%d\t", matrice[i][j]);
        }
        printf("\n");
    }
    printf("b) Elementul de la intersectia diagonalelor: "); //trebuie sa afisam elementul matrice[n/2][n/2]
    if(n%2==1)
        printf("%d", *(*(matrice + n/2)+ n/2));
    else
        printf("Nu exista!");

    printf("\nc) Elementele de pe diagonale: ");

    for(i=0; i<n; i++)
    {
        for(j=0; j<n; j++){
            if(i==j || i+j == n-1) 
                printf("%d ", *(*(matrice + i) + j));
        }
    }

    for(i=0; i<n; i++)
    {
        free(matrice[i]);
    }
    free(matrice);
    return 0;
}