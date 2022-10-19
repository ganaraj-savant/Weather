//
//  CityModel.swift
//  Weather
//
//  Created by E02383 on 19/10/22.
//

import Foundation

// MARK: - WelcomeElement
struct CityModel: Codable {
    let name : String?
    let local_names : Local_names?
    let lat : Double?
    let lon : Double?
    let country : String?
    let state : String?
    
    enum CodingKeys: String, CodingKey {
        
        case name = "name"
        case local_names = "local_names"
        case lat = "lat"
        case lon = "lon"
        case country = "country"
        case state = "state"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        local_names = try values.decodeIfPresent(Local_names.self, forKey: .local_names)
        lat = try values.decodeIfPresent(Double.self, forKey: .lat)
        lon = try values.decodeIfPresent(Double.self, forKey: .lon)
        country = try values.decodeIfPresent(String.self, forKey: .country)
        state = try values.decodeIfPresent(String.self, forKey: .state)
    }
    
}

struct Local_names : Codable {
    let kn : String?
    
    enum CodingKeys: String, CodingKey {
        
        case kn = "kn"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        kn = try values.decodeIfPresent(String.self, forKey: .kn)
    }
    
}
