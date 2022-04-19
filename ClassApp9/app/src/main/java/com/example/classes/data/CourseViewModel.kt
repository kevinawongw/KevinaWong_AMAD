package com.example.classes.data

import android.content.Context
import androidx.lifecycle.Transformations.map
import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.asLiveData
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.launch

class CourseViewModel(private val dataStoreRepo: DataStoreRepo): ViewModel() {

    val courses = dataStoreRepo.readFromDataStore.asLiveData()
    val coursesList = ArrayList<Course>()

    fun saveCourses(courseName: String, courseCode: String, courseTaughtBy: String){
        viewModelScope.launch(Dispatchers.IO) {
            dataStoreRepo.saveToDataStore(courseName,courseCode,courseTaughtBy)
            coursesList.add(Course(courseName,courseCode,courseTaughtBy))
        }
    }

    fun loadCourses():ArrayList<Course>{
        return coursesList
    }

}

class CourseViewModelFactory(private val dataStoreRepo: DataStoreRepo): ViewModelProvider.Factory{
    override fun <T: ViewModel> create(modelClass: Class<T>):T{
        return CourseViewModel(dataStoreRepo) as T
    }
}
