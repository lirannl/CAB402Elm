module Main exposing (main)
import Browser
import Http
import String exposing (fromInt)
import Http exposing (expectJson)
import Common exposing (Msg(..), Model(..), NoUserCause(..))
import View exposing (view)
import Decoders exposing (userDecoder)

main : Program () Model Msg
main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }

baseUrl : String
baseUrl = "https://jsonplaceholder.typicode.com/"

init : () -> (Model, Cmd Msg)
init _ =
  ( NoUser { cause = Unloaded, path = ""} , Cmd.none )

httpErrToString : Http.Error -> String
httpErrToString err = case err of
  Http.BadBody message -> message
  Http.BadStatus statusCode -> "Request returned status code " ++ fromInt statusCode
  Http.BadUrl _ -> "Bad URL"
  Http.Timeout -> "Timed out"
  Http.NetworkError -> "Network Error"

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    UpdateText newPath -> case model of
      Loading _ -> (model, Cmd.none)
      NoUser data -> (NoUser {data | path = newPath}, Cmd.none)
      Success data -> (Success {data | path = newPath}, Cmd.none)
    FetchUser newPath -> (Loading newPath, Http.get { 
        url = baseUrl ++ newPath
        , expect = expectJson GotJson userDecoder})
    ShowError errorMessage -> (NoUser {cause = Failure errorMessage, path = ""}, Cmd.none)
    GotJson result ->
      case result of
        Ok decodedUser ->
          (Success {user = decodedUser, path = ""}, Cmd.none)
        Err error ->
          (NoUser {cause = Failure (httpErrToString error), path = ""}, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions _ =
  Sub.none