//
//  ConfettiContainerView.swift
//  Language Learning App
//
//  Created by William Pendleton on 10/25/24.
//

import SwiftUI

struct ConfettiContainerView: View {
    var count: Int = 50
    @State var yPosition: CGFloat = 0
    @State var shouldEmit: Bool = true

    var body: some View {
        ZStack {
            ForEach(0..<count, id: \.self) { _ in
                ConfettiView()
                    .position(
                        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: yPosition != 0 ? CGFloat.random(in: 0...UIScreen.main.bounds.height) : yPosition
                    )
            }
        }
        .ignoresSafeArea()
        .onAppear {
            yPosition = CGFloat.random(in: 0...UIScreen.main.bounds.height)
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
}

#Preview {
    ConfettiContainerView()
}
