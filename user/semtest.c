#include "kernel/types.h"
#include "user/user.h"

#define SEM_ID 0
#define NPROC 5
int main(void)
{
    sem_init(SEM_ID, 2);

    for (int i = 0; i < NPROC; i++)
    {
        int pid = fork();

        if (pid == 0)
        {
            printf("Process %d waiting\n", getpid());

            sem_wait(SEM_ID);

            printf("Process %d ENTERED\n", getpid());

            for (volatile int j = 0; j < 100000000; j++)
                ;

            printf("Process %d EXITING\n", getpid());

            sem_post(SEM_ID);
            exit(0);
        }

        if (pid < 0)
        {
            printf("fork failed\n");
            exit(1);
        }
    }

    for (int i = 0; i < NPROC; i++)
        wait(0);

    printf("Semaphore test complete\n");
    exit(0);
}