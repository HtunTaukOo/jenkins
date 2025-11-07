//
//  IncidentListView.swift
//  Safe_Zone
//
//  Created by Tun Tauk Oo on 17/10/2568 BE.
//

import SwiftUI

struct IncidentListView: View {
    @EnvironmentObject var store: IncidentStore
    @State private var showAddIncident = false

    var body: some View {
        NavigationStack {
            List(store.incidents) { incident in
                HStack(spacing: 12) {
                    if let photo = incident.photo {
                        Image(uiImage: photo)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    } else {
                        Image(systemName: incident.imageName)
                            .font(.system(size: 40))
                            .foregroundColor(.gray)
                    }

                    VStack(alignment: .leading) {
                        Text(incident.title)
                            .font(.headline)
                        Text(incident.description)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                    }
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("Incidents")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAddIncident.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddIncident) {
                AddIncidentView()
            }
        }
    }
}

#Preview {
    IncidentListView()
        .environmentObject(IncidentStore())
}

