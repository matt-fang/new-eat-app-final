//
//  CardView.swift
//  new-eat-app
//
//  Created by Matthew Fang on 2/6/25.
//

import SwiftUI

struct CardView: View {
    var content: String
    var isSelected: Bool
    
    var body: some View {
        ZStack (alignment: .leading) {
            RoundedRectangle(cornerRadius: 30)
                .foregroundStyle(isSelected ? Color.whiteYellow : Color.lightYellow)
                VStack(alignment: .leading, spacing: 2) {
                    Text(content)
                        .font(.body)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(.black)
                }
                .padding(.horizontal)

        }.frame(minHeight: 64)
    }
}
