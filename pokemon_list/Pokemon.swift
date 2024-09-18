//
//  Pokemon.swift
//  pokemon_list
//
//  Created by Tanmay Gandhi on 20/08/24.
//

import Foundation

struct Pokemon: Codable {
    let id: Int?
    let name: String? //
    let type: String? //
    let description: String?
    let height: Int? //
    let weight: Int? //
    let imageUrl: String?
    let attack: Int? //
    let defense: Int? //
    let evolutionChain: [EvolutionChain]?
}

struct EvolutionChain: Codable {
    let id: String?
    let name: String?
}
