#include <stdio.h>
#include <unistd.h>
#include <sys/wait.h>

#define ANSI_COLOR_RED 		"\x1b[31m"
#define ANSI_COLOR_BLUE 	"\x1b[34m"
#define ANSI_COLOR_RESET	"\x1b[0m"

int main()
{
	pid_t pid;
	int status,error;

	char *argvOctave[] = {"octave","audioProcessing.m",NULL};
	char *argvRecord[] = {"arecord","-D","dmic_sv","-c2","-r","5000","-f","S32_LE","-t","wav","-V","stereo","-v","audio.wav","-d","5",NULL};

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
					printf(ANSI_COLOR_RED "Encontrada Correlação!!!\n" ANSI_COLOR_RESET);
				else
					printf(ANSI_COLOR_BLUE "Sem correlação\n" ANSI_COLOR_RESET);
			}		
		}			
	}	
	return 0;
}
