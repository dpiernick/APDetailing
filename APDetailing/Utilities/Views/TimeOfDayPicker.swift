//
//  TimeOfDayPicker.swift
//  APDetailing
//
//  Created by Dave Piernick on 5/1/23.
//

import SwiftUI

struct TimeOfDayPicker: View {
    @Binding var timeOfDay: TimeOfDay?
    
    init(timeOfDay: Binding<TimeOfDay?>) {
        self._timeOfDay = timeOfDay
    }
    
    var body: some View {
        HStack {
            RoundedButton(title: "Morning", type: timeOfDay == .morning ? .primary : .secondary) {
                timeOfDay = .morning
            }
            
            RoundedButton(title: "Afternoon", type: timeOfDay == .afternoon ? .primary : .secondary) {
                timeOfDay = .afternoon
            }
        }
    }
}

//struct TimeOfDayPicker_Previews: PreviewProvider {
//    static var previews: some View {
//        TimeOfDayPicker(viewModel: <#RequestUpdateApptViewModel#>)
//    }
//}
