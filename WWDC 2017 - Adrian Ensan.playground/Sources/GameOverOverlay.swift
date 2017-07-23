import SpriteKit

class GameOverOverlay: SKNode {

    var waitingForInput: Bool
    var cursorBlinkCounter: Int
    let scoreMessage: SKLabelNode
    let deathMessage: SKLabelNode
    let highscoreTitle: SKLabelNode
    var highscoreLabels: [(number: SKLabelNode, name: SKLabelNode, score: SKLabelNode)]
    let restartMessage: SKLabelNode
    var editingLabel: SKLabelNode?
    let cursor: SKShapeNode
    let maxNameWidth: CGFloat

    enum DeathType {
        case planet
        case asteroid
        case enemy

        var message: String {
            switch self {
            case .planet:
                return "crashing into a planet"
            case .asteroid:
                return "getting hit by an asteroid"
            case .enemy:
                return "getting shot down by an enemy"
            }
        }
    }

    init(unit: CGFloat, screenSize: CGSize) {
        self.waitingForInput = false
        self.cursorBlinkCounter = 30
        self.scoreMessage = SKLabelNode()
        self.deathMessage = SKLabelNode()
        self.highscoreTitle = SKLabelNode()
        self.highscoreLabels = [(number: SKLabelNode, name: SKLabelNode, score: SKLabelNode)]()
        self.restartMessage = SKLabelNode()
        self.cursor = SKShapeNode(rectOf: CGSize(width: 0.5 * unit, height: 4.5 * unit), cornerRadius: 0.24 * unit)
        self.maxNameWidth = 35 * unit
        super.init()

        let fade = SKSpriteNode()
        fade.size = screenSize
        fade.color = SKColor.black
        fade.alpha = 0.5
        self.addChild(fade)

        let gameOverLabel = SKLabelNode()
        gameOverLabel.text = "GAME OVER"
        gameOverLabel.fontName = "Moon Bold"
        gameOverLabel.verticalAlignmentMode = .bottom
        gameOverLabel.fontSize = 12 * unit
        gameOverLabel.position.y = 0.5 * screenSize.height - 16 * unit
        self.addChild(gameOverLabel)

        self.scoreMessage.fontName = "Moon Light"
        self.scoreMessage.verticalAlignmentMode = .center
        self.scoreMessage.fontSize = 4.5 * unit
        self.scoreMessage.position.y = 20 * unit
        self.addChild(self.scoreMessage)

        self.deathMessage.fontName = "Moon Light"
        self.deathMessage.verticalAlignmentMode = .center
        self.deathMessage.fontSize = 4.5 * unit
        self.deathMessage.position.y = 14 * unit
        self.addChild(self.deathMessage)

        self.highscoreTitle.fontName = "Moon Light"
        self.highscoreTitle.verticalAlignmentMode = .center
        self.highscoreTitle.fontSize = 4.5 * unit
        self.highscoreTitle.position.y = -5 * unit
        self.addChild(self.highscoreTitle)

        for i in 0..<5 {
            let highscoreNumberLabel = SKLabelNode()
            highscoreNumberLabel.text = "\(i + 1)"
            highscoreNumberLabel.fontName = "Moon Light"
            highscoreNumberLabel.horizontalAlignmentMode = .right
            highscoreNumberLabel.verticalAlignmentMode = .center
            highscoreNumberLabel.fontSize = 4 * unit
            highscoreNumberLabel.position.x = -22.5 * unit
            highscoreNumberLabel.position.y = -12 * unit - CGFloat(i) * 5 * unit
            self.addChild(highscoreNumberLabel)

            let highscoreNameLabel = SKLabelNode()
            highscoreNameLabel.text = "- - - - -"
            highscoreNameLabel.fontName = "Moon Light"
            highscoreNameLabel.horizontalAlignmentMode = .left
            highscoreNameLabel.verticalAlignmentMode = .center
            highscoreNameLabel.fontSize = 4 * unit
            highscoreNameLabel.position.x = -20 * unit
            highscoreNameLabel.position.y = -12 * unit - CGFloat(i) * 5 * unit
            self.addChild(highscoreNameLabel)

            let highscoreScoreLabel = SKLabelNode()
            highscoreScoreLabel.text = "-"
            highscoreScoreLabel.fontName = "Moon Light"
            highscoreScoreLabel.horizontalAlignmentMode = .right
            highscoreScoreLabel.verticalAlignmentMode = .center
            highscoreScoreLabel.fontSize = 4 * unit
            highscoreScoreLabel.position.x = 25 * unit
            highscoreScoreLabel.position.y = -12 * unit - CGFloat(i) * 5 * unit
            self.addChild(highscoreScoreLabel)

            self.highscoreLabels.append(number: highscoreNumberLabel, name: highscoreNameLabel, score: highscoreScoreLabel)
        }

        self.restartMessage.fontName = "Moon Light"
        self.restartMessage.verticalAlignmentMode = .bottom
        self.restartMessage.fontSize = 3 * unit
        self.restartMessage.position.y = -0.5 * screenSize.height + 2 * unit
        self.addChild(self.restartMessage)

        self.cursor.position.y = -20 * unit
        self.cursor.fillColor = SKColor.white
        self.cursor.lineWidth = 0
        self.cursor.alpha = 0
        self.cursor.zPosition = 1
        self.addChild(self.cursor)

        self.zPosition = 40
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func enterName() {
        self.waitingForInput = false
        self.restartMessage.text = "Press the space key to start a new journey"
        self.cursor.alpha = 0
        self.editingLabel = nil
    }

    func setDeathMessage(deathType: DeathType, destroyedRocks: Int, highscores: [(score: Int, name: String)], currentHighScore: Int) {
        self.scoreMessage.text = "You scored \(destroyedRocks) points"
        self.deathMessage.text = "before " + deathType.message

        if currentHighScore > -1 {
            self.highscoreTitle.text = "New Highscore!"
            self.highscoreTitle.fontColor = SKColor(red: 1, green: 0.9, blue: 0, alpha: 1)
            self.restartMessage.text = "Type your name and press enter"
        } else {
            self.highscoreTitle.text = "Highscores"
            self.highscoreTitle.fontColor = SKColor.white
            self.restartMessage.text = "Press the space key to start a new journey"
        }

        for i in 0..<highscores.count where highscores[i].score > 0 {
            self.highscoreLabels[i].name.text = highscores[i].name
            resizeLabel(nameLabel: self.highscoreLabels[i].name)

            self.highscoreLabels[i].score.text = "\(highscores[i].score)"
            if currentHighScore == i {
                self.waitingForInput = true
                self.cursor.alpha = 1
                self.cursor.position.y = self.highscoreLabels[i].name.position.y
                self.cursorBlinkCounter = 30
                self.highscoreLabels[i].number.fontColor = SKColor(red: 1, green: 0.9, blue: 0, alpha: 1)
                self.highscoreLabels[i].name.fontColor = SKColor(red: 1, green: 0.9, blue: 0, alpha: 1)
                self.highscoreLabels[i].score.fontColor = SKColor(red: 1, green: 0.9, blue: 0, alpha: 1)
                self.editingLabel = self.highscoreLabels[i].name
            } else {
                self.highscoreLabels[i].number.fontColor = SKColor.white
                self.highscoreLabels[i].name.fontColor = SKColor.white
                self.highscoreLabels[i].score.fontColor = SKColor.white
            }
        }
    }

    func update(unit: CGFloat) {
        self.cursorBlinkCounter -= 1
        if self.cursorBlinkCounter == 0 {
            self.cursorBlinkCounter = 30
            self.cursor.alpha = 1 - self.cursor.alpha
        }
        if let editingLabel = self.editingLabel {
            var trailingSpaces: CGFloat = 0
            if let text = editingLabel.text {
                var i = text.endIndex
                while i != text.startIndex && text.index(before: i) != text.startIndex && " \t".contains(String(text[text.index(before: i)])) {
                    trailingSpaces += 1
                    i = text.index(before: i)
                }
            }
            self.cursor.position.x = editingLabel.position.x + editingLabel.calculateAccumulatedFrame().width + unit + trailingSpaces * unit
        }
    }

    func resizeLabel(nameLabel: SKLabelNode) {
        nameLabel.setScale(1)
        var nameLabelWidth = nameLabel.calculateAccumulatedFrame().width
        if nameLabelWidth > self.maxNameWidth {
            let ratio: CGFloat = self.maxNameWidth / nameLabelWidth
            nameLabel.setScale(ratio)
            nameLabelWidth = nameLabel.calculateAccumulatedFrame().width
        }
        self.cursor.setScale(nameLabel.xScale)
    }
}
