//
//  AlamofireWrapper.swift
//  SnapKitUnitTest
//
//  Created by Arrr Park on 09/10/2023.
//

import Foundation
import Alamofire
import Combine
import RxSwift

enum NetworkError: Error {
    case badForm
    case networkError
}

struct AlamofireWrapper {
    static let shared = AlamofireWrapper()
    
    private init() { }
    
    private let baseURL = "https://itunes.apple.com/"
    
    private let jsonDecoder = JSONDecoder()
    
    private func configureHeaders() -> HTTPHeaders {
        [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }
    
    func byGet<T: Codable>(url: String, parameters: [String: Any]? = nil) -> Single<T> {
        return Single.create { observer -> Disposable in
            let task = AF.request("\(baseURL)\(url)", parameters: parameters, headers: configureHeaders())
                .validate(statusCode: 200..<300)
                .response(completionHandler: { response in
                    guard let data = response.data,
                          let data = try? jsonDecoder.decode(T.self, from: data) else {
                        observer(.failure(NetworkError.badForm))
                        return
                    }
                    observer(.success(data))
                })
            
            return Disposables.create { task.cancel() }
        }
    }
}
