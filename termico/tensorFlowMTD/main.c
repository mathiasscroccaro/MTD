#include <stdio.h>
#include <unistd.h>
#include <wiringPi.h>
#include <sys/wait.h>


int main()
{
	pid_t pid;
	int status,error;

	printf("\nInitializing...\n");

	char *argvPyleptonCapture[] = {"./pylepton_capture",NULL};
	char *argvNeuralNetwork[] = {"./loadTrainnedNetwork",NULL};

	while(1)
	{
		pid = fork();
		if (pid == 0)
		{
			execvp(argvPyleptonCapture[0],argvPyleptonCapture);
		}
		else
		{
			wait(&status);
			pid = fork();
			if (pid == 0)
				execvp(argvNeuralNetwork[0],argvNeuralNetwork);
			else
			{
				wait(&status);
				//if (status)
				//	printf("Medidor L02_M04\n");
				//else
				//	printf("Medidor L02_M15\n");
			}
		}
	}
	return 0;
}
