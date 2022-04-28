package com.example.classes.roomUtil
import com.example.classes.data.Course
import com.firebase.ui.firestore.FirestoreRecyclerOptions
import com.google.firebase.firestore.FirebaseFirestore


class CourseDatabase {

    private val db = FirebaseFirestore.getInstance()
    private val coursesRef = db.collection("courses")

    fun getOptions(): FirestoreRecyclerOptions<Course> {
        val query = coursesRef
        val options = FirestoreRecyclerOptions.Builder<Course>()
            .setQuery(query, Course::class.java)
            .build()
        return options
    }

    fun add(course: Course){
        coursesRef.add(course)
    }

    fun delete(id: String){
        coursesRef.document(id).delete()
    }
}