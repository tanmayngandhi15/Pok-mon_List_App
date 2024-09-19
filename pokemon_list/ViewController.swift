//
//  ViewController.swift
//  pokemon_list
//
//  Created by Tanmay Gandhi on 19/08/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var iv_bgGIF: UIImageView!
    @IBOutlet var tv_pokemonList: UITableView!
    @IBOutlet var sb_findPokemon: UISearchBar!
    var pvm = PokemonViewModel()
    let vm_av = AudioViewModel()
    var backPokID: Int?
    
    override func viewWillAppear(_ animated: Bool) {
        if backPokID == nil {
            iv_bgGIF.image = UIImage.gif(asset: "main_bgGIF")
            iv_bgGIF.alpha = 1.0
        } else {
            iv_bgGIF.alpha = 0.0
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if backPokID == nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                UIView.animate(withDuration: 1.5) {
                    self.iv_bgGIF.alpha = 0.0
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
      
        if backPokID == nil {

            vm_av.setAudio("GonnaCatchEmAll")
            pvm.callAPI()
        }
        
        pvm.vc = self
        TV_Configure()
    }

    
    func TV_Configure() {
        tv_pokemonList.dataSource = self
        tv_pokemonList.delegate = self
        tv_pokemonList.register(UINib(nibName: "PokemonTableViewCell", bundle: nil), forCellReuseIdentifier: "myCell")
        
        if let backPokID = backPokID, let id = pvm.searchPokemon(with: backPokID) {
            sb_findPokemon?.isHidden = false
            tv_pokemonList?.isHidden = false
            let indexPath = IndexPath(row: id, section: 0)
            
            // Scroll to the specified row
            tv_pokemonList?.scrollToRow(at: indexPath, at: .middle, animated: true)
            tv_pokemonList?.reloadData()
          }
        }
    }

extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        pvm.searchPokemon(with: searchText)
        tv_pokemonList?.reloadData()
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return pvm.filteredPokemon.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! PokemonTableViewCell
        
        cell.pvm = pvm
        cell.pokemonData = pvm.filteredPokemon[indexPath.row]

        return cell
    }
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 
        let pokemonStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let pokemonController = pokemonStoryboard.instantiateViewController(withIdentifier: "PokemonDetails") as? PokemonDetailsViewController {
            pokemonController.pvm = pvm
            pokemonController.pokData = pvm.filteredPokemon[indexPath.row]
            present(pokemonController, animated: true)
           
        }
    }
}

