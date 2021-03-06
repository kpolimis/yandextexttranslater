# yandextexttranslater  

[![CircleCI](https://circleci.com/gh/kpolimis/yandextexttranslater.svg?style=svg)](https://circleci.com/gh/kpolimis/yandextexttranslater)

## Overview


yandextexttranslater allows R users to interface with Yandex Translate API for text translation services.
Use this package by following the instructions below to install the package and register for a
free Yandex Translate API key.

## Install

Use devtools package to install from GitHub:

```R
library(devtools)
install_github("kpolimis/yandextexttranslater")
```

Register for a free Yandex Translate API key [here](https://tech.yandex.com/translate/doc/dg/concepts/api-overview-docpage/)

## Usage

View all functions in yandextexttranslater

```R
library(yandextexttranslater)
ls("package:yandextexttranslater")
```
```R
[1] "load_api_key"   "yandex_detect_language"   "yandex_supported_languages"   "yandex_translate"
```
First, use the function's text prompt to enter and save your Yandex API key to a file called
yandex_api_key.yml; this function also adds the value yandex_api_key to the global environment.
You can alternatively specify a directory in the function call that contains yandex_api_key.yml
and load the Yandex API key to your global environment.

```R
load_api_key(directory="")
```
### Yandex Translate API services
### See Resources below for full API documentation

Get a list of translation directions and abbreviation-language pairs for language abbreviations supported by Yandex Translate API

```R
supported_languages = yandex_supported_languages(yandex_api_key)
available_translations = supported_languages[[1]]
abbreviations = supported_languages[[2]]
```
```R
head(available_translations)
```
```R
translation from_language to_language
1       az-ru            az          ru
2       be-bg            be          bg
3       be-cs            be          cs
4       be-de            be          de
5       be-en            be          en
6       be-es            be          es
```
```R
head(abbreviations)
```

```R
abbreviation    language
1           af   Afrikaans
2           am     Amharic
3           ar      Arabic
4           az Azerbaijani
5           ba     Bashkir
6           be  Belarusian
```
To detect the language of the specified text

```R
detected_languaged = yandex_detect_language(yandex_api_key, text="voglio mangiare cena")
detected_languaged
```
```R
[1] "it"
```

To translate text to the specified language

```R
translated_text = yandex_translate(yandex_api_key, text="voglio mangiare cena", lang="it-en")
translated_text
```
```R
[1] "I want to eat dinner"
```
## Resources
* [Yandex Translate API overview](https://tech.yandex.com/translate/doc/dg/concepts/api-overview-docpage/)
* [Powered by Yandex.Translate](http://translate.yandex.com/)
