
import SpriteKit

class GameScene: SKScene {
  
  var money = 0
  var farmItems: [FarmItem] = []
  var stockItemConfigurations = [String: [String: NSNumber]]()
  
  var moneyLabel = SKLabelNode(fontNamed: "PressStart2P-Regular")
  
  override func didMove(to view: SKView) {
    NotificationCenter.default.addObserver(self, selector: #selector(saveGameData), name: NSNotification.Name(rawValue: "saveGameData"), object: nil)
    
    // Background
    let background = SKSpriteNode(imageNamed: "plant_background")
    background.position = CGPoint(x: size.width/2, y: size.height/2)
    background.zPosition = CGFloat(ZPosition.background.rawValue)
    addChild(background)
    
    // Money Display
    let moneyBackground = SKSpriteNode(imageNamed: "money_background")
    moneyBackground.position = CGPoint(x: size.width - moneyBackground.size.width/2 - 10, y: size.height - moneyBackground.size.height/2 - 13)
    moneyBackground.zPosition = CGFloat(ZPosition.HUDBackground.rawValue)
    addChild(moneyBackground)
    
    moneyLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
    moneyLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.top
    moneyLabel.position = CGPoint(x: size.width - 60, y: size.height - 90)
    moneyLabel.fontColor = SKColor(red: 77/255.0, green: 44/255.0, blue: 11/255.0, alpha: 0.8)
    moneyLabel.fontSize = 40
    moneyLabel.zPosition = CGFloat(ZPosition.HUDForeground.rawValue)
    addChild(moneyLabel)
    
    loadGameData()
  }
  
  // MARK: - Load and save plist file
  @objc func saveGameData() {
    let path = documentFilePath(fileName: "../plist/gamedata.plist")
    let farmData = NSMutableArray()
    for farmItem : FarmItem in farmItems {
      farmData.add(farmItem.data())
    }
    var stockItemConfigurationsObjects = [AnyObject]()
    var stockItemConfigurationsKeys = [NSCopying]()
    for (key, stockItemConfiguration) in stockItemConfigurations {
      stockItemConfigurationsKeys.append(key as NSCopying)
      stockItemConfigurationsObjects.append(stockItemConfiguration as AnyObject)

    }
    
    let stockItemConfigurationsNSDictionary = NSDictionary(objects: stockItemConfigurationsObjects, forKeys: stockItemConfigurationsKeys)
    let objects = [stockItemConfigurationsNSDictionary, money, farmData] as [Any]
    let keys = ["stockItemConfigurations", "money", "stockItemData"]
    let gameData = NSDictionary(objects: objects, forKeys: keys as [NSCopying])
    gameData.write(toFile: path, atomically: true)
  }
  
  func loadGameData() {
    var path = documentFilePath(fileName: "../plist/gamedata.plist")
    var gameData : NSDictionary? = NSDictionary(contentsOfFile: path)
    // Load gamedata template from mainBundle if no saveFile exists
    if gameData == nil {
      let mainBundle = Bundle.main
      path = mainBundle.path(forResource: "gamedata", ofType: "plist")!
      gameData = NSDictionary(contentsOfFile: path)
    }
    
    stockItemConfigurations = gameData!["stockItemConfigurations"] as! [String: [String: NSNumber]]
    money = gameData!["money"] as! Int
    moneyLabel.text = String(format: "%i $", money)
    let stockItemDataSet = gameData!["stockItemData"] as! [[String: AnyObject]]
    for stockItemData in stockItemDataSet {
      let itemType = stockItemData["type"] as AnyObject? as! String
      let stockItemConfiguration = stockItemConfigurations[itemType] as [String: NSNumber]?
      let stockItem  = FarmItem(stockItemData: stockItemData, stockItemConfiguration: stockItemConfiguration!, gameDelegate: self)
      let relativeX = Float(stockItemData["x"] as AnyObject? as! Double)
      let relativeY = Float(stockItemData["y"] as AnyObject? as! Double)
      stockItem.position = CGPoint(x: Int(relativeX * Float(size.width)), y: Int(relativeY * Float(size.height)))
      addChild(stockItem)
      farmItems.append(stockItem)
    }
  }
  
  func documentFilePath(fileName: String) -> String {
    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let fileURL = documentsURL.appendingPathComponent(fileName)
    return fileURL.path
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
