//
//  Safe_ZoneApp.swift
//  Safe_Zone
//
//  Created by Tun Tauk Oo on 11/9/2568 BE.
//

import SwiftUI
import Combine

@main
struct EmergencyApp: App {
    @StateObject private var store = IncidentStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}

