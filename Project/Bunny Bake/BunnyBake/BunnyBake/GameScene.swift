
import SpriteKit

class GameScene: SKScene {
  
  var money = 0
  var eggAmount = 0
  var creamAmount = 0
  var wheatAmount = 0
  var milkAmount = 0
  var farmItems: [FarmItem] = []
  var gameData = [String: [String: NSNumber]]()
  
  var moneyLabel = SKLabelNode(fontNamed: "PressStart2P-Regular")
  var milkLabel = SKLabelNode(fontNamed: "PressStart2P-Regular")
  var creamLabel = SKLabelNode(fontNamed: "PressStart2P-Regular")
  var eggLabel = SKLabelNode(fontNamed: "PressStart2P-Regular")
  var wheatLabel = SKLabelNode(fontNamed: "PressStart2P-Regular")

  
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
    
    // Background Music
    let backgroundSound = SKAudioNode(fileNamed: "bg.mp3")
    self.addChild(backgroundSound)
    
    // Inventory Display
    let milk = SKSpriteNode(imageNamed: "milk")
    milk.position = CGPoint(x: size.width - moneyBackground.size.width + 30, y: size.height - moneyBackground.size.height - 50)
    addChild(milk)
    
    // Milk
    milkLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
    milkLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.top
    milkLabel.position = CGPoint(x: size.width - 210, y: size.height - 235)
    milkLabel.fontColor = SKColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
    milkLabel.fontSize = 18
    addChild(milkLabel)
    
    // Cream

    let cream = SKSpriteNode(imageNamed: "cream")
    cream.position = CGPoint(x: size.width - moneyBackground.size.width + 150, y: size.height - moneyBackground.size.height - 50)
    addChild(cream)
    
    creamLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
    creamLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.top
    creamLabel.position = CGPoint(x: size.width - 90, y: size.height - 235)
    creamLabel.fontColor = SKColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
    creamLabel.fontSize = 18
    addChild(creamLabel)
    
    // Wheat
    let wheat = SKSpriteNode(imageNamed: "wheat")
    wheat.position = CGPoint(x: size.width - moneyBackground.size.width + 30, y: size.height - moneyBackground.size.height - 120)
    addChild(wheat)
    
    wheatLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
    wheatLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.top
    wheatLabel.position = CGPoint(x: size.width - 210, y: size.height - 305)
    wheatLabel.fontColor = SKColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
    wheatLabel.fontSize = 18
    addChild(wheatLabel)
    
    // Egg
    let egg = SKSpriteNode(imageNamed: "egg")
    egg.position = CGPoint(x: size.width - moneyBackground.size.width + 150, y: size.height - moneyBackground.size.height - 120)
    addChild(egg)
    
    eggLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
    eggLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.top
    eggLabel.position = CGPoint(x: size.width - 90, y: size.height - 305)
    eggLabel.fontColor = SKColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
    eggLabel.fontSize = 18
    addChild(eggLabel)

    load(dataFile: "playerData.plist")
  }
  
  // MARK: - Load and save plist file
//  func save(dataFile:String) {
//
//  let path = dataFileURL(fileName: "playerData.plist")
//    let objects = [money,milkAmount,creamAmount,wheatAmount,eggAmount] as [Any]
//    let keys = ["money", "wheatAmount","eggAmount", "creamAmount", "milkAmount"]
//    let gameData = NSDictionary(objects: objects, forKeys: keys as [NSCopying])
//    print("+== Writing Money: \(money) ==+")
//    gameData.write(toFile: path!, atomically: true)
//  }
//
  func load(dataFile: String) {
    
    // Get path and read data from path
    let configPath = Bundle.main.path(forResource: "saveData", ofType: "plist")!
    if FileManager.default.fileExists(atPath: configPath){
      let savedData = NSDictionary(contentsOfFile: configPath)
      // Get list of animals and crops
      let itemList = savedData!["stockItemData"] as! [[String: AnyObject]]
      
      // Load Items and Crops
      for item in itemList {
        
        let itemState = item["state"] as! Int
        let itemType = item["type"] as! String
        let itemSpecies = item["species"] as! String
        let itemLastSwitch = item["lastStateSwitchTime"] as! CFAbsoluteTime
        let itemX = item["x"] as! Double
        let itemY = item["y"] as! Double
        let gameConstSettings = (gameData[itemType] as [String: NSNumber]?)!
        
        print("+== Loading in \(itemSpecies)... ==+")
        let loadItem = FarmItem(state: itemState, species: itemSpecies, lastStateSwitchTime: itemLastSwitch, type: itemType, x: itemX, y: itemY, gameConstSettings: gameConstSettings, gameDelegate: self)
        
        loadItem.position = CGPoint(x: Int(Float(itemX) * Float(size.width)), y: Int(Float(itemY) * Float(size.height)))
        addChild(loadItem)
        farmItems.append(loadItem)
      }
    }
    let dataPath = dataFileURL(fileName: "playerData.plist")
    if FileManager.default.fileExists(atPath: dataPath!){
      let savedData = NSDictionary(contentsOfFile: dataPath!)
      money = savedData!["money"] as! Int
      milkAmount = savedData!["milkAmount"] as! Int
      creamAmount = savedData!["creamAmount"] as! Int
      eggAmount = savedData!["eggAmount"] as! Int
      wheatAmount = savedData!["wheatAmount"] as! Int

      moneyLabel.text = String("$\(money)")
      milkLabel.text = String("x\(milkAmount)")
      creamLabel.text = String("x\(creamAmount)")
      eggLabel.text = String("x\(eggAmount)")
      wheatLabel.text = String("x\(wheatAmount)")
    }
    else{
      // First Time Playing
      
      money = 50
      milkAmount = 0
      creamAmount = 0
      eggAmount = 0
      wheatAmount = 0
      moneyLabel.text = String("$\(money)")
      milkLabel.text = String("x\(milkAmount)")
      creamLabel.text = String("x\(creamAmount)")
      eggLabel.text = String("x\(eggAmount)")
      wheatLabel.text = String("x\(wheatAmount)")

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
  
  func save(dataFile:String) {
    
  let path = dataFileURL(fileName: "playerData.plist")
    let objects = [money,milkAmount,creamAmount,eggAmount,wheatAmount] as [Any]
    let keys = ["money", "milkAmount","creamAmount", "eggAmount", "wheatAmount"]
    let gameData = NSDictionary(objects: objects, forKeys: keys as [NSCopying])
    print("+== Writing Money: \(money) ==+")
    gameData.write(toFile: path!, atomically: true)
  }
  
  
  func updateCrop(species: String){
    switch species {
    case "cow":
      milkAmount += 2
      milkLabel.text = String("x\(milkAmount)")
      creamAmount += 2
      creamLabel.text = String("x\(creamAmount)")
    case "chicken":
      eggAmount += 3
      eggLabel.text = String("x\(eggAmount)")

    case "wheat":
      wheatAmount += 5
      wheatLabel.text = String("x\(wheatAmount)")
    default:
      return
    }
  }

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
    moneyLabel.text = String("$\(money)")
      
    return true
  }
  
  override func update(_ currentTime: TimeInterval) {
    for item in farmItems {
      item.update()
//      save(dataFile: "playerData.plist")
    }
  }
}
