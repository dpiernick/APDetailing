//
//  AddOnsView.swift
//  APDetailing
//
//  Created by Dave Piernick on 5/5/23.
//

import SwiftUI

struct AddOnsView: View {
    var addOns: [AddOn]
    
    var body: some View {
        ZStack {
            Color(.black)
            VStack(alignment: .leading) {
                Text("INDIVIDUAL")
                    .foregroundColor(.white)
                    .font(.system(size: 36, weight: .heavy, design: .default))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 2)
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("EXTERIOR")
                            .foregroundColor(.red)
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                            .padding(.bottom, 2)
                        ForEach(addOns.filter({ $0.type == .exterior }), id: \.self) { addOn in
                            HStack(alignment: .firstTextBaseline) {
                                Text("- ")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                
                                Text(addOn.nameAndPriceString ?? "")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                            }
                        }
                        .padding(.vertical, 1)
                        
                        Text("INTERIOR")
                            .foregroundColor(.red)
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                            .padding(.vertical, 2)
                        
                        ForEach(addOns.filter({ $0.type == .interior }), id: \.self) { addOn in
                            HStack(alignment: .firstTextBaseline) {
                                Text("- ")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                
                                Text(addOn.nameAndPriceString ?? "")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                            }
                        }
                        .padding(.vertical, 1)
                        
                        Spacer()
                        
                        Text("Note: Pricing may vary based on vehicle condition.")
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .italic()
                            .padding(.top, 40)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                    }
                }
            }
            .padding()
        }
    }
}

struct AddOnsView_Previews: PreviewProvider {
    static var previews: some View {
        AddOnsView(addOns: [AddOn(name: "Test Add On", price: 125, type: .exterior), AddOn(name: "Test 2", price: 50, type: .interior)])
    }
}
