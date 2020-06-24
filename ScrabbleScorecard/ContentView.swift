//
//  ContentView.swift
//  ScrabbleScorecard
//
//  Created by Steven Chen on 2020-06-03.
//  Copyright © 2020 Steven Chen. All rights reserved.
//

import SwiftUI
import Introspect

struct ContentView: View {
    @State var word: String = ""
    
    @State var multiplier = 0
    
    @State var p1words: [Word] = []
    @State var p2words: [Word] = []
    
    @State var p1name: String = "Player 1"
    @State var p2name: String = "Player 2"
    
    @State var idCounter: Int = 0
    
    @State var isNewGamePresented: Bool = false
    
    @State var p1newName: String = "Player 1"
    @State var p2newName: String = "Player 2"
    
    private let textFieldObserver = TextFieldObserver()
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack{
                    Button(action: {
                        UIApplication.shared.endEditing()
                    })
                    {
                        Image(systemName: "arrow.left")
                        Text("Back")
                    }
                    .padding(.top, 40)
                    Spacer()
                    Button(action: {
                        UIApplication.shared.endEditing()
                        withAnimation {
                            self.isNewGamePresented.toggle()
                        }
                    })
                    {
                        Text("New Game")
                    }
                    .padding(.top, 40)
                    
                }
                .padding([.top, .leading, .trailing], 15)
                    .background(Color.white)//(red: 0.2, green: 0.2, blue: 0.2, opacity: 1.0))
                
                withAnimation{
                HStack {
                    RoundedRectangle(cornerRadius: 20.0)
                        .padding(.leading, -20.0)
                        .foregroundColor(titleColor(difference: p1words.map({$0.rawScore * $0.multiplier}).reduce(0, +) - p2words.map({$0.rawScore * $0.multiplier}).reduce(0, +)))
                        .frame(width: 325.0, height:75.0)
                        .shadow(color: .gray, radius: 2, x: 2, y: 2)
                        .overlay(
                            HStack{
                                Text("Scrabble Scorecard")
                                    .foregroundColor(Color.white)
                            .padding(.leading, 15.0)
                            .font(.title)
                            Spacer()
                            }
                        )
                    Spacer()
                }
                }
                .padding(.vertical, 20)
                .background(Color.white)
                
