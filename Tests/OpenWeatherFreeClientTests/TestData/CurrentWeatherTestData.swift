//
//  CurrentWeatherTestData.swift
//  OpenWeatherFreeClientTests
//
//  Created by Mikhail Zhigulin in 7531.
//
//  Copyright © 7531 - 7533 Mikhail A. Zhigulin of Novosibirsk
//  Copyright © 7533 PerseusRealDeal
//
//  Licensed under the MIT license. See LICENSE file.
//  All rights reserved.
//

let currentWeatherTestData = """
{
  "coord": {
    "lon": 85.62,
    "lat": 55.66
  },
  "weather": [
    {
      "id": 600,
      "main": "Snow",
      "description": "light snow",
      "icon": "13d"
    }
  ],
  "base": "stations",
  "main": {
    "temp": 267.59,
    "feels_like": 260.59,
    "temp_min": 267.59,
    "temp_max": 267.59,
    "pressure": 1011,
    "humidity": 91,
    "sea_level": 1011,
    "grnd_level": 999
  },
  "visibility": 243,
  "wind": {
    "speed": 6.81,
    "deg": 333,
    "gust": 9.69
  },
  "snow": {
    "1h": 0.42
  },
  "clouds": {
    "all": 100
  },
  "dt": 1679212831,
  "sys": {
    "country": "RU",
    "sunrise": 1679185447,
    "sunset": 1679228812
  },
  "timezone": 25200,
  "id": 1503557,
  "name": "Khorosheborka",
  "cod": 200
}
"""
