import SpriteKit

class FarmItem: SKNode {
  
  // "Animal" or "Plant"
  let type: String
  let species: String
  private var amount: Int
  var state: State
  private var lastStateSwitchTime: CFAbsoluteTime

  
  private let maxAmount: Int
  private let relativeX: Float
  private let relativeY: Float
  private let stockingSpeed: Float
  private let sellingSpeed: Float
  private let stockingPrice: Int
  private let sellingPrice: Int
  
  private var gameDelegate: GameDelegate
  
  private var stockingTimer = SKLabelNode(fontNamed: "PressStart2P-Regular")
  private var stateImageHandler: StateImageHandler
  private var plantButton = SKSpriteNode(imageNamed: "plant_button")
  
  init(stockItemData: [String: AnyObject], stockItemConfiguration: [String: NSNumber], gameDelegate: GameDelegate) {
    
    self.gameDelegate = gameDelegate
    
    // initialize item from data
    // instead of loadValuesWithData method
    maxAmount = (stockItemConfiguration["maxAmount"]?.intValue)!
    stockingSpeed = (stockItemConfiguration["stockingSpeed"]?.floatValue)! * TimeScale
    sellingSpeed = (stockItemConfiguration["sellingSpeed"]?.floatValue)! * TimeScale
    stockingPrice = (stockItemConfiguration["stockingPrice"]?.intValue)!
    sellingPrice = (stockItemConfiguration["sellingPrice"]?.intValue)!
    
    type = stockItemData["type"] as AnyObject? as! String
    amount = stockItemData["amount"] as AnyObject? as! Int
    relativeX = Float(stockItemData["x"] as AnyObject? as! Double)
    relativeY = Float(stockItemData["y"] as AnyObject? as! Double)
    
    var relativeTimerPositionX: Float? = stockItemConfiguration["timerPositionX"]?.floatValue
    if relativeTimerPositionX == nil {
      relativeTimerPositionX = Float(0.0)
    }
    var relativeTimerPositionY: Float? = stockItemConfiguration["timerPositionY"]?.floatValue
    if relativeTimerPositionY == nil {
      relativeTimerPositionY = Float(0.0)
    }
    
    species = stockItemData["species"] as AnyObject? as! String
    
    stateImageHandler = StateImageHandler(type: type)
    
    let stateAsObject: AnyObject? = stockItemData["state"]
    let stateAsInt = stateAsObject as! Int
    state = State(rawValue: stateAsInt)!
    lastStateSwitchTime = stockItemData["lastStateSwitchTime"] as AnyObject? as! CFAbsoluteTime

    
    super.init()
    setupPriceLabel()
    setupStockingTimer(relativeX: relativeTimerPositionX!, relativeY: relativeTimerPositionY!)
    
    addChild(stateImageHandler.node)
    isUserInteractionEnabled = true
    
    if type == "plant"{
      addChild(plantButton)
    }
    addChild(stockingTimer)
    switchTo(state: state)

  }
  
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
  
  func setupStockingTimer(relativeX: Float, relativeY: Float) {
    // Create stocking Timer
    stockingTimer.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
    stockingTimer.fontSize = 20
    stockingTimer.fontColor = SKColor(red: 255/255.0, green: 30/255.0, blue: 5/255.0, alpha: 1.0)
    stockingTimer.position = CGPoint(x: Int(relativeX * Float(stateImageHandler.node.calculateAccumulatedFrame().size.width)), y: Int(relativeY * Float(stateImageHandler.node.calculateAccumulatedFrame().size.height)))
    stockingTimer.zPosition = CGFloat(ZPosition.HUDForeground.rawValue)
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
        stockingTimer.isHidden = true
        plantButton.isHidden = false
        stateImageHandler.updateImagefromStage(stage: 0)
      case .planting:
        stockingTimer.isHidden = false
        plantButton.isHidden = true
        stateImageHandler.updateImagefromStage(stage: 1)

      case .harvest:
        stockingTimer.isHidden = true
        plantButton.isHidden = true
        stateImageHandler.updateImagefromStage(stage: 2)
      }
    }
    else{
      if species == "cow" {
        switch state {
        case .planting:
          stockingTimer.isHidden = false
          plantButton.isHidden = true
          stateImageHandler.updateImagefromStage(stage: 0)

        case .harvest:
          stockingTimer.isHidden = true
          plantButton.isHidden = true
          stateImageHandler.updateImagefromStage(stage: 1)
        case .empty:
          switchTo(state: .planting)
        }
      }
      else{
        switch state {
        case .planting:
          stockingTimer.isHidden = false
          plantButton.isHidden = true
          stateImageHandler.updateImagefromStage(stage: 2)

        case .harvest:
          stockingTimer.isHidden = true
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
        
        let rotateLeft = SKAction.rotate(byAngle: 0.2, duration: 0.1)
        let rotateRight = rotateLeft.reversed()
        let shakeAction = SKAction.sequence([rotateLeft, rotateRight])
        let repeatAction = SKAction.repeat(shakeAction, count: 3)
        plantButton.run(repeatAction)
      }
    case .harvest:
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
    stockingTimer.text = String(format: "%.0f", stockingTimeLeft)
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
