//
//  DetailPackagePicker.swift
//  APDetailing
//
//  Created by Dave Piernick on 10/27/22.
//

import SwiftUI

struct DetailPackagePicker: View {
    @State var selectedPackage: DetailPackage
    
    init(selectedPackage: DetailPackage) {
        self.selectedPackage = selectedPackage
    }
    
    var body: some View {
        Menu {
            Picker("Package", selection: $selectedPackage) {
                ForEach(MockDetailPackages.allPackages, id: \.self) { package in
                    
                    Text(package.id + " - " + package.priceString)
                }
            }
        } label: {
            HStack(alignment: .bottom) {
                Text("Package:")
                    .font(.title3)
                    .foregroundColor(.white)
                Spacer()
                Text(selectedPackage.id)
                    .font(.title)
                    .foregroundColor(.white)
                Spacer()
                Text("-").font(.title).foregroundColor(.white)
                Spacer()
                Text(selectedPackage.priceString)
                    .font(.title)
                    .foregroundColor(.white)
            }
            .padding()
            .overlay(content: {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.red, lineWidth: 3)
            })
            .padding()
        }
    }
}
