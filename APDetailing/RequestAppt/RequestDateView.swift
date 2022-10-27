//
//  RequestDateView.swift
//  APDetailing
//
//  Created by Dave Piernick on 10/18/22.
//

import Foundation
import SwiftUI

enum TimeOfDay: String {
    case morning = "Morning"
    case afternoon = "Afternoon"
}

struct Appointment {
    var date: Date
    var time: TimeOfDay
    var package: DetailPackage
}

struct RequestDateView: View {
    
    @State var name = ""
    @State var phone = ""
    @State var apptDate = Date.now.addingTimeInterval(.day)
    @State var location = ""
    @State var carDescription = ""
    @State var selectedPackage: DetailPackage = MockDetailPackages.basic
    
    var body: some View {
        ScrollView {
            VStack {
                
                VStack {
                    TextField("Name", text: $name)
                        .textFieldStyle(.roundedBorder)
                    
                    TextField("Phone Number", text: $phone)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.decimalPad)
                    
                    TextField("Location", text: $location)
                        .textFieldStyle(.roundedBorder)
                    
                    TextField("Car Description", text: $carDescription)
                        .textFieldStyle(.roundedBorder)
                }
                .padding()
                
                DatePicker("Appointment Date",
                           selection: $apptDate,
                           in: Date.now.addingTimeInterval(.day)...Date.now.addingTimeInterval(.week * 4),
                           displayedComponents: .date)
                .datePickerStyle(.graphical)
                
                
                HStack {
                    Button {
                        //Set Am
                    } label: {
                        RoundedButtonLabel(title: "Morning")
                    }
                    
                    Button {
                        //set pm
                    } label: {
                        RoundedButtonLabel(title: "Afternoon")
                    }
                }
                .padding(.horizontal)
                
                DetailPackagePicker()
            }
        }
        .preferredColorScheme(.dark)
        .safeAreaInset(edge: .bottom) {
            ContainerView {
                Button {
                    //confirm appt
                } label: {
                    VStack(spacing: 0) {
                        LinearGradient(colors: [.clear, .black.opacity(0.8), .black], startPoint: .top, endPoint: .bottom).frame(height: 20)
                        ZStack {
                            Color.black.ignoresSafeArea(edges: .bottom).frame(maxHeight: 100)
                            RoundedButtonLabel(title: "Book Appointment  >")
                                .padding()
                        }
                    }
                }
                .padding(.vertical)
            }
            .frame(maxWidth: .infinity, minHeight: 125)
            .background {
                
            }
        }
        .ignoresSafeArea()
    }
}

struct RequestDateView_Previews: PreviewProvider {
    static var previews: some View {
        RequestDateView()
    }
}
