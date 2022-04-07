package com.example.movies.model

import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel

class MovieViewModel: ViewModel() {

    val movieList = MutableLiveData<ArrayList<Movie>>()

    fun updateList(newList: ArrayList<Movie>){
        movieList.value = newList
    }

}