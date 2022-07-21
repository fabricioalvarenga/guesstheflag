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
    @State private var score = 0
    @State private var messageToShowInAlert = ""
    @State private var times = 0
    @State private var countries = [
        (name: "Estonia", tapped: false, opaque: false),
        (name: "France", tapped: false, opaque: false),
        (name: "Germany", tapped: false, opaque: false),
        (name: "Ireland", tapped: false, opaque: false),
        (name: "Italy", tapped: false, opaque: false),
        (name: "Nigeria", tapped: false, opaque: false),
        (name: "Poland", tapped: false, opaque: false),
        (name: "Russia", tapped: false, opaque: false),
        (name: "Spain", tapped: false, opaque: false),
        (name: "UK", tapped: false, opaque: false),
        (name: "US", tapped: false, opaque: false),
    ]

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
                        Text(countries[correctAnswer].name)
                        
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            FlagImage(countrie: countries[number].name)
                        }
                        .opacity(countries[number].opaque ? 0.25: 1)
                        .scaleEffect(countries[number].opaque ? 0.5 : 1)
                        .animation(.default, value: countries[number].opaque)
                        .rotation3DEffect(Angle(degrees: countries[number].tapped ? 360 : 0), axis: (0, 1, 0))
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
            messageToShowInAlert = "That's the flag of \(countries[correctAnswer].name)."
            scoreTitle = "Wrong"
            score -= 1
        }
        
        withAnimation {
            // Toggle tapped property to true
            countries[number].tapped.toggle()

            // Change the opacity of the other two buttons
            for i in 0..<3 {
                if i != number {
                    countries[i].opaque = true
                }
            }
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
        restoreFlagsProperties()
        correctAnswer = Int.random(in: 0...2)
    }
    
    private func restoreFlagsProperties() {
        for i in 0..<countries.count {
            countries[i].tapped = false
            countries[i].opaque = false
        }
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
