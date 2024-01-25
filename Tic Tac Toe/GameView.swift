//
//  ContentView.swift
//  Tic Tac Toe
//
//  Created by Roman Vasyltsov on 20.01.2024.
//

import SwiftUI

struct GameView: View {
    
    @StateObject private var viewModel = GameViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                
                LazyVGrid(columns: viewModel.columns) {
                    ForEach(0..<9) { i in
                        ZStack {
                            GameSquareView(proxy: geometry)
                            
                            PlayerIndicator(systemImageName: viewModel.moves[i]?.indicator ?? "")
                                
                        }
                        .onTapGesture {
                            viewModel.processPlayerMove(for: i)
                        }
                    }
                }
                .padding(2)
                
                Spacer()
            }
            .disabled(viewModel.isGameBoardDisabled)
            .alert(item: $viewModel.alertItem, content: { alertItem in
                Alert(title: alertItem.title,
                      message: alertItem.message,
                      dismissButton: .default(alertItem.buttonTitle, action: { viewModel.resetGame() }))
            })
        }
    }
    
    
    
}

enum Player {
    case human, computer
}

struct Move {
    let player: Player
    let boardIndex: Int
    
    var indicator: String {
        return player == .human ? "xmark" : "circle"
    }
}

#Preview {
    GameView()
}

struct GameSquareView: View {
    
    var proxy: GeometryProxy
    
    var body: some View {
        RoundedRectangle(cornerRadius: 30)
            .stroke(.black, lineWidth: 6)
            .fill(.white)
            .frame(width: proxy.size.width/3 - 10,
                   height: proxy.size.width/3 - 10)
            .padding(2)
    }
}

struct PlayerIndicator: View {
    
    var systemImageName: String
    var body: some View {
        Image(systemName: systemImageName)
            .resizable()
            .frame(width: 60, height: 60)
            .foregroundColor(.red)
    }
}
