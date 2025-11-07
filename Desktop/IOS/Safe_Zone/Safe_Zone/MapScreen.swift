//
//  MapScreen.swift
//  Safe_Zone
//
//  Created by Tun Tauk Oo on 17/10/2568 BE.
//

import SwiftUI
import MapKit
import CoreLocation

struct MapScreen: View {
    @EnvironmentObject var store: IncidentStore
    @StateObject private var locationManager = LocationManager()
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    var body: some View {
        NavigationStack {
            ZStack {
                if let userLocation = locationManager.userLocation {
                    Map(coordinateRegion: $region,
                        showsUserLocation: true,
                        annotationItems: store.incidents) { incident in
                        MapAnnotation(coordinate: incident.coordinate) {
                            VStack(spacing: 2) {
                                Image(systemName: incident.imageName)
                                    .foregroundColor(.red)
                                    .font(.title)
                                Text(incident.title)
                                    .font(.caption)
                                    .bold()
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                    .onAppear {
                        region.center = userLocation.coordinate
                    }
                    .ignoresSafeArea(edges: .top)
                } else {
                    ProgressView("Fetching your location...")
                }
            }
        }
    }
}


#Preview {
    MapScreen()
        .environmentObject(IncidentStore())
}

