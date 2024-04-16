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
                
                if package.price2.isNotNil(), let price = package.price, let price2 = package.price2 {
                    HStack(spacing: 10) {
                        Text(package.name?.uppercased() ?? "")
                            .font(.system(size: 40, weight: .heavy, design: .default))
                        VStack(alignment: .leading) {
                            Text("CAR/CROSSOVER - $\(price)")
                            Text("SUV/TRUCK - $\(price2)")
                        }
                        .font(.system(size: 18, weight: .heavy, design: .default))
                    }
                    .foregroundColor(.white)
                    .padding(.bottom, 2)
                } else {
                    Text(package.nameAndPriceString?.uppercased() ?? "")
                        .foregroundColor(.white)
                        .font(.system(size: 36, weight: .heavy, design: .default))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 2)
                }
                
                

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
        DetailPackageView(package: DetailPackage.fullDetailPackage, basicServices: BasicServices(exteriorServices: ["test 1"], interiorServices: ["test 2"]))
    }
}
