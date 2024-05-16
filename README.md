
# Assignment Project


## Technologies used

    •    Mobile Application Frontend language used : Swift.
    •    Frameworks: Uikit.
    
## Requirements 

    • iOS 13.0+
    • Swift 5.0+
    • Xcode 14.0+

## Installation

    •    Open terminal in your system.
    •    Run the git clone command i.e git clone https://github.com/Ramancb/PrashantAdvaitAssignment.git.
    
    Your project is ready to run


## Folder Structure of project

    • AppGlobals: This folder contains SceneDelegate and AppDelegate files.
    
        1. AppDelegate.swift: This file contains the implementation of the UIApplicationDelegate protocol. It's responsible for managing the app's lifecycle events, such as app launch, backgrounding, termination, and handling various system-level events.
           
        2.SceneDelegate.swift: Introduced in iOS 13, the SceneDelegate manages the lifecycle of individual scenes in your app.
       
    • Workspace : Contain the following files.
    
        1. Model: ImageListModel conforms to the Codable protocol, enabling  decoding of data from https://acharyaprashant.org/api/v2/content/misc/media-coverages?limit=100 this api url response.
        2.Controller: ViewController handling user interactions, data presentation, and lifecycle events.
        3.CollectionCell : In this folder contain collection view cell swift file and collection cell xib file.
    
    • Utils: This folder contains the overall utility file and helper classes that we need in project.
    
        1. CacheManager: In this file contain CacheManager singelton class. overall memory and disk caching code handled in this file.
        2. APIService: In this file contain APIService class which is responsible for api call using URLSession provides methods.
    
    • SupportingFiles: This folder contains the  files like storyboard, assets and info.plist .

