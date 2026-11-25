module Main (main) where

import Tipos
import Dados
import Classificacao
import Leitura
import System.Exit (exitFailure)
import System.IO (hSetEncoding, stdout, utf8)

testar :: (Eq a, Show a) => String -> a -> a -> IO ()
testar nome obtido esperado
  | obtido == esperado = putStrLn ("OK      " ++ nome)
  | otherwise          = do
      putStrLn ("FALHOU  " ++ nome ++ ": " ++ show obtido)
      putStrLn ("Esperado: " ++ show esperado)
      exitFailure

exemplo :: Partida
exemplo = Partida 1 "Coritiba" 0 10 "Athletico"

campeonato :: [Partida]
campeonato =
  [ Partida 1 "Coritiba" 1 2 "Athletico", Partida 1 "Paraná" 0 0 "Operário"
  , Partida 1 "Londrina" 1 1 "Cascavel",  Partida 2 "Coritiba" 1 1 "Paraná"
  , Partida 2 "Athletico" 4 0 "Londrina", Partida 2 "Operário" 2 0 "Cascavel"
  , Partida 3 "Operário" 1 0 "Coritiba",  Partida 3 "Cascavel" 3 2 "Athletico"
  , Partida 3 "Paraná" 3 1 "Londrina",    Partida 4 "Londrina" 2 1 "Coritiba"
  , Partida 4 "Athletico" 2 0 "Operário", Partida 4 "Cascavel" 0 2 "Paraná"
  , Partida 5 "Cascavel" 1 0 "Coritiba",  Partida 5 "Paraná" 1 2 "Athletico"
  , Partida 5 "Londrina" 1 1 "Operário"
  ]

tabelaEsperada :: [Linha]
tabelaEsperada =
  [ Linha "Athletico" 5 4 0 1 12 5
  , Linha "Paraná" 5 2 2 1 7 4
  , Linha "Operário" 5 2 2 1 4 3
  , Linha "Cascavel" 5 2 1 2 5 7
  , Linha "Londrina" 5 1 2 2 5 10
  , Linha "Coritiba" 5 0 1 4 3 7
  ]

tabelaRodadaTres :: [Linha]
tabelaRodadaTres =
  [ Linha "Operário" 3 2 1 0 3 0
  , Linha "Athletico" 3 2 0 1 8 4
  , Linha "Paraná" 3 1 2 0 4 2
  , Linha "Cascavel" 3 1 1 1 4 5
  , Linha "Coritiba" 3 0 1 2 2 4
  , Linha "Londrina" 3 0 1 2 2 8
  ]

textoComErros :: String
textoComErros = unlines
  [ "1;Coritiba;dois;0;Athletico"
  , "2;Paraná;-1;0;Operário"
  , "3;Londrina;1;0;Londrina"
  , "4;Coritiba;1"
  , "5;Coritiba;1;0;Athletico"
  , "5;Paraná;0;1;Coritiba"
  ]

