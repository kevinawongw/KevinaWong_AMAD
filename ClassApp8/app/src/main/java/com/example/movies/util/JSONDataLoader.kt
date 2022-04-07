package com.example.movies.util

import android.content.Context
import android.util.Log
import com.android.volley.Request
import com.android.volley.toolbox.StringRequest
import com.android.volley.toolbox.Volley
import com.example.movies.model.Movie
import com.example.movies.model.MovieViewModel
import org.json.JSONException
import org.json.JSONObject

class JSONDataLoader {

    class JSONdata {
        fun loadJSON(context: Context, movieViewModel: MovieViewModel){
            val url = "https://api.themoviedb.org/3/movie/top_rated?api_key=9bc41deb95194da5e8865be1fe7750a4&language=en-US&page=1"

            val queue = Volley.newRequestQueue(context)

            val request = StringRequest(
                Request.Method.GET, url,
                { response ->
                    parseJSON(response, movieViewModel)
                },
                {
                    Log.e("RESPONSE", error("request failed"))
                }
            )

            queue.add(request)
        }

        fun parseJSON(response: String, movieViewModel: MovieViewModel){
            val dataList = ArrayList<Movie>()
            val poster_base_url = "https://image.tmdb.org/t/p/w185"

            try {
                val jsonObject = JSONObject(response)

                val resultsArray = jsonObject.getJSONArray("results")

                for (i in 0 until resultsArray.length()) {
                    val movieObject = resultsArray.getJSONObject(i)

                    val id = movieObject.getInt("id")
                    val title = movieObject.getString("title")
                    val posterURL = poster_base_url + movieObject.getString("poster_path")
                    val rating = movieObject.getDouble("vote_average").toString()

                    val newMovie = Movie(id, title, posterURL, rating)

                    dataList.add(newMovie)
                }
            } catch (e: JSONException) {
                e.printStackTrace()
            }
            movieViewModel.updateList(dataList)
        }
    }

}