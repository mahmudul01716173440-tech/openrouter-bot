package lang

import (
	"embed"
	"encoding/json"
	"log"
	"path/filepath"
	"strings"
)

//go:embed EN.json RU.json
var translationFiles embed.FS

var translations map[string]map[string]interface{}

func LoadTranslations(langDir string) error {
	translations = make(map[string]map[string]interface{})

	languages := []string{"EN", "RU"}

	for _, language := range languages {
		data, err := translationFiles.ReadFile(language + ".json")
		if err != nil {
			return err
		}

		var langMap map[string]interface{}
		if err := json.Unmarshal(data, &langMap); err != nil {
			return err
		}

		translations[language] = langMap
	}

	for _, language := range languages {
		log.Printf("Loaded embedded translations: %s", filepath.Join(langDir, language+".json"))
	}

	return nil
}

func Translate(key string, lang string) string {
	if translations == nil {
		log.Println("Translations not loaded. Did you call LoadTranslations?")
		return key
	}

	keys := strings.Split(key, ".")
	value := interface{}(translations[lang])

	for _, k := range keys {
		if m, ok := value.(map[string]interface{}); ok {
			value = m[k]
		} else {
			return key
		}
	}

	if str, ok := value.(string); ok {
		return str
	}

	return key
}
