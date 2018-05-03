#' @import dplyr
#' @import here
#' @import httr
#' @import stringi
#' @import stringr
#' @import tibble
#' @import yaml

#' @title Uses console input to save and load .yml file with yandex api key
#' @param directory File directory that contains "yandex_api_key.yml"
#' @return Creates global environment variable yandex_api_key in one of two ways.
#' First, given a file directory (default directory created with `here` package),
#' if yandex_api_key.yml exists, yandex_api_key takes the value of api_key field in the .yml file.
#' Otherwise, console input is saved to yandex_api_key.yml in the given directory
#' and the api_key field from .yml is the yandex_api_key
#' @export
#' @examples
#' load_api_key(directory="")

load_api_key = function(directory=""){
  if (directory==""){
    folder = here()
  } else {
    folder = directory
    }
  destfile = paste(folder, "yandex_api_key.yml", sep = "/")
  if(file.exists(destfile)){
    cat("\n")
    print("yandex_api_key.yml already exists")
    print("adding previously saved yandex api credentials to environment")
    yandex_api_key <<- yaml.load_file(destfile)$api_key
    }
  if(!file.exists(destfile)){
    n = readline(prompt = "Enter your yandex api key: ")
    print("creating yandex_api_key.yml")
    api_yaml = paste(as.name("api_key: "), "\"", n, "\"", sep="")
    res = tryCatch({write(api_yaml,file =  destfile,
                   method = "auto")},
      error=function(e){cat("ERROR :",conditionMessage(e), "\n")})

    yandex_api_key <<- yaml.load_file(destfile)$api_key
    }
  }

#' Gets a list of translation directions supported by the service
#'
#' @param yandex_api_key yandex API key
#' @param lang Defaults to English ("en")
#' @return A list with two data frames
#' The first data frame gives the supported translation directions (all columns are character data types)
#' The second data frame matches language abbreviations with full language name (all columns are character data types)
#' See \url{https://tech.yandex.com/translate/doc/dg/reference/getLangs-docpage/} for more details
#' @export
#' @examples
#' supported_languages = yandex_supported_languages(yandex_api_key)
#' available_translations = supported_languages[[1]]
#' abbreviations = supported_languages[[2]]

yandex_supported_languages = function(yandex_api_key, lang="en"){
  url = "https://translate.yandex.net/api/v1.5/tr.json/getLangs?"
  body = list(key=yandex_api_key, ui=lang)
  post_content = POST(url, body = body, encode = "form")
  parsed_content = content(post_content, "parsed")

  supported_languages = t(as.data.frame(parsed_content$dirs))
  rownames(supported_languages) = NULL
  supported_languages = as.data.frame(supported_languages)
  colnames(supported_languages) = "translation"
  supported_languages$from_language = lapply(FUN = function(translation) unlist(str_split(translation, "-"))[1], supported_languages$translation)
  supported_languages$to_language = lapply(FUN = function(translation) unlist(str_split(translation, "-"))[2], supported_languages$translation)
  supported_languages = supported_languages %>%
    mutate_at(vars(c("from_language", "to_language")), funs(unlist)) %>%
    mutate_if(is.factor, as.character)

  language_abbreviations = t(as.data.frame(parsed_content$langs))
  language_abbreviations = as.data.frame(language_abbreviations)
  language_abbreviations = tibble::rownames_to_column(language_abbreviations, "abbreviation")
  colnames(language_abbreviations) = c("abbreviation", "language")
  language_abbreviations = language_abbreviations %>%
    mutate_if(is.factor, as.character)
  return(list(supported_languages, language_abbreviations))
  }

#' Detects the language of the specified text.
#'
#' @param yandex_api_key yandex API key
#' @param text The text to detect the language for
#' @return String of detected language (character type)
#' See \url{https://tech.yandex.com/translate/doc/dg/reference/detect-docpage/} for more details
#' @export
#' @examples
#' detected_languaged = yandex_detect_language(yandex_api_key, text="voglio mangiare cena")


yandex_detect_language=function(yandex_api_key, text=""){
  url="https://translate.yandex.net/api/v1.5/tr.json/detect?"
  if(text != ""){
    body = list(key=yandex_api_key, text=text)
    }
  post_content = POST(url, body = body, encode = "form")
  parsed_content = content(post_content, "parsed")
  detected_language = parsed_content$lang
  return(detected_language)
  }

#' Translates text to the specified language
#'
#' @param yandex_api_key yandex API key
#' @param text The text to translate. The maximum size of the text being passed is 10000 characters.
#' @param lang The translation direction. You can use any of the following ways to set it:
#' As a pair of language codes separated by a hyphen ("from"-"to").
#' For example, en-ru indicates translating from English to Russian.
#' As the final language code (for example, ru). In this case, the service tries to detect the source language automatically.
#' @return translated text (character type)
#' See \url{https://tech.yandex.com/translate/doc/dg/reference/translate-docpage/} for more details
#' @export
#' @examples
#' translated_text = yandex_translate(yandex_api_key, text="voglio mangiare cena", lang="it-en")

yandex_translate = function(yandex_api_key, text="",lang=""){
  url="https://translate.yandex.net/api/v1.5/tr.json/translate?"

  if(text != ""){
    body = list(key=yandex_api_key, text=text)
    }

  if(lang != ""){
    body = list(key=yandex_api_key, text=text, lang=lang)
  }

  post_content = POST(url, body = body, encode = "form")
  parsed_content = content(post_content, "parsed")
  translated_text = parsed_content$text[[1]]
  return(translated_text)
  }
