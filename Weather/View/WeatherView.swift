//
//  WeatherView.swift
//  Weather
//
//  Created by Paresh  Thakkar on 9/17/24.
//

import SwiftUI
import Combine
import CoreLocation


struct WeatherView: View {
    @StateObject private var viewModel = WeatherViewModel()
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView()
                } else if let weather = viewModel.weatherResponse {
                    VStack {
                        HStack {
                            TextField("Enter city", text: $viewModel.city, onCommit: {
                                viewModel.fetchWeather(for: viewModel.city)
                            })
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                            
                            Button(action: {
                                viewModel.fetchWeather(for: viewModel.city)
                            }) {
                                Text("Search")
                                    .padding(8)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                        }
                        if let icon = weather.weather.first?.icon {
                            AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")) { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                        }
                    }
                    .padding()
                    VStack {
                               HStack {
                                   Text("City:")
                                   Spacer()
                                   Text("\(weather.name)")
                               }
                               Divider()

                               HStack {
                                   Text("Temperature:")
                                   Spacer()
                                   Text("\(weather.main.temp)°C")
                               }
                               Divider()

                               HStack {
                                   Text("Humidity:")
                                   Spacer()
                                   Text("\(weather.main.humidity)%")
                               }
                                Divider()

                                HStack {
                                    Text("Description:")
                                    Spacer()
                                    Text("\(weather.weather.first?.description ?? "N/A")")
                                }
                           }
                           .padding()
                    Spacer()
                
                } else if let errorMessage = viewModel.errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                }
            }
            .padding()
            .navigationTitle("Weather")
            .onAppear {
                // Fetch weather for last city if available
                if let lastCity = UserDefaults.standard.string(forKey: "lastCity") {
                    viewModel.fetchWeather(for: lastCity)
                }
                
                // Request location authorization
                if viewModel.locationService.authorizationStatus == .notDetermined {
                    viewModel.locationService.locationManager.requestWhenInUseAuthorization()
                }
            }
        }
        
    }
        
}


