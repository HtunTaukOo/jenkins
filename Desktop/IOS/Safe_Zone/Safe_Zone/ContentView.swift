//
//  ContentView.swift
//  Safe_Zone
//
//  Created by Tun Tauk Oo on 20/9/2568 BE.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            EmergencyView()
                .tabItem {
                    Label("Emergency", systemImage: "exclamationmark.triangle")
                }
            MapScreen()
                .tabItem {
                    Label("Map", systemImage: "map")
                }
            IncidentListView()
                .tabItem {
                    Label("Incident", systemImage: "list.bullet")
                }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(IncidentStore())
}

