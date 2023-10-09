//
//  SearchViewProtocol.swift
//  SnapKitUnitTest
//
//  Created by Arrr Park on 08/10/2023.
//

import Foundation
import Combine

protocol SearchAppProtocol {
    var apps: CurrentValueSubject<[AppInfo], Never> { get set }
    var isFetching: CurrentValueSubject<Bool, Never> { get set }
    var isTextFieldFocused: CurrentValueSubject<Bool, Never> { get set }
    var pageIndex: Int { get set }
    var word: String { get set }
    var isEndReached: Bool { get set }
    
    func searchApps(_ name: String) -> Future<SearchResult, NetworkError>
    func initialize()
}
