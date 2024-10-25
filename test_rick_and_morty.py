import unittest
from unittest.mock import patch
import requests
from rick_and_morty_script import is_from_earth_c137, fetch_characters

class TestRickAndMortyAPI(unittest.TestCase):

    def test_is_from_earth_c137_true(self):
        character = {"origin": {"name": "Earth (C-137)"}}
        self.assertTrue(is_from_earth_c137(character))

    def test_is_from_earth_c137_false(self):
        character = {"origin": {"name": "Mars"}}
        self.assertFalse(is_from_earth_c137(character))

    @patch('rick_and_morty_script.requests.get')
    def test_fetch_characters_success(self, mock_get):
        mock_response = mock_get.return_value
        mock_response.status_code = 200
        mock_response.json.return_value = {
            "info": {"next": None},
            "results": [{"name": "Rick Sanchez"}]
        }
        characters = fetch_characters()
        characters_list = list(characters)  # Convert generator to list
        self.assertEqual(len(characters_list), 1)
        self.assertEqual(characters_list[0]['name'], "Rick Sanchez")

    @patch('rick_and_morty_script.requests.get')
    def test_fetch_characters_http_error(self, mock_get):
        mock_get.side_effect = requests.exceptions.HTTPError("Error during API call")
        with self.assertRaises(requests.exceptions.HTTPError):
            list(fetch_characters())  # Force fetch to raise the error

if __name__ == '__main__':
    unittest.main()
