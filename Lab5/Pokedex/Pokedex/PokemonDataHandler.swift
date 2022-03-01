//
//  PokemonDataHandler.swift
//  Pokedex
//
//  Created by Kevina Wong on 2/24/22.
//

import Foundation

class PokemonDataHandler {
    
    var allPokemonData = AllPokemon()
    
    func loadJSON() async {

        let request = NSMutableURLRequest(url: NSURL(string: "https://pokeapi.co/api/v2/pokemon?limit=151")! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)

        request.httpMethod = "GET"

        do {
            let (data, response) = try await URLSession.shared.data(for: request as URLRequest, delegate: nil)
            guard (response as? HTTPURLResponse)?.statusCode == 200
            else{
                print("File Download Error... Status Code: \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
                return
            }
            
            print("Download Complete :)")
            await parseJSON(data)
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    func parseJSON(_ data: Data) async{
        do{

            let apiData = try JSONDecoder().decode(PokemonAPI.self, from: data)

            allPokemonData.pokemon = apiData.results
            
            
            for pokemon in apiData.results{
                print("loading \(pokemon.name)")
                await loadPokemonData(url: pokemon.url)
            }
            
            print("Number of Pokemon Added: \(allPokemonData.pokemon.count)")
            print("+==== Done ====+")
        }
        catch let jsonErr{
            print(String(describing: jsonErr))
            print(jsonErr.localizedDescription)
            return
        }
    }
    
    
    func getPokemon() -> [PokemonData]{
        return allPokemonData.pokemon
    }
    
//    func getFoundPokemon() -> PokemonInfo{
//        return foundPokemon!
//    }
//
    func loadPokemonData(url: String) async  {

        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)

            request.httpMethod = "GET"

            do {
                let (data, response) = try   await URLSession.shared.data(for: request as URLRequest, delegate: nil)
                guard (response as? HTTPURLResponse)?.statusCode == 200
                else{
                    print("File Download Error... Status Code: \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
                    return
                }
                parsePokemonDetails(data)
            }
            catch{
                print(error.localizedDescription)
            }
            
        }
    
    func parsePokemonDetails(_ data: Data){
        do{
            let apiData = try JSONDecoder().decode(PokemonInfo.self, from: data)

//      allPokemonData.pokemonInfo.append(apiData.self)
            
            allPokemonData.pokemonInfo.append(apiData)

            print("Adding: \(apiData.name)")
            print("+==== Pokemon Download Complete ====+")

            
        }
        catch let jsonErr{
            print(String(describing: jsonErr))
            print(jsonErr.localizedDescription)
            return
        }
    }
    
}

