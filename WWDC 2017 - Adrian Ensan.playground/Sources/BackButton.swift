import SpriteKit

class BackButton: Button {

    let arrow: SKSpriteNode

    override init(unit: CGFloat) {
        let arrowTexture: SKTexture?
        do { // Create Arrow Texture
            let size = 8 * unit
            let arrowPath = CGMutablePath()
            let cosAngle: CGFloat = CGFloat(cos(.pi / 4.5))
            let sinAngle: CGFloat = CGFloat(sin(.pi / 4.5))
            let halfHeight = 0.5 * size
            let halfWidth = 0.1 * size
            let x = -0.75 * (halfHeight * sinAngle - halfWidth)
            let radius = 0.1 * size
            arrowPath.addArc(center: CGPoint(x: x + 1.5 * halfWidth, y: 0), radius: radius, startAngle: CGFloat(-.pi / 4.5 - .pi / 2 - .pi / 4), endAngle: CGFloat(-.pi / 4.5 - .pi + .pi / 4), clockwise: true)
            arrowPath.addArc(center: CGPoint(x: x + halfWidth + halfHeight * sinAngle, y: halfHeight * cosAngle), radius: radius, startAngle: CGFloat(-.pi / 4.5), endAngle: CGFloat(-.pi / 4.5 - .pi), clockwise: false)
            arrowPath.addArc(center: CGPoint(x: x - halfWidth, y: 0), radius: radius, startAngle: CGFloat(-.pi / 4.5 - .pi), endAngle: CGFloat(-.pi / 4.5 - .pi / 2), clockwise: false)
            arrowPath.addArc(center: CGPoint(x: x + halfWidth + halfHeight * sinAngle, y: -halfHeight * cosAngle), radius: radius, startAngle: CGFloat(-.pi / 4.5 - .pi / 2), endAngle: CGFloat(-.pi / 4.5 - .pi / 2 - .pi), clockwise: false)
            let arrowShape = SKShapeNode(path: arrowPath)
            arrowShape.fillColor = SKColor.white
            arrowShape.lineWidth = 0
            arrowTexture = SKView().texture(from: arrowShape)
        }
        self.arrow = SKSpriteNode(texture: arrowTexture)
        super.init(unit: unit)

        self.arrow.zPosition = 31
        self.addChild(self.arrow)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func update() {
        super.update()
    }
}
