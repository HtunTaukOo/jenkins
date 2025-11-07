//
//  SettingView.swift
//  Safe_Zone
//
//  Created by Tun Tauk Oo on 17/10/2568 BE.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("emergencyPhoneNumber") private var phoneNumber: String = ""
    @AppStorage("panicAction") private var panicAction: String = "Call"
    
    let options = ["Call", "Send Message"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Emergency Contact")) {
                    TextField("Phone Number", text: $phoneNumber)
                        .keyboardType(.phonePad)
                }
                
                Section(header: Text("Panic Button Action")) {
                    Picker("Action", selection: $panicAction) {
                        ForEach(options, id: \.self) { option in
                            Text(option)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            .navigationTitle("Settings")
        }
    }
}

