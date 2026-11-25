## **Tabela de Classificação em Haskell**

Projeto desenvolvido por: 

- Carlos Sacerdote
- Arthur Domingues 
- Rafael Brandão 
- Gustavo Fagundes.

O objetivo é calcular a classificação de um campeonato de futebol a partir dos resultados das partidas

---

## **O que o programa faz**

- Mostra a classificação final e após a 3ª rodada.
- Calcula pontos, saldo de gols e aproveitamento dos times.
- Mostra a maior goleada e a média de gols.
- Identifica erros nos dados das partidas.

A classificação considera pontos, vitórias, saldo de gols, gols marcados e nome do time, nessa ordem

---

## **Organização dos arquivos**

- Tipos.hs: tipos dos dados e consultas básicas.
- Dados.hs: dados do campeonato.
- Classificacao.hs: cálculos e classificação.
- Leitura.hs: leitura, validação e formatação da tabela.
- Main.hs: execução do programa.
- tests/Testes.hs: testes da Camada 1.
- docs/decisoes.md: espaço para registrar decisões e limitações.

---

## **Como executar o Main.hs**

É necessário ter o GHC instalado, com o comando runghc disponível.

Abra o terminal na pasta principal do repositório e execute:

runghc -isrc src/Main.hs

O programa utiliza os dados de src/Dados.hs. Não é necessário digitar os resultados no terminal

---

## **Como compilar**

Na pasta principal do repositório, execute:

ghc -Wall -isrc src/Main.hs -o campeonato

Depois, no Windows PowerShell, execute:

.\campeonato.exe

---

## **Como executar os testes**

Na pasta principal do repositório, execute:

runghc -isrc tests/Testes.hs

Os testes mostram OK quando o resultado está correto e FALHOU quando é diferente do esperado

---

## **Formato dos dados**

Cada partida deve seguir esta ordem, com os campos separados por ponto e vírgula:

rodada;mandante;gols do mandante;gols do visitante;visitante

Exemplo:

1;Coritiba;2;1;Athletico

Linhas vazias e linhas começando com # são ignoradas

O programa identifica:

- Quantidade incorreta de campos ou nomes de times vazios
- Números inválidos na rodada ou nos gols
- Gols negativos
- Um time jogando contra ele mesmo
- Um time jogando mais de uma vez na mesma rodada