main :: IO ()
main = do
  hSetEncoding stdout utf8
  putStrLn "Camada 1: "
  testar "resultadoPara mandante"       (resultadoPara "Coritiba"  exemplo) (Just Derrota)
  testar "resultadoPara visitante"      (resultadoPara "Athletico" exemplo) (Just Vitoria)
  testar "resultadoPara nao jogou"      (resultadoPara "Paraná"    exemplo) Nothing
  testar "resultadoPara empate 0x0"     (resultadoPara "Operário" (Partida 1 "Paraná" 0 0 "Operário")) (Just Empate)
  testar "participou mandante"          (participou "Coritiba" exemplo) True
  testar "participou nao jogou"         (participou "Londrina" exemplo) False
  testar "times sem repeticao, ordenado" (times campeonato)
         ["Athletico", "Cascavel", "Coritiba", "Londrina", "Operário", "Paraná"]
  testar "times de lista vazia"         (times []) []

  putStrLn "\nCamada 2: "
  testar "pontos por resultado" (map pontos [Vitoria, Empate, Derrota]) [3, 1, 0]
  testar "linha do Coritiba" (linhaDoTime campeonato "Coritiba") (Linha "Coritiba" 5 0 1 4 3 7)
  testar "linha de time ausente" (linhaDoTime campeonato "Ausente") (Linha "Ausente" 0 0 0 0 0 0)
  testar "pontos da linha" (pontosLinha (Linha "Paraná" 5 2 2 1 7 4)) 8
  testar "saldo negativo" (saldo (Linha "Coritiba" 5 0 1 4 3 7)) (-4)
  testar "aproveitamento" (aproveitamento (Linha "Athletico" 5 4 0 1 12 5)) 80
  testar "aproveitamento sem jogos" (aproveitamento (Linha "Ausente" 0 0 0 0 0 0)) 0
  testar "classificacao completa" (classificacao campeonato) tabelaEsperada
  testar "Parana e Operario empatam em pontos"
    (map pontosLinha (filter (\linha -> time linha `elem` ["Paraná", "Operário"]) (classificacao campeonato))) [8, 8]
  testar "Parana vence Operario no saldo de gols"
    (map time (filter (\linha -> time linha `elem` ["Paraná", "Operário"]) (classificacao campeonato)))
    ["Paraná", "Operário"]
  testar "classificacao ate a rodada 3" (classificacao (ateRodada 3 campeonato)) tabelaRodadaTres
  testar "tabela intermediaria diferente da final"
    (classificacao (ateRodada 3 campeonato) /= classificacao campeonato) True
  testar "rodada 3 inclui nove partidas" (length (ateRodada 3 campeonato)) 9
  testar "antes da primeira rodada" (ateRodada 0 campeonato) []
  testar "classificacao vazia" (classificacao []) []
  testar "maior goleada" (maiorGoleada campeonato) (Just (Partida 2 "Athletico" 4 0 "Londrina"))
  testar "maior goleada vazia" (maiorGoleada []) Nothing
  testar "media de gols" (mediaGols campeonato) (Just 2.4)
  testar "media de gols vazia" (mediaGols []) Nothing
  testar "desempate por vitorias"
    (map time (filter (\linha -> time linha `elem` ["A", "B"])
      (classificacao [Partida 1 "A" 1 0 "X", Partida 2 "A" 0 1 "Y",
                     Partida 3 "B" 0 0 "X", Partida 4 "B" 0 0 "Y", Partida 5 "B" 0 0 "Z"])))
    ["A", "B"]
  testar "desempate por gols marcados"
    (map time (classificacao [Partida 1 "A" 2 1 "X", Partida 1 "B" 1 0 "Y"])) ["A", "B", "X", "Y"]
  testar "desempate por nome"
    (map time (classificacao [Partida 1 "B" 1 0 "Y", Partida 1 "A" 1 0 "X"])) ["A", "B", "X", "Y"]

  putStrLn "\nCamada 3: "
  testar "separar campos" (separar ';' "a;b;") ["a", "b", ""]
  testar "partida valida" (lerPartida 1 "1;Coritiba;2;1;Athletico") (Right (Partida 1 "Coritiba" 2 1 "Athletico"))
  testar "campeonato valido" (lerCampeonato dadosCampeonato) (Right campeonato)
  testar "campos invalidos" (lerCampeonato "1;Coritiba;2") (Left (CamposInvalidos 1))
  testar "time vazio" (lerCampeonato "1;;2;0;Athletico") (Left (CamposInvalidos 1))
  testar "numero invalido nos gols" (lerCampeonato "1;Coritiba;dois;0;Athletico") (Left (NumeroInvalido 1))
  testar "numero invalido na rodada" (lerCampeonato "dois;Coritiba;2;0;Athletico") (Left (NumeroInvalido 1))
  testar "rodada zero" (lerCampeonato "0;Coritiba;2;0;Athletico") (Left (NumeroInvalido 1))
  testar "placar negativo" (lerCampeonato "1;Coritiba;0;-1;Athletico") (Left (PlacarNegativo 1))
  testar "mesmo time" (lerCampeonato "1;Coritiba;1;0;Coritiba") (Left (MesmoTime 1))
  testar "time repetido na rodada"
    (lerCampeonato "1;Coritiba;1;0;Athletico\n1;Paraná;0;1;Coritiba")
    (Left (TimeRepetidoNaRodada 1 "Coritiba"))
  testar "mesmo time em rodadas diferentes"
    (lerCampeonato "1;Coritiba;1;0;Athletico\n2;Paraná;0;1;Coritiba")
    (Right [Partida 1 "Coritiba" 1 0 "Athletico", Partida 2 "Paraná" 0 1 "Coritiba"])
  testar "ignora comentarios e linhas vazias"
    (lerCampeonato "# campeonato\n\n  # rodada 1\n1; Coritiba ; 2 ; 1 ; Athletico ")
    (Right [Partida 1 "Coritiba" 2 1 "Athletico"])
  testar "mantem o numero original da linha"
    (lerCampeonato "# campeonato\n\n1;Coritiba;dois;0;Athletico") (Left (NumeroInvalido 3))
  testar "para no primeiro erro" (lerCampeonato textoComErros) (Left (NumeroInvalido 1))
  testar "lista todos os erros" (todosOsErros textoComErros)
    [NumeroInvalido 1, PlacarNegativo 2, MesmoTime 3, CamposInvalidos 4, TimeRepetidoNaRodada 5 "Coritiba"]
  testar "entrada valida sem erros" (todosOsErros dadosCampeonato) []
  testar "campeonato vazio" (lerCampeonato "") (Right [])
  testar "tabela formatada" (tabelaFormatada [Linha "Coritiba" 2 1 1 0 3 1])
    (unlines [ "Pos | Time     | Pts |   J |   V |   E |   D |  SG"
             , "  1 | Coritiba |   4 |   2 |   1 |   1 |   0 |   2" ])
  testar "tabela vazia" (tabelaFormatada [])
    "Pos | Time | Pts |   J |   V |   E |   D |  SG\n"

  putStrLn "\nTodos os testes passaram."
