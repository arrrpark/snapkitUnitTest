//
//  SearchViewModel.swift
//  SnapKitUnitTest
//
//  Created by Arrr Park on 09/10/2023.
//

import UIKit
import Combine

class SearchViewModel {
    var apps = CurrentValueSubject<[AppInfo], Never>([])
    var searchedWords = CurrentValueSubject<[Word], Never>([])
    var isFetching = CurrentValueSubject<Bool, Never>(false)
    var isTextFieldFocused = CurrentValueSubject<Bool, Never>(false)
    var isTextFieldCharacterExists = CurrentValueSubject<Bool, Never>(false)
    var isEndReached = false
    var pageIndex = 0
    var word = ""
    
    func searchApps(_ name: String) -> Future<SearchResult, NetworkError> {
        var parameters: [String: Any] = ["country": "us",
                                         "term": name,
                                         "limit": 10,
                                         "entity": "software"]
        
        if pageIndex != 0 {
            parameters["offset"] = pageIndex * 10 + 1
        }
    
        return AlamofireWrapper.shared.byGet(url: "search", parameters: parameters)
    }
    
    func initialize() {
        apps.value = []
        word = ""
        isEndReached = false
        pageIndex = 0
    }
}
