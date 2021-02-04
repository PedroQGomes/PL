# MIEI - 3ºAno - Processamento de Linguagens

## Trabalho Pratico Nº1 

O primeiro trabalho pratico consiste na elaboração de um projeto usando o FLEX que converte ficheiros HTML para o formato JSON.


### Dependencias

Para este trabalho foi usada a biblioteca glib e a ferramenta Flex

```
sudo apt-get install libglib2.0-dev
```

```
sudo apt-get install flex
```




### Instalação e testes

Para compilar 

```
make
```

Para executar com um ficheiro HTML de input

```
./filtro < Publico_extraction_portuguese_comments_4.html
```
Para limpar a diretoria 

```
make clean
```

## Trabalho Pratico Nº2 

O segundo trabalho pratico consiste na elaboração de uma gramática concreta para o formato TOML tendo como resultado a conversão para o formato JSON.

### Dependencias

Para este trabalho foi usada a biblioteca glib e as ferramentas Flex e Yacc

```
sudo apt-get install libglib2.0-dev
```

```
sudo apt-get install flex
```

```
sudo apt-get install bison -y
```

```
sudo apt-get install byacc -y
```

### Instalação e testes

Para compilar 

```
make tojson
```

Para executar com um ficheiro TOML de input 

```
./tojson < input.toml
```
 
Para limpar a diretoria 

```
make clean
```