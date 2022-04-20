package com.example.classes.roomUtil

import androidx.lifecycle.LiveData
import com.example.classes.data.Course


class CourseRepository(private val courseDAO: CourseDAO) {

    val courseList: LiveData<List<Course>> = courseDAO.getAllItems()

    suspend fun insertItem(course: Course) {
        courseDAO.insertItem(course)
    }

    suspend fun deleteItem(course: Course) {
        courseDAO.deleteItem(course)
    }

    suspend fun deleteAll() {
        courseDAO.deleteAll()
    }
}