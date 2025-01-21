//
//  HomeScreen.swift
//  TabBarSUI
//
//  Created by Kirill Khomicevich on 21.01.2025.
//

import SwiftUI

struct HomeScreen: View {
    @State private var indexTab: Int = 0
    @State private var curvePos: CGFloat = 0

    private var bottomSafeArea: CGFloat {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
            return keyWindow.safeAreaInsets.bottom
        }
        return 0
    }

    private var tabBarHeight: CGFloat {
        let defaultTabBarHeight: CGFloat = 49
        return defaultTabBarHeight + bottomSafeArea
    }

    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            Color(.orange.withProminence(.secondary))
            
            HStack {
                madeTab(imageName: "home", indexTabSelect: 0)
                madeTab(imageName: "search", indexTabSelect: 1)
                madeTab(imageName: "world", indexTabSelect: 2)
                madeTab(imageName: "menu", indexTabSelect: 3)
            }
            .padding(.horizontal, 25)
            .padding(.bottom, bottomSafeArea)
            .frame(height: tabBarHeight)
            .background(Color.white.clipShape(CShape(curvePos: curvePos)))
        }
        .ignoresSafeArea()
    }

    @ViewBuilder
    func madeTab(imageName: String, indexTabSelect: Int) -> some View {
        GeometryReader { geometry in
            VStack {
                Button {
                    withAnimation(.spring()) {
                        indexTab = indexTabSelect
                        self.curvePos = geometry.frame(in: .global).midX
                    }
                } label: {
                    Image(imageName)
                        .renderingMode(.template)
                        .resizable()
                        .foregroundStyle(indexTab == indexTabSelect ? .black : .gray)
                        .frame(width: 24, height: 24)
                        .padding(15)
                        .background(
                            Color.white
                                .opacity(indexTab == indexTabSelect ? 1 : 0)
                                .clipShape(Circle())
                        )
                        .offset(y: indexTab == indexTabSelect ? -35 : 0)
                }
            }
            .frame(width: 43, height: 43)
            .onAppear {
                DispatchQueue.main.async {
                    self.curvePos = geometry.frame(in: .global).midX
                }
            }
        }
        .frame(width: 43, height: 43)

        if indexTabSelect != 3 {
            Spacer()
        }
    }
}

struct CShape: Shape {
    var curvePos: CGFloat

    var animatableData: CGFloat {
        get { return curvePos }
        set { curvePos = newValue }
    }

    func path(in rect: CGRect) -> Path {
        Path {
            $0.move(to: CGPoint(x: 0, y: 0))
            $0.addLine(to: CGPoint(x: 0, y: rect.height))
            $0.addLine(to: CGPoint(x: rect.width, y: rect.height))
            $0.addLine(to: CGPoint(x: rect.width, y: 0))

            $0.move(to: CGPoint(x: curvePos + 35, y: 0))
            $0.addQuadCurve(
                to: CGPoint(x: curvePos - 35, y: 0),
                control: CGPoint(x: curvePos, y: 48)
            )
        }
    }
}

#Preview {
    HomeScreen()
}
