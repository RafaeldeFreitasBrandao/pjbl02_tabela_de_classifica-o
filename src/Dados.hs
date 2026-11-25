module Dados (dadosCampeonato) where

dadosCampeonato :: String
dadosCampeonato = unlines
  [ "1;Coritiba;1;2;Athletico"
  , "1;Paraná;0;0;Operário"
  , "1;Londrina;1;1;Cascavel"
  , ""
  , "2;Coritiba;1;1;Paraná"
  , "2;Athletico;4;0;Londrina"
  , "2;Operário;2;0;Cascavel"
  , ""
  , "3;Operário;1;0;Coritiba"
  , "3;Cascavel;3;2;Athletico"
  , "3;Paraná;3;1;Londrina"
  , ""
  , "4;Londrina;2;1;Coritiba"
  , "4;Athletico;2;0;Operário"
  , "4;Cascavel;0;2;Paraná"
  , ""
  , "5;Cascavel;1;0;Coritiba"
  , "5;Paraná;1;2;Athletico"
  , "5;Londrina;1;1;Operário"
  ]