//
//  OneRandomNumberViewController.swift
//  LottoDiary
//
//  Created by Madeline on 3/20/24.
//

import SwiftUI
import UIKit

//class OneRandomNumberViewController: UIViewController {
//    let swiftUIView = OneRandomNumberView()
//    let hostingView = UIHostingController(rootView: swiftUIView)
//    func window.rootViewController = UINavigationController(rootViewController: hostingView)
//}

public struct OneRandomNumberView: View {
    
    @State private var basket: String = ""
    let coin = ["🪙", "💳", "🍔", "🐰", "🐖", "🐲","🍀"]
    
    public init() {}
    public var body: some View {
        VStack {
            Text("소원을 빌고, 원하는 것을 드래그해서 넣어보세요.")
                .fontWeight(.medium)
                .font(.system(size: 14))
                .padding(.bottom, 10)
            Spacer()
            Text(basket)
                .font(.largeTitle)
                .frame(maxWidth: 300)
            HStack {
                VStack(spacing: 10) {
                    ZStack {
                        Color.clear // Invisible layer to increase the draggable area
                        Text(coin.randomElement() ?? "🍀")
                            .scaleEffect(2)
                    }
                    .frame(width: 200, height: 200) // Increased frame size for easier dragging
                    .onDrag { NSItemProvider(object: String(self.coin.randomElement() ?? "🍀") as NSString) }
                    .onLongPressGesture(minimumDuration: 0.5) {
                        // Trigger the weakest haptic feedback on long press
                        let generator = UIImpactFeedbackGenerator(style: .light)
                        generator.impactOccurred()
                    }
                }
                VStack(spacing: 10) {
                    Circle()
                        .frame(width: 150, height: 150)
                        .opacity(0.3)
                        .frame(width: 200, height: 200)
                        .onDrop(of: [.text], delegate: FoodDropDelegate(basket: $basket))
                }
            }
            .animation(.spring(), value: basket)
        }
        .frame(maxWidth: 400, maxHeight: 400)
    }
}

fileprivate
struct FoodDropDelegate: DropDelegate {
    
    @Binding var basket: String
    
    func performDrop(info: DropInfo) -> Bool {
        let number = Int.random(in: 1...45)
        self.basket = "\(number)"
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        
        return true
    }
}
