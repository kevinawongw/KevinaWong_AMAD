package com.example.pokedexandroid.model

import android.util.Log
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel

class PokemonViewModel: ViewModel() {

    var pokemonList = MutableLiveData<ArrayList<Pokemon>>()

    fun updatePokemon(newList: ArrayList<Pokemon>) {
        pokemonList.value = newList
        Log.i("POKEMON LIST", "UPDATED")
    }

}