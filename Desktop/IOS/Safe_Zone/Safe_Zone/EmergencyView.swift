//
//  PanicView.swift
//  Safe_Zone
//
//  Created by Tun Tauk Oo on 20/9/2568 BE.
//

import SwiftUI
import MessageUI

struct EmergencyView: View {
    @AppStorage("emergencyPhoneNumber") private var phoneNumber: String = ""
    @AppStorage("panicAction") private var panicAction: String = "Call"
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showSettings = false
    @State private var showMessageView = false
    @State private var messageError = false
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                Button(action: {
                    performPanicAction()
                }) {
                    Text("Panic")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                        .frame(width: 200, height: 200)
                        .background(Color.red)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                }
                
                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showSettings.toggle()
                    } label: {
                        Image(systemName: "gear")
                    }
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
            .sheet(isPresented: $showMessageView) {
                MessageComposerView(
                    recipients: [phoneNumber],
                    body: generateEmergencyMessage(),
                    isPresented: $showMessageView
                )
            }
            .alert("⚠️Alert", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
            .alert("Message Error", isPresented: $messageError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Your device cannot send messages. Please check your message settings.")
            }
            .onAppear {
                locationManager.requestLocation()
            }
        }
    }
    
    private func performPanicAction() {
        guard !phoneNumber.isEmpty else {
            alertMessage = "No phone number saved in Settings.\n\nPlease go to the settings and add one before pressing Panic button."
            showAlert = true
            return
        }
        
        if panicAction == "Call" {
            callNumber(phoneNumber)
        } else {
            locationManager.requestLocation { location in
                if location == nil {
                    alertMessage = "Location unavailable, sending message without coordinates"
                    showAlert = true
                    return
                }
                sendEmergencyMessage()
            }
        }
    }


    private func sendEmergencyMessage() {
            
            if MFMessageComposeViewController.canSendText() {
                showMessageView = true
            } else {
                messageError = true
            }
        }
        
        private func generateEmergencyMessage() -> String {
            guard let location = locationManager.userLocation else {
                return "EMERGENCY! I need help immediately! \n\n My location is currently unavailable.\n\nPlease call me at your earliest convenience."
            }
            
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            let coordinates = String(format: "%.6f, %.6f", latitude, longitude)
            
            let googleMapsLink = "https://www.google.com/maps?q=\(latitude),\(longitude)&z=17"
            let appleMapsLink = "https://maps.apple.com/?q=\(latitude),\(longitude)&z=17"
            
            return """
            EMERGENCY! I need help immediately!
            
            MY CURRENT LOCATION:
            Coordinates: \(coordinates)
            
            MAP LINKS:
            Google Maps: \(googleMapsLink)
            Apple Maps: \(appleMapsLink)
            
            Please come to this location or send help!
            """
        }
    
    private func callNumber(_ number: String) {
        let filteredNumber = number.filter("0123456789".contains)
        if let url = URL(string: "tel://\(filteredNumber)"),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}


#Preview {
    EmergencyView()
}
