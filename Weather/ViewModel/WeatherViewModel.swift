//
//  WeatherViewModel.swift
//  Weather
//
//  Created by E02383 on 19/10/22.
//

import Foundation
import CoreLocation

class WeatherViewModel: NSObject {
    
    private let apiKey = "857f0381577f42d1d630c48a18e9b768"
    var city: CityModel?
    var coordinate: CoordinatesModel?
    var weather_5_Days: [List]?
    
    func getCurrentCity(lat: CLLocationDegrees, lon: CLLocationDegrees, completionHandler: @escaping (Bool, String) -> Void) {
        let apiURL = "https://api.openweathermap.org/geo/1.0/reverse?lat=\(lat)&lon=\(lon)&appid=\(apiKey)"
        
        APIHelper.shared.getResponse(fromAPI: apiURL, method: "GET") { data in
            let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode([CityModel].self, from: data)
                self.city = decodedData.first
                
                completionHandler(true, "Data fetched successfully.")
            } catch {
                completionHandler(false, error.localizedDescription)
            }
        }
    }
    
    func getCurrentLocation(city: String, completionHandler: @escaping (Bool, String) -> Void) {
        let apiURL = "https://api.openweathermap.org/geo/1.0/direct?q=\(city)&appid=\(apiKey)"
        
        APIHelper.shared.getResponse(fromAPI: apiURL, method: "GET") { data in
            let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode([CoordinatesModel].self, from: data)
                self.coordinate = decodedData.first
                
                completionHandler(true, "Data fetched successfully.")
            } catch {
                completionHandler(false, error.localizedDescription)
            }
        }
    }
    
    func get5DayWeatherForecast(lat: Double, lon: Double, completionHandler: @escaping (Bool, String) -> Void) {
        let apiURL = "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&appid=\(apiKey)"
        
        APIHelper.shared.getResponse(fromAPI: apiURL, method: "GET") { data in
            let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode(WeatherModel.self, from: data)
                self.weather_5_Days = decodedData.list
                
                completionHandler(true, "Data fetched successfully.")
            } catch {
                completionHandler(false, error.localizedDescription)
            }
        }
    }
}
