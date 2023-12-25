//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {

    //MARK: IBOutlets
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    //MARK: Attributes
    public var manager: WeatherManagerProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchTextField.delegate = self
    }

    //MARK: IBActions
    @IBAction func searchButtonPressed(_ sender: Any) {
        self.startFetchingWeather()
    }
    
    //MARK: PRIVATE FUNCTIONS
    private func startFetchingWeather() {
        guard let cityName = self.searchTextField.text else { return }
        self.searchTextField.endEditing(true)
        Task {
            do {
                let weatherModel = try await manager.fetchWeather(from: cityName)
                self.updateUILabels(with: weatherModel.cityName, String(weatherModel.currentTemp))
            } catch let error as NetworkError {
                var message = error.message
                self.showAlert(with: message)
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
    
    private func updateUILabels(with cityName: String, _ temp: String) {
        DispatchQueue.main.async {
            self.cityLabel.text = cityName
            self.temperatureLabel.text = temp
        }
    }
}

//MARK: UITextFieldDelegates
extension WeatherViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.startFetchingWeather()
        return true;
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.text = nil
        return true
    }
}
