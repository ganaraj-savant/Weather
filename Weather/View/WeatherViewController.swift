//
//  ViewController.swift
//  Weather
//
//  Created by E02383 on 19/10/22.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var currentCityLabel: UILabel!
    @IBOutlet weak var forecastTableView: UITableView!
    
    let locationManager = CLLocationManager()
    let viewModel = WeatherViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        searchTextField.delegate = self
        
        forecastTableView.delegate = self
        forecastTableView.dataSource = self
    }

}


extension WeatherViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(searchTextField.text ?? "")
        
        guard let queryText = searchTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return
        }
        
        viewModel.getCurrentLocation(city: queryText) { isSuccess, message in
            if isSuccess {
                print("lat = \(self.viewModel.coordinate?.lat ?? 0.0) & lon = \(self.viewModel.coordinate?.lon ?? 0.0)")
                
                guard let lat = self.viewModel.coordinate?.lat, let lon = self.viewModel.coordinate?.lon else {
                    return
                }
                
                self.viewModel.get5DayWeatherForecast(lat: lat, lon: lon) { isVictory, news in
                    if isVictory {
                        DispatchQueue.main.async {
                            self.forecastTableView.reloadData()
                        }
                    } else {
                        print(news)
                    }
                }
            } else {
                print(message)
            }
        }
    }
}


extension WeatherViewController: CLLocationManagerDelegate {
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            
            viewModel.getCurrentCity(lat: lat, lon: lon) { isSuccess, message in
                if isSuccess {
                    DispatchQueue.main.async {
                        self.currentCityLabel.text = self.viewModel.city?.name
                    }
                } else {
                    print(message)
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}


extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "CellReuseIdentifier")
        
        if indexPath.row / 8 == 0 {
            cell.textLabel?.text = viewModel.weather_5_Days?[indexPath.row].weather?[0].main
        }
        
        return cell
    }
    
}

