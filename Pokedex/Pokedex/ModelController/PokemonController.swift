//
//  PokemonController.swift
//  Pokedex
//
//  Created by Jake Gloschat on 2/23/23.
//

import UIKit

class PokemonController {
    
    static func fetchPokemon(searchTerm: String, completion: @escaping (Pokemon?) -> Void) {
        guard let baseURL = URL(string: Constants.PokemonURL.baseURL) else { completion(nil) ; return }
        var urlComponent = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        urlComponent?.path.append(searchTerm.lowercased())
        
        guard let finalURL = urlComponent?.url else { completion (nil) ; return }
        print("FinalURL: \(finalURL)")
        
        // MARK: - DataTask
        URLSession.shared.dataTask(with: finalURL) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                completion(nil) ; return
            }
            
            if let response = response as? HTTPURLResponse {
                print("Pokemon Response Status Code: \(response.statusCode)")
            }
            
            guard let data = data else { completion(nil) ; return }
            
            do{
                if let topLevel = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String : Any] {
                    
                    let pokemon = Pokemon(dictionary: topLevel)
                    completion(pokemon)
                }
            }catch{
                print(error.localizedDescription)
                completion(nil)
                return
            }
        }.resume()
    }
    
    static func fetchImage(forPokemon: Pokemon, completion: @escaping (UIImage?) -> Void) {
        guard let finalURL = URL(string: forPokemon.spritePath) else {completion(nil) ; return }
       
        // MARK: - DataTask
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            if let error = error {
                print("There was an error fetching the data. the url is \(finalURL), the error is \(error.localizedDescription)")
            }
            
            guard let data = data else { completion(nil) ; return }
            
                let pokemonImage = UIImage(data: data)
                completion(pokemonImage)
        }.resume()
    }
}

