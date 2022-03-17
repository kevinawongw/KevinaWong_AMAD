
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
    
    loadGameData()
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
  
  func loadGameData() {
    
    // Get path and read data from path
    let path = Bundle.main.path(forResource: "saveData", ofType: "plist")!
    let savedData = NSDictionary(contentsOfFile: path)
    print("=== READING FROM \(String(describing: path)) \(String(describing: savedData)) ===")
    
    
    gameData = savedData!["stockItemConfigurations"] as! [String: [String: NSNumber]]
    money = savedData!["money"] as! Int
    moneyLabel.text = String("$\(money)")
    
    // Get list of animals and crops
    let itemList = savedData!["stockItemData"] as! [[String: AnyObject]]
    
    // Load Items and Crops
    for item in itemList {
      let itemType = item["type"] as AnyObject? as! String
      let stockItemConfiguration = gameData[itemType] as [String: NSNumber]?
      let loadItem  = FarmItem(stockItemData: item, stockItemConfiguration: stockItemConfiguration!, gameDelegate: self)
      let relativeX = Float(item["x"] as AnyObject? as! Double)
      let relativeY = Float(item["y"] as AnyObject? as! Double)
      loadItem.position = CGPoint(x: Int(relativeX * Float(size.width)), y: Int(relativeY * Float(size.height)))
      addChild(loadItem)
      farmItems.append(loadItem)
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
    moneyLabel.text = String(format: "%i $", money)
    
    return true
  }

  
  override func update(_ currentTime: TimeInterval) {
    for item in farmItems {
      item.update()
    }
  }
}
