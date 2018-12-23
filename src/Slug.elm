module Slug exposing (Slug, fromString, toString)


type Slug
    = Slug String


fromString : String -> Slug
fromString words =
    Slug (sluggify words)


toString : Slug -> String
toString (Slug slug) =
    slug


sluggify : String -> String
sluggify =
    String.toLower
        >> replaceSpacesWithDashes
        >> keepOnlyAlphaNums


replaceSpacesWithDashes : String -> String
replaceSpacesWithDashes =
    String.words >> String.join "-"


keepOnlyAlphaNums : String -> String
keepOnlyAlphaNums =
    String.toList
        >> List.filter (\char -> char == '-' || Char.isAlphaNum char)
        >> String.fromList
