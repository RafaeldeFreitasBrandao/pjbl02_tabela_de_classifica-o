module Leitura where

import Tipos
import Data.Char (isSpace)
import Data.List (intercalate)
import Text.Read (readMaybe)

data Erro
  = CamposInvalidos Int
  | NumeroInvalido Int
  | PlacarNegativo Int
  | MesmoTime Int
  | TimeRepetidoNaRodada Int Time
  deriving (Show, Eq)

separar :: Char -> String -> [String]
separar separador texto =
  case break (== separador) texto of
    (parte, []) -> [parte]
    (parte, _:resto) -> parte : separar separador resto

limpar :: String -> String
limpar = reverse . dropWhile isSpace . reverse . dropWhile isSpace

lerNumero :: Int -> String -> Either Erro Int
lerNumero numero texto =
  maybe (Left (NumeroInvalido numero)) Right (readMaybe texto)

lerPartida :: Int -> String -> Either Erro Partida
lerPartida numero texto =
  case map limpar (separar ';' texto) of
    [rodadaTexto, casa, golsCasaTexto, golsForaTexto, fora] -> do
      rodadaLida <- lerNumero numero rodadaTexto
      golsCasa <- lerNumero numero golsCasaTexto
      golsFora <- lerNumero numero golsForaTexto

      if null casa || null fora
        then Left (CamposInvalidos numero)
        else if golsCasa < 0 || golsFora < 0
          then Left (PlacarNegativo numero)
          else if casa == fora
            then Left (MesmoTime numero)
            else Right (Partida rodadaLida casa golsCasa golsFora fora)

    _ -> Left (CamposInvalidos numero)

ignorarLinha :: String -> Bool
ignorarLinha texto =
  case limpar texto of
    [] -> True
    '#':_ -> True
    _ -> False

linhasValidas :: String -> [(Int, String)]
linhasValidas texto =
  filter (not . ignorarLinha . snd) (zip [1..] (lines texto))

errosRodadas :: [Partida] -> [Erro]
errosRodadas partidas =
  snd (foldl verificar ([], []) partidas)
  where
    verificar (vistos, erros) partida =
      let
        atuais =
          [ (rodada partida, mandante partida)
          , (rodada partida, visitante partida)
          ]
        repetidos = filter (`elem` vistos) atuais
        novosErros = map (uncurry TimeRepetidoNaRodada) repetidos
      in
        (vistos ++ atuais, erros ++ novosErros)

lerCampeonato :: String -> Either Erro [Partida]
lerCampeonato texto = do
  partidas <- traverse (uncurry lerPartida) (linhasValidas texto)

  case errosRodadas partidas of
    [] -> Right partidas
    erro:_ -> Left erro

todosOsErros :: String -> [Erro]
todosOsErros texto =
  let
    resultados = map (uncurry lerPartida) (linhasValidas texto)
    erros = [erro | Left erro <- resultados]
    partidas = [partida | Right partida <- resultados]
  in
    erros ++ errosRodadas partidas

mensagemErro :: Erro -> String
mensagemErro (CamposInvalidos numero) =
  "Linha " ++ show numero ++ ": informe os cinco campos e os nomes dos times."

mensagemErro (NumeroInvalido numero) =
  "Linha " ++ show numero ++ ": rodada e gols devem ser numeros inteiros."

mensagemErro (PlacarNegativo numero) =
  "Linha " ++ show numero ++ ": os gols nao podem ser negativos."

mensagemErro (MesmoTime numero) =
  "Linha " ++ show numero ++ ": um time nao pode jogar contra si mesmo."

mensagemErro (TimeRepetidoNaRodada numero nome) =
  "Rodada " ++ show numero ++ ": o time " ++ nome ++ " jogou mais de uma vez."

tabelaFormatada :: [Linha] -> String
tabelaFormatada tabela =
  unlines
    ("Pos | Time | Pts | J | V | E | D | SG"
      : zipWith formatarLinha [1..] tabela)

formatarLinha :: Int -> Linha -> String
formatarLinha posicao linha =
  intercalate " | "
    [ show posicao
    , time linha
    , show (vitorias linha * 3 + empates linha)
    , show (jogos linha)
    , show (vitorias linha)
    , show (empates linha)
    , show (derrotas linha)
    , show (golsPro linha - golsContra linha)
    ]
