//
//  DetailPackageView.swift
//  APDetailing
//
//  Created by Dave Piernick on 10/18/22.
//

import Foundation
import SwiftUI

struct DetailPackageView: View {
    
    var package: DetailPackage
    var basicServices: BasicServices
    
    var body: some View {
        ZStack {
            Color(.black)
            VStack(alignment: .leading) {
                Text(package.nameAndPriceString ?? "")
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
                        ForEach(basicServices.exteriorServices ?? [], id: \.self) { service in
                            HStack(alignment: .firstTextBaseline) {
                                Text("- ")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                
                                Text("\(service)")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20, weight: .medium))
                            }
                        }
                        .padding(.vertical, 1)
                        
                        ForEach(package.exteriorServices ?? [], id: \.self) { service in
                            HStack(alignment: .firstTextBaseline) {
                                Text("- ")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                
                                Text("\(service)")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20, weight: .heavy))
                                    .italic()
                            }
                        }
                        .padding(.vertical, 1)
                        
                        Text("INTERIOR")
                            .foregroundColor(.red)
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                            .padding(.vertical, 2)
                        
                        ForEach(basicServices.interiorServices ?? [], id: \.self) { service in
                            HStack(alignment: .firstTextBaseline) {
                                Text("- ")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                
                                Text("\(service)")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20, weight: .medium))
                            }
                        }
                        .padding(.vertical, 1)

                        ForEach(package.interiorServices ?? [], id: \.self) { service in
                            HStack(alignment: .firstTextBaseline) {
                                Text("- ")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                
                                Text("\(service)")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20, weight: .heavy))
                                    .italic()
                            }
                        }
                        .padding(.vertical, 1)
                                                
                        Text("Note: Pricing may vary based on vehicle condition.")
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .italic()
                            .padding(.top, 40)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        Spacer()
                    }
                }
            }
            .padding()
        }
    }
}


struct MenuItemView_Previews: PreviewProvider {
    static var previews: some View {
        DetailPackageView(package: DetailPackage.inOutDetailPackage, basicServices: BasicServices(exteriorServices: ["test 1"], interiorServices: ["test 2"]))
    }
}
