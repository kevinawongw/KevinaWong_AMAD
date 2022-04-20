package com.example.classes

import CourseViewModel
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.view.View
import android.widget.EditText
import android.widget.LinearLayout
import androidx.activity.viewModels
import com.google.android.material.floatingactionbutton.FloatingActionButton
import com.google.android.material.snackbar.Snackbar
import androidx.lifecycle.Observer
import androidx.recyclerview.widget.DividerItemDecoration
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.example.classes.data.Course
import com.google.android.material.tabs.TabLayout





class MainActivity : AppCompatActivity() {

    private val viewModel: CourseViewModel by viewModels()

    private lateinit var name: EditText
    private lateinit var code: EditText
    private lateinit var taughtBy: EditText
    private lateinit var tabLayout: TabLayout
    private lateinit var addLayout: LinearLayout
    private lateinit var viewLayout: LinearLayout
    private lateinit var totalView: LinearLayout
    private var curNameInput = ""
    private var curCodeInput = ""
    private var curTaughtBy = ""
    private var tabNum = 0


    override fun onCreate(savedInstanceState: Bundle?) {

        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)


        name = findViewById(R.id.courseNameInput)
        code = findViewById(R.id.courseCodeInput)
        taughtBy = findViewById(R.id.taughtByInput)
        tabLayout = findViewById(R.id.tabLayout)
        addLayout = findViewById(R.id.addLayout)
        viewLayout = findViewById(R.id.viewLayout)
        totalView = findViewById(R.id.totalView)

        totalView.removeAllViews()
        totalView.addView(tabLayout,0)
        totalView.addView(viewLayout,1)
        findViewById<FloatingActionButton>(R.id.fab).visibility = View.INVISIBLE

        Log.i("== VIEWS ==", "Loaded")

        /*
       RECYCLER VIEW
        */

        val recyclerView: RecyclerView = findViewById(R.id.recyclerView)
        recyclerView.addItemDecoration(DividerItemDecoration(this, LinearLayoutManager.VERTICAL))
        recyclerView.layoutManager = LinearLayoutManager(this, LinearLayoutManager.VERTICAL, false)
        val adapter = CourseAdapter(viewModel)
        recyclerView.adapter = adapter


        /*
        Listeners
         */


//        name.doOnTextChanged { text, start, before, count ->  } {
//            curNameInput = name.text.toString()
//            Log.i("==CHANGED==", curNameInput)
//        }
//
//        code.do {
//            curCodeInput = code.text.toString()
//        }
//
//        taughtBy.doAfterTextChanged {
//            curTaughtBy = taughtBy.text.toString()
//        }

        findViewById<FloatingActionButton>(R.id.fab).setOnClickListener{ view ->
            val myName = name.text.toString()
            val myCode = code.text.toString()
            val myTeach = taughtBy.text.toString()
            viewModel.add(Course(0,myName, myCode, myTeach))
            Snackbar.make(view, R.string.saved, Snackbar.LENGTH_LONG).show()
        }

        viewModel.courseList.observe(this, Observer { courses ->
            adapter.update()
        })

        tabLayout.addOnTabSelectedListener(object : TabLayout.OnTabSelectedListener {

            override fun onTabSelected(tab: TabLayout.Tab?) {
                if (tab!!.position == 0){
                    Log.i("== TAB CHANGED ==", tab.position.toString())

                    totalView.removeAllViews()
                    findViewById<FloatingActionButton>(R.id.fab).visibility = View.INVISIBLE
                    totalView.addView(tabLayout,0)
                    viewLayout.visibility = View.VISIBLE
                    totalView.addView(viewLayout,1)
                    tabNum = tab.position

                }
                else if (tab.position == 1){
                    Log.i("== TAB CHANGED ==", tab.position.toString())

                    totalView.removeAllViews()
                    findViewById<FloatingActionButton>(R.id.fab).visibility = View.VISIBLE
                    totalView.addView(tabLayout,0)
                    addLayout.visibility = View.VISIBLE
                    totalView.addView(addLayout,1)
                    tabNum = tab.position
                }
            }

            override fun onTabUnselected(tab: TabLayout.Tab?) {
            }

            override fun onTabReselected(tab: TabLayout.Tab?) {
            }

        })

    }

    // SAVE STATE FOR TAB INDEX, INPUTS
    fun updateView(){

        if (tabNum == 0){

            totalView.removeAllViews()

            findViewById<FloatingActionButton>(R.id.fab).visibility = View.INVISIBLE
            totalView.addView(tabLayout,0)
            viewLayout.visibility = View.VISIBLE
            totalView.addView(viewLayout,1)
            val tab = tabLayout.getTabAt(tabNum)
            tab!!.select()
        }
        else if (tabNum == 1){

            totalView.removeAllViews()
            findViewById<FloatingActionButton>(R.id.fab).visibility = View.VISIBLE
            totalView.addView(tabLayout,0)
            addLayout.visibility = View.VISIBLE
            totalView.addView(addLayout,1)
            val tab = tabLayout.getTabAt(tabNum)
            tab!!.select()
        }

        name.setText(curNameInput)
        code.setText(curCodeInput)
        taughtBy.setText(curTaughtBy)
    }

    override fun onSaveInstanceState(outState: Bundle) {
        tabNum.let{outState.putInt("selectedTab", it)}
        name.text.toString().let { outState.putString("curName",it)}
        code.text.toString().let { outState.putString("curCode",it)}
        taughtBy.text.toString().let { outState.putString("curTaughtBy",it)}
        super.onSaveInstanceState(outState)
    }

    override fun onRestoreInstanceState(savedInstanceState: Bundle) {
        super.onRestoreInstanceState(savedInstanceState)
        tabNum = savedInstanceState.getInt("selectedTab")
        curNameInput = savedInstanceState.getString("curName")!!
        curCodeInput = savedInstanceState.getString("curCode")!!
        curTaughtBy = savedInstanceState.getString("curTaughtBy")!!
        updateView()
    }



}