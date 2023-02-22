//
//  AppointmentCellView.swift
//  APDetailing
//
//  Created by Dave Piernick on 2/11/23.
//

import SwiftUI

struct AppointmentCellView: View {
    var appt: Appointment
    
    var body: some View {
        HStack(alignment: .top) {
            VStack {
                Text(appt.date!.monthAbbv)
                Text(appt.date!.dayOfMonth).font(.title)
                Text(appt.date!.year)
            }
            .padding()
            
            VStack(alignment: .leading) {
                HStack {
                    Text(appt.statusString).foregroundColor(appt.statusStringColor)
                    Text("- \(appt.timeOfDay!)")
                }
                Text("\(appt.package!.id) - $\(appt.package!.price)")
                    .font(.title)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                Text(appt.location!)
            }
            .padding()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(Color.red, lineWidth: 1)
        }
    }
}

struct AppointmentStatusView_Previews: PreviewProvider {
    static var previews: some View {
            AppointmentCellView(appt: MockAppointments.appt1)
    }
}
