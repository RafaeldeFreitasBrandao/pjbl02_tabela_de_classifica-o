### ** PJBL02 - Tabela de Classificação em Haskell**

Projeto desenvolvido pelos estudantes:

- Arthur Domingues 
- Carlos Sacerdote
- Gustavo Fagundes
- Rafael Brandão 

### ** Objetivo **
O objetivo do desenvolvimento do projeto é consolidar os fundamentos da programação funcional através de um problema concreto: Calcular a classificação de um campeonato de futebol a partir dos resultados das partidas.

---

### ** Linguagem e Ambiente de Execução **

O projeto foi desenvolvido e testado usando a linguagem Haskell, com o GHC 9.10.3 instalado localmente pelo GHCup, no Windows. O playground só foi usado para prática e mini-testes.

O código utiliza a bilbioteca base, como descrito no projeto, então não é necessário instalar nenhum pacote extra.

### **O que o programa faz**

- Mostra a classificação final e após a 3ª rodada.
- Calcula pontos, saldo de gols e aproveitamento dos times.
- Mostra a maior goleada e a média de gols.
- Identifica erros nos dados das partidas.

A classificação considera pontos, vitórias, saldo de gols, gols marcados e nome do time, nessa ordem

---

### **Organização dos arquivos**

- Tipos.hs: tipos dos dados e consultas básicas.
- Dados.hs: dados do campeonato.
- Classificacao.hs: cálculos e classificação.
- Leitura.hs: leitura, validação e formatação da tabela.
- Main.hs: execução do programa.
- tests/Testes.hs: testes das Camadas 1, 2 e 3.
- docs/decisoes.md: decisões de implementação e limitações conhecidas.

---

### **Como executar o Main.hs**

É necessário ter o GHC instalado, com o comando runghc disponível.

Abra o terminal na pasta principal do repositório e execute:

runghc -isrc src/Main.hs

O programa utiliza os dados de src/Dados.hs. Não é necessário digitar os resultados no terminal

---

### **Como compilar**

Na pasta principal do repositório, execute:

```
ghc -Wall -isrc src/Main.hs -o campeonato
```

Depois, no Windows PowerShell, execute:
```
.\campeonato.exe
```
---

### **Como executar os testes**

O arquivo tests/Testes.hs reúne 50 testes das três camadas, incluindo classificação, desempates e validação dos dados.

Na pasta principal do repositório, execute:
```
runghc -isrc tests/Testes.hs
```

Os testes mostram OK quando o resultado está correto e FALHOU quando é diferente do esperado

---

### **Formato dos dados**

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
