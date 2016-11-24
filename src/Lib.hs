module Lib
    ( someFunc
    , Email(..)
    , emailParser
    ) where

import Text.Parsec

data Email = Email String [String]
  deriving (Eq, Show)

-- the very basic characters
latin = ['a'..'z'] ++ ['A'..'Z']
digits = ['0'..'9']
specials = "!#$%&'*+-/=?^_`{|}~"
baseChars = oneOf $ latin ++ digits ++ specials

-- characters allowed within quotes
quotedChars = oneOf " (),:;<>@[]."
escapedChars = oneOf "\"\\"

quotedString = char '"' *> stringInQuotes <* char '"'
  where stringInQuotes = mconcat <$> many1 charsInQuotes
        charsInQuotes = many1 (baseChars <|> quotedChars) <|> escapedChars2
        escapedChars2 = (:) <$> char '\\' <*> count 1 escapedChars


-- the local part
localParserPart = quotedString <|> many1 baseChars
localParser = mconcat <$> localParserPart `sepBy1` char '.'

dnsLabel =  many1 $ noneOf "."
domainParser = dnsLabel `sepBy1` char '.'


emailParser :: Parsec String st Email
emailParser = do
        localPart <- localParser
        char '@'
        domainPart <- domainParser
        return $ Email localPart domainPart

someFunc :: IO ()
someFunc = putStrLn "someFunc"
