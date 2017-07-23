import SpriteKit

class Button: SKNode {

    var isSelected: Bool
    let clickCircle: SKShapeNode
    let size: CGSize

    init(unit: CGFloat) {
        self.isSelected = false
        self.clickCircle = SKShapeNode(circleOfRadius: 6 * unit)
        self.size = CGSize(width: 10 * unit, height: 10 * unit)
        super.init()

        self.clickCircle.fillColor = SKColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
        self.clickCircle.lineWidth = 0
        self.clickCircle.zPosition = 30
        self.clickCircle.xScale = 0
        self.clickCircle.yScale = 0
        self.addChild(self.clickCircle)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update() {
        if self.isSelected && self.clickCircle.xScale < 1 {
            self.clickCircle.xScale += 0.125
        } else if !self.isSelected && self.clickCircle.xScale > 0 {
            self.clickCircle.xScale -= 0.125
        }
        if self.clickCircle.xScale != self.clickCircle.yScale {
            self.clickCircle.yScale = self.clickCircle.xScale
        }
    }
}
