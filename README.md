# yandextexttranslater  

R package to interface with Yandex Translate API for text translation services  

To install from github:

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
#>"load_api_key"   "yandex_detect_language"   "yandex_supported_languages" "yandex_translate"   
```
First, load and save Yandex API key to .yml file and global environment for Yandex Translate API services
```R
load_api_key()
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
