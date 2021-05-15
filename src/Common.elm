module Common exposing (..)
import Http

type Msg
  = FetchUser String
  | UpdateText String
  | ShowError String
  | GotJson (Result Http.Error User)

type alias User = 
  {
    id : Int
    , name : String
    , email : String
  }

type NoUserCause = Unloaded | Failure String
type Model
  = NoUser {cause: NoUserCause, path: String}
  | Loading String
  | Success {user: User, path: String}