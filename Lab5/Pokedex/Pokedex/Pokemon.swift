//
//  Pokemon.swift
//  Pokedex
//
//  Created by Kevina Wong on 2/24/22.
//

import Foundation

struct PokemonInfo: Decodable {
    let id: Int
    let name: String
    let types: [Type]
    let sprites: Sprite
}

struct Type: Decodable{
    let type: PokemonData
}

struct Sprite: Decodable{
    let front_default: String
}

struct PokemonAPI: Decodable {
    let next: String
    let results: [PokemonData]
}

struct PokemonData: Decodable {
    let name: String
    let url: String
}

struct AllPokemon{
    var pokemon = [PokemonData]()
    var pokemonInfo = [PokemonInfo]()
}
