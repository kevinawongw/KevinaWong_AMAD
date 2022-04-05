package com.example.fruits.ui.slideshow

import android.content.Intent
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageButton
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProvider
import com.example.fruits.DetailFruit
import com.example.fruits.FruitData
import com.example.fruits.R
import com.example.fruits.databinding.FragmentSlideshowBinding

class SlideshowFragment : Fragment() {

    private lateinit var slideshowViewModel: SlideshowViewModel
    private var _binding: FragmentSlideshowBinding? = null
    private val binding get() = _binding!!

    lateinit var appleImageButton: ImageButton
    lateinit var bananaImageButton: ImageButton
    lateinit var cherryImageButton: ImageButton
    lateinit var dragonFruitImageButton: ImageButton
    lateinit var durianImageButton: ImageButton
    lateinit var grapeImageButton: ImageButton
    lateinit var mangoImageButton: ImageButton
    lateinit var orangeImageButton: ImageButton
    lateinit var watermelonImageButton: ImageButton


    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {

        slideshowViewModel =
            ViewModelProvider(this).get(SlideshowViewModel::class.java)
        _binding = FragmentSlideshowBinding.inflate(inflater, container, false)

        val root: View = binding.root

        appleImageButton = root.findViewById(R.id.appleImage)
        appleImageButton.setOnClickListener {
            imageClicked(appleImageButton)
        }
        bananaImageButton = root.findViewById(R.id.bananaImage)
        bananaImageButton.setOnClickListener {
            imageClicked(bananaImageButton)
        }
        cherryImageButton = root.findViewById(R.id.cherryImage)
        cherryImageButton.setOnClickListener {
            imageClicked(cherryImageButton)
        }
        dragonFruitImageButton = root.findViewById(R.id.dragonFruitItmage)
        dragonFruitImageButton.setOnClickListener {
            imageClicked(dragonFruitImageButton)
        }
        durianImageButton = root.findViewById(R.id.durianImage)
        durianImageButton.setOnClickListener {
            imageClicked(durianImageButton)
        }
        grapeImageButton = root.findViewById(R.id.grapeImage)
        grapeImageButton.setOnClickListener {
            imageClicked(grapeImageButton)
        }
        mangoImageButton = root.findViewById(R.id.mangoImage)
        mangoImageButton.setOnClickListener {
            imageClicked(mangoImageButton)
        }
        orangeImageButton = root.findViewById(R.id.orangeImage)
        orangeImageButton.setOnClickListener {
            imageClicked(orangeImageButton)
        }
        watermelonImageButton = root.findViewById(R.id.watermelonImage)
        watermelonImageButton.setOnClickListener {
            imageClicked(watermelonImageButton)
        }

        return root
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }

    fun imageClicked(view: android.view.View){

        var fruitList = FruitData.fruitsList
        var index = -1

        when (view) {
            appleImageButton -> index = 0
            bananaImageButton -> index = 1
            cherryImageButton -> index = 2
            dragonFruitImageButton -> index = 3
            durianImageButton -> index = 4
            grapeImageButton -> index = 5
            mangoImageButton -> index = 6
            orangeImageButton -> index = 7
            watermelonImageButton -> index = 8
        }

        val intent = Intent(this.context, DetailFruit::class.java)
        intent.putExtra("name", fruitList[index].name)
        intent.putExtra("resourceID", fruitList[index].imageID)

        startActivity(intent)
    }
}