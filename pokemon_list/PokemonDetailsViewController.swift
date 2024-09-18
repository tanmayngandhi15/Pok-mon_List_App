//
//  PokemonDetailsViewController.swift
//  pokemon_list
//
//  Created by Tanmay Gandhi on 24/08/24.
//

import UIKit

class PokemonDetailsViewController: UIViewController {
    
    var pokData: Pokemon?
    let vm_av = AudioViewModel()
    
    var pvm: PokemonViewModel?
    
    @IBOutlet var vw_main: UIView!
    
    @IBOutlet var btn_back: UIButton!
    @IBOutlet var iv_pokeImage: UIImageView!
    @IBOutlet var vw_lblBg: UIView!
    @IBOutlet var lbl_pokeName: UILabel!
    @IBOutlet var lbl_attack: UILabel!
    @IBOutlet var lbl_defense: UILabel!
    @IBOutlet var lbl_height: UILabel!
    @IBOutlet var lbl_weight: UILabel!
    @IBOutlet var lbl_type: UILabel!
    @IBOutlet var cv_pokemonEvolution: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vw_lblBg.layer.cornerRadius = vw_lblBg.bounds.height / 2
        
        btn_back.layer.cornerRadius = btn_back.bounds.height / 2
        
        iv_pokeImage.image = .remove
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        iv_pokeImage.addGestureRecognizer(tapGesture)
        
        if let pokData = pokData {
            
            vw_main.backgroundColor = TypeColorViewModel().color(for: pokData.type!)
            
            cv_pokemonEvolution.backgroundColor = TypeColorViewModel().color(for: pokData.type!)
            
            pvm?.loadPokemonImage(for: pokData) { [weak self] image in
                
                DispatchQueue.main.async {
                    
                    self?.iv_pokeImage.image = image
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        self?.iv_pokeImage.animatePokemonImage()
                    }
                }
            }
            /*
             pokData.imageUrl?.loadImage(completion: { [weak self] image in
             
             DispatchQueue.main.async {
             
             self?.iv_pokeImage.image = image
             self?.pvm?.dictPokemon.setObject(image!, forKey: NSNumber(value: pokData.id!))
             DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
             self?.iv_pokeImage.animatePokemonImage()
             }
             }
             })
             */
            lbl_pokeName.text = pokData.name
            
            lbl_attack.text = "Attack: \(String(pokData.attack!))"
            lbl_defense.text = "Defense: \(String(pokData.defense!))"
            lbl_height.text = "Height: \(String(pokData.height!))"
            lbl_weight.text = "Weight: \(String(pokData.weight!))"
            lbl_type.text = "Type: \(String(pokData.type!))"
            
            cv_pokemonEvolution.register(UINib(nibName: "PokemonEvolutionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "pokeEvolution")
            
            cv_pokemonEvolution.reloadData()
        }
        
    }
    
    @objc func imageTapped() {
        // Call the animation function after the image is tapped
        
        vm_av.setAudio(pokData?.name)
        iv_pokeImage.animatePokemonImage()
    }
    
    @IBAction func btn_backClick(_ sender: UIButton) {
        
        guard let pvm = pvm, let pokId = pokData?.id else { return }
        
        let pokemonStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let pokemonController = pokemonStoryboard.instantiateViewController(withIdentifier: "ViewControllerStoryboard") as? ViewController {
            pokemonController.pvm = pvm
            pokemonController.pvm.arrPokemon = pvm.arrPokemon
            pokemonController.backPokID = pokId
            present(pokemonController, animated: true)
        }
    }
    
    func getPokeData(_ id: String?) -> Pokemon? {
        
        guard let id = id, let ID = Int(id) else { return nil }
        
            return pvm?.arrPokemon.first { $0.id == ID }
        
      /*
        guard let id = id else { return nil}
        
        if let ID = Int(id) {
            
            if let pokemonList = pvm?.arrPokemon {
                
                for i in 0 ..< pokemonList.count {
                    
                    if let pokId = pokemonList[i].id {
                        
                        if ID == pokId {
                            
                            return pokemonList[i]
                        }
                    }
                }
            }
        }
        
        return nil
        */
    }
    
}

extension PokemonDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let id = pokData?.evolutionChain?[indexPath.row].id {
            
            if let pokemonData = getPokeData(id) {
                
                let pokemonStoryboard = UIStoryboard(name: "Main", bundle: nil)
                
                if let pokemonController = pokemonStoryboard.instantiateViewController(withIdentifier: "PokemonDetails") as? PokemonDetailsViewController {
                    pokemonController.pvm = pvm
                    pokemonController.pokData = pokemonData
                    
                    present(pokemonController, animated: true)
                    
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2 - 10 // Two columns with spacing
        let height: CGFloat = 180
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokData?.evolutionChain?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pokeEvolution", for: indexPath) as! PokemonEvolutionCollectionViewCell
        
        cell.pvm = pvm
        cell.pokemonData = getPokeData(pokData?.evolutionChain?[indexPath.row].id)
        
        return cell
    }
    
}
