module Classificacao 
 ( pontos, linhaDoTime, pontosLinha, saldo, aproveitamento
 , classificacao, ateRodada, maiorGoleada, mediaGols
 ) where
 
import Data.List (sortBy, maximumBy)
import Data.Ord (comparing, Down(..))
import Tipos

pontos :: Resultado -> Int
pontos Vitoria = 3
pontos Empate  = 1
pontos Derrota = 0

linhaInicial :: Time -> Linha
linhaInicial t = Linha t 0 0 0 0 0 0

linhaDoTime :: [Partida] -> Time -> Linha
linhaDoTime ps t = foldl (somarPartida t) (linhaInicial t) (filter (participou t) ps)

golsPara :: Time -> Partida -> Maybe (Int, Int)
golsPara nome partida
  | nome == mandante partida = Just (golsMandante partida, golsVisitante partida)
  | nome == visitante partida = Just (golsVisitante partida, golsMandante partida)
  | otherwise = Nothing

somarPartida :: Time -> Linha -> Partida -> Linha
somarPartida t l p = case (resultadoPara t p, golsPara t p) of
  (Just r, Just (feitos, sofridos)) -> l
    { jogos      = jogos l + 1
    , vitorias   = vitorias l + contar Vitoria r
    , empates    = empates l + contar Empate r
    , derrotas   = derrotas l + contar Derrota r
    , golsPro    = golsPro l + feitos
    , golsContra = golsContra l + sofridos
    }
  _ -> l
  where
    contar esperado r = if r == esperado then 1 else 0

pontosLinha :: Linha -> Int
pontosLinha l = vitorias l * pontos Vitoria + empates l * pontos Empate + derrotas l * pontos Derrota

saldo :: Linha -> Int
saldo l = golsPro l - golsContra l

aproveitamento :: Linha -> Double 
aproveitamento l
  | jogos l == 0 = 0
  | otherwise     = 100 * fromIntegral (pontosLinha l) / fromIntegral (jogos l * pontos Vitoria)


criterios :: Linha -> Linha -> Ordering 
criterios = comparing (Down . pontosLinha)
  <> comparing (Down . vitorias)
  <> comparing (Down . saldo)
  <> comparing (Down . golsPro)
  <> comparing time
  
classificacao :: [Partida] -> [Linha]
classificacao ps = sortBy criterios (map (linhaDoTime ps) (times ps))

ateRodada :: Int -> [Partida] -> [Partida]
ateRodada n = filter ((<= n) . rodada)

diferencaGols :: Partida -> Int 
diferencaGols p = abs (golsMandante p - golsVisitante p)

totalGols :: Partida -> Int 
totalGols p = golsMandante p + golsVisitante p

maiorGoleada :: [Partida] -> Maybe Partida
maiorGoleada [] = Nothing
maiorGoleada ps = Just (maximumBy (comparing diferencaGols) ps)

mediaGols :: [Partida] -> Maybe Double
mediaGols[] = Nothing
mediaGols ps  = Just (fromIntegral (sum (map totalGols ps)) / fromIntegral (length ps))
