//
//  DetailPackageView.swift
//  APDetailing
//
//  Created by Dave Piernick on 10/18/22.
//

import Foundation
import SwiftUI

struct DetailPackageView: View {
    
    var item: DetailPackage
    
    var body: some View {
        ZStack {
            Color(.black)
            VStack(alignment: .leading) {
                Text("\(item.id) - $\(item.price)")
                    .foregroundColor(.white)
                    .font(.system(size: 36, weight: .heavy, design: .default))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 2)
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("EXTERIOR")
                            .foregroundColor(.red)
                            .font(.system(size: 30, weight: .medium, design: .rounded))
                            .padding(.bottom, 2)
                        ForEach(item.exteriorServices, id: \.self) { service in
                            HStack(alignment: .firstTextBaseline) {
                                Text("- ")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                
                                let boldItalic = MockDetailPackages.basicExterior.contains(service)
                                if boldItalic {
                                    Text("\(service.rawValue)")
                                        .foregroundColor(.white)
                                        .font(.system(size: 20, weight: .medium))
                                } else {
                                    Text("\(service.rawValue)")
                                        .foregroundColor(.white)
                                        .font(.system(size: 20, weight: .heavy))
                                        .italic()
                                }
                            }

                        }
                        .padding(.vertical, 1)
                        Text("INTERIOR")
                            .foregroundColor(.red)
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                            .padding(.vertical, 2)
                        ForEach(item.interiorServices, id: \.self) { service in
                            HStack(alignment: .firstTextBaseline) {
                                Text("- ")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                let boldItalic = MockDetailPackages.basicInterior.contains(service)
                                if boldItalic {
                                    Text("\(service.rawValue)")
                                        .foregroundColor(.white)
                                        .font(.system(size: 20, weight: .medium, design: .rounded))
                                } else {
                                    Text("\(service.rawValue)")
                                        .foregroundColor(.white)
                                        .font(.system(size: 20, weight: .heavy))
                                        .italic()
                                }
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
        DetailPackageView(item: MockDetailPackages.exclusive)
    }
}
