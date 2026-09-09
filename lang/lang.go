package lang

import (
	"embed"
	"encoding/json"
	"strings"
)

//go:embed EN.json RU.json
var translationFiles embed.FS

var translations map[string]map[string]interface{}

func LoadTranslations(_ string) error {
	translations = make(map[string]map[string]interface{})

	for _, language := range []string{"EN", "RU"} {
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

	return nil
}

func Translate(key string, lang string) string {
	if translations == nil {
		return key
	}

	keys := strings.Split(key, ".")
	value := interface{}(translations[lang])

	for _, k := range keys {
		m, ok := value.(map[string]interface{})
		if !ok {
			return key
		}

		value = m[k]
	}

	if str, ok := value.(string); ok {
		return str
	}

	return key
}
