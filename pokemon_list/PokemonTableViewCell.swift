//
//  PokemonTableViewCell.swift
//  pokemon_list
//
//  Created by Tanmay Gandhi on 20/08/24.
//

import UIKit

class PokemonTableViewCell: UITableViewCell {
    
    @IBOutlet var vw_main: UIView!
    @IBOutlet var lbl_pokNm: UILabel!
    @IBOutlet var iv_pokPhoto: UIImageView!
    @IBOutlet var lbl_pokDesc: UILabel!

    let vm_tc = TypeColorViewModel()
    let vm_av = AudioViewModel()

    var pokemonData: Pokemon? {
        didSet { // Property Observers
            fillData()
        }
    }
    
    var pvm: PokemonViewModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        iv_pokPhoto.addGestureRecognizer(tapGesture)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @objc func imageTapped() {
        // vm_av.setAudio(pokemonData?.name?.uppercased())
        vm_av.setAudio(pokemonData?.name)
        }
    
    func fillData() {
        
        vw_main.backgroundColor = vm_tc.color(for: (pokemonData?.type)!)
        
        if let type = pokemonData?.type {
            vw_main.backgroundColor = vm_tc.color(for: type)
            
            lbl_pokNm.textColor = type == "electric" ? .brown : .white
        }


        lbl_pokNm.text = pokemonData?.name?.uppercased()
        
        lbl_pokDesc.text = pokemonData?.description
        
        iv_pokPhoto.image = .remove
        
        let currentPhotoPath = pokemonData?.imageUrl
        
        pvm?.loadPokemonImage(for: pokemonData!) { [weak self] image in
            DispatchQueue.main.async {
                if currentPhotoPath == self?.pokemonData?.imageUrl {
                    self?.iv_pokPhoto.image = image
                }
            }
        }
        
/*
        pokemonData?.imageUrl?.loadImage(completion: { [weak self] image in
            
            DispatchQueue.main.async {
                
                if currentPhotoPath == self?.pokemonData?.imageUrl {
                    
                    self?.iv_pokPhoto.image = image
                }
            }
        })
*/

    }
 
}

