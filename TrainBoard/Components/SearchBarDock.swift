//
//  SearchBarDock.swift
//  TrainBoard
//
//  Created by Rachit Sharma on 15/04/2026.
//

import SwiftUI

struct SearchBarDock: View {
    @Binding var searchText: String
    @Binding var shouldDismissKeyboard:Bool
    var onSearch: () -> Void
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.white.opacity(0.75))

            TextField("e.g. London Bridge or LBG", text: $searchText)
                .focused($isFocused)
                .foregroundStyle(.white)
                .textInputAutocapitalization(.characters)
                .disableAutocorrection(true)
                .submitLabel(.search)
                .onSubmit(onSearch)

            Button {
                onSearch()
                self.isFocused = false
            } label: {
                Image(systemName: "arrow.right")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.black)
                    .frame(width: 40, height: 40)
                    .background(.white)
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
            .onChange(of: shouldDismissKeyboard) { oldValue, newValue in
                if newValue{
                    isFocused = false
                    shouldDismissKeyboard = false
                }
            }
        }
        .padding(12)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        }
    }
}
