//
//  DetailPackagePicker.swift
//  APDetailing
//
//  Created by Dave Piernick on 10/27/22.
//

import SwiftUI

struct DetailPackagePicker: View {
    var menu: DetailMenuObject?
    @Binding var selectedPackage: DetailPackage?
    
    var priceList: [String] {
        var list = [String]()
        for package in menu?.detailPackages ?? [] {
            package.nameAndPriceString.map({ list.append($0) })
        }
        
        return list.isEmpty == false ? list : DetailPackage.defaultPriceStrings
    }

    var body: some View {
        Menu {
            Picker("Package", selection: $selectedPackage) {
                ForEach(menu?.detailPackages ?? [], id: \.self) { package in
                    Text(package.nameAndPriceString ?? "").tag(package)
                }
            }
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Package").foregroundColor(Color(white: 0.4))
                        .foregroundColor(Color(UIColor.placeholderText))
                    Text(selectedPackage?.nameAndPriceString ?? "")
                        .foregroundColor(.white)
                        .font(.title2)
                }
                Spacer()
                Image(systemName: "chevron.up.chevron.down")
                    .foregroundColor(.white)
                    .font(.title3)
                    .padding(.trailing, 8)
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

struct DetailPackagePicker_Previews_Container : View {
    @State var package: DetailPackage? = .fullDetailPackage

     var body: some View {
         DetailPackagePicker(selectedPackage: $package)
     }
}

struct DetailPackagePicker_Previews : PreviewProvider {
    static var previews: some View {
        DetailPackagePicker_Previews_Container()
    }
}
