//
//  PoddPage.swift
//  SSC26
//
//  Created by Rodrigo Cont on 09/02/26.
//
import SwiftUI

enum BoardDefinition {
    
    static func makePages() -> [PoddPage] {
        [
            makePage1(),
            makeActions2(),
            makePlay3(),
            makeFoodDrink4(),
            makeFeelings5(),
            makeBody6()
        ]
    }
    
    private static func makePage1() -> PoddPage {
        PoddPage(
            id: 1,
            title: "Actions 1",
            tabColor: .white,
            tiles: [
                wordTile("I",     append: "I",      speak: "i",      icon: "I",     border: .yellow),
                wordTile("It",    append: "it",     speak: "it",     icon: "It",    border: .yellow),
                wordTile("Like",  append: "like",   speak: "like",   icon: "Like",  border: .orange),
                wordTile("Go",    append: "go",     speak: "go",     icon: "Go",    border: .green),
                wordTile("Stop",  append: "stop",   speak: "stop",   icon: "Stop",  border: .green),
                wordTile("More",  append: "more",   speak: "more",   icon: "More",  border: .purple),
                
                
                wordTile("You",   append: "you",    speak: "you",    icon: "You",   border: .yellow),
                wordTile("Don't", append: "don't",  speak: "don't",  icon: "Dont",  border: .red),
                wordTile("Want",  append: "want",   speak: "want",   icon: "Want",  border: .orange),
                wordTile("Help",  append: "help",   speak: "help",   icon: "Help",  border: .green),
                wordTile("What",  append: "what",   speak: "what",   icon: "What",  border: .blue),
                wordTile("Where", append: "where",  speak: "where",  icon: "Where", border: .blue),
            ]
        )
    }
    
    
    private static func makeActions2() -> PoddPage {
        PoddPage(
            id: 2,
            title: "Actions 2",
            tabColor: .gray,
            tiles: [
                
                wordTile("Drink",     append: "drink",      speak: "drink",      icon: "Drink",     border: .green),
                wordTile("Play",      append: "play",       speak: "play",       icon: "Play",      border: .green),
                wordTile("Listen",    append: "listen",     speak: "listen",     icon: "Listen",    border: .green),
                wordTile("Rest",      append: "rest",       speak: "rest",       icon: "Rest",      border: .green),
                wordTile("Sleep",     append: "sleep",      speak: "sleep",      icon: "Sleep",     border: .green),
                wordTile("How are you",      append: "how are you",       speak: "how are you",       icon: "howareyou",      border: .green),
                
                
                wordTile("Eat",       append: "eat",        speak: "eat",        icon: "Eat",       border: .green),
                wordTile("Look",      append: "look",       speak: "look",       icon: "Look",      border: .green),
                wordTile("Toilet",    append: "toilet",     speak: "toilet",     icon: "Toilet",    border: .green),
                wordTile("Go",        append: "go",         speak: "go",         icon: "Go",        border: .green),
                wordTile("Thank you", append: "thank you",  speak: "thank you", icon: "ThankYou",  border: .green),
                wordTile("Feel",      append: "feel",       speak: "feel",       icon: "Feel",      border: .green),
            ]
        )
    }
    
    private static func makePlay3() -> PoddPage {
        PoddPage(
            id: 3,
            title: "Play 3",
            tabColor: .red,
            tiles: [
                wordTile("Ball",       append: "ball",       speak: "ball",       icon: "Ball",       border: .red),
                wordTile("Play",       append: "play",       speak: "play",       icon: "Play",       border: .red),
                wordTile("Music",      append: "music",      speak: "music",      icon: "Music",      border: .red),
                wordTile("Game",       append: "game",       speak: "game",       icon: "Game",       border: .red),
                wordTile("Playground", append: "playground", speak: "playground", icon: "Playground", border: .red),
                wordTile("More",       append: "more",       speak: "more",       icon: "More",       border: .purple),
                
                
                wordTile("Blocks",     append: "blocks",     speak: "blocks",     icon: "Blocks",     border: .red),
                wordTile("Draw",       append: "draw",       speak: "draw",       icon: "Draw",       border: .red),
                wordTile("Book",       append: "book",       speak: "book",       icon: "Book",       border: .red),
                wordTile("Outside",    append: "outside",    speak: "outside",    icon: "Outside",    border: .red),
                wordTile("Dance",      append: "dance",      speak: "dance",      icon: "Dance",      border: .red),
                wordTile("Theatre",    append: "theatre",    speak: "theatre",    icon: "Theatre",    border: .red),
            ]
        )
    }
    
