//
//  AddIncidentView.swift
//  Safe_Zone
//
//  Created by Tun Tauk Oo on 17/10/2568 BE.
//

import SwiftUI
import CoreLocation

struct AddIncidentView: View {
    @EnvironmentObject var store: IncidentStore
    @Environment(\.dismiss) var dismiss

    @State private var title = ""
    @State private var description = ""
    @State private var imageName = "exclamationmark.triangle.fill"
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    @State private var showSourceTypeSheet = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @StateObject private var locationManager = LocationManager()

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Title", text: $title)
                    TextField("Description", text: $description)

                    Picker("Icon", selection: $imageName) {
                        Label("Warning", systemImage: "exclamationmark.triangle.fill").tag("exclamationmark.triangle.fill")
                        Label("Fire", systemImage: "flame.fill").tag("flame.fill")
                        Label("Accident", systemImage: "car.fill").tag("car.fill")
                        Label("Medical", systemImage: "cross.case.fill").tag("cross.case.fill")
                    }
                } header: {
                    Text("Incident Details")
                }

                Section {
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    } else {
                        Text("No photo selected")
                            .foregroundColor(.secondary)
                    }

                    Button("Add Photo") {
                        showSourceTypeSheet = true
                    }
                } header: {
                    Text("Photo Evidence")
                }

                Section {
                    if let location = locationManager.userLocation {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Latitude: \(location.coordinate.latitude)")
                            Text("Longitude: \(location.coordinate.longitude)")
                        }
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    } else {
                        HStack {
                            ProgressView()
                            Text("Fetching location…")
                                .foregroundColor(.secondary)
                        }
                    }
                } header: {
                    Text("Location")
                }
            }
            .navigationTitle("Add Incident")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if let location = locationManager.userLocation {
                            let incident = Incident(
                                title: title,
                                description: description,
                                imageName: imageName,
                                coordinate: location.coordinate,
                                photo: selectedImage
                            )
                            store.addIncident(incident)
                            dismiss()
                        }
                    }
                    .disabled(title.isEmpty)
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $selectedImage, sourceType: sourceType)
            }
            .confirmationDialog("Choose Photo Source", isPresented: $showSourceTypeSheet) {
                Button("Camera") {
                    sourceType = .camera
                    showImagePicker = true
                }
                Button("Photo Library") {
                    sourceType = .photoLibrary
                    showImagePicker = true
                }
                Button("Cancel", role: .cancel) {}
            }
        }
    }
}


#Preview {
    AddIncidentView()
        .environmentObject(IncidentStore())
}



