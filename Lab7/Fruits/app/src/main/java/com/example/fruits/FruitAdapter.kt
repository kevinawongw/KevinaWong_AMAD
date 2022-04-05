package com.example.fruits

import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.example.fruits.FruitAdapter.ViewHolder

class FruitAdapter(private val fruitList: ArrayList<Fruit>, private val clickListener:(Fruit) -> Unit): RecyclerView.Adapter<ViewHolder>(){

    class ViewHolder(view: View): RecyclerView.ViewHolder(view) {
        val fruitTextView: TextView = view.findViewById(R.id.itemTextView)
        val fruitImage: ImageView = view.findViewById(R.id.fruitImageView)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val layoutInflater = LayoutInflater.from(parent.context)
        val itemViewHolder = layoutInflater.inflate(R.layout.list_item, parent, false)
        return ViewHolder(itemViewHolder)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val fruit = fruitList[position]
        Log.d("=== SETTING ===", fruit.name)
        holder.fruitTextView.text = fruit.name
        holder.fruitImage.setImageResource(fruit.imageID)
        holder.itemView.setOnClickListener{clickListener(fruit)}
    }

    override fun getItemCount() = fruitList.size

}
