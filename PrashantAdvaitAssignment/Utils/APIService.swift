//
//  APIService.swift
//  PrashantAdvaitAssignment
//
//  Created by Raman choudhary on 10/05/24.
//

import Foundation

// Define a class to handle API operations
class APIService {

    // Base URL of the API
    private let baseUrl = "https://acharyaprashant.org/api/v2/content/misc/media-coverages?limit=100"

    // Function to fetch data from a specific url
    func fetchData(completion: @escaping (Result<Data, Error>) -> Void) {
        
        guard let url = URL(string: baseUrl) else {
            completion(.failure(APIError.invalidURL))
            return
        }

        // Create the URL request
        var request = URLRequest(url: url)
        request.httpMethod = "GET" // or "POST", "PUT", etc.
        // You can add headers or body if needed
        // request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // Perform the network task
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Check for errors, unwrap data and handle HTTP responses
            guard let data = data, error == nil else {
                completion(.failure(error ?? APIError.networkError))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(APIError.invalidResponse))
                return
            }

            // Successfully retrieved data
            completion(.success(data))
        }
        task.resume()
    }
}

// Define possible errors
enum APIError: Error {
    case invalidURL
    case networkError
    case invalidResponse
}


