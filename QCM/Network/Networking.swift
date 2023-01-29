//
//  Networking.swift
//  QCM
//
//  Created by Sofien Benharchache on 28/01/2023.
//

import Foundation

typealias GenericResult<T: Decodable> = (Result<T, NetworkingError>) -> ()

struct Networking {
    /// Find and return local file.
    ///
    /// - Parameter name : file name to read data.
    /// - Parameter type : type to read data. By default "json" file extension is used.
    ///
    /// - Returns: json data if file exist else return nil
    static func localFile(name: String,
                          ofType type: String = "json") throws -> Data? {
        
        guard let path = Bundle.main.path(forResource: name, ofType: type)
        else { throw NetworkingError.invalidUrl }
        
        let url = URL(fileURLWithPath: path)
        
        do { return try Data(contentsOf: url) }
        catch { throw NetworkingError.request(error: error) }
    }
    
    /// Decode to data
    ///
    /// Decode from json data.
    /// If an error occured a Networking Error is catched and passing into result completion.
    ///
    /// - Parameter data : Data json to decode.
    /// - Parameter toType : Expected type to decode.
    /// - Parameter completion : Result of decoded data. Can be succeded or failed with NetworkingError.
    static func decode<T: Decodable>(data: Data,
                                     toType: T.Type,
                                     _ completion: @escaping GenericResult<T>) {
        do {
            let data = try JSONDecoder().decode(T.self, from: data)
            completion(.success(data))
        } catch {
            completion(.failure(NetworkingError.decoded(error: error)))
        }
    }
    
    static func load<T: Decodable>(from name:String,
                                   completion: @escaping GenericResult<T>) {
        do {
            guard let data = try Networking.localFile(name: name)
            else {
                completion(.failure(NetworkingError.dataNotFound))
                return
            }
            Networking.decode(data: data, toType: T.self, completion)

        } catch {
            completion(.failure(NetworkingError.decoded(error: error)))
        }
    }
}

enum NetworkingError: Error {
    case request(error: Error),
         timedOut,
         invalidUrl,
         dataNotFound,
         decoded(error: Error),
         unknown(error: Error)
}
