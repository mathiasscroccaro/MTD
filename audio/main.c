#include <stdio.h>
#include <unistd.h>
#include <wiringPi.h>
#include <sys/wait.h>

#define ANSI_COLOR_RED 		"\x1b[31m"
#define ANSI_COLOR_BLUE 	"\x1b[34m"
#define ANSI_COLOR_RESET	"\x1b[0m"

void gpioLow()
{
	pid_t pid;
	int status;
	char *lowGpio[] = {"gpio","-g","write","23","0",NULL};
	
	pid = fork();
	
	if (pid == 0)
		execvp(lowGpio[0],lowGpio);
	else
		wait(&status);
	return;
}

void gpioHigh()
{
	pid_t pid;
	int status;
	char *highGpio[] = {"gpio","-g","write","23","1",NULL};
	
	pid = fork();
	
	if (pid == 0)
		execvp(highGpio[0],highGpio);
	else
		wait(&status);
	return;
}

void init()
{
	pid_t pid;
	int status;
	char *initGpio[] = {"gpio","export","23","out",NULL};
	
	pid = fork();
	if (pid == 0)
		execvp(initGpio[0],initGpio);
	else
		wait(&status);
	return;
}

int main()
{
	pid_t pid;
	int status,error;
	
	char *argvOctave[] = {"octave-cli","audioProcessing.m",NULL};
	char *argvRecord[] = {"arecord","-D","mic_sv","-c2","-r","48000","-f","S32_LE","-t","wav","-V","stereo","-v","audio.wav","-d","3",NULL};

	init();

	while(1)
	{
		pid = fork();
		if (pid == 0)
			execvp(argvRecord[0],argvRecord);
		else if (pid > 0)
		{
			wait(&status);
			pid = fork();
			if (pid == 0)
				execvp(argvOctave[0],argvOctave);
			else
			{
				wait(&status);
				if (status)
					gpioHigh();
					//printf(ANSI_COLOR_RED "Encontrada Correlação!!!\n" ANSI_COLOR_RESET);
					//digitalWrite (16, HIGH) ;
				else
					gpioLow();
					//digitalWrite (16, LOW) ;
					//printf(ANSI_COLOR_BLUE "Sem correlação\n" ANSI_COLOR_RESET);
			}		
		}			
	}	
	return 0;
}
