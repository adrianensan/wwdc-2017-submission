import SpriteKit

class SettingsOverlay: SKNode {

    let backButton: BackButton
    let matchPlayerOption, matchWorldOption, arrowKeysControl, adKeysControl: SKNode
    let matchPlayerCircle, matchWorldCircle, arrowKeysCircle, adKeysCircle: SKSpriteNode

    init(unit: CGFloat, screenSize: CGSize) {
        self.backButton = BackButton(unit: unit)

        matchPlayerOption = SKNode()
        matchWorldOption = SKNode()
        arrowKeysControl = SKNode()
        adKeysControl = SKNode()

        let optionCircle = SKShapeNode(circleOfRadius: 2 * unit)
        optionCircle.fillColor = SKColor.white
        optionCircle.lineWidth = 0
        let optionCircleTexture = SKView().texture(from: optionCircle)

        matchPlayerCircle = SKSpriteNode(texture: optionCircleTexture)
        matchWorldCircle = SKSpriteNode(texture: optionCircleTexture)
        arrowKeysCircle = SKSpriteNode(texture: optionCircleTexture)
        adKeysCircle = SKSpriteNode(texture: optionCircleTexture)

        super.init()

        backButton.position.x = -0.5 * screenSize.width + backButton.size.width + 2 * unit
        backButton.position.y = 0.5 * screenSize.height - backButton.size.height - 2 * unit
        backButton.zPosition = 1
        self.addChild(backButton)

        let fade = SKSpriteNode()
        fade.size = screenSize
        fade.color = SKColor.black
        fade.alpha = 0.5
        self.addChild(fade)

        let titleLabel = SKLabelNode()
        titleLabel.text = "SETTINGS"
        titleLabel.fontName = "Moon Bold"
        titleLabel.verticalAlignmentMode = .bottom
        titleLabel.fontSize = 12 * unit
        titleLabel.position.y = 0.5 * screenSize.height - 16 * unit
        titleLabel.zPosition = 1
        self.addChild(titleLabel)

        do { // Create Camera Angle Section
            let cameraAngle = SKNode()
            cameraAngle.position.y = 15 * unit

            let cameraAngleLabel = SKLabelNode()
            cameraAngleLabel.text = "Camera Angle:"
            cameraAngleLabel.fontName = "Moon Bold"
            cameraAngleLabel.horizontalAlignmentMode = .right
            cameraAngleLabel.verticalAlignmentMode = .center
            cameraAngleLabel.fontSize = 6 * unit
            cameraAngleLabel.position.x = -12 * unit
            cameraAngleLabel.fontColor = SKColor.white
            cameraAngle.addChild(cameraAngleLabel)


            matchPlayerOption.position.x = -4 * unit
            matchPlayerOption.position.y = 5 * unit
            matchPlayerOption.alpha = 0.75

            matchPlayerCircle.position.x = 2 * unit
            matchPlayerCircle.zPosition = 1
            matchPlayerOption.addChild(matchPlayerCircle)

            let matchPlayerLabel = SKLabelNode()
            matchPlayerLabel.text = "Follow Player"
            matchPlayerLabel.fontName = "Moon Light"
            matchPlayerLabel.horizontalAlignmentMode = .left
            matchPlayerLabel.verticalAlignmentMode = .center
            matchPlayerLabel.fontSize = 4.5 * unit
            matchPlayerLabel.position.x = 9 * unit
            matchPlayerLabel.fontColor = SKColor.white
            matchPlayerOption.addChild(matchPlayerLabel)

            cameraAngle.addChild(matchPlayerOption)


            matchWorldOption.position.x = -4 * unit
            matchWorldOption.position.y = -5 * unit
            matchWorldOption.alpha = 0.75

            matchWorldCircle.position.x = 2 * unit
            matchWorldCircle.zPosition = 1
            matchWorldOption.addChild(matchWorldCircle)

            let matchWorldLabel = SKLabelNode()
            matchWorldLabel.text = "Fixed on World"
            matchWorldLabel.fontName = "Moon Light"
            matchWorldLabel.horizontalAlignmentMode = .left
            matchWorldLabel.verticalAlignmentMode = .center
            matchWorldLabel.fontSize = 4.5 * unit
            matchWorldLabel.position.x = 9 * unit
            matchWorldLabel.fontColor = SKColor.white
            matchWorldOption.addChild(matchWorldLabel)

            cameraAngle.addChild(matchWorldOption)

            self.addChild(cameraAngle)

        }

        do { // Create Move Controls Section
            let moveControls = SKNode()
            moveControls.position.y = -15 * unit

            let controlsLabel = SKLabelNode()
            controlsLabel.text = "Move Controls:"
            controlsLabel.fontName = "Moon Bold"
            controlsLabel.horizontalAlignmentMode = .right
            controlsLabel.verticalAlignmentMode = .center
            controlsLabel.fontSize = 6 * unit
            controlsLabel.position.x = -12 * unit
            controlsLabel.fontColor = SKColor.white
            moveControls.addChild(controlsLabel)

            // Arrow Keys Control
            arrowKeysControl.position.x = -4 * unit
            arrowKeysControl.position.y = 5 * unit
            arrowKeysControl.alpha = 0.75

            arrowKeysCircle.position.x = 2 * unit
            arrowKeysCircle.zPosition = 1
            arrowKeysControl.addChild(arrowKeysCircle)

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

            let arrowKeys = SKSpriteNode(texture: arrowsTexture)
            arrowKeys.position.x = 18 * unit
            arrowKeys.zPosition = 1
            arrowKeysControl.addChild(arrowKeys)
            moveControls.addChild(arrowKeysControl)


            // AD Keys Control
            adKeysControl.position.x = -4 * unit
            adKeysControl.position.y = -5 * unit
            adKeysControl.alpha = 0.75

            adKeysCircle.position.x = 2 * unit
            adKeysCircle.zPosition = 1
            adKeysControl.addChild(adKeysCircle)

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

            let adKeys = SKSpriteNode(texture: adKeysTexture)
            adKeys.position.x = 18 * unit
            adKeys.zPosition = 1
            adKeysControl.addChild(adKeys)
            moveControls.addChild(adKeysControl)
            
            
            self.addChild(moveControls)
        }

        let bottomMessage = SKLabelNode()
        bottomMessage.text = "© Adrian Ensan  -  Made with love for WWDC 2017"
        bottomMessage.fontName = "Moon Light"
        bottomMessage.verticalAlignmentMode = .bottom
        bottomMessage.fontSize = 3 * unit
        bottomMessage.position.y = -0.5 * screenSize.height + unit
        bottomMessage.fontColor = SKColor.white
        self.addChild(bottomMessage)
        
        self.zPosition = 40
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func click(at point: CGPoint, settings: inout [String: Bool]) {
        let matchPlayerOptionPoint = convert(point, to: matchPlayerOption)
        let matchWorldOptionPoint = convert(point, to: matchWorldOption)
        let arrowKeysControlPoint = convert(point, to: arrowKeysControl)
        let adKeysControlPoint = convert(point, to: adKeysControl)

        if settings["isAngleFixedOnWorld"] == true && matchPlayerOptionPoint.x > 0 &&
            matchPlayerOptionPoint.x < 1.2 * matchPlayerOption.calculateAccumulatedFrame().width &&
            abs(matchPlayerOptionPoint.y) < 0.75 * matchPlayerOption.calculateAccumulatedFrame().height {
            settings["isAngleFixedOnWorld"] = false
        } else if settings["isAngleFixedOnWorld"] == false && matchWorldOptionPoint.x > 0 &&
            matchWorldOptionPoint.x < 1.2 * matchWorldOption.calculateAccumulatedFrame().width &&
            abs(matchWorldOptionPoint.y) < 0.75 * matchWorldOption.calculateAccumulatedFrame().height {
            settings["isAngleFixedOnWorld"] = true
        } else if settings["useADKeys"] == true && arrowKeysControlPoint.x > 0 &&
            arrowKeysControlPoint.x < 1.2 * arrowKeysControl.calculateAccumulatedFrame().width &&
            abs(arrowKeysControlPoint.y) < 0.75 * arrowKeysControl.calculateAccumulatedFrame().height {
            settings["useADKeys"] = false
        } else if settings["useADKeys"] == false && adKeysControlPoint.x > 0 &&
            adKeysControlPoint.x < 1.2 * adKeysControl.calculateAccumulatedFrame().width &&
            abs(adKeysControlPoint.y) < 0.75 * adKeysControl.calculateAccumulatedFrame().height {
            settings["useADKeys"] = true
        }

    }
    
    func update( settings: [String: Bool]) {
        self.backButton.update()
        if matchPlayerOption.alpha != (settings["isAngleFixedOnWorld"] == true ? 0.5 : 1) {
            matchPlayerOption.alpha += 0.0625 * (settings["isAngleFixedOnWorld"] == true ? -1 : 1)
            let percentage = (matchPlayerOption.alpha - 0.5) / 0.5
            matchWorldOption.alpha = 1 - 0.25 * percentage
            if settings["isAngleFixedOnWorld"] == false {
                if percentage > 0.8 {
                    matchPlayerCircle.setScale(1.2 - 0.2 * (percentage - 0.8) / 0.2)
                } else {
                    matchPlayerCircle.setScale(0.2 + 1 * (percentage / 0.8))
                }
                matchWorldCircle.setScale(1 - 0.8 * percentage)
            } else {
                matchPlayerCircle.setScale(0.2 + 0.8 * percentage)
                if percentage < 0.2 {
                    matchWorldCircle.setScale(1 + 0.2 * percentage / 0.2)
                } else {
                    matchWorldCircle.setScale(1.2 - 1 * (percentage - 0.2) / 0.8)
                }
            }
        }

        if arrowKeysControl.alpha != (settings["useADKeys"] == true ? 0.5 : 1) {
            arrowKeysControl.alpha += 0.0625 * (settings["useADKeys"] == true ? -1 : 1)
            let percentage = (arrowKeysControl.alpha - 0.5) / 0.5
            adKeysControl.alpha = 1 - 0.25 * percentage
            if settings["useADKeys"] == false {
                if percentage > 0.8 {
                    arrowKeysCircle.setScale(1.2 - 0.2 * (percentage - 0.8) / 0.2)
                } else {
                    arrowKeysCircle.setScale(0.2 + 1 * (percentage / 0.8))
                }
                adKeysCircle.setScale(1 - 0.8 * percentage)
            } else {
                arrowKeysCircle.setScale(0.2 + 0.8 * percentage)
                if percentage < 0.2 {
                    adKeysCircle.setScale(1 + 0.2 * percentage / 0.2)
                } else {
                    adKeysCircle.setScale(1.2 - 1 * (percentage - 0.2) / 0.8)
                }
            }
        }
    }
}
