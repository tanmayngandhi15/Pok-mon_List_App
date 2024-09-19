//
//  PokemonViewModel.swift
//  pokemon_list
//
//  Created by Tanmay Gandhi on 20/08/24.
//

import UIKit

class PokemonViewModel {
    
    weak var vc: ViewController?
    var filteredPokemon: [Pokemon] = []
    var dictPokemon = NSCache<NSNumber, UIImage>()
    
    var arrPokemon :[Pokemon] = [] {
        didSet{
            filteredPokemon = arrPokemon
        }
    }
    
    func callAPI() {
        
        guard let url = URL(string: "https://pokedex-bb36f.firebaseio.com/pokemon.json") else {
            return
        }
        print(url)
        let task = URLSession.shared.dataTask(with: url) {
            dataresponse, response, error in
            
            guard let data = dataresponse, error == nil else {
                print("Error: ", error?.localizedDescription ?? "Response Error")
                return
            }
            
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                
                if var pokemonArray = jsonResponse as? [Any] {
                    // Remove the initial null value if present
                    if pokemonArray.first is NSNull {
                        pokemonArray.removeFirst()
                    }
                    
                    // Convert the cleaned array back to Data
                    let cleanedData = try JSONSerialization.data(withJSONObject: pokemonArray, options: [])
                    
                    // Decode the cleaned data into Pokemon objects
                    let decoder = JSONDecoder()
                    let pokemonList = try decoder.decode([Pokemon].self, from: cleanedData)
                    self.arrPokemon = pokemonList
                    
                    DispatchQueue.main.async {
                        
                        if let vc = self.vc {
                            
                            vc.tv_pokemonList?.reloadData()
                            vc.sb_findPokemon?.isHidden = false
                            vc.tv_pokemonList?.isHidden = false
                        } else {
                            print("Error VC")
                        }
                        
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        if let vc = self.vc {
                            let alert = UIAlertController(title: "Error", message: "Failed to load Pokémon data.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default))
                            vc.present(alert, animated: true)
                        } else {
                            print("Error VC")
                        }
                    }

                }
                
            } catch let decodingError {
                print("Decoding Error: \(decodingError.localizedDescription)")
            }
        }
        task.resume()
    }
    
    // Function to find Pokémon Position in Array based on PokemonID
            func searchPokemon(with id: Int) -> Int? {
                for i in 0 ..< arrPokemon.count {
                    if arrPokemon[i].id == id {
                        return i
                    }
                }
                return nil
            }
    
    // Function to filter Pokémon based on the search query
    func searchPokemon(with query: String) {
        if query.isEmpty {
            // If query is empty, show the full list
            filteredPokemon = arrPokemon
        } else {
            // Filter based on name matching the query
            filteredPokemon = arrPokemon.filter { pokedata in
                pokedata.name!.contains(query.lowercased())
            }
        }
    }
    
    func loadPokemonImage(for pokemon: Pokemon, completion: @escaping (UIImage?) -> Void) {
        let pokemonId = NSNumber(value: pokemon.id!) // Assuming each Pokémon has a unique `id`
        
        // Check if image is already cached
        if let cachedImage = dictPokemon.object(forKey: pokemonId) {
            
            completion(cachedImage)
            return
        }
        
        // If not cached, fetch image from URL
        if let imageUrl = pokemon.imageUrl {
            imageUrl.loadImage { [weak self] image in
                if let image = image {
                    // Cache the image for future use
                    
                    self?.dictPokemon.setObject(image, forKey: pokemonId)
                }
                completion(image)
            }
        } else {
            completion(nil)
        }
    }
    
    
}
