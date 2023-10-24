# snapkitUnitTest

This project is a sample appstore app that uses official Apple's API(https://developer.apple.com/library/archive/documentation/AudioVideo/Conceptual/iTuneSearchAPI/index.html#//apple_ref/doc/uid/TP40017632-CH3-SW1) to show my coding style.
It uses MVVM architecture. ViewModel is injected and used in all ViewControllers, seperating business logic from presentation logic. This project consists of two view controllers.

Instead of using storyboards, I made UI programmatically using SnapKit.
It uses Alamofire for networking, and CoreData for perminent data store.

Below libraries are used that are available at Swift Package Manager.
- RxSwift
- RxCocoa
- Then
- SnapKit
- Alamofire
- Cosmos
- SnapShotTesting
- Kinfisher

App's requirements are as follows.
- When users launches the app, they are able to search apps.
- When they are typing the text, the screen shows recent words that starts with the text. It shows up to 10 recent words.
- When users hit the done button, the app searches availble apps on the apple store with the typed text.
- App shows the results. With one search, app can get 10 available apps at most.
- When user hits the bottom of the screen on searching screen, the app tries to search more with the typed text, if available.
- When user clicks the app on the list, detail screen would be shown.

  
![AppStorePreview](https://github.com/arrrpark/snapkitUnitTest/assets/69378425/bf918147-b701-4776-a5f4-dd2f819fa899)



For most test part, this project uses XCUnitTest, including UI-related features.
Only some parts that can't be tested through XCUnitTest are tested through XCUITest. (For example, collectionView's paging logic)
