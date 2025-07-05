//
//  CurrenWeatherResponse.swift
//  WeatherAppDemo
//
//  Created by Kate Alyssa Joanna L. de Leon on 3/20/25.
//

import Foundation

struct CurrentWeatherResponse: Codable {
    let name: String
    let weather: [Weather]
    let main: Main
    let coord: Coord?

    struct Weather: Codable {
        let icon: String
    }

    struct Main: Codable {
        let temp: Double
    }
    
    struct Coord: Codable {
        let lon: Double
        let lat: Double
    }
}

struct ForecastResponse: Codable {
    let list: [ForecastEntry]
}

struct ForecastEntry: Codable {
    let dt_txt: String
    let main: Main
    let weather: [Weather]

    struct Main: Codable {
        let temp: Double
    }

    struct Weather: Codable {
        let icon: String
    }
}
