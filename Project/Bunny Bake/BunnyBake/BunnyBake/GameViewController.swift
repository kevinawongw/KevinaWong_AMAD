import UIKit
import SpriteKit

extension SKNode {
  class func unarchiveFromFile(file : NSString) -> SKNode? {
    if let path = Bundle.main.path(forResource: file as String, ofType: "sks") {
      do {
        let sceneData = try NSData(contentsOfFile: path, options: .mappedIfSafe)
        let archiver = NSKeyedUnarchiver(forReadingWith: sceneData as Data)
        
        archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
        let scene = archiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as! GameScene
        archiver.finishDecoding()
        return scene
      } catch let error as NSError {
        print("Error: \(error.domain)")
      }
      return nil
    } else {
      return nil
    }
  }
}

class GameViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let view = self.view as! SKView? {
      if let scene = GameScene.unarchiveFromFile(file: "GameScene") as? GameScene {
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFill
        
        // Present the scene
        view.presentScene(scene)
      }
    }
  }

  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    if UIDevice.current.userInterfaceIdiom == .phone {
      return .allButUpsideDown
    } else {
      return .all
    }
  }
  
}
