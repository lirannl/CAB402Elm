module View exposing (view)
import Browser exposing (Document)
import Html exposing (Html, button, text, textarea, div, br, pre)
import Html.Events exposing (onClick, onInput)
import Html.Attributes exposing (value)
import Common exposing (Msg(..), NoUserCause(..), Model(..))
import Html.Attributes exposing (target, autofocus, autocomplete)

fetchNewUserButton : String -> Html Msg
fetchNewUserButton path = 
  button [onClick (FetchUser path)] [ text "Submit" ]

handleInput : String -> String -> Msg
handleInput original target = case String.uncons (String.reverse target) of
  Just ('\n', _) -> case original of 
    "" -> ShowError "Path must not be empty"
    _ -> FetchUser original
  _ -> UpdateText target
inputField : String -> Html Msg
inputField path =
  textarea [onInput (handleInput path), value path
  , autofocus True
  , autocomplete False] []

inputArea : String -> Html Msg
inputArea path =
  div [] [
    inputField path
    , br [] []
    ,fetchNewUserButton path
  ]

view : Model -> Document Msg
view model =
  case model of
    NoUser {cause, path} -> {
      title = "User Fetcher",
      body = [
        text (case cause of
          Unloaded -> "Welcome! Please input a path for the API call and click \"Submit\"."
          Failure msg -> "Failed: " ++ msg)
        , inputArea path
      ]}
    Loading path -> {
      title = "Loading",
      body = [
        text ("Loading \"" ++ path ++ "\"...")
      ]}
    Success {user, path} -> {
      title = user.name,
      body = [
        pre [] [ text ("Email: " ++ user.email) ]
        , pre [] [ text ("Name: " ++ user.name)]
        , pre [] [ text ("ID: " ++ String.fromInt user.id)]
        , inputArea path
      ]}