package com.example.classes.data
import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity
data class Course(
    @PrimaryKey(autoGenerate = true) var id:Int,
    var name: String, val code: String, val taughtBy:String
){}