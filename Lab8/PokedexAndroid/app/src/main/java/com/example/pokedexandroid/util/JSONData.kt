package com.example.pokedexandroid.util

import android.content.Context
import android.util.Log
import com.android.volley.Request
import com.android.volley.toolbox.StringRequest
import com.android.volley.toolbox.Volley
import com.example.pokedexandroid.model.Pokemon
import com.example.pokedexandroid.model.PokemonViewModel
import org.json.JSONException
import org.json.JSONObject

class JSONData() {

    fun loadJSONObject(context: Context, pokemonViewModel: PokemonViewModel){

        val url = "https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json"
        val queue = Volley.newRequestQueue(context)
        val request = StringRequest(Request.Method.GET, url,
            { response ->
                parseJSON(response, pokemonViewModel)
            },
            {
                Log.e("RESPONSE", error("request failed"))
            }
        )

        queue.add(request)
    }

    fun parseJSON(response: String, pokemonViewModel: PokemonViewModel){
        val dataList = ArrayList<Pokemon>()

        try {
            val jsonObject = JSONObject(response)
            val resultsArray = jsonObject.getJSONArray("pokemon")
            for (i in 0 until 151) {
                val pokemonObject = resultsArray.getJSONObject(i)

                val name = pokemonObject.getString("name")
                val id = pokemonObject.getInt("id")
                val sprite = pokemonObject.getString("img")
                var types = ArrayList<String>()
                val typesArray = pokemonObject.getJSONArray("type")

                for (i in 0 until typesArray.length()) {
                    val typeName = typesArray[i].toString()
                    types.add(typeName)
                }

                Log.i("==== ADDING ====", name)
                Log.i("==== NO ====", id.toString())
                Log.i("==== NO ====", sprite)
                Log.i("==== TYPE ====", types[0].toString())

                val newPokemon = Pokemon(name, id, sprite, types)
                dataList.add(newPokemon)
            }
        } catch (e: JSONException) {
            e.printStackTrace()
        }
        pokemonViewModel.updatePokemon(dataList)
    }

}