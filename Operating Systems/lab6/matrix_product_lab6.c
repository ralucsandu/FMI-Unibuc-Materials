#include <stdlib.h>
#include <pthread.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>

int **matrixA, **matrixB; 

struct matrix
{ int i, j, p;};

void *product(void *m)
{
    struct matrix *arg = m;
    int x;
    int* sum = (int*)malloc(sizeof(int));
    *sum=0;

    for (x=0; x < arg->p; x++)
        *sum += matrixA[arg->i][x] *  matrixB[x][arg->j];
    
    free(m);
    m=NULL;

    return sum;
}

int main()
{
    int i, j, id=0, m, p1, p2, n;
    void *result;

    printf("The dimensions of the matrix A are: ");
    scanf("%d %d", &m, &p1);
    printf("The elements of the matrix A are: \n");
    matrixA = (int**)malloc(sizeof (int*) *m);
    for (i=0; i<m; ++i)
    {
        matrixA[i] = (int*)malloc(sizeof(int)*p1);
        for(j=0; j<p1; ++j)
        {
            int elem;
            scanf("%d", &elem);
            matrixA[i][j]=elem;
        }
    }

    printf("The dimensions of the matrix B are: ");
    scanf("%d %d", &p2, &n);

    if(p1 == p2)
    {
    printf("The elements of the matrix B are: \n");
    matrixB = (int**)malloc(sizeof(int*)*p2);
    for (i=0; i<p2; ++i)
    {
        matrixB[i] = (int*)malloc(sizeof(int)*n);
        for(j=0; j<n; ++j)
        {
            int elem;
            scanf("%d", &elem);
            matrixB[i][j]=elem;
        }
    }

    pthread_t thr[m*n];
    int result_matrix[m][n];

    for(i=0; i<m; ++i)
    {
        for(j=0; j<n; ++j)
        {
            struct matrix *arg = (struct matrix*)malloc(sizeof(struct matrix));
            arg->i = i;
            arg->j = j;
            arg->p = p1;

            if(pthread_create(&thr[id++], NULL, product, arg))
            {
                perror(NULL);
                return errno;
            }
        }
    }

    id=0;

    for(i=0; i<m; ++i)
        for(j=0; j<n; ++j)
        {
            if(pthread_join(thr[id++], &result))
            {
                perror(NULL);
                return errno;
            }
            result_matrix[i][j] = *((int*)result);
        }
    free(result);
    result = NULL;

    printf("\nThe resulted matrix is: \n");
    for(i=0; i<m; ++i)
    {
        for(j=0; j<n; ++j)
            printf("%d ", result_matrix[i][j]);
        printf("\n");
    }

    for(i=0; i<p1; ++i)
        free(matrixA[i]);
    free(matrixA);

    for(i=0; i<p2; ++i)
        free(matrixB[i]);
    free(matrixB);

    }

    else 
    {
        printf("\nThe dimensions are incompatible!\n");

    }
    return 0;
}