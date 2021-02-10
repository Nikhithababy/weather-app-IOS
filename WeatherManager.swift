//
//  WeatherManager.swift
//  Clima
//
//  Created by user186829 on 2/10/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate
{
    func didUpdateWeather(_ weatherManager:WeatherManager,weather:WeatherModel)
    func didFailWithError(error: Error)}
struct WeatherManager
{
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=0b17b1b86924b51da61244568301527c&units=metric"
    var delegate : WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
            let urlString = "\(weatherURL)&q=\(cityName)"
            print(urlString)
            performRequest(with:urlString)
        
    }
    
    func performRequest(with urlString: String){
       if let url=URL(string:urlString){
        let session = URLSession(configuration: .default)
        //let task = session.dataTask(with:url,completionHandler:handle(data:response:error:))
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil
            {
                self.delegate?.didFailWithError(error: error!)
                return
                
            }
            if let safeData = data
            {
               // let dataString = String(data:safeData,encoding: .utf8)
              if let weather = self.parseJSON(weatherData:safeData)
              {
                
                self.delegate?.didUpdateWeather(self,weather:weather)
              }
                
            }        }
        task.resume()
        
    }
    }
    func parseJSON(weatherData:Data)->WeatherModel?
    {
        let decoder = JSONDecoder()
        do{
         let decodedata =  try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedata.weather[0].id
            let temp = decodedata.main.temp
            let name = decodedata.name
            let weather = WeatherModel(conditionId: id, cityName: name,temperature: temp)
            //print(getconditionName(weatherID:id))
            //print(weather.conditionName)
            return weather
            
          }
        catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
