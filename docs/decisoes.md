### **Decisões do projeto**

O projeto foi dividido em módulos para separar os dados, os cálculos, a leitura e a execução do programa. Isso facilita entender e testar cada parte.

---

### **Tipos dos dados**

- Time usa String para representar o nome de cada time.
- Resultado usa Vitoria, Empate e Derrota para limitar os resultados possíveis.
- Partida e Linha usam campos com nomes para facilitar a leitura e evitar confusão entre os valores.
- Pontos e saldo são calculados a partir da Linha, evitando guardar informações repetidas.

---

### **Cálculo da classificação**

Foi usado foldl para acumular as estatísticas de cada time, começando com uma linha zerada. O filter seleciona as partidas do time e o map monta as linhas da tabela.

A ordenação usa sortBy, comparing e Down. Os critérios são pontos, vitórias, saldo de gols, gols marcados e nome do time, nessa ordem. Assim, não foi necessário criar uma ordenação manual.

---

### **Leitura e tratamento de erros**

Os dados ficam em uma String no módulo Dados, com os campos separados por ponto e vírgula. Isso permite executar o programa sem digitar resultados no terminal.

- readMaybe converte os números sem lançar uma exceção quando o texto é inválido.
- Either retorna uma partida válida ou um erro com a linha ou rodada do problema.
- A notação do encadeia as conversões e traverse aplica a leitura às linhas do campeonato.
- Maybe representa a ausência de um resultado, como a maior goleada de uma lista vazia.
- todosOsErros reúne os erros encontrados, incluindo times repetidos na mesma rodada entre as partidas válidas.

Os cálculos e a validação são funções puras. No programa principal, apenas main realiza entrada e saída.

---

### **Testes**

Os testes das três camadas ficam em tests/Testes.hs. Os resultados esperados foram definidos para conferir as funções básicas, a tabela final, a tabela após a terceira rodada, os desempates e as entradas inválidas.

O programa de testes encerra com falha quando encontra um resultado diferente do esperado.

---

### **Limitações conhecidas**

- Os nomes dos times diferenciam letras maiúsculas, minúsculas e acentos. Por isso, os nomes precisam ser escritos da mesma forma em todas as partidas.
- O programa não verifica se o número da rodada é maior que zero.
- lerCampeonato verifica a repetição de times depois de converter as linhas. Se houver uma repetição antes de uma linha com formato ou número inválido, o erro da linha posterior pode ser informado primeiro.
- todosOsErros informa o primeiro erro de leitura de cada linha e verifica as repetições apenas entre as partidas que conseguiu ler.
