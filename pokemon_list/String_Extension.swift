//
//  String_Extension.swift
//  pokemon_list
//
//  Created by Tanmay Gandhi on 17/09/24.
//

import UIKit

extension String {

func loadImage(completion: @escaping (UIImage?) -> Void) {
    
    guard let url = URL(string: self) else {
        return
    }
    
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        guard let data = data, error == nil else {
            completion(nil)
            return
        }
        let image = UIImage(data: data)
        completion(image)
    }
    task.resume()
}
}

