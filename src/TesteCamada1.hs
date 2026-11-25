module Main (main) where

import Tipos

testar :: (Eq a, Show a) => String -> a -> a -> IO ()
testar nome obtido esperado
  | obtido == esperado = putStrLn ("OK      " ++ nome)
  | otherwise          = putStrLn ("FALHOU  " ++ nome ++ ": " ++ show obtido)

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

main :: IO ()
main = do
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