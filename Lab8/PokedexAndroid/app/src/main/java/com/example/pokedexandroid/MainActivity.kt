package com.example.pokedexandroid

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import androidx.activity.viewModels
import androidx.lifecycle.Observer
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.example.pokedexandroid.model.Pokemon
import com.example.pokedexandroid.model.PokemonViewModel
import com.example.pokedexandroid.util.JSONData

class MainActivity : AppCompatActivity() {

    val viewModel: PokemonViewModel by viewModels()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        if (viewModel.pokemonList.value == null){
            val loader = JSONData()
            loader.loadJSONObject(this.applicationContext, viewModel)
        }


        /*
        RECYCLER VIEW
         */

        val recyclerView: RecyclerView = findViewById(R.id.recyclerView)

        recyclerView.layoutManager = LinearLayoutManager(this, LinearLayoutManager.VERTICAL, false)
        val adapter = MyListAdapter(viewModel)
        recyclerView.adapter = adapter
        viewModel.pokemonList.observe(this, Observer {
            adapter.update()
        })

    }

}
