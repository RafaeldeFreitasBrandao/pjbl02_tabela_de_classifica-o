module Tipos 
(Time
, Resultados (..)
, Partida (..)
, Linha (..)
, participou
, resultadoPara
, times
) where 

import Data.List (nub, sort)

type Time = String 

data Resultado = Vitoria | Empate | Derrota
  deriving (Show, Eq)
  
data Partida = Partida
  { rodada        :: Int
  , mandante      :: Time
  , golsMandante  :: Int 
  , golsVisitante :: Int 
  , visitante     :: Time
    
  }
  
data Linha = Linha 
 { time           :: Time
 , jogos          :: Int
 , vitorias       :: Int 
 , empates        :: Int
 , derrotas       :: Int 
 , golsPro        :: Int
 ,golsContra      :: Int
 }
 
participou :: Time -> Partida -> Bool
participou t p = t == mandante p || t == visitante p
