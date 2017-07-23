import SpriteKit

class Planet: SKNode {

    let planet: SKSpriteNode
    var planetFeatures: [SKSpriteNode]
    var radius: CGFloat
    var hitCounter: Int
    var planetExplosion: Explosion?
    var explosions: [Explosion]

    init(unit: CGFloat, planetTexture: SKTexture?, planetFeatureTexture: SKTexture?) {
        self.planet = SKSpriteNode(texture: planetTexture)
        self.planetFeatures = [SKSpriteNode]()
        self.radius = 0
        self.hitCounter = 0
        self.explosions = [Explosion]()
        super.init()

        self.planet.colorBlendFactor = 1
        self.planet.zPosition = 1
        self.addChild(self.planet)

        for _ in 0..<10 {
            let planetFeature = SKSpriteNode(texture: planetFeatureTexture)
            planetFeature.colorBlendFactor = 1
            planetFeature.zPosition = 2
            self.planetFeatures.append(planetFeature)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func hit(at point: CGPoint, unit: CGFloat, theme: Theme) {
        guard self.hitCounter < 50 else {
            return
        }
        let explosion = Explosion(type: .Planet, unit: 0.04 * unit, theme: theme)
        self.hitCounter += 1
        explosion.position = point
        self.addChild(explosion)
        self.explosions.append(explosion)
        if (hitCounter == 50) {
            self.planetExplosion = Explosion(type: .ActualPlanet, unit: 0.01 * (self.radius + 2) * unit, theme: theme)
            if let planetExplosion = self.planetExplosion {
                self.addChild(planetExplosion)
            }
        }
    }

    func reset(unit: CGFloat, theme: Theme) {
        self.radius = 15 + CGFloat(arc4random_uniform(30))
        if self.hitCounter == 50 {
            self.planetExplosion?.removeFromParent()
            self.planetExplosion = nil
            self.addChild(self.planet)
        }
        self.hitCounter = 0
        self.planet.size.width = 2 * self.radius * unit
        self.planet.size.height = self.planet.size.width
        self.planet.color = theme.object

        for planetFeature in self.planetFeatures {
            planetFeature.color = theme.objectFeature
            if planetFeature.parent == self.planet {
                planetFeature.removeFromParent()
            }
        }

        for i in 0..<Int(4 + arc4random_uniform(7)) {
            self.planetFeatures[i].size.width = (0.04 + 0.36 * Random.percentage) * self.radius * unit
            self.planetFeatures[i].size.height = (0.03 + 0.02 * Random.percentage) * self.radius * unit
            var conflict: Bool = false
            repeat {
                conflict = false
                self.planetFeatures[i].position.x = Random.direction * 0.45 * (self.planet.size.width - self.planetFeatures[i].size.width) * Random.percentage
                self.planetFeatures[i].position.y = Random.direction * 0.45 * (self.planet.size.height - self.planetFeatures[i].size.width) * Random.percentage * cos(0.5 * abs(self.planetFeatures[i].position.x) / (0.5 * self.planet.size.width) * .pi)

                for j in 0..<i {
                    if abs(self.planetFeatures[i].position.x - self.planetFeatures[j].position.x) < 0.75 * (self.planetFeatures[i].size.width + self.planetFeatures[j].size.width) &&
                        abs(self.planetFeatures[i].position.y - self.planetFeatures[j].position.y) < self.planetFeatures[i].size.height + self.planetFeatures[j].size.height {
                        conflict = true
                        break
                    }
                }
            } while conflict
            self.planet.addChild(self.planetFeatures[i])
        }
    }

    func update(unit: CGFloat) {
        for explosion in self.explosions {
            explosion.update(unit: unit)
            if explosion.particles.count == 0 {
                explosion.removeFromParent()
                self.explosions.remove(at: self.explosions.index(of: explosion)!)
            }
        }
        if let planetExplosion = self.planetExplosion {
            planetExplosion.update(unit: unit)
            if planetExplosion.flash.xScale > 0.915 && self.planet.parent == self {
                self.planet.removeFromParent()
            }
        }
    }
}
