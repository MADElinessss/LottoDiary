//
//  OneRandomNumberViewController.swift
//  LottoDiary
//
//  Created by Madeline on 3/20/24.
//

import SwiftUI
import UIKit

public struct OneRandomNumberView: View {
    
    @State private var basket: String = ""
    let coin1 = ["🏆", "💳", "🍔", "🐰", "🐖", "☃️","🍀"]
    let coin2 = ["🐲", "💛", "🐹", "🦄", "🌞", "🌧️","🍀"]
    let coin3 = ["🐖", "🐔", "🦁", "🐳", "🌝", "☀️","🍀"]
    let coin4 = ["🥟", "🐶", "🐯", "🎄", "🌸", "🍎","🍀"]
    
    public init() {}
    
    public var body: some View {
        VStack {
            Text("번호 1개를 추천해드릴게요.\n소원을 빌고, 롱탭해서 원하는 것을 드래그해서 넣어보세요.")
                .fontWeight(.medium)
                .font(.system(size: 16))
                .padding(.top, 24)
                .padding(.bottom, 50)
            
            if let drawNumber = Int(basket) {
                Text(basket)
                    .font(.largeTitle)
                    .frame(width: 60, height: 60)
                    .background(Circle().fill(color(for: drawNumber)))
                    .foregroundColor(.white)
            } else {
                Text(basket)
                    .font(.largeTitle)
            }
            
            Spacer()
            
            ZStack {
                Circle()
                    .frame(width: 150, height: 150)
                    .opacity(0.3)
                    .foregroundColor(Color.green)
                    .onDrop(of: [.text], delegate: FoodDropDelegate(basket: $basket))
                
                EmojiButtonView(emoji: coin1.randomElement() ?? "🍀", basket: $basket)
                    .offset(x: 0, y: -100) // Top
                EmojiButtonView(emoji: coin2.randomElement() ?? "🍀", basket: $basket)
                    .offset(x: 100, y: 0) // Right
                EmojiButtonView(emoji: coin3.randomElement() ?? "🍀", basket: $basket)
                    .offset(x: 0, y: 100) // Bottom
                EmojiButtonView(emoji: coin4.randomElement() ?? "🍀", basket: $basket)
                    .offset(x: -100, y: 0) // Left
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .animation(.spring(), value: basket)
    }
    
    private func color(for drawNumber: Int) -> Color {
        switch drawNumber {
        case 1...10:
            return Color("lotteryYellow")
        case 11...20:
            return Color("lotteryBlue")
        case 21...30:
            return Color("lotteryRed")
        case 31...40:
            return Color("lotteryGray")
        case 41...45:
            return Color("lotteryGreen")
        default:
            return Color.gray
        }
    }
}

// 이모지 버튼 뷰
struct EmojiButtonView: View {
    
    let emoji: String
    @Binding var basket: String
    
    var body: some View {
        Text(emoji)
            .scaleEffect(2)
            .onDrag {
                NSItemProvider(object: emoji as NSString)
            }
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
