//
//  WebHelper.swift
//  APDetailing
//
//  Created by Dave Piernick on 2/28/23.
//

import Foundation

class WebHelper {
    static var instagramUsername = "ap_mobile_detailing"
    static var instagramDeepLink = URL(string: "instagram://user?username=\(instagramUsername)")!
    static var instagramWebLink = URL(string: "https://instagram.com/\(instagramUsername)")!
    
    static var facebookUsername = "APDetailingMobile"
    static var facebookDeepLink = URL(string: "facebook-profiles://profile/\(facebookUsername)")!
    static var facebookWebLink = URL(string: "https://facebook.com/\(facebookUsername)")!
}
