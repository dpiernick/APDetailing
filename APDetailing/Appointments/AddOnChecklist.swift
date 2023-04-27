//
//  AddOnChecklist.swift
//  APDetailing
//
//  Created by Dave Piernick on 4/26/23.
//

import SwiftUI

struct AddOnChecklist: View {
    @StateObject var viewModel: AddOnChecklistViewModel
    @Binding var selectedAddOns: [AddOn]
    @State var isExpanded: Bool = false
    
    init(selectedAddOns: Binding<[AddOn]>) {
        _selectedAddOns = selectedAddOns
        _viewModel = StateObject(wrappedValue: AddOnChecklistViewModel(selectedAddOns: selectedAddOns.wrappedValue))
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Add Ons")
                        .foregroundColor(Color(UIColor.placeholderText))
                        .padding(.bottom, 4)
                    
                    if selectedAddOns.count > 0 {
                        Text("\(selectedAddOns.count) Selected - $\(viewModel.selectedAddOns.compactMap({ $0.price ?? 0 }).reduce(0, +))")
                            .font(.title2)
                    }
                }
                
                
                Spacer()
                
                Image(systemName: "chevron.up")
                    .font(.title3)
                    .bold()
                    .rotationEffect(isExpanded ? .init(degrees: 180) : .zero, anchor: .center)
                    .padding(.trailing)
                    .onTapGesture {
                        withAnimation {
                            isExpanded.toggle()
                        }
                    }
            }
            
            if isExpanded {
                ForEach(viewModel.allAddOns ?? [], id: \.self) { addOn in
                    HStack {
                        Image(systemName: selectedAddOns.contains(addOn) ? "checkmark.square.fill" : "square")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(selectedAddOns.contains(addOn) ? .red : .gray)
                            .font(.system(size: 20, weight: .bold, design: .default))
                        
                        Text(addOn.nameAndPriceString ?? "")
                            .foregroundColor(.white)
                            .font(.title3)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                        
                        Spacer()
                    }
                    .padding(.vertical, 6)
                    .onTapGesture {
                        selectedAddOns = viewModel.toggleSelectedAddOn(addOn)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
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

@MainActor class AddOnChecklistViewModel: ObservableObject {
    var allAddOns = DetailMenu.shared.addOns ?? [AddOn(name: "test", price: 123), AddOn(name: "asdfasdf", price: 654), AddOn(name: "asdfasdf", price: 654)]
    var selectedAddOns: [AddOn]
    
    init(selectedAddOns: [AddOn]) {
        self.selectedAddOns = selectedAddOns
    }
    
    func addOnIsSelected(_ addOn: AddOn) -> Bool {
        selectedAddOns.contains(addOn)
    }
    
    func toggleSelectedAddOn(_ addOn: AddOn) -> [AddOn] {
        if selectedAddOns.contains(addOn) == true {
            selectedAddOns = selectedAddOns.filter({ $0 != addOn })
        } else {
            selectedAddOns.append(addOn)
        }
        return selectedAddOns
    }
}

struct AddOnChecklist_Previews: PreviewProvider {
    // we show the simulated view, not the BoolButtonView itself
    static var previews: some View {
        OtherView()
            .preferredColorScheme(.dark)
    }
    
    // nested OTHER VIEW providing the one value for binding makes the trick
    struct OtherView : View {
        @State var addOns = [AddOn(name: "test", price: 123), AddOn(name: "asdfasdf", price: 654), AddOn(name: "asdfasdf", price: 654)]
        var body: some View {
            AddOnChecklist(selectedAddOns: $addOns)
        }
    }
    
    
}
