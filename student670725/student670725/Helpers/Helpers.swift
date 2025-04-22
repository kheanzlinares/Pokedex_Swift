//
//  Helpers.swift
//  student670725
//
//  Created by Niña Kheaney Linares on 31/10/2024.
//

import Foundation

// MARK: - Network Utility
struct NetworkManager {
    
    /// Fetches data of a given type from a URL
    static func fetchData<T: Decodable>(urlString: String, type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedData))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

// MARK: - Network Error Enum
enum NetworkError: Error {
    case invalidURL
    case noData
}

// MARK: - Usage Example

// Fetching Pokémon types
func getPokemonTypes(urlString: String, completion: @escaping (Result<[PokemonTypes], Error>) -> Void) {
    NetworkManager.fetchData(urlString: urlString, type: PokemonTypeDetails.self) { result in
        switch result {
        case .success(let pokemonTypeDetails):
            completion(.success(pokemonTypeDetails.types))
        case .failure(let error):
            completion(.failure(error))
        }
    }
}

extension String {
    func extractIdFromUrl() -> Int? {
        return Int(self.split(separator: "/").last ?? "")
    }
}
