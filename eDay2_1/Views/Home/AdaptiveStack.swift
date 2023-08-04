//
//  AdaptiveStack.swift
//  eDay2_1
//
//  Created by 杨东举 on 2023/8/4.
//

import SwiftUI

struct AdaptiveStack<Content: View>: View {
    let content: Content
    var horizontalAlignment: HorizontalAlignment = .center
    var verticalAlignment: VerticalAlignment = .center
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    init(
        horizontalAlignment: HorizontalAlignment = .center,
        verticalAlignment: VerticalAlignment = .center,
        @ViewBuilder content: () -> Content
    ) {
        self.horizontalAlignment = horizontalAlignment
        self.verticalAlignment = verticalAlignment
        self.content = content()
    }

    var body: some View {
        Group {
            if horizontalSizeClass == .compact {
                VStack(alignment: horizontalAlignment, content: { self.content })
            } else {
                HStack(alignment: verticalAlignment, content: { self.content })
            }
        }
    }
}

