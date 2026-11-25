### **Decisões do projeto**

O projeto foi dividido em módulos para separar os dados, os cálculos, a leitura e a execução do programa, Assim facilitando o entendimento e podendo testar cada parte

---

### **Tipos dos dados**

- Time usa String para representar o nome de cada time
- Resultado usa Vitoria, Empate e Derrota para limitar os resultados possíveis
- Partida e Linha usam campos com nomes para facilitar a leitura e evitar confusão entre os valores
- Pontos e saldo são calculados a partir da Linha, evitando guardar informações repetidas
- Linha guarda vitórias, empates, derrotas e gols, mas não pontos nem o saldo. Esses dois valores são calculados por pontosLinha e saldo, então não tem como a Linha dicar com pontos que não batem com as vitórias e os empates.
- A tabela formatada também usa pontosLinha e saldo, para que o cálculo exista em um lugar só. 

---

### **Cálculo da classificação**

Foi usado o *Foldl* para acumular as estatísticas de cada time, começando com uma linha zerada. O *filter* seleciona as partidas do time e o *map* monta uma linha para cada time da tabela.

A escolha do *foldl*, e não do *foldr*, foi porque o resultado é um único valor acumulado (a Linha) e as partidas são somadas na ordem em que aconteceram, da esquerda para a direita. O *foldr* só traria vantagem se o resultado fosse uma lista contruída aos poucos ou se fosse preciso parar antes do fim, o que não ocorre nesse caso.

A ordenação usa *SortBy* com uma única função de comparação, montada com *comparing*, *Down* e o operador *<>*. Como *Ordering* é um Monoid, o *<>* só passa para o critério seguinte quando o anterior dá empate. Assim não foi preciso escrever uma ordenção á mão nem encadear vários *SortBy*.

Os critérios seguem o regulamento do Campeonato Brasileiro, na ordem: pontos, número de vitórias, saldo de gols, e glos marcados. O nome do time em ordem alfabética entra por último, so para que a ordem seja sempre a mesma quando todos os critérios anteriores empatam.

---

### **Leitura e tratamento de erros**

Os dados ficam em uma String no módulo Dados, com os campos separados por ponto e vírgula. Isso permite executar o programa sem digitar resultados no terminal

- readMaybe converte os números sem lançar uma exceção quando o texto é inválido
- Either retorna uma partida válida ou um erro com a linha ou rodada do problema
- A notação do encadeia as conversões e traverse aplica a leitura às linhas do campeonato
- Maybe representa a ausência de um resultado, como a maior goleada de uma lista vazia
- todosOsErros reúne os erros encontrados, incluindo times repetidos na mesma rodada entre as partidas válidas
- As validações de lerPartida usam a função exigir, que devolve Right () quando a condição vale e Left com o erro quando não vale. Dentro do do, o primeiro Left interrompe a leitura, sem precisar de if ou case aninhados
- A rodada precisa ser um número positivo. Rodada 0 ou negativa gera NumeroInvalido
- maiorGoleada usa maximumBy, que quebra com lista vazia. Isso não acontece porque o caso da lista vazia é tratado antes e devolve Nothing, então a função é total
- Além dos módulos da lista do enunciado, foram usados System.IO (hSetEncoding, para os acentos aparecerem corretamente no terminal do Windows) e System.Exit (exitFailure, nos testes). Os dois fazem parte da biblioteca padrão (base)


Os cálculos e a validação são funções puras. No programa principal, apenas main realiza entrada e saída

---

### **Testes**

Os testes das três camadas ficam em tests/Testes.hs. Os resultados esperados foram definidos para conferir as funções básicas, a tabela final, a tabela após a terceira rodada, os desempates e as entradas inválidas

O programa de testes encerra com falha (exitFailure) no primeiro resultado diferente do esperado e mostra o valor obtido e o esperado. Foi uma escolha para que um erro não passe despercebido no meio de muitas linhas de OK. A desvantagem é que, quando há mais de uma falha, só a primeira aparece

---
### **Limitações conhecidas**

- O desempate não usa confronto direto nem cartões, que fazem parte do regulamento do Brasileirão, porque a partida não guarda essas informações. O nome do time é usado no lugar desses critérios
- Os nomes dos times são comparados exatamente como foram escritos. "Parana" e "Paraná", ou "coritiba" e "Coritiba", são tratados como times diferentes. Só os espaços no início e no fim são removidos
- Números muito grandes na rodada ou nos gols não geram erro: passam do limite do Int e viram outro valor
- todosOsErros mostra primeiro os erros de leitura das linhas e depois os de time repetido na rodada, sem ordenar pelo número da linha. A verificação de time repetido só considera as linhas que foram lidas com sucesso
- O programa não verifica se todos os times jogam em todas as rodadas, nem se as rodadas são seguidas (por exemplo, 1, 2 e 5)
- A tabela formatada alinha números de até 3 caracteres. Valores maiores, como 1000 pontos, deixam as colunas desalinhadas

---