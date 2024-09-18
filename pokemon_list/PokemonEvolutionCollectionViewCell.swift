//
//  PokemonEvolution.swift
//  pokemon_list
//
//  Created by Tanmay Gandhi on 27/08/24.
//

import UIKit

class PokemonEvolutionCollectionViewCell: UICollectionViewCell {

    @IBOutlet var iv_pokemon: UIImageView!
    
    @IBOutlet var lbl_pokemonName: UILabel!
    
    @IBOutlet var vw_cellBg: UIView!

    var pokemonData: Pokemon? {
        didSet { // Property Observers
            fillData()
        }
    }
    
    var pvm: PokemonViewModel?
    
    func fillData() {
        
        lbl_pokemonName.text = pokemonData?.name

        vw_cellBg.layer.cornerRadius = 15
        iv_pokemon.image = UIImage(named: "pokeball")
        if let _ = pokemonData?.id {

            pvm?.loadPokemonImage(for: pokemonData!) { [weak self] image in
                
                DispatchQueue.main.async {

                    self?.iv_pokemon.image = image
                }
            }
            
            // iv_pokemon.setImage(from: pokemonData?.imageUrl)
        }
        
    }
    
}
