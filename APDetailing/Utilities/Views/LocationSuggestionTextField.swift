//
//  LocationSuggestionTextField.swift
//  APDetailing
//
//  Created by Dave Piernick on 2/22/23.
//

import SwiftUI

struct LocationSuggestionTextField: View {
    @ObservedObject var viewModel: RequestUpdateApptViewModel
    @FocusState var isFocused: Bool
    
    init(viewModel: RequestUpdateApptViewModel, isFocused: Bool) {
        self.viewModel = viewModel
        self.isFocused = isFocused
    }
    
    var suggestionOverlay: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(viewModel.suggestions, id: \.self) { suggestion in
                Button {
                    viewModel.selectSuggestion(suggestion)
                    isFocused = false
                } label: {
                    Text(suggestion)
                        .foregroundColor(.white)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .alignmentGuide(.bottom) { d in d[.top] }
        .background {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(.red, lineWidth: 1)
                .background(Color(white: 0.1))
        }
    }
    
    var body: some View {
        CustomTextField("Location", text: $viewModel.location)
            .zIndex(1)
            .alignmentGuide(.top, computeValue: { v in v[.bottom] })
            .focused($isFocused)
            .onChange(of: viewModel.appt.location ?? "") { newValue in
                viewModel.getLocationSuggestions(query: newValue)
            }
            .overlay(alignment: .top) {
                if viewModel.suggestions.isEmpty == false {
                    suggestionOverlay
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UITextField.textDidBeginEditingNotification)) { obj in
                if let textField = obj.object as? UITextField {
                    textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
                }
            }
    }
}

struct LocationSuggestionTextField_Previews: PreviewProvider {
    static var previews: some View {
        LocationSuggestionTextField(viewModel: RequestUpdateApptViewModel(appt: nil, completion: { _ in }), isFocused: true)
    }
}
