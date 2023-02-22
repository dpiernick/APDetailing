//
//  DetailPackagePicker.swift
//  APDetailing
//
//  Created by Dave Piernick on 10/27/22.
//

import SwiftUI

struct DetailPackagePicker: View {
    @Binding var selectedPackage: DetailPackage

    var body: some View {
        Menu {
            Picker("Package", selection: $selectedPackage) {
                ForEach(MockDetailPackages.allPackages) { package in
                    Text(package.id + " - " + package.priceString).tag(package)
                }
            }
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Package")
                        .foregroundColor(Color(UIColor.placeholderText))
                    Text("\(selectedPackage.id) - \(selectedPackage.priceString)")
                        .foregroundColor(.white)
                        .font(.title2)
                }
                Spacer()
                Image(systemName: "chevron.up.chevron.down")
                    .foregroundColor(.white)
            }
            .padding(8)
            .overlay(content: {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.red, lineWidth: 1)
            })
            .preferredColorScheme(.dark)
        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

//struct DetailPackagePicker_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailPackagePicker(selectedPackage: MockDetailPackages.basic)
//    }
//} 
