import SpriteKit

class FarmItem: SKNode {
  
  // "Animal" or "Plant"
  let type: String
  let species: String
  private var amount: Int
  var state: State
  private var lastStateSwitchTime: CFAbsoluteTime
  var x: Double
  var y: Double

  
  private let maxAmount: Int
  private let relativeX: Float
  private let relativeY: Float
  private let stockingSpeed: Float
  private let sellingSpeed: Float
  private let stockingPrice: Int
  private let sellingPrice: Int
  let itemPosition: CGPoint
  
  private var gameDelegate: GameDelegate
  
  private var timer = SKLabelNode(fontNamed: "PressStart2P-Regular")
  private var stateImageHandler: StateImageHandler
  private var plantButton = SKSpriteNode(imageNamed: "plant_button")
  
  init(state: Int, species: String, amount: Int, lastStateSwitchTime: CFAbsoluteTime, type: String, x: Double, y: Double, gameConstSettings: [String: NSNumber], gameDelegate: GameDelegate){
    
    self.gameDelegate = gameDelegate
    self.species = species
    self.amount = amount
    self.lastStateSwitchTime = lastStateSwitchTime
    self.type = type
    self.state = State(rawValue: state)!
    self.x = x
    self.y = y
    self.relativeX = Float(x)
    self.relativeY = Float(y)
    
    maxAmount = (gameConstSettings["maxAmount"]?.intValue)!
    stockingSpeed = (gameConstSettings["stockingSpeed"]?.floatValue)! * TimeScale
    sellingSpeed = (gameConstSettings["sellingSpeed"]?.floatValue)! * TimeScale
    stockingPrice = (gameConstSettings["stockingPrice"]?.intValue)!
    sellingPrice = (gameConstSettings["sellingPrice"]?.intValue)!
    
    var relativeTimerPositionX: Float? = gameConstSettings["timerPositionX"]?.floatValue
    if relativeTimerPositionX == nil {
      relativeTimerPositionX = Float(0.0)
    }
    var relativeTimerPositionY: Float? = gameConstSettings["timerPositionY"]?.floatValue
    if relativeTimerPositionY == nil {
      relativeTimerPositionY = Float(0.0)
    }
        
    stateImageHandler = StateImageHandler(type: type)
    itemPosition = CGPoint(x: Int(relativeX * Float(stateImageHandler.node.calculateAccumulatedFrame().size.width)), y: Int(relativeY * Float(stateImageHandler.node.calculateAccumulatedFrame().size.height)))
    
    super.init()
    setupPriceLabel()
    setupTimer(relativeX: relativeTimerPositionX!, relativeY: relativeTimerPositionY!)
    
    addChild(stateImageHandler.node)
    isUserInteractionEnabled = true
    
    if type == "plant"{
      addChild(plantButton)
    }
    addChild(timer)
    switchTo(state: self.state)

    
  }
  
//  init(stockItemData: [String: AnyObject], stockItemConfiguration: [String: NSNumber], gameDelegate: GameDelegate) {
//
//    self.gameDelegate = gameDelegate
//
//    // initialize item from data
//    // instead of loadValuesWithData method
//    maxAmount = (stockItemConfiguration["maxAmount"]?.intValue)!
//    stockingSpeed = (stockItemConfiguration["stockingSpeed"]?.floatValue)! * TimeScale
//    sellingSpeed = (stockItemConfiguration["sellingSpeed"]?.floatValue)! * TimeScale
//    stockingPrice = (stockItemConfiguration["stockingPrice"]?.intValue)!
//    sellingPrice = (stockItemConfiguration["sellingPrice"]?.intValue)!
//
//    type = stockItemData["type"] as! String
//    amount = stockItemData["amount"] as! Int
//    relativeX = Float(stockItemData["x"] as! Double)
//    relativeY = Float(stockItemData["y"] as! Double)
//    let stateNum = Float(stockItemData["state"] as! Double)
//    stateAsInt = Int(stateNum)
//
//    var relativeTimerPositionX: Float? = stockItemConfiguration["timerPositionX"]?.floatValue
//    if relativeTimerPositionX == nil {
//      relativeTimerPositionX = Float(0.0)
//    }
//    var relativeTimerPositionY: Float? = stockItemConfiguration["timerPositionY"]?.floatValue
//    if relativeTimerPositionY == nil {
//      relativeTimerPositionY = Float(0.0)
//    }
//
//    species = stockItemData["species"] as! String
//
//    stateImageHandler = StateImageHandler(type: type)
//
//    state = State(rawValue: stateAsInt)!
//    lastStateSwitchTime = stockItemData["lastStateSwitchTime"] as AnyObject? as! CFAbsoluteTime
//
//    itemPosition = CGPoint(x: Int(relativeX * Float(stateImageHandler.node.calculateAccumulatedFrame().size.width)), y: Int(relativeY * Float(stateImageHandler.node.calculateAccumulatedFrame().size.height)))
//
//
//    super.init()
//    setupPriceLabel()
//    setupTimer(relativeX: relativeTimerPositionX!, relativeY: relativeTimerPositionY!)
//
//    addChild(stateImageHandler.node)
//    isUserInteractionEnabled = true
//
//    if type == "plant"{
//      addChild(plantButton)
//    }
//    addChild(timer)
//    switchTo(state: state)
//
//  }
//
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupPriceLabel() {
    // Create price label tag
      let plantLabel = SKLabelNode(fontNamed: "TrebuchetMS-Bold")
      plantLabel.fontSize = 24
      plantLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
      plantLabel.fontColor = SKColor.black
      plantLabel.zPosition = CGFloat(ZPosition.HUDForeground.rawValue)
      plantButton.zPosition = CGFloat(ZPosition.HUDBackground.rawValue)
      plantButton.addChild(plantLabel)
    }
  
