import PlaygroundSupport
import SpriteKit

// You can change the view's size to whatever size you'd like,
// everything will dynamically adjust to the dimensions
let viewSize = CGSize(width: 1700, height: 1050)

let sceneView = SKView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: viewSize))
sceneView.ignoresSiblingOrder = true
let gameScene = GameScene(size: viewSize)
sceneView.presentScene(gameScene)

PlaygroundPage.current.liveView = sceneView
PlaygroundPage.current.needsIndefiniteExecution = true
