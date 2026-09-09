package lang

import (
	"embed"
	"encoding/json"
	"strings"
)

// Embed translation files directly into the Go binary.
// The Docker container does NOT need the lang/ folder at runtime.
//
//go:embed EN.json RU.json
var translationFiles embed.FS

var translations map[string]map[string]interface{}

// LoadTranslations loads all translations from the embedded JSON files.
func LoadTranslations() error {
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

// Translate returns the translated text for a key.
func Translate(key string, language string) string {
	if translations == nil {
		return key
	}

	keys := strings.Split(key, ".")

	value := interface{}(translations[language])

	for _, keyPart := range keys {
		m, ok := value.(map[string]interface{})
		if !ok {
			return key
		}

		value = m[keyPart]
	}

	if text, ok := value.(string); ok {
		return text
	}

	return key
}
