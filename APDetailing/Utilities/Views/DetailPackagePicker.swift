//
//  DetailPackagePicker.swift
//  APDetailing
//
//  Created by Dave Piernick on 10/27/22.
//

import SwiftUI

class DetailPackagePickerViewModel: ObservableObject {
    @Binding var selectedPackage: DetailPackage?
    
    init(selectedPackage: Binding<DetailPackage?>) {
        self._selectedPackage = selectedPackage
    }
}

struct DetailPackagePicker: View {
    var menu: DetailMenuObject?
    @ObservedObject var viewModel: DetailPackagePickerViewModel
    @State var package: DetailPackage
    @State var isSUV: Bool
    
    init(menu: DetailMenuObject? = nil, selectedPackage: Binding<DetailPackage?>) {
        self.menu = menu
        self._package = State(initialValue: selectedPackage.wrappedValue ?? .fullDetailPackage)
        self._isSUV = State(initialValue: selectedPackage.wrappedValue?.isSUV ?? false)
        self.viewModel = DetailPackagePickerViewModel(selectedPackage: selectedPackage)
    }
    
    var priceList: [String] {
        var list = [String]()
        for package in menu?.detailPackages ?? [] {
            package.nameAndPriceString.map({ list.append($0) })
        }
        
        return list.isEmpty == false ? list : DetailPackage.defaultPriceStrings
    }

    var body: some View {
        VStack {
            Menu {
                Picker("Package", selection: $package) {
                    ForEach(menu?.detailPackages ?? [.fullDetailPackage, .otherDetailPackage], id: \.self) { package in
                        Text((package.nameAndPriceString) ?? "")
                    }
                }
                .onChange(of: package) { package in
                    viewModel.selectedPackage = package
                }
            } label: {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Package").foregroundColor(Color(white: 0.4))
                            .foregroundColor(Color(UIColor.placeholderText))
                        Text(viewModel.selectedPackage?.nameAndPriceString ?? "")
                            .foregroundColor(.white)
                            .font(.title2)
                    }
                    Spacer()
                    Image(systemName: "chevron.up.chevron.down")
                        .foregroundColor(.white)
                        .font(.title3)
                        .padding(.trailing, 8)
                }
            }
            
            
            ContainerView {
                if package == .fullDetailPackage {
                    HStack {
                        Image(systemName: isSUV == true ? "checkmark.square.fill" : "square")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(isSUV == true ? .red : .gray)
                            .font(.system(size: 20, weight: .bold, design: .default))
                        
                        Text("SUV/Truck")
                            .foregroundColor(.white)
                            .font(.title3)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                        
                        Spacer()
                    }
                    .onTapGesture {
                        isSUV.toggle()
                        viewModel.selectedPackage?.isSUV = isSUV
                    }
                }
            }
            .padding(.vertical, 4)
        }
        .padding(8)
        .overlay(content: {
            RoundedRectangle(cornerRadius: 8)
                .stroke(.red, lineWidth: 1)
        })
        .preferredColorScheme(.dark)
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
