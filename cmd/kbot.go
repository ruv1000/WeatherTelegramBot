/*
Copyright © 2023 Ihor Shevchenko magicruv@gmail.com
*/
package cmd

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
	"time"

	"github.com/spf13/cobra"

	telebot "gopkg.in/telebot.v3"
)

var (
	// TeleToken bot
	TeleToken = os.Getenv("TELE_TOKEN")
	apiKey    = os.Getenv("OWM_API_KEY")
	city      string
)

// kbotCmd represents the kbot command
var kbotCmd = &cobra.Command{
	Use:     "kbot",
	Aliases: []string{"start"},
	Short:   "A brief description of your command",
	Long: `A longer description that spans multiple lines and likely contains examples
and usage of using your command. For example:

Cobra is a CLI library for Go that empowers applications.
This application is a tool to generate the needed files
to quickly create a Cobra application.`,
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Printf("kbot %s started \n", appVersion)

		kbot, err := telebot.NewBot(telebot.Settings{
			URL:    "",
			Token:  TeleToken,
			Poller: &telebot.LongPoller{Timeout: 10 * time.Second},
		})

		if err != nil {
			log.Fatalf("Please check TELE_TOKEN env variable. %s", err)
			return
		}

		kbot.Handle(telebot.OnText, func(m telebot.Context) error {
			log.Print(m.Message().Payload, m.Text())
			payload := m.Message().Payload

			switch payload {
			case "hello":
				err = m.Send(fmt.Sprintf("Hello I'm weather bot %s!", appVersion))
			case "weather":
				if city == "" {
					err = m.Send("Please specify a city using the -c flag, e.g., /weather -c Kyiv")
				} else {
					err = m.Send(city)
					weatherInfo, err := getWeatherInfo(city)
					if err != nil {
						err = m.Send(fmt.Sprintf("Error getting weather information: %s", err))
					} else {
						err = m.Send(weatherInfo)
					}
				}
			}

			return err
		})

		// testCity := "Kyiv"
		// testWeatherInfo, err := getWeatherInfo(testCity)
		// if err != nil {
		// 	log.Printf("Error getting weather information for %s: %s", testCity, err)
		// } else {
		// 	log.Printf("Weather information for %s: %s", testCity, testWeatherInfo)
		// }

		kbot.Start()
	},
}

func init() {
	rootCmd.AddCommand(kbotCmd)

	kbotCmd.Flags().StringVarP(&city, "city", "c", "", "Specify the city for weather information")
}

func getWeatherInfo(city string) (string, error) {
	apiURL := fmt.Sprintf("https://api.openweathermap.org/data/2.5/weather?q=%s&appid=%s", city, apiKey)

	resp, err := http.Get(apiURL)
	if err != nil {
		return "", err
	}
	defer resp.Body.Close()

	var weatherData map[string]interface{}
	if err := json.NewDecoder(resp.Body).Decode(&weatherData); err != nil {
		return "", err
	}

	// Теперь вы можете извлечь нужные данные из структуры weatherData
	// Например, температуру можно получить так:
	temperature, ok := weatherData["main"].(map[string]interface{})["temp"].(float64)
	if !ok {
		return "", fmt.Errorf("Failed to get temperature from the response")
	}

	return fmt.Sprintf("Temperature in %s: %.2f°C", city, temperature-273.15), nil
}
