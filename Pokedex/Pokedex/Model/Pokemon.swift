//
//  Pokemon.swift
//  Pokedex
//
//  Created by Jake Gloschat on 2/23/23.
//

import Foundation

class Pokemon {
    
    let name: String
    let id: Int
    let moves: [String]
    let spritePath: String
    
    init(name: String, id: Int, moves: [String], spritePath: String) {
        self.name = name
        self.id = id
        self.moves = moves
        self.spritePath = spritePath
    }
}

extension Pokemon {
    enum Keys: String {
        case name = "name"
        case id
        case moves
        
        
        case sprites
        case spritePath = "front_default"
        
    }
    convenience init?(pokemonDictionary: [String : Any]) {
      guard let name = pokemonDictionary[Keys.name.rawValue] as? String,
        let id = pokemonDictionary[Keys.id.rawValue] as? Int,
        let moves = pokemonDictionary[Keys.moves.rawValue] as? [String],
        
        let spriteDictionary = pokemonDictionary[Keys.sprites.rawValue] as? [String: Any],
        let spritePath = spriteDictionary[Keys.spritePath.rawValue] as? String else { return nil }
        
        self.init(name: name, id: id, moves: moves, spritePath: spritePath)
    
    }
}
