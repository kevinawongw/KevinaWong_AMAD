package com.example.classes.data

import android.util.Log
import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.emptyPreferences
import androidx.datastore.preferences.core.stringPreferencesKey
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.catch
import kotlinx.coroutines.flow.map
import java.io.IOException


class DataStoreRepo(private val dataStore: DataStore<Preferences>) {

    private object PreferencesKeys {
        val NAME = stringPreferencesKey("name")
        val CODE = stringPreferencesKey("code")
        val TAUGHTBY = stringPreferencesKey("taughtBy")
    }

    val readFromDataStore: Flow<Course> = dataStore.data
        .catch { exception ->
            if (exception is IOException) {
                Log.d("DataStoreRepository", exception.message.toString())
                emit(emptyPreferences())
            } else {
                throw exception
            }
        }
        .map { preference ->
            val name = preference[PreferencesKeys.NAME] ?: ""
            val code = preference[PreferencesKeys.CODE] ?: ""
            val taughtBy = preference[PreferencesKeys.TAUGHTBY] ?: ""

            Course(name,code,taughtBy)
        }


    suspend fun saveToDataStore(name: String, code: String, taughtby: String){
        dataStore.edit { preference ->
            preference[PreferencesKeys.NAME] = name
            preference[PreferencesKeys.CODE] = code
            preference[PreferencesKeys.TAUGHTBY] = taughtby

            Log.d("=== COURSE ADDED ===", preference[PreferencesKeys.NAME].toString())
            Log.d("* CODE: ", preference[PreferencesKeys.CODE].toString())
            Log.d("* TAUGHT BY:", preference[PreferencesKeys.TAUGHTBY].toString())

        }
    }
}
