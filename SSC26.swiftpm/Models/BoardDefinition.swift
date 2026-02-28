//
//  BoardDefinition.swift
//  SSC26
//
//  Created by Rodrigo Cont on 09/02/26.
//
import SwiftUI

enum BoardDefinition {
    
    static func makePages() -> [BookPage] {
        [
            makePage1(),
            makeActions2(),
            makePlay3(),
            makeFoodDrink4(),
            makeFeelings5(),
            makeBody6()
        ]
    }
    
    private static func makePage1() -> BookPage {
        BookPage(
            id: 1,
            title: "Actions 1",
            tabColor: Color(hex: "#E6E6E6"),
            tiles: [
                wordTile("I",     append: "I",      speak: "i",      icon: "I",     border: Color(hex: "#990099")),
                wordTile("It",    append: "it",     speak: "it",     icon: "It",    border: Color(hex: "#990099")),
                wordTile("Like",  append: "like",   speak: "like",   icon: "Like",  border: .green),
                wordTile("Go",    append: "go",     speak: "go",     icon: "Go",    border: .green),
                wordTile("Stop",  append: "stop",   speak: "stop",   icon: "Stop",  border: .green),
                wordTile("More",  append: "more",   speak: "more",   icon: "More",  border: Color(hex: "#E6E6E6")),
                
                wordTile("You",   append: "you",    speak: "you",    icon: "You",   border: Color(hex: "#990099")),
                wordTile("Don't", append: "don't",  speak: "don't",  icon: "Dont",  border: .red),
                wordTile("Want",  append: "want",   speak: "want",   icon: "Want",  border: .green),
                wordTile("Help",  append: "help",   speak: "help",   icon: "Help",  border: .green),
                wordTile("What",  append: "what",   speak: "what",   icon: "What",  border: .orange),
                wordTile("Where", append: "where",  speak: "where",  icon: "Where", border: .orange),
            ]
        )
    }
    
    private static func makeActions2() -> BookPage {
        BookPage(
            id: 2,
            title: "Actions 2",
            tabColor: Color(hex: "#E6E6E6"),
            tiles: [
                wordTile("Drink",       append: "drink",       speak: "drink",       icon: "Drink",     border: .green),
                wordTile("Play",        append: "play",        speak: "play",        icon: "Play",      border: .green),
                wordTile("Listen",      append: "listen",      speak: "listen",      icon: "Listen",    border: .green),
                wordTile("Rest",        append: "rest",        speak: "rest",        icon: "Rest",      border: .green),
                wordTile("Toilet",      append: "toilet",      speak: "toilet",      icon: "Toilet",    border: .yellow),
                wordTile("How are you", append: "how are you", speak: "how are you", icon: "howareyou",  border: .orange),
                
                wordTile("Eat",         append: "eat",         speak: "eat",         icon: "Eat",       border: .green),
                wordTile("Look",        append: "look",        speak: "look",        icon: "Look",      border: .green),
                wordTile("Sleep",       append: "sleep",       speak: "sleep",       icon: "Sleep",     border: .green),
                wordTile("Go",          append: "go",          speak: "go",          icon: "Go",        border: .green),
                wordTile("Feel",        append: "feel",        speak: "feel",        icon: "Feel",      border: .green),
                wordTile("Thank you",   append: "thank you",   speak: "thank you",   icon: "ThankYou",  border: .orange),
            ]
        )
    }
    
    private static func makePlay3() -> BookPage {
        BookPage(
            id: 3,
            title: "Play 3",
            tabColor: Color(hex: "#FF6257"),                tiles: [
                wordTile("Draw",       append: "draw",       speak: "draw",       icon: "Draw",       border: .green),
                wordTile("Play",       append: "play",       speak: "play",       icon: "Play",       border: .green),
                wordTile("Music",      append: "music",      speak: "music",      icon: "Music",      border: .yellow),
                wordTile("Game",       append: "game",       speak: "game",       icon: "Game",       border: .yellow),
                wordTile("Playground", append: "playground", speak: "playground", icon: "Playground", border: .yellow),
                wordTile("Movie",       append: "movie",       speak: "movie",       icon: "Movie",       border: .yellow),
                wordTile("Dance",      append: "dance",      speak: "dance",      icon: "Dance",      border: .green),
                
                wordTile("Ball",       append: "ball",       speak: "ball",       icon: "Ball",       border: .yellow),
                wordTile("Book",       append: "book",       speak: "book",       icon: "Book",       border: .yellow),
                wordTile("Outside",    append: "outside",    speak: "outside",    icon: "Outside",    border: .yellow),
                wordTile("Blocks",     append: "blocks",     speak: "blocks",     icon: "Blocks",     border: .yellow),
                wordTile("Theatre",    append: "theatre",    speak: "theatre",    icon: "Theatre",    border: .yellow),
            ]
        )
    }
    
