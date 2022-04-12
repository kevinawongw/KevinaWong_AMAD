package com.example.pokedexandroid

import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.example.pokedexandroid.model.PokemonViewModel
import com.squareup.picasso.Picasso

class MyListAdapter(private val pokemonViewModel: PokemonViewModel): RecyclerView.Adapter<MyListAdapter.ViewHolder>() {
    private var myPokemonList = pokemonViewModel.pokemonList.value

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val nameTextView: TextView = view.findViewById(R.id.textView)
        val idTextView: TextView = view.findViewById(R.id.textView2)
        val imageView: ImageView = view.findViewById(R.id.imageView)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val layoutInflater = LayoutInflater.from(parent.context)
        val itemViewHolder = layoutInflater.inflate(R.layout.card_list_item, parent, false)
        return ViewHolder(itemViewHolder)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val pokemon = myPokemonList?.get(position)
        pokemon?.name?.let { Log.i("RECYCLE", it) }
        holder.nameTextView.text = pokemon?.name ?: "Unknown"
        if (pokemon != null) {
            holder.idTextView.text = "No. " + pokemon.id
        }


        Picasso.get().load(pokemon?.sprite?.replace("http:", "https:"))
            .into(holder.imageView);
    }

    override fun getItemCount(): Int {
        if (myPokemonList != null) {
            return myPokemonList!!.size
        } else return 0
    }

    fun update() {
        myPokemonList = pokemonViewModel.pokemonList.value
        notifyDataSetChanged()
    }
}