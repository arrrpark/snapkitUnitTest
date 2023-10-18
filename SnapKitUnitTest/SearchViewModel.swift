//
//  SearchViewModel.swift
//  SnapKitUnitTest
//
//  Created by Arrr Park on 09/10/2023.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewModel {
    var apps = BehaviorRelay<[AppInfo]>(value: [])
    var searchedWords = BehaviorRelay<[Word]>(value: [])
    var isFetching = BehaviorRelay<Bool>(value: false)
    var isSearchFieldFocused = BehaviorRelay<Bool>(value: false)
    var isSearchFieldCharacterExists = BehaviorRelay<Bool>(value: false)
    
    var isEndReached = false
    var pageIndex = 0
    var word = ""
    
    func searchApps(_ name: String) -> Single<SearchResult> {
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
        apps.accept([])
        word = ""
        isEndReached = false
        pageIndex = 0
    }
}
