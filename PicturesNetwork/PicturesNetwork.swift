//
//  PicturesNetwork.swift
//  PicturesNetwork
//
//  Created by OMac on 8/21/19.
//  Copyright © 2019 OMac. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

open class PicturesNetworkManager: NSObject {
    
    private static let headers = ["Authorization": "Client-ID 4c9fbfbbd92c17a2e95081cec370b4511659666240eb4db9416c40c641ee843b"]
    private static let baseURLString = "https://api.unsplash.com/"
    
    public static func getPictures(page: Int = 1, query: String? = nil, completion: @escaping (_ result: Any) -> (), error: @escaping (_ errorString: String) -> ()) {
        searchPicturesBy(page: page, query: query, completion: completion, error: error)
    }
    
    public static func getImageFrom(_ urlString: String, completion: @escaping (_ result: UIImage) -> ()) {
        Alamofire.request(urlString).responseImage { response in
            if let image = response.result.value {
                completion(image)
            }
        }
    }
    
    private static func searchPicturesBy(page: Int = 1, query: String?, completion: @escaping (_ result: Any) -> (), error: @escaping (_ errorString: String) -> ()) {
        var path = "photos?page=\(page)&per_page=30"
        if let query = query {
            path = "search/photos" + "?page=\(page)&per_page=30&query=\(query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")"
        }
        Alamofire.request(baseURLString + path, method: .get, parameters: [:], encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            
            if let pictures = response.result.value {
                completion(pictures)
            } else {
                error(response.result.error?.localizedDescription ?? "Error")
            }
        }
    }
}
