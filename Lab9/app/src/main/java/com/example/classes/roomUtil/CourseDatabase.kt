package com.example.classes.roomUtil

import android.content.Context
import androidx.room.Database
import androidx.room.Room
import androidx.room.RoomDatabase
import com.example.classes.data.Course



@Database(entities = arrayOf(Course::class), version = 1, exportSchema = false)
abstract class CourseDatabase: RoomDatabase() {

    companion object {
        @Volatile
        private var dbInstance: CourseDatabase? = null

        fun getDatabase(context: Context): CourseDatabase {
            if (dbInstance == null) {
                synchronized(CourseDatabase::class) {
                    dbInstance = Room.databaseBuilder(context, CourseDatabase::class.java, "item.db").build()
                }
            }
            return dbInstance!!
        }
    }

    abstract fun courseDao(): CourseDAO
}