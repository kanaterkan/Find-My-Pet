//
//  FindMyPetApp.swift
//  FindMyPet
//
//  Created by Moritz Müscher on 08.11.23.
//

import SwiftUI



//entry point of the application
@main
struct FindMyPetApp: App {
    
    // is used to associate an instance of "AppDelegate" class with the FindMyPetApp strcture
    //Standard  class in UIKit and used to handle application lifecycle events (start, end)wa
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    //Container for the main content
    var body: some Scene {
        WindowGroup {
            //Will be displayed
            WelcomeScreen()
        }
    }
}
