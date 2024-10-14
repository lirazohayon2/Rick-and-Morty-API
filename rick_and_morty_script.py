from flask import Flask, jsonify
import requests
import csv

app = Flask(__name__)

api_url = "https://rickandmortyapi.com/api/character/"
params = {
    "species": "Human",
    "status": "Alive",
}


def is_from_earth_c137(character):
    return character["origin"]["name"] == "Earth (C-137)"


def fetch_characters():
    next_url = api_url
    while next_url:
        try:
            response = requests.get(next_url, params=params)
            response.raise_for_status()  # Check if the request was successful
        except requests.exceptions.RequestException as e:
            print(f"Error during API call: {e}")
            break

        data = response.json()

        # Yield each character in the results
        yield from data["results"]

        # Update next_url to the next page if it exists, otherwise set to None
        next_url = data["info"]["next"]


def write_to_csv(characters):
    with open("rick_and_morty_characters.csv", mode="w", newline="") as file:
        writer = csv.DictWriter(file, fieldnames=["Name", "Location", "Image"])
        writer.writeheader()
        writer.writerows(characters)
    print("Data has been successfully written to CSV file.")


@app.route('/characters', methods=['GET'])
def get_characters():
    characters = [
        {
            "Name": character["name"],
            "Location": character["origin"]["name"],
            "Image": character["image"]
        }
        for character in fetch_characters()
        if is_from_earth_c137(character)
    ]

    write_to_csv(characters)

    return jsonify(characters)


# Healthcheck endpoint
@app.route('/healthcheck', methods=['GET'])
def healthcheck():
    return jsonify({"status": "healthy"})


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
