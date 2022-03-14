//  StateImageHandler.swift
//  Bunny Bake
//
//  Created by Kevina Wong on 3/5/22.

import Foundation
import SpriteKit

class StateImageHandler {
  
  /*
   Variables
   */
  var node : SKNode
  private var current = SKSpriteNode()
  private let sprites: [SKTexture]
  
  /*
  Initialize -
  1. Fill sprite image for every stage

  Empty -> spritesTemp[0]
  Planting -> spriteTemp[1]
  Harvest -> spriteTemp[2]

  Waiting Cows -> spriteTemp[0]
  Cows Harvest -> spriteTemp[1]
  Waiting Chickens -> spriteTemp[1]
  Chickens Harvest -> spriteTemp[2]
   */
  
  init(type:String) {
    node = SKNode()
    var spritesTemp = [SKTexture]()
    
    if type == "plant"{
      let imageNames: [String] = ["farm_empty", "farm_planting", "farm_harvest"]
      
      for i in imageNames {
        let image : UIImage? = UIImage(named: i)
        if image != nil {
          spritesTemp.append(SKTexture(image: image!))
        }
      }
    }
    else {
      let imageNames: [String] = ["cow_waiting", "cow_harvest", "chicken_waiting", "chicken_harvest"]
      
      for i in imageNames {
        let image : UIImage? = UIImage(named: i)
        if image != nil {
          spritesTemp.append(SKTexture(image: image!))
        }
    }
    

    }
    
    sprites = spritesTemp
    current = SKSpriteNode(texture: spritesTemp[0])
    current.zPosition = CGFloat(ZPosition.stockItemsBackground.rawValue)
    node.addChild(current)
    updateImagefromStage(stage: 0)
    
  }
  
  /*
   Update image depending on stage
   
   For Plants:
   Empty -> spritesTemp[0]
   Planting -> spriteTemp[1]
   Harvest -> spriteTemp[2]

   For Animals:
   Waiting Cows -> spriteTemp[0]
   Cows Harvest -> spriteTemp[1]
   Waiting Chickens -> spriteTemp[1]
   Chickens Harvest -> spriteTemp[2]
   */
  func updateImagefromStage(stage: Int) {
      let texture = sprites[stage]
      current.texture = texture
  }
  
}
