import SpriteKit

class Explosion: SKNode {

    enum type {
        case Player
        case Asteroid
        case Planet
        case ActualPlanet
    }

    let type: Explosion.type

    let flash: SKShapeNode
    var particles: [SKSpriteNode]
    var particleProperties: [[CGFloat]] // [xSpeed, ySpeed, rotationSpeed]

    init(type: Explosion.type, unit: CGFloat, theme: Theme) {
        self.type = type
        self.flash = SKShapeNode(circleOfRadius: 120 * unit)
        self.particles = [SKSpriteNode]()
        self.particleProperties = [[CGFloat]]()
        super.init()

        self.flash.fillColor = SKColor.white
        self.flash.lineWidth = 0
        self.flash.xScale = 0
        self.flash.yScale = 0
        self.flash.zPosition = 40
        self.addChild(self.flash)

        for i in 0..<50 where type != .Planet || i % 2 == 0 {
            let particle = SKSpriteNode()
            if self.type == .Player {
                particle.color = SKColor.white
            } else {
                particle.color = theme.objectFeature
            }
            particle.alpha = 0.7 + 0.25 * Random.percentage
            self.particles.append(particle)
            self.addChild(particle)

            var particleProperties = [CGFloat]()
            particleProperties.append(CGFloat(50 + arc4random_uniform(150)) / 300 * cos(CGFloat(i) / 25 * .pi))
            particleProperties.append(CGFloat(50 + arc4random_uniform(150)) / 300 * sin(CGFloat(i) / 25 * .pi))
            particleProperties.append(CGFloat(25 + arc4random_uniform(50)) / 1000 * .pi)

            let size = 1 + 2 * Random.percentage
            self.particleProperties.append(particleProperties)
            if type == .Player {
                particle.size = CGSize(width: size * unit, height: size * unit)
            } else if type == .Planet {
                particle.size = CGSize(width: 15 * size * unit, height: 15 * size * unit)
            } else if type == .ActualPlanet {
                particle.size = CGSize(width: 8 * size * unit, height: 8 * size * unit)
            } else {
                particle.size = CGSize(width: 7 * size * unit, height: 7 * size * unit)
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(unit: CGFloat) {
        switch self.type {
        case .Player:
            if self.flash.alpha > 0 {
                if self.flash.xScale < 1 {
                    self.flash.xScale += 0.08
                    self.flash.yScale += 0.08
                } else {
                    self.flash.alpha -= 0.0625
                    if self.flash.alpha == 0 {
                        self.flash.removeFromParent()
                    }
                }
            }
            
            for particle in self.particles {
                let i: Int = self.particles.index(of: particle)!
                particle.position.x += self.particleProperties[i][0] * unit
                particle.position.y += self.particleProperties[i][1] * unit
                particle.zRotation += self.particleProperties[i][2]
                particle.alpha -= 0.006
                if particle.alpha < 0.007 {
                    particle.alpha = 0.007
                    particle.removeFromParent()
                    self.particles.remove(at: i)
                    self.particleProperties.remove(at: i)
                }
            }
        case .Asteroid:
            if self.flash.alpha > 0 {
                if self.flash.xScale < 0.9 {
                    self.flash.xScale += (1 - self.flash.xScale) / 5
                    self.flash.yScale = self.flash.xScale
                } else {
                    self.flash.alpha = 0
                }
            }
            for particle in self.particles {
                let i: Int = self.particles.index(of: particle)!
                particle.position.x += self.particleProperties[i][0] * unit
                particle.position.y += self.particleProperties[i][1] * unit
                particle.zRotation += self.particleProperties[i][2]
                particle.alpha -= 0.015
                if particle.alpha < 0.016 {
                    particle.removeFromParent()
                    self.particles.remove(at: i)
                    self.particleProperties.remove(at: i)
                }
            }
        case .Planet:
            if self.flash.alpha > 0 {
                if self.flash.xScale < 0.92 {
                    self.flash.xScale += (1 - self.flash.xScale) / 3
                    self.flash.yScale = self.flash.xScale
                } else {
                    self.flash.alpha = 0
                }
            }
            for particle in self.particles {
                let i: Int = self.particles.index(of: particle)!
                particle.position.x += self.particleProperties[i][0] * unit * 1.5
                particle.position.y += self.particleProperties[i][1] * unit * 1.5
                particle.zRotation += self.particleProperties[i][2]
                particle.alpha -= 0.018
                if particle.alpha < 0.019 {
                    particle.removeFromParent()
                    self.particles.remove(at: i)
                    self.particleProperties.remove(at: i)
                }
            }
        case .ActualPlanet:
            if self.flash.alpha > 0 {
                if self.flash.xScale < 0.92 {
                    self.flash.xScale += (1 - self.flash.xScale) / 5
                    self.flash.yScale = self.flash.xScale
                } else {
                    self.flash.alpha = 0
                }
            }
            for particle in self.particles {
                let i: Int = self.particles.index(of: particle)!
                particle.position.x += self.particleProperties[i][0] * unit
                particle.position.y += self.particleProperties[i][1] * unit
                particle.zRotation += self.particleProperties[i][2]
                particle.alpha -= 0.004
                if particle.alpha < 0.005 {
                    particle.removeFromParent()
                    self.particles.remove(at: i)
                    self.particleProperties.remove(at: i)
                }
            }
        }
    }
}
