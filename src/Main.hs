module Main where

import Tipos
import Dados
import Classificacao
import Leitura
import System.IO (hSetEncoding, stdout, utf8)

dadosInvalidos :: String
dadosInvalidos = unlines
  [ "1;Coritiba;dois;0;Athletico"
  , "2;Paraná;-1;0;Operário"
  , "3;Londrina;1;0;Londrina"
  , "4;Coritiba;1"
  , "5;Coritiba;1;0;Athletico"
  , "5;Coritiba;2;0;Paraná"
  ]

main :: IO ()
main = do
  hSetEncoding stdout utf8
  case lerCampeonato dadosCampeonato of
    Left erro -> putStrLn (mensagemErro erro)
    Right partidas -> do
      let tabela = classificacao partidas

      putStrLn "Classificação final"
      putStrLn (tabelaFormatada tabela)

      putStrLn "Classificação após a 3ª rodada"
      putStrLn (tabelaFormatada (classificacao (ateRodada 3 partidas)))

      putStrLn "Maior goleada"
      case maiorGoleada partidas of
        Nothing -> putStrLn "Nenhuma partida."
        Just partida -> putStrLn
          (mandante partida ++ " " ++ show (golsMandante partida)
            ++ " x " ++ show (golsVisitante partida)
            ++ " " ++ visitante partida)

      case mediaGols partidas of
        Nothing -> putStrLn "Sem partidas para calcular a média."
        Just media -> putStrLn ("Média de gols: " ++ show media)

      putStrLn "\nAproveitamento dos times"
      mapM_ (\linha -> putStrLn
        (time linha ++ ": " ++ show (aproveitamento linha) ++ "%")) tabela

  putStrLn "\nPrimeiro erro da entrada inválida"
  case lerCampeonato dadosInvalidos of
    Left erro -> putStrLn (mensagemErro erro)
    Right partidas -> putStrLn (tabelaFormatada (classificacao partidas))

  putStrLn "\nTodos os erros da entrada inválida"
  mapM_ (putStrLn . mensagemErro) (todosOsErros dadosInvalidos)
