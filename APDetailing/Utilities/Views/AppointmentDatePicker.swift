//
//  AppointmentDatePicker.swift
//  APDetailing
//
//  Created by Dave Piernick on 4/9/24.
//

import SwiftUI
import Combine

enum QuarterHour: Int, CaseIterable {
    case onTheHour = 0
    case fifteen = 15
    case thirty = 30
    case fortyFive = 45
    
    var stringValue: String {
        switch self {
        case .onTheHour: "00"
        case .fifteen: "15"
        case .thirty: "30"
        case .fortyFive: "45"
        }
    }
}

enum AmPm: String, CaseIterable { case am = "AM", pm = "PM" }

struct TimeOfDay: Equatable {
    var hour: Int
    var minute: QuarterHour
    var amPm: AmPm
    
    static var hoursOfDay = [1,2,3,4,5,6,7,8,9,10,11,12]
}

class AppointmentDatePickerViewModel: ObservableObject {
    @Binding var date: Date
    
    init(date: Binding<Date>) {
        self._date = date
    }
    
    func setDay(day: Date) {
        self.date = day.setTime(timeOfDay: date.timeOfDay() ?? TimeOfDay(hour: 9, minute: .onTheHour, amPm: .am))
    }
    
    func setTime(timeOfDay: TimeOfDay) {
        self.date = date.setTime(timeOfDay: timeOfDay)
    }
}

struct AppointmentDatePicker: View {
    
    @ObservedObject var viewModel: AppointmentDatePickerViewModel
    
    @State var day: Date
    @State var time: TimeOfDay
    @State var isEditingTime: Bool = false
    @State var isEditingDate: Bool = false
        
    init(date: Binding<Date>) {
        self.viewModel = AppointmentDatePickerViewModel(date: date)
        self._day = State(initialValue: date.wrappedValue)
        self._time = State(initialValue: date.wrappedValue.timeOfDay() ?? TimeOfDay(hour: 9, minute: .onTheHour, amPm: .am))
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Date")
                    .foregroundColor(Color(white: 0.4))
                
                Spacer()
                
                Text(viewModel.date.dateString())
                    .onTapGesture {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        withAnimation {
                            if isEditingTime {
                                isEditingTime.toggle()
                            }
                            isEditingDate.toggle()
                        }
                    }
                    .padding(6)
                    .background {
                        RoundedRectangle(cornerRadius: 4).foregroundColor(Color(white: 0.2))
                    }
                    .padding(.trailing, 4)
                
                Text(viewModel.date.timeString)
                    .onTapGesture {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        withAnimation {
                            if isEditingDate {
                                isEditingDate.toggle()
                            }
                            isEditingTime.toggle()
                        }
                    }
                    .padding(6)
                    .background {
                        RoundedRectangle(cornerRadius: 4).fill(Color(white: 0.2))
                    }
                    .padding(.trailing, 4)
            }
            .frame(maxWidth: .infinity)
            
            if isEditingTime {
                HStack {
                    Picker("", selection: $time.hour) {
                        ForEach(TimeOfDay.hoursOfDay, id: \.self) {
                            Text(String($0)).tag(TimeOfDay.hoursOfDay.firstIndex(of: time.hour))
                        }
                    }
                    
                    Picker("", selection: $time.minute) {
                        ForEach(QuarterHour.allCases, id: \.self) {
                            Text($0.stringValue).tag(QuarterHour.allCases.firstIndex(of: time.minute))
                        }
                    }
                    
                    Picker("", selection: $time.amPm) {
                        ForEach(AmPm.allCases, id: \.self) {
                            Text($0.rawValue).tag(AmPm.allCases.firstIndex(of: time.amPm))
                        }
                    }
                }
                .pickerStyle(.wheel)
                .onChange(of: time) { time in
                    viewModel.setTime(timeOfDay: time)
                }
            }
            
            if isEditingDate {
                DatePicker("Appointment Date",
                           selection: $day,
                           in: Calendar.current.startOfDay(for: Date() + .day)...Date.distantFuture,
                           displayedComponents: [.date])
                    .datePickerStyle(.graphical)
                    .onChange(of: day) { day in
                        viewModel.setDay(day: day)
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
    }
}

//#Preview {
//    AppointmentDatePicker("Titlw", time: (hour: 11, minute: 30, amPm: .pm), date: Date())
//}