                HStack(spacing: 10) {
                    HStack(spacing: -5) {
                        Button(action: {
                            self.multiplier = (self.multiplier + 1) % 3
                        }) {
                            RoundedRectangle(cornerRadius: 5.0)
                                .foregroundColor(multiplierColor(multiplier: self.multiplier))
                                .frame(width:45.0, height:36.0)
                            .overlay(
                                HStack(spacing:3) {
                                    Image(systemName: "multiply")
                                        .foregroundColor(.white)
                                    Text(String(self.multiplier + 1))
                                        .foregroundColor(.white)
                                }
                            )
                        }
                        .padding(.leading, 10.0)
                        TextField("Word", text: $word){
                            UIApplication.shared.endEditing()
                        }
                            .padding(.leading, 10.0)
                            .foregroundColor(Color.black)
                            .font(Font.system(size: 24))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .multilineTextAlignment( TextAlignment.center)
                            .autocapitalization(.allCharacters)
                            .disableAutocorrection(true)
                    }
                    
                    VStack {
                        Button(action: {
                            if(!self.word.isEmpty){
                                self.p1words.insert(Word(id: self.idCounter, word: self.word.uppercased(), rawScore: rawScore(rawWord: self.word), multiplier: self.multiplier + 1), at:0)
                                self.word = ""
                                self.multiplier = 0
                                self.idCounter += 1
                                UIApplication.shared.endEditing()
                            }
                        }) {
                            HStack {
                                Image(systemName: "plus")
                                Text("Play Word")
                            }.padding(10.0)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10.0)
                                    .stroke(lineWidth: 2.0)
                            )
                            
                        }
                        .padding(.trailing, 10.0)
                        Button(action: {
                            if(!self.word.isEmpty){
                                self.p2words.insert(Word(id: self.idCounter, word: self.word.uppercased(), rawScore: rawScore(rawWord: self.word), multiplier: self.multiplier + 1), at:0)
                                self.word = ""
                                self.multiplier = 0
                                self.idCounter += 1
                                UIApplication.shared.endEditing()
                            }
                        }) {
                            HStack {
                                Image(systemName: "plus")
                                    .foregroundColor(Color.pink)
                                Text("Play Word")
                                    .foregroundColor(Color.pink)
                            }.padding(10.0)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10.0)
                                    .stroke(lineWidth: 2.0)
                                    .foregroundColor(.pink)
                            )
                            
                        }
                        .padding(.trailing, 10.0)
                    }
                }
                .padding(.bottom, 10.0)
                .background(Color.white)
                HStack(spacing: 0){
                    List {
                        Section(header: HStack {
                            Text(self.p1name)
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(15)

                            Spacer()
                            Text(String(p1words.map({$0.rawScore * $0.multiplier}).reduce(0, +)))
                                .foregroundColor(Color.white)
                                .multilineTextAlignment(.trailing)
                            .padding(15)
                        }.onTapGesture{
                            self.p1words = self.p1words
                        }
                            .background(Color.blue)
                            .listRowInsets(EdgeInsets(
                                top: 0,
                                leading: 0,
                                bottom: 0,
                                trailing: 0))
                            )
                        {
                            if p1words.isEmpty{
                                Text("")
                            }
                            else{
                                ForEach(p1words) { p1word in
                                    HStack{
                                        Text(p1word.word)
                                        Spacer()
                                        Text(String(p1word.rawScore * p1word.multiplier))
                                    }
                                }.onDelete(perform: deletep1)
                            }
                        }
                            .listRowInsets(EdgeInsets(
                                top: 0,
                                leading: 15,
                                bottom: 0,
                                trailing: 15))
                    }
                        .onAppear() {
                            UITableView.appearance().separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                        }
                    
                    Divider()
                    
                    List {
                        Section(header: HStack {
                            Text(self.p2name)
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(15)

                            Spacer()
                            
                            Text(String(p2words.map({$0.rawScore * $0.multiplier}).reduce(0, +)))
                            .foregroundColor(Color.white)
                            .multilineTextAlignment(.trailing)
                            .padding(15)
                        }
                        .background(Color.pink)
                        .listRowInsets(EdgeInsets(
                            top: 0,
                            leading: 0,
                            bottom: 0,
                            trailing: 0))
                        )
                        {
                            if p2words.isEmpty{
                                Text("")
                            }
                            else{
                                ForEach(p2words) { p2word in
                                    HStack{
                                        Text(p2word.word)
                                        Spacer()
                                        Text(String(p2word.rawScore * p2word.multiplier))
                                    }
                                }.onDelete(perform: deletep2)
                            }
                        }
                        .listRowInsets(EdgeInsets(
                            top: 0,
                            leading: 15,
                            bottom: 0,
                            trailing: 15))
                    }
                }
    //          .padding(10)
//                Spacer()
//                    .frame(height: 15)
//                HStack {
//                    HStack(alignment: .bottom){
//                        Spacer()
//                        Text(String(p1words.map({$0.rawScore * $0.multiplier}).reduce(0, +)))
//                            .foregroundColor(Color.white)
//                            .multilineTextAlignment(.trailing)
//                    }.padding(.trailing, 20.0)
//                    HStack {
//                        Spacer()
//                        Text(String(p2words.map({$0.rawScore * $0.multiplier}).reduce(0, +)))
//                            .foregroundColor(Color.white)
//                            .multilineTextAlignment(.trailing)
//                    }
//                    .padding(.trailing, 20.0)
//
//                }
//                .padding(.bottom, 10.0)
                Rectangle()
                    .fill(Color.gray)
                    .frame(height:40.0)
                    

            }
