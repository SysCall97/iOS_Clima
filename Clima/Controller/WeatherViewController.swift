//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    //MARK: IBOutlets
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: Attributes
    public var manager: WeatherManagerProtocol!
    private let locationManager = CLLocationManager()
    private var coordinate: CLLocationCoordinate2D?

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        self.searchTextField.delegate = self
    }

    //MARK: IBActions
    @IBAction func searchButtonPressed(_ sender: Any) {
        self.startFetchingWeatherFromCity()
    }
    
    @IBAction func getCurrentLocationWeatherPressed(_ sender: Any) {
        self.startFetchingWeatherFromCurrentLocation()
    }
    //MARK: PRIVATE FUNCTIONS
    private func startFetchingWeatherFromCity() {
        guard let cityName = self.searchTextField.text else { return }
        if cityName == "" { return }
        self.searchTextField.endEditing(true)
        self.view.isUserInteractionEnabled = false
        self.activityIndicator.startAnimating()
        Task {
            do {
                let weatherModel = try await manager.fetchWeather(from: cityName)
                self.updateUI(with: weatherModel)
                self.activityIndicator.stopAnimating()
                self.view.isUserInteractionEnabled = true
            } catch let error as NetworkError {
                let message = error.message
                self.activityIndicator.stopAnimating()
                self.showAlert(with: message)
                self.view.isUserInteractionEnabled = true
            }
        }
    }

    private func startFetchingWeatherFromCurrentLocation() {
        guard let coordinate = self.coordinate else { return }
        self.searchTextField.endEditing(true)
        self.view.isUserInteractionEnabled = false
        self.activityIndicator.startAnimating()
        Task {
            do {
                let weatherModel = try await manager.fetchWeather(from: coordinate)
                self.updateUI(with: weatherModel)
                self.activityIndicator.stopAnimating()
                self.view.isUserInteractionEnabled = true
            } catch let error as NetworkError {
                let message = error.message
                self.activityIndicator.stopAnimating()
                self.showAlert(with: message)
                self.view.isUserInteractionEnabled = true
            }
        }
    }

    private func showAlert(with message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func updateUI(with model: WeatherModel) {
        DispatchQueue.main.async {
            self.cityLabel.text = model.cityName
            self.temperatureLabel.text = String(format: "%.1f", model.currentTemp)
            if let image = UIImage(named: model.iconName) {
                self.conditionImageView.image = image
            }
        }
    }
}

//MARK: UITextFieldDelegates
extension WeatherViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.startFetchingWeatherFromCity()
        return true;
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.text = nil
        return true
    }
}

//MARK: CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.coordinate = location.coordinate
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("ERROR")
    }
}
