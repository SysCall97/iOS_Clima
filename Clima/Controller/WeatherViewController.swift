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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
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
        self.startFetchingWeather()
        return true;
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.text = nil
        return true
    }
}
