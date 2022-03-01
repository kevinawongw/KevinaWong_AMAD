//
//  Joke.swift
//  Jokes
//
//  Created by Kevina Wong on 2/24/22.
//

import Foundation

struct Joke: Decodable{
    let setup: String
    let delivery: String
}

struct JokeData: Decodable{
    var jokes = [Joke]()
}
