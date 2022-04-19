package com.example.classes

import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.lifecycle.LiveData
import androidx.recyclerview.widget.RecyclerView
import com.example.classes.data.Course
import com.example.classes.CourseAdapter.ViewHolder


class CourseAdapter (private val courseList: ArrayList<Course>): RecyclerView.Adapter<ViewHolder>(){

    class ViewHolder(view: View): RecyclerView.ViewHolder(view) {
        val nameTextView: TextView = view.findViewById(R.id.courseNameTextVIew)
        val courseTextView: TextView = view.findViewById(R.id.courseCodeTextView)
        val taughtByTextView: TextView = view.findViewById(R.id.taughtByTextView)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val layoutInflater = LayoutInflater.from(parent.context)
        val itemViewHolder = layoutInflater.inflate(R.layout.list_item, parent, false)
        return ViewHolder(itemViewHolder)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val course = courseList.get(position)
        Log.d("=== RECYCLE ===", course.code)
        holder.nameTextView.text = course.name
        holder.courseTextView.text = course.code
        holder.taughtByTextView.text = course.taughtBy
    }

    override fun getItemCount() = courseList.size


}