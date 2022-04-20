package com.example.classes.roomUtil

import androidx.lifecycle.LiveData
import androidx.room.Dao
import androidx.room.Delete
import androidx.room.Insert
import androidx.room.Query
import com.example.classes.data.Course

@Dao
interface CourseDAO {
    @Query("SELECT * FROM Course ORDER BY name ASC")

    fun getAllItems(): LiveData<List<Course>>

    @Insert
    suspend fun insertItem(item: Course)

    @Delete
    suspend fun deleteItem(item: Course)

    @Query("DELETE FROM Course")
    suspend fun deleteAll()
}
