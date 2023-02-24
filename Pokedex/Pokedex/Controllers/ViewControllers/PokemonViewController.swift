//
//  PokemonViewController.swift
//  Pokedex
//
//  Created by Karl Pfister on 2/3/22.
//

import UIKit

class PokemonViewController: UIViewController {
    
    @IBOutlet weak var pokemonSearchBar: UISearchBar!
    @IBOutlet weak var pokemonIDLabel: UILabel!
    @IBOutlet weak var pokemonNameLabel: UILabel!
    @IBOutlet weak var pokemonSpriteImageView: UIImageView!
    @IBOutlet weak var pokemonMovesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pokemonMovesTableView.dataSource = self
        pokemonMovesTableView.delegate = self
        pokemonSearchBar.delegate = self
    }
    
    // MARK: - Properties
    var pokemon: Pokemon?
    
    // MARK: - Functions
    
    func updateViews(pokemon: Pokemon) {
        PokemonController.fetchImage(forPokemon: pokemon) { image in
            guard let image = image else { return }
            DispatchQueue.main.async {
                self.pokemon = pokemon
                self.pokemonNameLabel.text = pokemon.name
                self.pokemonIDLabel.text = "\(pokemon.id)"
                self.pokemonSpriteImageView.image = image
                self.pokemonMovesTableView.reloadData()
            }
        }
    }
    
    
}// End

extension PokemonViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let pokemon = pokemon else { return 0}
        return pokemon.moves.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "moveCell", for: indexPath)
        let move = pokemon?.moves[indexPath.row]
        var config = cell.defaultContentConfiguration()
        config.text = move
        cell.contentConfiguration = config
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "moves"
    }
    
}

extension PokemonViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        PokemonController.fetchPokemon(searchTerm: searchText) { pokemon in
            guard let pokemon = pokemon else { return }
            self.updateViews(pokemon: pokemon)
        }
    }
}
