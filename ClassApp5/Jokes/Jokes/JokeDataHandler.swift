//
//  JokeDataHandler.swift
//  Jokes
//
//  Created by Kevina Wong on 2/24/22.
//

import Foundation

class JokeDataHandler {
    var jokeDate = JokeData()
    
    func loadjson() async {
        
        guard let urlPath = URL(string: "https://v2.jokeapi.dev/joke/Programming?type=twopart&amount=10")
        else{
            print("URL Error :(")
            return
        }
        
        do {
            let (data,response) = try await URLSession.shared.data(from: urlPath, delegate: nil)
            guard (response as? HTTPURLResponse)?.statusCode == 200
            else{
                print("file download error")
                return
            }
            print("Download Complete :)")
            parsejson(data)
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    func parsejson (_ data: Data) {
            do
            {
                let apiData = try JSONDecoder().decode(JokeData.self, from: data)
                for joke in apiData.                {
                    jokeData.body.append(joke)
                    print(joke)
                }
                print("number of jokes parsed \(jokeData.body.count)")
                print("parsejson done")
            }
            catch let jsonErr
            {
                print(jsonErr.localizedDescription)
                return
            }
        }

        func getJokes() -> [Joke] {
            return jokeData.body
        }
}