    private static func makeFoodDrink4() -> PoddPage {
        PoddPage(
            id: 4,
            title: "Food & Drink 4",
            tabColor: .green,
            tiles: [
                
                wordTile("Water",     append: "water",     speak: "water",     icon: "Water",     border: .green),
                wordTile("Milk",      append: "milk",      speak: "milk",      icon: "Milk",      border: .green),
                wordTile("Apple",     append: "apple",     speak: "apple",     icon: "Apple",     border: .green),
                wordTile("Cookie",    append: "cookie",    speak: "cookie",    icon: "Cookie",    border: .green),
                wordTile("Pizza",     append: "pizza",     speak: "pizza",     icon: "Pizza",     border: .green),
                wordTile("More",      append: "more",      speak: "more",      icon: "More",      border: .purple),
                wordTile("Juice",     append: "juice",     speak: "juice",     icon: "Juice",     border: .green),
                wordTile("Snack",     append: "snack",     speak: "snack",     icon: "Snack",     border: .green),
                
                
                wordTile("Banana",    append: "banana",    speak: "banana",    icon: "Banana",    border: .green),
                wordTile("Chocolate", append: "chocolate", speak: "chocolate", icon: "Chocolate", border: .green),
                wordTile("Pasta",     append: "pasta",     speak: "pasta",     icon: "Pasta",     border: .green),
                wordTile("Hamburger", append: "hamburger", speak: "hamburger", icon: "Hamburger", border: .green),
                
            ]
        )
    }
    
    
    private static func makeFeelings5() -> PoddPage {
        PoddPage(
            id: 5,
            title: "Feelings 5",
            tabColor: .teal,
            tiles: [
                
                wordTile("Happy",  append: "happy",  speak: "happy",  icon: "Happy",  border: .blue),
                wordTile("Angry",  append: "angry",  speak: "angry",  icon: "Angry",  border: .blue),
                wordTile("Tired",  append: "tired",  speak: "tired",  icon: "Tired",  border: .blue),
                wordTile("Good",   append: "good",   speak: "good",   icon: "Good",   border: .blue),
                wordTile("Bored",  append: "bored",  speak: "bored",  icon: "Bored",  border: .blue),
                wordTile("More",   append: "more",   speak: "more",   icon: "More",   border: .purple),
                
                
                wordTile("Sad",    append: "sad",    speak: "sad",    icon: "Sad",    border: .blue),
                wordTile("Scared", append: "scared", speak: "scared", icon: "Scared", border: .blue),
                wordTile("Fun",    append: "fun",    speak: "fun",    icon: "Fun",    border: .blue),
                wordTile("Bad",    append: "bad",    speak: "bad",    icon: "Bad",    border: .blue),
                wordTile("Hurt",   append: "hurt",   speak: "hurt",   icon: "Hurt",   border: .blue),
                wordTile("Hungry", append: "hungry", speak: "hungry", icon: "Hungry", border: .blue),
            ]
        )
    }
    
    private static func makeBody6() -> PoddPage {
        PoddPage(
            id: 6,
            title: "Body 6",
            tabColor: .yellow,
            tiles: [
                wordTile("Headache",    append: "headache",    speak: "headache",    icon: "Headache",    border: .yellow),
                wordTile("Throat", append: "throat", speak: "throat", icon: "throat",  border: .yellow),
                wordTile("Foot",   append: "foot",   speak: "foot",   icon: "foot",    border: .yellow),
                wordTile("Arm",    append: "arm",    speak: "arm pain",    icon: "arm",     border: .yellow),
                wordTile("Hot",         append: "hot",         speak: "hot",         icon: "Hot",         border: .yellow),
                wordTile("Pain",        append: "pain",        speak: "pain",        icon: "Pain",        border: .yellow),
                
                
                wordTile("Leg",    append: "leg",    speak: "leg",    icon: "leg",     border: .yellow),
                wordTile("Back",   append: "back",   speak: "back",   icon: "back",    border: .yellow),
                wordTile("Bellyache",   append: "bellyache",   speak: "belly ache",  icon: "Bellyache",   border: .yellow),
                wordTile("Cold",        append: "cold",        speak: "cold",        icon: "Cold",        border: .yellow),
                wordTile("Hurt",        append: "hurt",        speak: "hurt",        icon: "Hurt",        border: .yellow),
                wordTile("Tickle",      append: "tickle",      speak: "tickle",      icon: "Tickle",      border: .yellow),
            ]
        )
    }
    
    private static func wordTile(_ label: String,
                                 append: String,
                                 speak: String,
                                 icon: String,
                                 border: Color) -> PoddTile {
        PoddTile(
            label: label,
            appendText: append,
            speakText: speak,
            iconName: icon,
            borderColor: border,
            kind: .word
        )
    }
}