//            .padding(.bottom)
//            .background(Color(red: 0.2, green: 0.2, blue: 0.2, opacity: 1.0))
            .edgesIgnoringSafeArea(.all)
            
            ZStack{
                Spacer()
                VStack {
                    HStack {
                        Button(action: {
                            withAnimation {
                                UIApplication.shared.endEditing()
                                self.isNewGamePresented.toggle()
                                self.p1newName = self.p1name
                                self.p2newName = self.p2name
                            }
                        })
                        {
                            HStack{
                                Image(systemName: "arrow.left")
                                Text("Back")
                            }
                            .padding([.top, .leading], 15)
                        }
                        .padding(.top, UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.safeAreaInsets.top)
                        Spacer()
                    }
                    Spacer()
                    VStack(alignment: .center){
                        Spacer()
                        Text("New Game")
                            .font(Font.system(size: 32))
                            .foregroundColor(.black)
                            .padding(25)
                        Spacer()
                        Spacer()
                        TextField("Player 1", text: $p1newName){
                            UIApplication.shared.endEditing()
                        }
                        .padding(.horizontal, 15)
                            .foregroundColor(Color.blue)
                            .font(Font.system(size: 48))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .multilineTextAlignment( TextAlignment.center)
                            .disableAutocorrection(true)
                            .introspectTextField { textField in
                                textField.addTarget(
                                    self.textFieldObserver,
                                    action: #selector(TextFieldObserver.textFieldDidBeginEditing),
                                    for: .editingDidBegin
                                )
                            }
                        TextField("Player 2", text: $p2newName){
                            UIApplication.shared.endEditing()
                        }
                        .padding(.horizontal, 15)
                            .foregroundColor(Color.pink)
                            .font(Font.system(size: 48))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .multilineTextAlignment( TextAlignment.center)
                            .disableAutocorrection(true)
                            .introspectTextField { textField in
                                textField.addTarget(
                                    self.textFieldObserver,
                                    action: #selector(TextFieldObserver.textFieldDidBeginEditing),
                                    for: .editingDidBegin
                                )
                            }
                        Spacer()
                        
                    
                    
                    Button(action: {
                        withAnimation {
                            UIApplication.shared.endEditing()
                            self.isNewGamePresented.toggle()
                            self.p1name = self.p1newName
                            self.p2name = self.p2newName
                            self.p1words.removeAll()
                            self.p2words.removeAll()
                            self.multiplier = 0
                            self.word = ""
                        }
                    })
                    {
                        RoundedRectangle(cornerRadius: 5)
                        .fill(Color.green)
                        .frame(height:100)
                        .padding(.horizontal, 15)
                        .shadow(color: .gray, radius: 2, x: 2, y: 2)
                    }
                        .overlay(
                            HStack{
                                Spacer()
                                Text("Go")
                                    .font(Font.system(size: 48))
                                    .foregroundColor(Color.white)
                                Image(systemName: "checkmark.circle.fill")
                                    .font(Font.system(size: 48))
                                    .foregroundColor(Color.white)
                                Spacer()
                            }
                        )
                        .padding(.top, 25)
                    Spacer()
                    }
                }
            }.background(Color.yellow)
                .edgesIgnoringSafeArea(.all)
                .offset(x:0, y: self.isNewGamePresented ? 0 : UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.frame.height ?? 0)
        }
    }
    


    func deletep1(at offsets:IndexSet){
        p1words.remove(atOffsets: offsets)
    }
    
    func deletep2(at offsets:IndexSet){
        p2words.remove(atOffsets: offsets)
    }

}

func multiplierColor (multiplier: Int) -> Color {
    switch(multiplier){
    case 0:
        return Color.gray
    case 1:
        return Color.green
    case 2:
        return Color.orange
    default:
        return Color.gray
    }
}

func titleColor (difference: Int) -> Color {
    if difference == 0{
        return Color.gray
    }
    else if difference < 0 {
        return Color.pink
    }
    else {
        return Color.blue
    }
}

func rawScore(rawWord: String) -> Int {
    var score = 0
    for char in rawWord.uppercased() {
        switch (char){
        case "A", "E", "I", "O", "U", "L", "N", "S", "T", "R":
            score += 1
        case "D", "G":
            score += 2
        case "B", "C", "M", "P":
            score += 3
        case "F", "H", "V", "W", "Y":
            score += 4
        case "K":
            score += 5
        case "J", "X":
            score += 8
        case "Q", "Z":
            score += 10
        default:
            continue
        }
    }
    return score
}

private class TextFieldObserver: NSObject {
    @objc
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.selectAll(nil)
    }
}


extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
