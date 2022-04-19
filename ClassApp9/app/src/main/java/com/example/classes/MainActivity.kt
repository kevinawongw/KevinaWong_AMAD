package com.example.classes

import android.content.Context
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.view.View
import android.widget.LinearLayout
import android.widget.TextView
import androidx.datastore.preferences.preferencesDataStore
import androidx.lifecycle.ViewModelProvider
import com.example.classes.data.CourseViewModel
import com.example.classes.data.CourseViewModelFactory
import com.example.classes.data.DataStoreRepo
import com.google.android.material.floatingactionbutton.FloatingActionButton
import com.google.android.material.snackbar.Snackbar
import androidx.lifecycle.Observer
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView

import com.google.android.material.tabs.TabLayout

private val Context.dataStore by preferencesDataStore(name =  "courses")

class MainActivity : AppCompatActivity() {

    private lateinit var viewModel: CourseViewModel
    private lateinit var name: TextView
    private lateinit var code: TextView
    private lateinit var taughtBy: TextView
    private lateinit var tabLayout: TabLayout
    private lateinit var addLayout: LinearLayout
    private lateinit var viewLayout: LinearLayout

    override fun onCreate(savedInstanceState: Bundle?) {

        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        viewModel = ViewModelProvider(this,
            CourseViewModelFactory(DataStoreRepo(dataStore)))[CourseViewModel::class.java]
        Log.i("== VIEW MODEL ==", "Loaded")


        name = findViewById(R.id.courseCodeInput)
        code = findViewById(R.id.courseCodeInput)
        taughtBy = findViewById(R.id.taughtByInput)
        tabLayout = findViewById(R.id.tabLayout)
        addLayout = findViewById(R.id.addLayout)
        viewLayout = findViewById(R.id.viewLayout)

        addLayout.visibility = View.INVISIBLE

        Log.i("== VIEWS ==", "Loaded")

        /*
       RECYCLER VIEW
        */

        val recyclerView: RecyclerView = findViewById(R.id.recyclerView)

        recyclerView.layoutManager = LinearLayoutManager(this, LinearLayoutManager.VERTICAL, false)
        val adapter = CourseAdapter(viewModel.loadCourses())
        recyclerView.adapter = adapter

        /*
        Listeners
         */

        findViewById<FloatingActionButton>(R.id.fab).setOnClickListener{ view ->
            val myName = name.text.toString()
            val myCode = code.text.toString()
            val myTeach = taughtBy.text.toString()
            viewModel.saveCourses(myName, myCode, myTeach)
            Snackbar.make(view, R.string.saved, Snackbar.LENGTH_LONG).show()
            Log.i("== CURRENTLY HAVE ==", viewModel.loadCourses().size.toString())
        }

        viewModel.courses.observe(this, Observer { courses ->
            name.text = courses.name
            code.text = courses.code
            taughtBy.text = courses.taughtBy
        })

        tabLayout.addOnTabSelectedListener(object : TabLayout.OnTabSelectedListener {

            override fun onTabSelected(tab: TabLayout.Tab?) {
                if (tab!!.position == 0){
                    Log.i("== TAB CHANGED ==", tab.position.toString())

                    viewLayout.visibility = View.VISIBLE
                    addLayout.visibility = View.INVISIBLE
                }
                else if (tab.position == 1){
                    Log.i("== TAB CHANGED ==", tab.position.toString())

                    viewLayout.visibility = View.INVISIBLE
                    addLayout.visibility = View.VISIBLE
                }
            }

            override fun onTabReselected(tab: TabLayout.Tab?) {
                // Handle tab reselect
            }

            override fun onTabUnselected(tab: TabLayout.Tab?) {
                // Handle tab unselect
            }
        })

    }


}