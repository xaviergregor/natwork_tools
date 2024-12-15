package main

import (
	"fmt"
	"io/ioutil"
	"net/http"
)

func main() {
	// L'URL d'un service qui retourne l'adresse IP externe
	url := "https://api.ipify.org"

	// Faire une requête GET
	resp, err := http.Get(url)
	if err != nil {
		fmt.Printf("Erreur lors de la requête: %v\n", err)
		return
	}
	defer resp.Body.Close()

	// Lire la réponse
	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		fmt.Printf("Erreur lors de la lecture de la réponse: %v\n", err)
		return
	}

	// Afficher l'adresse IP
	fmt.Printf("Votre adresse IP externe est: %s\n", string(body))
}

