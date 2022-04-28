package com.example.classes

import CourseViewModel
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.example.classes.CourseAdapter.ViewHolder
import com.example.classes.data.Course
import com.firebase.ui.firestore.FirestoreRecyclerAdapter
import com.firebase.ui.firestore.FirestoreRecyclerOptions
import com.google.android.material.snackbar.Snackbar


class CourseAdapter(options: FirestoreRecyclerOptions<Course>, private val courseViewModel: CourseViewModel) : FirestoreRecyclerAdapter<Course, CourseAdapter.ViewHolder>(options)  {

    class ViewHolder(view: View): RecyclerView.ViewHolder(view) {

        val nameTextView: TextView = view.findViewById(R.id.courseNameTextVIew)
        val courseTextView: TextView = view.findViewById(R.id.courseCodeTextView)
        val taughtByTextView: TextView = view.findViewById(R.id.taughtByTextView)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): CourseAdapter.ViewHolder {
        val layoutInflater = LayoutInflater.from(parent.context)
        val recipeViewHolder = layoutInflater.inflate(R.layout.list_item, parent, false)
        return ViewHolder(recipeViewHolder)
    }

    override fun onBindViewHolder(holder: CourseAdapter.ViewHolder, position: Int, model: Course) {

        holder.nameTextView.text = model.name
        holder.courseTextView.text = model.code
        holder.taughtByTextView.text = model.taughtBy


        holder.itemView.setOnCreateContextMenuListener(){menu, view, menuInfo ->
            menu.setHeaderTitle(R.string.delete)
            menu.add(R.string.yes).setOnMenuItemClickListener {
                val id = snapshots.getSnapshot(position).id
                courseViewModel.delete(id)
                Snackbar.make(view, R.string.delete, Snackbar.LENGTH_LONG)
                    .setAction(R.string.action, null).show()
                true
            }
            menu.add(R.string.no)
        }

    }
}
