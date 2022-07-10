//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by FABRICIO ALVARENGA on 29/06/22.
//

import SwiftUI

struct FlagImage: View {
    var countrie: String
    
    var body: some View {
        Image(countrie)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}

struct WhiteFontWithBoldTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.white)
    }
}

extension View {
    func whiteFontWithBoldTitle() -> some View {
        modifier(WhiteFontWithBoldTitle())
    }
}

struct ContentView: View {
    @State private var showingScore = false
    @State private var showingFinalAlert = false
    @State private var scoreTitle = ""
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var score = 0
    @State private var messageToShowInAlert = ""
    @State private var times = 0

    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                        
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            FlagImage(countrie: countries[number])
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .whiteFontWithBoldTitle()
//                    .foregroundColor(.white)
//                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text(messageToShowInAlert)
        }
        .alert("Game over", isPresented: $showingFinalAlert) {
            Button("OK", action: resetGame)
        } message: {
            Text("Your final score was \(score)")
        }
    }
    
    private func flagTapped(_ number: Int) {
        if number == correctAnswer {
            messageToShowInAlert = ""
            scoreTitle = "Correct"
            score += 1
        } else {
            messageToShowInAlert = "That's the flag of \(countries[correctAnswer])."
            scoreTitle = "Wrong"
            score -= 1
        }
        
        messageToShowInAlert += "\nYour score is \(score)"
        showingScore = true
        
        times += 1
        if times == 8 {
            showingFinalAlert = true
        } else {
            showingFinalAlert = false
        }

    }
    
    private func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    private func resetGame() {
        scoreTitle = ""
        score = 0
        messageToShowInAlert = ""
        times = 0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
