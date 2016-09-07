module Material.Form.Textfield exposing (render)

import Html exposing (Html)
import Html.Attributes exposing (value)
import Html.Events exposing (onInput, onFocus, onBlur)
import Material
import Material.Textfield
import Material.Options exposing (Property)
import Msg exposing (Msg)
import Parts
import Form
import Form.Field
import Model exposing (Model)
import Types exposing (User)


{-| This is a merger of Material.Textfield.render and Form.Input.textInput.  Here are their respective type signatures:

#### Material.Textfield

The `render` function has the following type signature as of this writing:

```
render
  : (Parts.Msg (Container c) m -> m)
  -> Parts.Index
  -> (Container c)
  -> List (Property m)
  -> Html m
```

#### Form

The `textInput` function has the following type signature as of this writing:

```
textInput : Input e String
```

So it just returns an `Input`.  The type for Form.Input is defined as follows
as of this writing:

```
{-| An input renders Html from a field state and list of additional attributes.
    All input functions using this type alias are pre-wired with event handlers.
-}
type alias Input e a =
  FieldState e a -> List (Attribute Msg) -> Html Msg
```

Initially, this is not terribly clear to me.  Ultimately I realized that type
resolves to `Html Msg` once the baseInput is applied to the value returned
from `Form.getFieldAsString`.  Here's the definition of `baseInput`:

```
baseInput : String -> (String -> Field) -> Input e String
baseInput t toField state attrs =
  let
    formAttrs =
      [ type' t
      , value (state.value ?= "")
      , onInput (toField >> (Input state.path))
      , onFocus (Focus state.path)
      , onBlur (Blur state.path)
      ]
  in
    input (formAttrs ++ attrs) []
```

So here we can see that the `Input` type is a function that takes a
`FieldState` and a `List (Attribute Msg)` to produce an `Html Msg`.  So the
value we fetched with `Form.getFieldAsString` satisfies the first argument,
and our empty list is the list of attributes we want to bolt on.

render just needs to pass the corresponding Form-related handlers to the
Material.render function and handle mapping the various `Msg` types
appropriately...it's not extremely straightforward but it's entirely
scrutable...

We'll also make it a little less 'generic' because we don't need to, so don't
think you can immediately take this and turn it into a genericizable(-ifiable)
module without a bit more work, mnkay?
-}
render :
    Model
    -> (Parts.Msg (Container Material.Model) Msg -> Msg)
    -> Material.Model
    -> Parts.Index
    -> Html Msg
render model mdlMsg mdl index =
    Material.Textfield.render mdlMsg
        index
        mdl
        [ Material.Textfield.label "Name"
        , Material.Textfield.floatingLabel
        , Material.Textfield.text'
        , Material.Textfield.value model.newUser.name
        , Material.Textfield.onInput <| Msg.UserMsg' << Msg.SetNewUserName
        ]



-- render :
--     (a -> Msg)
--     -> Parts.Index
--     -> Model
--     -> List (Property () Msg)
--     -> Form.FieldState () User
--     -> Html Msg
-- render formMsgConstructor index model properties state =
--     Material.Textfield.render Msg.Mdl
--         index
--         model
--         (properties
--             ++ [ value (state.value ?= "")
--                , onInput <| formMsgConstructor (Form.Field.Text >> (Form.Input state.path))
--                , onFocus <| formMsgConstructor (Form.Focus state.path)
--                , onBlur <| formMsgConstructor (Form.Blur state.path)
--                ]
--         )


(?=) =
    flip Maybe.withDefault


type alias Container c =
    { c | textfield : Parts.Indexed Material.Textfield.Model }
