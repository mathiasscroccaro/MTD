#include <stdio.h>
#include <unistd.h>
#include <wiringPi.h>
#include <sys/wait.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <signal.h>
#include <fcntl.h>
#include <string.h>
#include <poll.h>
#include <stdlib.h>
#include <unistd.h>

// BCM reference pins
#define ledPin "23"
#define pushButtonPin "24"

void initGPIO(void);
void waitButton(void);
void doCalibration(void);
void doMeasurement(void);
void doAnalysis(void);
void mainFunc(void);

void initGPIO(void)
{
	int fd;
	char str[20];

	fd = open("/sys/class/gpio/export", O_WRONLY);
	write(fd,ledPin,2);
	close(fd);
	
	fd = open("/sys/class/gpio/export", O_WRONLY);
	write(fd,pushButtonPin,2);
	close(fd);
	
	fd = open("/sys/class/gpio/gpio23/direction", O_WRONLY);
	write(fd,"out",3);
	close(fd);

	fd = open("/sys/class/gpio/gpio24/direction", O_WRONLY);
	write(fd,"in",2);
	close(fd);
	
	fd = open("/sys/class/gpio/gpio24/edge", O_WRONLY);
	write(fd,"rising",6);
	close(fd);
}

void waitButton(void)
{
	pid_t pid;
	int status;
	struct pollfd fds[1];
	char aux[16];
	int fd;
	char value;

	fd = open("/sys/class/gpio/gpio23/value", O_WRONLY);
	write(fd,"1",1);
	close(fd);

	while(1)
	{

		fd = open("/sys/class/gpio/gpio24/value",O_RDONLY);
		read(fd, aux, sizeof(aux));
		value = aux[0];
		if (value == '1')
		{
			break;
		}
		usleep(10000);
		close(fd);
	}		

	/*
	
	fds[0].fd = open("/sys/class/gpio/gpio24/value",O_RDONLY);
	fds[0].events = POLLPRI | POLLERR;

	read(fds[0].fd, aux, sizeof(aux));

	poll(fds,1,-1);
		
	if (fds[0].revents & POLLPRI)
		printf("Button pressed!\n");	

	close(fds[0].fd);

	*/

	fd = open("/sys/class/gpio/gpio23/value", O_WRONLY);
	write(fd,"0",1);
	close(fd);
}

void doCalibration(void)
{
	pid_t pid;
	char *argvCalibration[] = {"./calibration",NULL};
	int status;

	pid = fork();
	if (pid == 0)
		execvp(argvCalibration[0],argvCalibration);
	else
		wait(&status);
}

void doMeasurement(void)
{
	pid_t pid;
	char *argvPyleptonCapture[] = {"./pylepton_capture",NULL};
	int status;

	pid = fork();
	if (pid == 0)
		execvp(argvPyleptonCapture[0],argvPyleptonCapture);
	else
		wait(&status);
}

void doAnalysis(void)
{
	pid_t pid;
	char *argvNeuralNetwork[] = {"./loadTrainnedNetwork",NULL};
	int status;

	pid = fork();
	if (pid == 0)
		execvp(argvNeuralNetwork[0],argvNeuralNetwork);
	else
		wait(&status);
}

void mainFunc(void)
{
	pid_t pid;
	int status;
	
	printf("\nIniciando GPIO...\n");
	initGPIO();
	printf("\nAguardando botão ser pressionado para calibração...\n");
	waitButton();
	printf("\nCalibrando...\n");
	doCalibration();
	usleep(100000);
	printf("\nAguardando botão ser pressionado para medida...\n");
	waitButton();
	doMeasurement();
	printf("\nMedida feita\n\nRealizando Análise...\n");
	doAnalysis();
	printf("\nAnálise completa!\n");
}

int main()
{
	/*
	pid_t pid;
	int status,error;

	char *argvCalibration[] = {"./calibration",NULL};
	char *argvPyleptonCapture[] = {"./pylepton_capture",NULL};
	char *argvNeuralNetwork[] = {"./loadTrainnedNetwork",NULL};
	*/

	mainFunc();

	return 0;
	
	/*

	pid = fork();
	if (pid == 0)
		execvp(argvCalibration[0],argvCalibration);
	else
		wait(&status);
	

	pid = fork();
	if (pid == 0)
		execvp(argvPyleptonCapture[0],argvPyleptonCapture);
	else
		wait(&status);


	pid = fork();
	if (pid == 0)
		execvp(argvNeuralNetwork[0],argvNeuralNetwork);
	else
		wait(&status);
	
	
	return 0;
	*/
}
