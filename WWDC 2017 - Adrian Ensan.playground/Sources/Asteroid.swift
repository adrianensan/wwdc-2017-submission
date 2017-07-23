import SpriteKit

class Asteroid: SKNode {

    var isDestroyed: Bool
    let asteroid: SKShapeNode
    var size: CGFloat
    var moveSpeed: [CGFloat]
    var rotationSpeed: CGFloat
    var explosion: Explosion?

    init(unit: CGFloat) {
        self.isDestroyed = false
        self.asteroid = SKShapeNode()
        self.size = 0
        self.moveSpeed = [0, 0]
        self.rotationSpeed = 0
        super.init()

        self.asteroid.lineWidth = unit

        self.addChild(self.asteroid)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func reset(unit: CGFloat, theme: Theme) {
        self.isDestroyed = false
        self.asteroid.fillColor = theme.object
        self.asteroid.strokeColor = theme.objectFeature

        if let explosion = self.explosion {
            explosion.removeFromParent()
        }
        self.explosion = nil

        self.size = 15 + CGFloat(arc4random_uniform(12))
        self.moveSpeed[0] = (0.02 + 0.45 * Random.percentage) * Random.direction
        self.moveSpeed[1] = (0.02 + 0.45 * Random.percentage) * Random.direction
        self.rotationSpeed = CGFloat.pi * (0.001 + 0.01 * Random.percentage * Random.direction)
        var points = [CGPoint](repeating: CGPoint.zero, count: 6)

        points[0].x = -1 / 6 - 0.3 * Random.percentage
        points[1].x = 1 / 6 - 0.3 * Random.percentage
        points[2].x = 1 / 6 + 0.3 * Random.percentage
        points[3].x = 1 / 6 + 0.3 * Random.percentage
        points[4].x = 1 / 6 - 0.3 * Random.percentage
        points[5].x = -1 / 6 - 0.3 * Random.percentage

        points[0].y = 1 / 6 - 0.3 * Random.percentage
        points[1].y = 0.5
        points[2].y = 1 / 6 - 0.3 * Random.percentage
        points[3].y = -1 / 6 - 0.3 * Random.percentage
        points[4].y = -0.5
        points[5].y = -1 / 6 - 0.3 * Random.percentage

        self.asteroid.alpha = 1
        let asteroidPath = CGMutablePath()
        asteroidPath.addLines(between: [CGPoint(x: points[0].x * size * unit, y: points[0].y * size * unit),
                                        CGPoint(x: points[1].x * size * unit, y: points[1].y * size * unit),
                                        CGPoint(x: points[2].x * size * unit, y: points[2].y * size * unit),
                                        CGPoint(x: points[3].x * size * unit, y: points[3].y * size * unit),
                                        CGPoint(x: points[4].x * size * unit, y: points[4].y * size * unit),
                                        CGPoint(x: points[5].x * size * unit, y: points[5].y * size * unit)])

        asteroidPath.closeSubpath()
        self.asteroid.path = asteroidPath
    }

    func explode(unit: CGFloat, theme: Theme) {
        guard !self.isDestroyed else {
            return
        }
        self.isDestroyed = true
        self.explosion = Explosion(type: .Asteroid, unit: unit / 150 * self.size, theme: theme)
        self.addChild(self.explosion!)
    }

    public func update(unit: CGFloat) {
        if let explosion = self.explosion {
            explosion.update(unit: unit)
            if explosion.particles.count == 0 {
                explosion.removeFromParent()
                self.explosion = nil
            }
        } else if !self.isDestroyed {
            self.asteroid.zRotation += self.rotationSpeed
            self.position.x += self.moveSpeed[0] * unit
            self.position.y += self.moveSpeed[1] * unit
        }

    }
    
}
