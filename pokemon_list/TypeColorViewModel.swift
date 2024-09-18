//
//  TypeColorViewModel.swift
//  pokemon_list
//
//  Created by Tanmay Gandhi on 21/08/24.
//

import UIKit

class TypeColorViewModel {
    
    func color(for type: String) -> UIColor {
        switch type.lowercased() {
        case "fire":
            return .red
        case "water":
            return .blue
        case "grass":
            return .green
        case "electric":
            return .yellow
        case "flying":
            return .cyan
        case "poison":
            return .purple
        case "bug":
            return .systemTeal
        case "normal":
            return .orange
        case "ground":
            return .brown
        case "fairy":
            return .systemPink
        case "fighting":
            return .systemRed
        case "psychic":
            return .magenta
        case "steel":
            return .gray
        case "ice":
            return .systemBlue
        case "rock":
            return .darkGray
        case "dragon":
            return .systemIndigo
        default:
            return .systemBrown // Default color for unknown types
        }
    }
}
