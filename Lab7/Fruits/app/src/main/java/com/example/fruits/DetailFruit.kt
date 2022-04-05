package com.example.fruits

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.ImageView
import android.widget.TextView
import com.example.fruits.ui.home.HomeFragment

class DetailFruit : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_detail_fruit)
        val name = intent.getStringExtra("name")
        val resourceID = intent.getIntExtra("resourceID", -1)

        //update view
        val fruitImage: ImageView = findViewById(R.id.fruitImage)
        fruitImage.setImageResource(resourceID)
        val fruitName: TextView = findViewById(R.id.fruitName)
        fruitName.text = name
    }


    // Save State on Rotation
    override fun onSaveInstanceState(outState: Bundle) {
        super.onSaveInstanceState(outState)
        // No information to save
    }

    override fun onRestoreInstanceState(savedInstanceState: Bundle) {
        super.onRestoreInstanceState(savedInstanceState)
        // No information to save
    }


}