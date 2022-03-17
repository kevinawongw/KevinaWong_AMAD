import SpriteKit

class FarmItem: SKNode {
  
  // MARK: Variables for Item
  let type: String
  let species: String
  private var amount: Int
  var state: State
  private var lastStateSwitchTime: CFAbsoluteTime
  var x: Double
  var y: Double
  let itemPosition: CGPoint

  // MARK: Set Values for Type
  private let maxAmount: Int
  private let relativeX: Float
  private let relativeY: Float
  private let stockingSpeed: Float
  private let sellingSpeed: Float
  private let stockingPrice: Int
  private let sellingPrice: Int
  
  private var gameDelegate: GameDelegate
  
  // MARK: Game Scene Items (Timers, Buttons, etc.)
  private var timer = SKLabelNode(fontNamed: "PressStart2P-Regular")
  private var stateImageHandler: StateImageHandler
  private var plantButton = SKSpriteNode(imageNamed: "plant_button")
  
  // MARK: Constructor
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
    setPlantButton()
    setupTimer(relativeX: relativeTimerPositionX!, relativeY: relativeTimerPositionY!)
    
    addChild(stateImageHandler.node)
    isUserInteractionEnabled = true
    
    if type == "plant"{
      addChild(plantButton)
    }
    addChild(timer)
    switchTo(state: self.state)
  }
  
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  // MARK: Setting up buttons and text
  
  func setPlantButton() {
      plantButton.zPosition = CGFloat(ZPosition.HUDBackground.rawValue)
    }
  
  func setupTimer(relativeX: Float, relativeY: Float) {
    timer.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
    timer.fontSize = 20
    timer.fontColor = SKColor(red:255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
    timer.position = CGPoint(x: Int(relativeX * Float(stateImageHandler.node.calculateAccumulatedFrame().size.width)), y: Int(relativeY * Float(stateImageHandler.node.calculateAccumulatedFrame().size.height)))
    timer.zPosition = CGFloat(ZPosition.HUDForeground.rawValue)
  }
  
  // MARK: - Data
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
  
  // MARK: State Handling
  
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
        }
        else {
          plantButton.run(shakeItemAnimation())
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
    
    harvestLabel.run(fadingText(), completion: {harvestLabel.removeFromParent()})
    
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

  // MARK: Animation
  
  func shakeItemAnimation() -> SKAction {
    let rotateLeft = SKAction.rotate(byAngle: 0.2, duration: 0.1)
    let rotateRight = rotateLeft.reversed()
    let shakeAction = SKAction.sequence([rotateLeft, rotateRight])
    let shake = SKAction.repeat(shakeAction, count: 3)
    return shake
  }
  
  func fadingText() -> SKAction {
    let moveLabel = SKAction.move(by: CGVector(dx: 0, dy: 20), duration: 10)
    let fadeLabel = SKAction.fadeOut(withDuration: 1.0)
    let fadingTextAction = SKAction.group([moveLabel, fadeLabel])
    return fadingTextAction
  }
}
