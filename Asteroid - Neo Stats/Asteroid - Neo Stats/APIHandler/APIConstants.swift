//
//  APIConstants.swift
//  Asteroid - Neo Stats
//
//  Created by Shailendra Kushwaha on 05/02/23.
//

import Foundation



struct APIConstant {

    enum EndPoint :String {
        case feed = "feed"
        
        var path : String {
            let baseURL = "https://api.nasa.gov/neo/rest/v1/"
            return baseURL + self.rawValue
        }
    }
}
