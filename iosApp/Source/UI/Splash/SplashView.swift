//
//  SplashView.swift
//  iosApp
//
//  Created by Чаусов Николай on 08.06.2023.
//  Copyright © 2023 MobileUp. All rights reserved.
//

import SwiftUI

struct SplashView: View {
    private enum Constants {
        static let logoTitle = "Pokemons"
        static let logoFontSize: CGFloat = 36
        static let opacityMax: CGFloat = 1
        static let pathMax = 1.0
        static let paintAnimationDuration = 2.5
        static let fadeAnimationDuration = 0.7
        static let fadeSleepDuration: UInt64 = 700_000_000
        static let paintAnimationSleepDuration: UInt64 = 2_700_000_000
    }
    
    let onAnimationFinished: Closure.Void
    
    @State private var pathProgress: Double = .zero
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                Spacer()
                Spacer()
                
                PokemonLogoView(progress: $pathProgress)
                    .aspectRatio(.one, contentMode: .fit)
                    .padding(.leading, 10)
                    .overlay(alignment: .bottomLeading) {
                        MobileUpLogoView(pathProgress: $pathProgress)
                            .padding(.leading, 40)
                    }
                
                HStack {
                    Text(Constants.logoTitle)
                        .font(.system(size: Constants.logoFontSize, weight: .bold))
                        .foregroundColor(.blue)
                 
                    Spacer()
                }
                
                Spacer()
            }
            .padding(.horizontal, 60)
        }
        .onAppear {
            Task {
                withAnimation(.linear(duration: Constants.paintAnimationDuration)) {
                    pathProgress = Constants.pathMax
                }
                
                await dismissWithFade()
            }
        }
    }

    private func dismissWithFade() async {
        try? await Task.sleep(nanoseconds: Constants.paintAnimationSleepDuration)
        
        DispatchQueue.main.async {
            onAnimationFinished()
        }
    }
}

private struct PokemonLogoView: View {
    private enum Constants {
        static let defaultLineWidth: CGFloat = 20
    }
    
    var lineWidth = Constants.defaultLineWidth
    
    @Binding var progress: Double
    
    var body: some View {
        PokemonLogoShape()
            .trim(from: .zero, to: progress)
            .stroke(Color.blue, lineWidth: Constants.defaultLineWidth)
    }
    
    private struct PokemonLogoShape: Shape {
        func path(in rect: CGRect) -> Path {
            Path { path in
                path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
                path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
                
                path.addCurve(
                    to: CGPoint(x: rect.minX, y: rect.midY),
                    control1: CGPoint(x: rect.maxX / 2, y: rect.minY),
                    control2: CGPoint(x: rect.maxX / 2, y: rect.midY)
                )
            }
        }
    }
}

private struct MobileUpLogoView: View {
    private enum Constants {
        static let mediumCircleWidthMultiplier: CGFloat = 5
        static let largeCircleWidthMultiplier: CGFloat = 10
        static let degreesRotateUp: CGFloat = -90
        static let degreesRotateDown: CGFloat = 90
        static let degreesRotateLeft: CGFloat = 180
        static let defaultLineWidth: CGFloat = 5
    }
    
    @Binding var pathProgress: Double
    
    var body: some View {
        ZStack {
            Circle()
                .trim(from: .zero, to: pathProgress)
                .stroke(Color.blue, lineWidth: Constants.defaultLineWidth)
                .frame(width: Constants.defaultLineWidth, height: Constants.defaultLineWidth)
                .rotationEffect(.degrees(Constants.degreesRotateLeft))
            
            Circle()
                .trim(from: .zero, to: pathProgress)
                .stroke(Color.blue, lineWidth: Constants.defaultLineWidth)
                .frame(
                    width: (Constants.defaultLineWidth * Constants.mediumCircleWidthMultiplier),
                    height: (Constants.defaultLineWidth * Constants.mediumCircleWidthMultiplier)
                )
                .rotationEffect(.degrees(Constants.degreesRotateUp))
            
            Circle()
                .trim(from: .zero, to: pathProgress)
                .stroke(Color.blue, lineWidth: Constants.defaultLineWidth)
                .frame(
                    width: (Constants.defaultLineWidth * Constants.largeCircleWidthMultiplier),
                    height: (Constants.defaultLineWidth * Constants.largeCircleWidthMultiplier)
                )
                .rotationEffect(.degrees(Constants.degreesRotateDown))
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView(onAnimationFinished: {})
    }
}
