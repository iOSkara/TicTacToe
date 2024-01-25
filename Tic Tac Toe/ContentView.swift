//
//  ContentView.swift
//  Tic Tac Toe
//
//  Created by Roman Vasyltsov on 20.01.2024.
//

import SwiftUI

struct ContentView: View {
    
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    
    @State private var moves: [Move?] = Array(repeating: nil, count: 9)
    @State private var isGameBoardDisabled = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                
                LazyVGrid(columns: columns) {
                    ForEach(0..<9) { i in
                        ZStack {
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(.black, lineWidth: 6)
                                .fill(.white)
                                .frame(width: geometry.size.width/3 - 10,
                                       height: geometry.size.width/3 - 10)
                                .padding(2)
                            
                            Image(systemName: moves[i]?.indicator ?? "")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .foregroundColor(.red)
                                
                        }
                        .onTapGesture {
                            if isSquareOccupied(in: moves, forIndex: i) { return }
                            moves[i] = Move(player: .human, boardIndex: i)
                            isGameBoardDisabled = true
                            
                            if checkWinCondition(for: .human, in: moves) {
                                print("Human Wins")
                                return
                            }
                            
                            if checkForDraw(in: moves) {
                                print("Draw")
                                return
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                let computerPosition = determineComputerMovePosition(in: moves)
                                moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
                                isGameBoardDisabled = false
                                
                                if checkWinCondition(for: .computer, in: moves) {
                                    print("Computer Wins")
                                    return
                                }
                                
                                if checkForDraw(in: moves) {
                                    print("Draw")
                                    return
                                }
                            }
                        }
                    }
                }
                .padding(2)
                
                Spacer()
            }
            .disabled(isGameBoardDisabled)
        }
    }
    
    func isSquareOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
        return moves.contains(where: { $0?.boardIndex == index })
    }
    
    func determineComputerMovePosition(in moves: [Move?]) -> Int {
        var movePosition = Int.random(in: 0..<9)
        
        while isSquareOccupied(in: moves, forIndex: movePosition) {
            movePosition = Int.random(in: 0..<9)
        }
        
        return movePosition
    }
    
    func checkWinCondition(for player: Player, in moves: [Move?]) -> Bool {
    let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
        let playerMoves = moves.compactMap { $0 }.filter { $0.player == player }
        let playerPositions = Set(playerMoves.map { $0.boardIndex })
        for pattern in winPatterns where pattern.isSubset(of: playerPositions) { return true }
        
        return false
    }
    
    func checkForDraw(in moves: [Move?]) -> Bool {
        return moves.compactMap { $0 }.count == 9
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
    ContentView()
}
