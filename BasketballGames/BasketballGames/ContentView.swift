//
//  ContentView.swift
//  BasketballGames
//
//  Created by Samuel Shi on 2/27/25.
//

import SwiftUI

struct Game: Codable {
    var isHomeGame: Bool
    var team: String
    var date: String
    var opponent: String
    var id: Int
    var score: Score
}

struct Score: Codable {
    var unc: Int
    var opponent: Int
}

struct ContentView: View {
    @State var games: [Game] = [Game]()
    var body: some View {
        NavigationView {
            List(games, id: \.id) { game in
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(game.team) vs \(game.opponent)")
                        
                        Text(game.date)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        Text(String("\(game.score.unc)  - \(game.score.opponent)"))
                        
                        Text(game.isHomeGame ? "Home" : "Away")
                            .foregroundStyle(.secondary)
                    }
                }
            }.task {
                await loadData()
            }
            .navigationTitle("UNC Basketball")
        }
    }
    
    func loadData() async {
        guard let url = URL(
            string: "https://api.samuelshi.com/uncbasketball"
        ) else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedGames = try? JSONDecoder().decode([Game].self, from: data) {
                games = decodedGames
            }
        } catch {
            print("Invalid data")
        }
    }
}

#Preview {
    ContentView()
}
