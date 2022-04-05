package com.example.fruits

object FruitData {
    
    val fruitsList = ArrayList<Fruit>()

    init {
        fruitsList.add(Fruit("Apple", R.drawable.apple))
        fruitsList.add(Fruit("Bananas", R.drawable.bananas))
        fruitsList.add(Fruit("Cherries", R.drawable.cherries))
        fruitsList.add(Fruit("DragonFruit", R.drawable.dragonfruit))
        fruitsList.add(Fruit("Durian", R.drawable.durian))
        fruitsList.add(Fruit("Grapes", R.drawable.grapes))
        fruitsList.add(Fruit("Mango", R.drawable.mango))
        fruitsList.add(Fruit("Orange", R.drawable.orange))
        fruitsList.add(Fruit("Watermelon", R.drawable.watermelon))


    }
}