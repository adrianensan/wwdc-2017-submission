import SpriteKit

class IntroOverlay: SKNode {

    let tamperedScoresMessage: SKLabelNode
    let arrowKeys, adKeys: SKSpriteNode

    init(unit: CGFloat, screenSize: CGSize) {
        self.tamperedScoresMessage = SKLabelNode()
        self.arrowKeys = SKSpriteNode()
        self.adKeys = SKSpriteNode()
        super.init()

        tamperedScoresMessage.text = "The highscores file has been tampered with, highscores have been reset"
        tamperedScoresMessage.fontName = "Moon Light"
        tamperedScoresMessage.verticalAlignmentMode = .center
        tamperedScoresMessage.fontSize = 3.5 * unit
        tamperedScoresMessage.position.y = -0.5 * screenSize.height + 15 * unit
        tamperedScoresMessage.fontColor = SKColor(red: 1, green: 0.2, blue: 0, alpha: 1)
        tamperedScoresMessage.zPosition = 1

        let fade = SKSpriteNode()
        fade.size = screenSize
        fade.color = SKColor.black
        fade.alpha = 0.5
        self.addChild(fade)

        let titleLabel = SKLabelNode()
        titleLabel.text = "ROCK DESTROYER"
        titleLabel.fontName = "Moon Bold"
        titleLabel.verticalAlignmentMode = .bottom
        titleLabel.fontSize = 12 * unit
        titleLabel.position.y = 0.5 * screenSize.height - 16 * unit
        titleLabel.zPosition = 1
        self.addChild(titleLabel)

        let byLabel = SKLabelNode()
        byLabel.text = "A game by Adrian Ensan"
        byLabel.fontName = "Moon Light"
        byLabel.verticalAlignmentMode = .top
        byLabel.fontSize = 4.5 * unit
        byLabel.position.y = 0.5 * screenSize.height - 20 * unit
        byLabel.zPosition = 1
        addChild(byLabel)

        do { // Create Objective Section
            let objective = SKNode()
            objective.position.y = 8 * unit
            objective.zPosition = 1

            let objectiveLabel = SKLabelNode()
            objectiveLabel.text = "Objective:"
            objectiveLabel.fontName = "Moon Bold"
            objectiveLabel.horizontalAlignmentMode = .right
            objectiveLabel.verticalAlignmentMode = .center
            objectiveLabel.fontSize = 6 * unit
            objectiveLabel.position.x = -14 * unit
            objectiveLabel.fontColor = SKColor.white
            objective.addChild(objectiveLabel)


            let objectiveText = ["Destroy everything in your path.",
                                 "Objects are destroyed by shooting them.",
                                 "Asteroids take 1 hit and are worth 1 point.",
                                 "Planets take 50 hits and are worth 100 points.",
                                 "The game is over when you crash into a planet",
                                 "or get hit by 2 asteroids in a row."]

            for i in 0..<objectiveText.count {
                let objectiveLine = SKLabelNode()
                objectiveLine.text = objectiveText[i]
                objectiveLine.fontName = "Moon Light"
                objectiveLine.horizontalAlignmentMode = .left
                objectiveLine.verticalAlignmentMode = .bottom
                objectiveLine.fontSize = 3 * unit
                objectiveLine.position.x = -10 * unit
                objectiveLine.position.y = -3 * unit * CGFloat(i - 2)
                objectiveLine.fontColor = SKColor.white
                objective.addChild(objectiveLine)
            }

            self.addChild(objective)

        }

        do { // Create Controls Section
            let controls = SKNode()
            controls.position.y = -18 * unit
            controls.zPosition = 1

            let controlsLabel = SKLabelNode()
            controlsLabel.text = "Controls:"
            controlsLabel.fontName = "Moon Bold"
            controlsLabel.horizontalAlignmentMode = .right
            controlsLabel.verticalAlignmentMode = .center
            controlsLabel.fontSize = 6 * unit
            controlsLabel.position.x = -14 * unit
            controlsLabel.fontColor = SKColor.white
            controls.addChild(controlsLabel)

            // Move Controls
            let moveControls = SKNode()
            moveControls.position.x = 2 * unit

            let arrowsTexture: SKTexture?
            do { // Create Arrow Keys Texture
                let arrowKeysShapes = SKNode()

                let arrowPath = CGMutablePath()
                arrowPath.addArc(center: CGPoint(x: 0.5 * unit, y: 2.5 * unit), radius: 0.5 * unit, startAngle: .pi, endAngle: 0.425 * .pi, clockwise: true)
                arrowPath.addArc(center: CGPoint(x: 6 * unit, y: 0), radius: 0.5 * unit, startAngle: 0.25 * .pi, endAngle: -0.25 * .pi, clockwise: true)
                arrowPath.addArc(center: CGPoint(x: 0.5 * unit, y: -2.5 * unit), radius: 0.5 * unit, startAngle: -0.425 * .pi, endAngle: -.pi, clockwise: true)
                arrowPath.closeSubpath()

                let leftArrow = SKShapeNode(path: arrowPath)
                leftArrow.position.x = -2 * unit
                leftArrow.zRotation = .pi
                leftArrow.fillColor = SKColor.white
                leftArrow.lineWidth = 0
                arrowKeysShapes.addChild(leftArrow)

                let rightArrow = SKShapeNode(path: arrowPath)
                rightArrow.position.x = 2 * unit
                rightArrow.fillColor = SKColor.white
                rightArrow.lineWidth = 0
                arrowKeysShapes.addChild(rightArrow)

                arrowsTexture = SKView().texture(from: arrowKeysShapes)
            }
            if let arrowsTexture = arrowsTexture {
                arrowKeys.texture = arrowsTexture
                arrowKeys.size = arrowsTexture.size()
            }
            arrowKeys.position.y = -4 * unit
            arrowKeys.zPosition = 1
            moveControls.addChild(arrowKeys)

            let adKeysTexture: SKTexture?
            do {
                let adKeysShapes = SKNode()

                let aKey = SKShapeNode(rectOf: CGSize(width: 6 * unit, height: 6 * unit), cornerRadius: 0.5 * unit)
                aKey.position.x = -5 * unit
                aKey.fillColor = SKColor.white
                aKey.lineWidth = 0
                adKeysShapes.addChild(aKey)

                let aLabel = SKLabelNode()
                aLabel.text = "A"
                aLabel.fontName = "Moon Light"
                aLabel.verticalAlignmentMode = .center
                aLabel.fontSize = 3 * unit
                aLabel.fontColor = SKColor.black
                aKey.addChild(aLabel)

                let dKey = SKShapeNode(rectOf: CGSize(width: 6 * unit, height: 6 * unit), cornerRadius: 0.5 * unit)
                dKey.position.x = 5 * unit
                dKey.fillColor = SKColor.white
                dKey.lineWidth = 0
                adKeysShapes.addChild(dKey)

                let dLabel = SKLabelNode()
                dLabel.text = "D"
                dLabel.fontName = "Moon Light"
                dLabel.verticalAlignmentMode = .center
                dLabel.fontSize = 3 * unit
                dLabel.fontColor = SKColor.black
                dKey.addChild(dLabel)

                adKeysTexture = SKView().texture(from: adKeysShapes)
            }
            if let adKeysTexture = adKeysTexture {
                adKeys.texture = adKeysTexture
                adKeys.size = adKeysTexture.size()
            }
            adKeys.position.y = -4 * unit
            adKeys.zPosition = 1
            moveControls.addChild(adKeys)

            let moveLabel = SKLabelNode()
            moveLabel.text = "Move"
            moveLabel.fontName = "Moon Bold"
            moveLabel.verticalAlignmentMode = .bottom
            moveLabel.fontSize = 4 * unit
            moveLabel.position.y = 2 * unit
            moveLabel.fontColor = SKColor.white
            moveControls.addChild(moveLabel)

            controls.addChild(moveControls)


            // Shoot Controls
            let shootControls = SKNode()
            shootControls.position.x = 32 * unit

            let spaceBar = SKShapeNode(rectOf: CGSize(width: 25 * unit, height: 6 * unit), cornerRadius: 0.5 * unit)
            spaceBar.position.y = -4 * unit
            spaceBar.fillColor = SKColor.white
            spaceBar.lineWidth = 0
            shootControls.addChild(spaceBar)

            let spaceLabel = SKLabelNode()
            spaceLabel.text = "Spacebar"
            spaceLabel.fontName = "Moon Light"
            spaceLabel.verticalAlignmentMode = .center
            spaceLabel.fontSize = 3 * unit
            spaceLabel.fontColor = SKColor.black
            spaceBar.addChild(spaceLabel)

            let shootLabel = SKLabelNode()
            shootLabel.text = "Shoot"
            shootLabel.fontName = "Moon Bold"
            shootLabel.verticalAlignmentMode = .bottom
            shootLabel.fontSize = 4 * unit
            shootLabel.position.y = 2 * unit
            shootLabel.fontColor = SKColor.white
            shootControls.addChild(shootLabel)

            controls.addChild(shootControls)

            
            self.addChild(controls)
        }

        let startMessage = SKLabelNode()
        startMessage.text = "Press space to begin (But click here first to gain keyboard focus)"
        startMessage.fontName = "Moon Light"
        startMessage.verticalAlignmentMode = .bottom
        startMessage.fontSize = 3 * unit
        startMessage.position.y = -0.5 * screenSize.height + unit
        startMessage.fontColor = SKColor.white
        self.addChild(startMessage)

        self.zPosition = 40
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func changeMoveControls(adControls: Bool) {
        arrowKeys.isHidden = adControls
        adKeys.isHidden = !adControls
    }
}
