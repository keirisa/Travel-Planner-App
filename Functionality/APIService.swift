//
//  APIService.swift
//  Travel Planner App
//
//  Created by Kate Alyssa Joanna L. de Leon on 4/14/25.
//

import Foundation
import UIKit

class APIService {
    static let shared = APIService()
    
    private init() {}
    
    func fetchDestinations(completion: @escaping ([APIDestination]?, Error?) -> Void) {
        guard let url = URL(string: "https://map523-travel-planner-api.vercel.app/destinations") else {
            completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "No data received", code: 0, userInfo: nil))
                return
            }
            
            do {
                let destinations = try JSONDecoder().decode([APIDestination].self, from: data)
                completion(destinations, nil)
            } catch {
                print("JSON decoding error: \(error)")
                completion(nil, error)
            }
        }
        
        task.resume()
    }
}
