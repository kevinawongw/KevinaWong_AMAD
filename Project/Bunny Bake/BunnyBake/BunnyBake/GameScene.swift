
import SpriteKit

class GameScene: SKScene {
  
  var money = 0
  var farmItems: [FarmItem] = []
  var gameData = [String: [String: NSNumber]]()
  
  var moneyLabel = SKLabelNode(fontNamed: "PressStart2P-Regular")
  
  override func didMove(to view: SKView) {
    
    // Background
    let background = SKSpriteNode(imageNamed: "plant_background")
    background.position = CGPoint(x: size.width/2, y: size.height/2)
    addChild(background)
    
    // Money Display
    let moneyBackground = SKSpriteNode(imageNamed: "money_background")
    moneyBackground.position = CGPoint(x: size.width - moneyBackground.size.width/2 - 10, y: size.height - moneyBackground.size.height/2 - 13)
    addChild(moneyBackground)
    
    moneyLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
    moneyLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.top
    moneyLabel.position = CGPoint(x: size.width - 60, y: size.height - 90)
    moneyLabel.fontColor = SKColor(red: 77/255.0, green: 44/255.0, blue: 11/255.0, alpha: 0.8)
    moneyLabel.fontSize = 40
    addChild(moneyLabel)
    
    load()
  }
  
  // MARK: - Load and save plist file
//  @objc func saveGameData() {
//    let path = documentFilePath(fileName: "../plist/gamedata.plist")
//    let farmData = NSMutableArray()
//    for farmItem : FarmItem in farmItems {
//      farmData.add(farmItem.data())
//    }
//    var stockItemConfigurationsObjects = [AnyObject]()
//    var stockItemConfigurationsKeys = [NSCopying]()
//    for (key, stockItemConfiguration) in stockItemConfigurations {
//      stockItemConfigurationsKeys.append(key as NSCopying)
//      stockItemConfigurationsObjects.append(stockItemConfiguration as AnyObject)
//
//    }
//
//    let stockItemConfigurationsNSDictionary = NSDictionary(objects: stockItemConfigurationsObjects, forKeys: stockItemConfigurationsKeys)
//    let objects = [stockItemConfigurationsNSDictionary, money, farmData] as [Any]
//    let keys = ["stockItemConfigurations", "money", "stockItemData"]
//    let gameData = NSDictionary(objects: objects, forKeys: keys as [NSCopying])
//    gameData.write(toFile: path, atomically: true)
//  }
  
//  func save(){
//    let path = Bundle.main.path(forResource: "saveData", ofType: "plist")!
//    if FileManager.default.fileExists(atPath: path){
//      game
//    }
//
//  }
//
  func load() {
    
    // Get path and read data from path
    let path = Bundle.main.path(forResource: "saveData", ofType: "plist")!
    if FileManager.default.fileExists(atPath: path){
      let savedData = NSDictionary(contentsOfFile: path)
  
      money = savedData!["money"] as! Int
      moneyLabel.text = String("$\(money)")
      
      // Get list of animals and crops
      let itemList = savedData!["stockItemData"] as! [[String: AnyObject]]
      
      // Load Items and Crops
      for item in itemList {
        
        let itemState = item["state"] as! Int
        let itemType = item["type"] as! String
        let itemAmount = item["amount"] as! Int
        let itemSpecies = item["species"] as! String
        let itemLastSwitch = item["lastStateSwitchTime"] as! CFAbsoluteTime
        let itemX = item["x"] as! Double
        let itemY = item["y"] as! Double
        let gameConstSettings = (gameData[itemType] as [String: NSNumber]?)!
        
        print("+== Loading in \(itemSpecies)... ==+")
        let loadItem = FarmItem(state: itemState, species: itemSpecies, amount: itemAmount, lastStateSwitchTime: itemLastSwitch, type: itemType, x: itemX, y: itemY, gameConstSettings: gameConstSettings, gameDelegate: self)
        
        loadItem.position = CGPoint(x: Int(Float(itemX) * Float(size.width)), y: Int(Float(itemY) * Float(size.height)))
        addChild(loadItem)
        farmItems.append(loadItem)
      }
    }
  }
  
  func dataFileURL(fileName: String) -> String? {
    let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let url = urls.first?.appendingPathComponent(fileName)
    return url?.path
  }
  
  
}

// MARK: - GameDelegate
extension GameScene: GameDelegate {
  
  func updateMoney(by delta: Int) -> Bool {
    if money + delta < 0 {
      return false
    }
    let deltaLabel = SKLabelNode(fontNamed: "TrebuchetMS-Bold")
    if delta < 0 {
      deltaLabel.fontColor = SKColor(red: 244/255.0, green: 80/255.0, blue: 80/255.0, alpha: 1.0)
    } else {
      deltaLabel.fontColor = SKColor(red: 156/255.0, green: 179/255.0, blue: 207/255.0, alpha: 1.0)
    }
    deltaLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
    deltaLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.bottom
    deltaLabel.position = moneyLabel.position
    deltaLabel.text = String(format: "%i $", delta)
    deltaLabel.fontSize = moneyLabel.fontSize
    deltaLabel.zPosition = CGFloat(ZPosition.HUDForeground.rawValue)
    addChild(deltaLabel)
    
    let moveLabelAction = SKAction.move(by: CGVector(dx: 0, dy: 20), duration: 0.5)
    let fadeLabelAction = SKAction.fadeOut(withDuration: 0.5)
    let labelAction = SKAction.group([moveLabelAction, fadeLabelAction])
    deltaLabel.run(labelAction, completion: {deltaLabel.removeFromParent()})
    
    money += delta
    moneyLabel.text = String("$ \(money)")
    
    return true
  }

  
  override func update(_ currentTime: TimeInterval) {
    for item in farmItems {
      item.update()
    }
  }
}
