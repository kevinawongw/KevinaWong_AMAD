package com.example.classes

import CourseViewModel
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.example.classes.CourseAdapter.ViewHolder
import com.google.android.material.snackbar.Snackbar


class CourseAdapter (private val courseViewModel: CourseViewModel): RecyclerView.Adapter<ViewHolder>(){

    private var myCourseList = courseViewModel.courseList.value


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
        val course = myCourseList?.get(position)
        holder.nameTextView.text = course?.name
        holder.courseTextView.text = course?.code
        holder.taughtByTextView.text = course?.taughtBy


        holder.itemView.setOnCreateContextMenuListener(){menu, view, menuInfo ->
            //set the menu title
            menu.setHeaderTitle(R.string.delete)

            //add the choices to the menu
            menu.add(R.string.yes).setOnMenuItemClickListener {
                //remove item from view model
                courseViewModel.delete(course!!)
                Snackbar.make(view, R.string.deleteItem, Snackbar.LENGTH_LONG)
                    .setAction(R.string.action, null).show()
                true
            }
            menu.add(R.string.no)
        }
    }


    fun update(){
        myCourseList = courseViewModel.courseList.value
        notifyDataSetChanged()
    }

    override fun getItemCount(): Int {
        return if (myCourseList != null) {
            myCourseList!!.size
        } else 0
    }




}