    private static func makeFoodDrink4() -> BookPage {
        BookPage(
            id: 4,
            title: "Food & Drink 4",
            tabColor: .green,
            tiles: [
                wordTile("Water",     append: "water",     speak: "water",     icon: "Water",     border: .yellow),
                wordTile("Milk",      append: "milk",      speak: "milk",      icon: "Milk",      border: .yellow),
                wordTile("Apple",     append: "apple",     speak: "apple",     icon: "Apple",     border: .yellow),
                wordTile("Cookie",    append: "cookie",    speak: "cookie",    icon: "Cookie",    border: .yellow),
                wordTile("Pizza",     append: "pizza",     speak: "pizza",     icon: "Pizza",     border: .yellow),
                wordTile("Fruit Salad",      append: "fruit salad",      speak: "fruit salad",      icon: "FruitSalad",      border: .yellow),
                wordTile("Juice",     append: "juice",     speak: "juice",     icon: "Juice",     border: .yellow),
                wordTile("Snack",     append: "snack",     speak: "snack",     icon: "Snack",     border: .yellow),
                
                wordTile("Banana",    append: "banana",    speak: "banana",    icon: "Banana",    border: .yellow),
                wordTile("Chocolate", append: "chocolate", speak: "chocolate", icon: "Chocolate", border: .yellow),
                wordTile("Pasta",     append: "pasta",     speak: "pasta",     icon: "Pasta",     border: .yellow),
                wordTile("Hamburger", append: "hamburger", speak: "hamburger", icon: "Hamburger", border: .yellow),
            ]
        )
    }
    
    private static func makeFeelings5() -> BookPage {
        BookPage(
            id: 5,
            title: "Feelings 5",
            tabColor: .teal,
            tiles: [
                wordTile("Happy",  append: "happy",  speak: "happy",  icon: "Happy",  border: .blue),
                wordTile("Angry",  append: "angry",  speak: "angry",  icon: "Angry",  border: .blue),
                wordTile("Tired",  append: "tired",  speak: "tired",  icon: "Tired",  border: .blue),
                wordTile("Good",   append: "good",   speak: "good",   icon: "Good",   border: .blue),
                wordTile("Bored",  append: "bored",  speak: "bored",  icon: "Bored",  border: .blue),
                wordTile("Anxious",   append: "anxious",   speak: "anxious",   icon: "Anxious",   border: .blue),
                
                wordTile("Sad",    append: "sad",    speak: "sad",    icon: "Sad",    border: .blue),
                wordTile("Scared", append: "scared", speak: "scared", icon: "Scared", border: .blue),
                wordTile("Fun",    append: "fun",    speak: "fun",    icon: "Fun",    border: .blue),
                wordTile("Bad",    append: "bad",    speak: "bad",    icon: "Bad",    border: .blue),
                wordTile("Hurt",   append: "hurt",   speak: "hurt",   icon: "Hurt",   border: .blue),
                wordTile("Hungry", append: "hungry", speak: "hungry", icon: "Hungry", border: .blue),
            ]
        )
    }
    
    private static func makeBody6() -> BookPage {
        BookPage(
            id: 6,
            title: "Body 6",
            tabColor: .yellow,
            tiles: [
                wordTile("Headache",  append: "headache",  speak: "headache",   icon: "Headache",  border: .yellow),
                wordTile("Throat",    append: "throat",    speak: "throat",     icon: "throat",    border: .yellow),
                wordTile("Foot",      append: "foot",      speak: "foot",       icon: "foot",      border: .yellow),
                wordTile("Arm",       append: "arm",       speak: "arm pain",   icon: "arm",       border: .yellow),
                
                wordTile("Hurt",      append: "hurt",      speak: "hurt",       icon: "Hurt",      border: .green),
                wordTile("Cold",      append: "cold",      speak: "cold",       icon: "Cold",      border: .blue),
                wordTile("Leg",       append: "leg",       speak: "leg",        icon: "leg",       border: .yellow),
                wordTile("Back",      append: "back",      speak: "back",       icon: "back",      border: .yellow),
                wordTile("Bellyache", append: "bellyache", speak: "belly ache", icon: "Bellyache", border: .yellow),
                wordTile("Pain",      append: "pain",      speak: "pain",       icon: "Pain",      border: .yellow),
                wordTile("Tickle",    append: "tickle",    speak: "tickle",     icon: "Tickle",    border: .yellow),
                
                wordTile("Hot",       append: "hot",       speak: "hot",        icon: "Hot",       border: .blue),
            ]
        )
    }
    
    private static func wordTile(_ label: String,
                                 append: String,
                                 speak: String,
                                 icon: String,
                                 border: Color) -> BookTile {
        BookTile(
            label: label,
            appendText: append,
            speakText: speak,
            iconName: icon,
            borderColor: border,
            kind: .word
        )
    }
}
