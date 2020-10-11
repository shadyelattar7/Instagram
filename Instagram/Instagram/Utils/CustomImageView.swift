//
//  CustomImageView.swift
//  Instagram
//
//  Created by Elattar on 4/24/20.
//  Copyright © 2020 Elattar. All rights reserved.
//

import UIKit


var imageCache = [String:UIImage]()

class CustomImageView: UIImageView{
    
    var lastUrlUsedToLoadImage: String?
   
    func loadImage(url: String) {
        
        self.image = nil
        
        //check is url cache Image or not , is cached func is return
        if let cacheImage = imageCache[url]{
            self.image = cacheImage
            return
        }

        
        lastUrlUsedToLoadImage = url
        guard let url = URL(string: url) else {return}
        
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Failed to fetch post image" , error)
                return
            }
            
            //Becouse not repate image but i did not understand this line of code
            if url.absoluteString != self.lastUrlUsedToLoadImage{
                return
            }
            
            guard let imageData = data else {return}
            let photoImage = UIImage(data: imageData)
            
            
            //to cache Image
            imageCache[url.absoluteString] = photoImage
            
            DispatchQueue.main.async {
                self.image = photoImage
            }
            
        }.resume()
    }
    
}
