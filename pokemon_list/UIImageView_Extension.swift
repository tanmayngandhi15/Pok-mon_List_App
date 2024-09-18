//
//  UIImage_Extension.swift
//  pokemon_list
//
//  Created by Tanmay Gandhi on 17/09/24.
//

import UIKit

extension UIImageView {
    func setImage(from urlString: String?) {

        guard let urlString = urlString else {
            return
        }
        
        // Convert the string to a URL
        guard let url = URL(string: urlString) else {
            print("Invalid URL string")
            return
        }
        
        // Create a data task to download the image
        URLSession.shared.dataTask(with: url) { data, response, error in
            // Check if data was received and there was no error
            guard let data = data, error == nil else {
                print("Failed to download image: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            // Convert data to UIImage
            if let downloadedImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    // Set the image on the main thread
                    self.image = downloadedImage
                }
            }
        }.resume()
    }
    
    func animatePokemonImage() {
           
        self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        self.alpha = 0
            
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [.curveEaseInOut], animations: {
               
                self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0).rotated(by: .pi / 8)
                self.alpha = 1.0
            }) { _ in
               
                UIView.animate(withDuration: 0.25) {
                    self.transform = .identity
                }
            }
        }
    
}
