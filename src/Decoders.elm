module Decoders exposing (..)
import Json.Decode exposing (Decoder, map3, field, int, string)
import Common exposing (User)

userDecoder : Decoder User
userDecoder = map3 User
  (field "id" int) 
  (field "name" string)
  (field "email" string)