//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController ,UITextFieldDelegate, WeatherManagerDelegate{

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var Searchtext: UITextField!
    var weathermanager = WeatherManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        Searchtext.delegate = self
        weathermanager.delegate = self
        
        // Do any additional setup after loading the view.
    }

    @IBAction func Searchbutton(_ sender: UIButton) {
        Searchtext.endEditing(true)
        print(Searchtext.text!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(Searchtext.text!)
        Searchtext.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = Searchtext.text
        {
            weathermanager.fetchWeather(cityName: city)
        }
        Searchtext.text=""
        
        }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool{
        if textField.text != ""{
            return true
        }
        else
        {
            textField.placeholder = "Type Something"
            return false
        }
    
    }
    func didUpdateWeather(_ weatherManager: WeatherManager,weather:WeatherModel)
    {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName:weather.conditionName)
            
        }
        print(weather.temperature)
    }
    func didFailWithError(error: Error) {
        print(error)
    }
}

