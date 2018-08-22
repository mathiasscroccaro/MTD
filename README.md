# Projeto MTD - Raspberry Pi 

Neste repositório serão encontrados os arquivos utilizados no projeto MTD para análise de dados, processamento de sinais, configuração da RPI.

## Instalação da Raspberry Pi

Para instalar a imagem do Raspbian no cartão sd, seguir os seguintes passos:

1) Colocar o cartão SD no computador;

2) Baixar a imagem do Raspbian;

3) Verificar qual a partição do cartão SD:

	$ fdisk -l

4) Executar o comando para cópia da imagem ao cartão:

	$ dd bs=4M if=/pi_image_path.img of=/dev/sdX && sync

## Sensor de Áudio

O sensor de Áudio está completo. No repositório do sensor de áudio será encontrado os algoritmos utilizados para reconhecimento de um sinal de relé.

----

## Sensor eletromagnético

O sensor eletromagnético está em andamento. No repositório do sensor eletromagnético será encontrado algoritmos para análise dos dados.