  func setupTimer(relativeX: Float, relativeY: Float) {
    // Create stocking Timer
    timer.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
    timer.fontSize = 20
    timer.fontColor = SKColor(red:255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
    timer.position = CGPoint(x: Int(relativeX * Float(stateImageHandler.node.calculateAccumulatedFrame().size.width)), y: Int(relativeY * Float(stateImageHandler.node.calculateAccumulatedFrame().size.height)))
    timer.zPosition = CGFloat(ZPosition.HUDForeground.rawValue)
  }
  
  // MARK: - Write dictionary for storage of StockItem
  func data() -> NSDictionary {
    let data = NSMutableDictionary()
    data["type"] = type
    data["species"] = species
    data["amount"] = amount
    data["x"] = relativeX
    data["y"] = relativeY
    data["lastStateSwitchTime"] = lastStateSwitchTime
    data["state"] = lastStateSwitchTime
    return data
  }
  
  func switchTo(state: State) {
    if self.state != state {
      lastStateSwitchTime = CFAbsoluteTimeGetCurrent()
    }

    self.state = state
    if type == "plant"{
      switch state {
      case .empty:
        timer.isHidden = true
        plantButton.isHidden = false
        stateImageHandler.updateImagefromStage(stage: 0)
      case .planting:
        timer.isHidden = false
        plantButton.isHidden = true
        stateImageHandler.updateImagefromStage(stage: 1)

      case .harvest:
        timer.isHidden = true
        plantButton.isHidden = true
        stateImageHandler.updateImagefromStage(stage: 2)
      }
    }
    else{
      if species == "cow" {
        switch state {
        case .planting:
          timer.isHidden = false
          plantButton.isHidden = true
          stateImageHandler.updateImagefromStage(stage: 0)

        case .harvest:
          timer.isHidden = true
          plantButton.isHidden = true
          stateImageHandler.updateImagefromStage(stage: 1)
        case .empty:
          switchTo(state: .planting)
        }
      }
      else{
        switch state {
        case .planting:
          timer.isHidden = false
          plantButton.isHidden = true
          stateImageHandler.updateImagefromStage(stage: 2)

        case .harvest:
          timer.isHidden = true
          plantButton.isHidden = true
          stateImageHandler.updateImagefromStage(stage: 3)
        case .empty:
          switchTo(state: .planting)
        }
      }
    }
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    switch state {
    case .empty:
      let bought = gameDelegate.updateMoney(by: -stockingPrice * maxAmount)
      if bought {
        switchTo(state: .planting)
      } else {
        let playSound = SKAction.playSoundFileNamed("hit.wav", waitForCompletion: true)
        run(playSound)
        
        // Shake "Plant Sign" if the user can't afford to plant
        let rotateLeft = SKAction.rotate(byAngle: 0.2, duration: 0.1)
        let rotateRight = rotateLeft.reversed()
        let shakeAction = SKAction.sequence([rotateLeft, rotateRight])
        let repeatAction = SKAction.repeat(shakeAction, count: 3)
        plantButton.run(repeatAction)
      }
    case .harvest:
      harvestAnimation()
      gameDelegate.updateMoney(by: stockingPrice * maxAmount)
      switchTo(state: .empty)
    default:
      break
    }
  }
  
  func updateStockingTimerText() {
    let stockingTimeTotal = CFTimeInterval(Float(maxAmount) * stockingSpeed)
    let currentTime = CFAbsoluteTimeGetCurrent()
    let timePassed = currentTime - lastStateSwitchTime
    let stockingTimeLeft = stockingTimeTotal - timePassed
    timer.text = String(Int(stockingTimeLeft))
  }
  
  func harvestAnimation() -> Bool {

    let harvestLabel = SKLabelNode(fontNamed: "TrebuchetMS-Bold")

    harvestLabel.fontColor = SKColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
    
    harvestLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
    harvestLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.bottom
    harvestLabel.position = itemPosition
    if species == "cow"{
      harvestLabel.text = "+2 Milk & Cream"
    }
    else if species == "chicken"{
      harvestLabel.text = "+3 Eggs"
    }
    else {
      harvestLabel.text = "+5 Wheat"
    }
    
    harvestLabel.fontSize = 20
    harvestLabel.zPosition = CGFloat(ZPosition.HUDForeground.rawValue)
    addChild(harvestLabel)
    
    // Fade Animation for Adding
    let moveLabelAction = SKAction.move(by: CGVector(dx: 0, dy: 20), duration: 10)
    let fadeLabelAction = SKAction.fadeOut(withDuration: 1.0)
    let labelAction = SKAction.group([moveLabelAction, fadeLabelAction])
    harvestLabel.run(labelAction, completion: {harvestLabel.removeFromParent()})
    
    return true
  }
  
  
  func update() {
    let currentTimeAbsolute = CFAbsoluteTimeGetCurrent()
    let timePassed = currentTimeAbsolute - lastStateSwitchTime
    
    switch state {
      case .planting:
        updateStockingTimerText()
        amount = min(Int(Float(timePassed) / stockingSpeed), maxAmount)
        if amount == maxAmount {
          switchTo(state: .harvest)
        }
    default:
      break
    }
  }

}
