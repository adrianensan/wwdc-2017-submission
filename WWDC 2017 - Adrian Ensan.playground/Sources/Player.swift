import SpriteKit

class Player: SKNode {

    
    let player: SKSpriteNode
    let flame: SKShapeNode
    var isDead: Bool
    var isDamaged: Bool
    var recoverCounter: Int

    var explosion: Explosion?

    init(unit: CGFloat) {
        
        self.player = SKSpriteNode()
        self.flame = SKShapeNode()
        self.isDead = true
        self.isDamaged = false
        self.recoverCounter = 0
        super.init()

        let playerTexture: SKTexture?
        do { // Create Player Texture
            let playerShape = SKShapeNode()

            let playerPath = CGMutablePath()
            playerPath.addLines(between: [CGPoint(x: 1 * unit, y: 4 * unit),
                                         CGPoint(x: 1.5 * unit, y: 1.5 * unit),
                                         CGPoint(x: 2.5 * unit, y: 1.5 * unit),
                                         CGPoint(x: 2.5 * unit, y: 5 * unit),
                                         CGPoint(x: 2.75 * unit, y: 5 * unit),
                                         CGPoint(x: 4 * unit, y: 1 * unit),
                                         CGPoint(x: 2.75 * unit, y: -1 * unit),
                                         CGPoint(x: 2.5 * unit, y: -1 * unit),
                                         CGPoint(x: 2.5 * unit, y: 0.5 * unit),
                                         CGPoint(x: 2 * unit, y: 0.5 * unit),
                                         CGPoint(x: 1 * unit, y: -1 * unit),

                                         CGPoint(x: -1 * unit, y: -1 * unit),
                                         CGPoint(x: -2 * unit, y: 0.5 * unit),
                                         CGPoint(x: -2.5 * unit, y: 0.5 * unit),
                                         CGPoint(x: -2.5 * unit, y: -1 * unit),
                                         CGPoint(x: -2.75 * unit, y: -1 * unit),
                                         CGPoint(x: -4 * unit, y: 1 * unit),
                                         CGPoint(x: -2.75 * unit, y: 5 * unit),
                                         CGPoint(x: -2.5 * unit, y: 5 * unit),
                                         CGPoint(x: -2.5 * unit, y: 1.5 * unit),
                                         CGPoint(x: -1.5 * unit, y: 1.5 * unit),
                                         CGPoint(x: -1 * unit, y: 4 * unit)])
            playerPath.addArc(center: CGPoint(x: 0, y: 4 * unit), radius:  unit, startAngle: .pi, endAngle: 0, clockwise: true)
            playerPath.closeSubpath()
            playerShape.path = playerPath
            playerShape.fillColor = SKColor.white
            playerShape.lineWidth = 0

            let windowShape = SKShapeNode(circleOfRadius: 0.5 * unit)
            windowShape.fillColor = SKColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
            windowShape.lineWidth = 0
            windowShape.position.y = 4 * unit
            playerShape.addChild(windowShape)

            for i in 0..<3 {
                let line = SKShapeNode(rectOf: CGSize(width: (3 - 0.75 * CGFloat(i)) * unit, height: 0.2 * unit), cornerRadius: 0.09 * unit)
                line.fillColor = SKColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 1)
                line.lineWidth = 0
                line.position.y = (0.5 - 0.5 * CGFloat(i)) * unit
                playerShape.addChild(line)
            }

            playerTexture = SKView().texture(from: playerShape)
        }
        if let playerTexture = playerTexture {
            self.player.texture = playerTexture
            self.player.size = playerTexture.size()
        }

        let flamePath = CGMutablePath()
        flamePath.addLines(between: [CGPoint(x: 1.2 * unit, y: 0),
                                     CGPoint(x: -1.2 * unit, y: 0),
                                     CGPoint(x: 0, y: -5 * unit)])
        flamePath.closeSubpath()
        self.flame.path = flamePath
        self.flame.position.y = -3 * unit
        self.flame.fillColor = SKColor(red: 0.9, green: 0.7, blue: 0, alpha: 1)
        self.flame.lineWidth = 0

        self.zPosition = 31
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reset(unit: CGFloat) {
        self.isDead = false
        self.isDamaged = false
        self.zRotation = 0
        self.alpha = 1
        if let explosion = self.explosion {
            explosion.removeFromParent()
            self.explosion = nil
        }
        self.addChild(self.player)
        self.addChild(self.flame)
    }

    func hit(unit: CGFloat, theme: Theme) {
        guard !self.isDead else {
            return
        }
        self.alpha = 1
        if let explosion = self.explosion {
            explosion.removeFromParent()
            self.explosion = nil
        }
        if !self.isDamaged {
            self.isDamaged = true
            self.recoverCounter = 240
            self.explosion = Explosion(type: .Planet, unit: unit / 10, theme: theme)
            if let explosion = self.explosion {
                explosion.zPosition = 50
                self.addChild(explosion)
            }
        } else {
            self.explosion = Explosion(type: .Player, unit: unit, theme: theme)
            if let explosion = self.explosion {
                explosion.zPosition = 50
                self.addChild(explosion)
            }
            self.isDead = true
        }
    }

    func flashIsFullscreen() -> Bool {
        if let explosion = self.explosion , self.isDead && explosion.flash.xScale >= 1 && explosion.flash.alpha == 1 {
            return true
        }
        return false
    }

    func update(unit: CGFloat, angle: CGFloat) {
        if let explosion = self.explosion {
            explosion.update(unit: unit)
            if !self.isDead && explosion.flash.alpha == 0 {
                explosion.removeFromParent()
                self.explosion = nil
            }
        }
        if !self.isDead{
            if self.isDamaged {
                self.recoverCounter -= 1
                self.alpha = 1 - 0.75 * Random.percentage
                if self.recoverCounter == 0 {
                    self.isDamaged = false
                    self.alpha = 1
                }
            }
            self.zRotation += 0.6 * (angle - self.zRotation)
            self.flame.xScale = 0.5 + 0.5 * Random.percentage
            self.flame.yScale = 0.3 + 0.7 * Random.percentage
        }
    }
    
}
