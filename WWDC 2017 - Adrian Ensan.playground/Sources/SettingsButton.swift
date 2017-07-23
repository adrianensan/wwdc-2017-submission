import SpriteKit

class SettingsButton: Button {

    let gear: SKSpriteNode

    override init(unit: CGFloat) {
        let gearTexture: SKTexture?
        do {
            let size = 8 * unit

            let iconSize8 = size / 8
            let iconSize28 = size / 2.8
            let iconSize2 = size / 2
            let iconSize12 = size / 12
            let path = CGMutablePath()
            path.addArc(center: CGPoint(x: 0, y: 0), radius: size / 5, startAngle: 0, endAngle: 2 * .pi, clockwise: false)
            path.closeSubpath()
            path.addLines(between: [CGPoint(x: size / 8, y: size / 2.8)])
            for i in 0..<6 {
                let cosAngle: CGFloat = CGFloat(cos(Double(i) * .pi / 3))
                let sinAngle: CGFloat = CGFloat(sin(Double(i) * .pi / 3))
                path.addLine(to: CGPoint(x: iconSize8 * cosAngle - iconSize28 * sinAngle, y: iconSize28 * cosAngle + iconSize8 * sinAngle))
                path.addLine(to: CGPoint(x: iconSize12 * cosAngle - iconSize2 * sinAngle, y: iconSize2 * cosAngle + iconSize12 * sinAngle))
                path.addLine(to: CGPoint(x: -iconSize12 * cosAngle - iconSize2 * sinAngle, y: iconSize2 * cosAngle + -iconSize12 * sinAngle))
                path.addLine(to: CGPoint(x: -iconSize8 * cosAngle - iconSize28 * sinAngle, y: iconSize28 * cosAngle + -iconSize8 * sinAngle))
            }
            path.addLine(to: CGPoint(x: size / 8, y: size / 2.8))
            path.closeSubpath()
            let gearShape = SKShapeNode(path: path)
            gearShape.fillColor = SKColor.white
            gearShape.lineWidth = 0

            gearTexture = SKView().texture(from: gearShape)
        }
        self.gear = SKSpriteNode(texture: gearTexture)
        super.init(unit: unit)

        self.gear.zPosition = 35
        self.addChild(self.gear)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func update() {
        super.update()
        if self.isSelected {
            self.gear.zRotation -= 0.025 * .pi / 3
        } else if self.gear.zRotation != 0 {
            self.gear.zRotation += 0.025 * .pi / 3
        }
        if self.gear.zRotation <= -.pi / 3 || self.gear.zRotation > 0 {
            self.gear.zRotation = 0
        }
    }
}
