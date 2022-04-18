

import SpriteKit

class StockItem: SKNode {
  
  let type: String
  let flavor: String
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
  
  private var stockingTimer = SKLabelNode(fontNamed: "TrebuchetMS-Bold")
  private var progressBar: ProgressBar
  private var sellButton = SKSpriteNode(imageNamed: "sell_button")
  private var priceTag = SKSpriteNode(imageNamed: "price_tag")
  
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
    
    flavor = stockItemData["flavor"] as AnyObject? as! String
    
    // Create progress bar
    if type == "cookie" {
      let baseName = String(format: "item_%@", type) + "_tray_%i"
      progressBar = DiscreteProgressBar(baseName: baseName)
      
    } else {
      let emptyImageName = NSString(format: "item_%@_empty", type)
      let fullImageName = NSString(format: "item_%@_%@", type, flavor)
      progressBar = ContinuousProgressBar(emptyImageName: emptyImageName as String, fullImageName: fullImageName as String)
    }
    
    let stateAsObject: AnyObject? = stockItemData["state"]
    let stateAsInt = stateAsObject as! Int
    state = State(rawValue: stateAsInt)!
    lastStateSwitchTime = stockItemData["lastStateSwitchTime"] as AnyObject? as! CFAbsoluteTime

    
    super.init()
    setupPriceLabel()
    setupStockingTimer(relativeX: relativeTimerPositionX!, relativeY: relativeTimerPositionY!)
    
    addChild(progressBar.node)
    isUserInteractionEnabled = true
    sellButton.zPosition = CGFloat(ZPosition.HUDForeground.rawValue)
    
    addChild(priceTag)
    addChild(stockingTimer)
    addChild(sellButton)
    switchTo(state: state)

  }
  
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupPriceLabel() {
    // Create price label tag
    let priceTagLabel = SKLabelNode(fontNamed: "TrebuchetMS-Bold")
    priceTagLabel.fontSize = 24
    priceTagLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
    priceTagLabel.text = String(format: "%i$", maxAmount * stockingPrice)
    priceTagLabel.fontColor = SKColor.black
    priceTagLabel.zPosition = CGFloat(ZPosition.HUDForeground.rawValue)
    priceTag.zPosition = CGFloat(ZPosition.HUDBackground.rawValue)
    priceTag.addChild(priceTagLabel)
  }
  
  func setupStockingTimer(relativeX: Float, relativeY: Float) {
    // Create stocking Timer
    stockingTimer.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
    stockingTimer.fontSize = 30
    stockingTimer.fontColor = SKColor(red: 198/255.0, green: 139/255.0, blue: 207/255.0, alpha: 1.0)
    stockingTimer.position = CGPoint(x: Int(relativeX * Float(progressBar.node.calculateAccumulatedFrame().size.width)), y: Int(relativeY * Float(progressBar.node.calculateAccumulatedFrame().size.height)))
    stockingTimer.zPosition = CGFloat(ZPosition.HUDForeground.rawValue)
  }
  
  // MARK: - Write dictionary for storage of StockItem
  func data() -> NSDictionary {
    let data = NSMutableDictionary()
    data["type"] = type
    data["flavor"] = flavor
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
    switch state {
    case .empty:
      stockingTimer.isHidden = true
      sellButton.isHidden = true
      priceTag.isHidden = false
    case .stocking:
      stockingTimer.isHidden = false
      sellButton.isHidden = true
      priceTag.isHidden = true
    case .stocked:
      stockingTimer.isHidden = true
      sellButton.isHidden = false
      priceTag.isHidden = true
      progressBar.setProgress(percentage: 1)
    case .selling:
      stockingTimer.isHidden = true
      sellButton.isHidden = true
      priceTag.isHidden = true
    }
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    switch state {
    case .empty:
      let bought = gameDelegate.updateMoney(by: -stockingPrice * maxAmount)
      if bought {
        switchTo(state: .stocking)
      } else {
        let playSound = SKAction.playSoundFileNamed("hit.wav", waitForCompletion: true)
        run(playSound)
        
        let rotateLeft = SKAction.rotate(byAngle: 0.2, duration: 0.1)
        let rotateRight = rotateLeft.reversed()
        let shakeAction = SKAction.sequence([rotateLeft, rotateRight])
        let repeatAction = SKAction.repeat(shakeAction, count: 3)
        priceTag.run(repeatAction)
      }
    case .stocked:
      switchTo(state: .selling)
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
    case .stocking:
      updateStockingTimerText()
      amount = min(Int(Float(timePassed) / stockingSpeed), maxAmount)
      if amount == maxAmount {
        switchTo(state: .stocked)
      }
    default:
      break
    }
  }


}
