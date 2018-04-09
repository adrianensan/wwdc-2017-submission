import SpriteKit

class ScoreDisplay: SKNode {

    var score: [SKLabelNode]

    override init() {
        self.score = [SKLabelNode]()
        super.init()
    }

    func reset() {
        self.removeChildren(in: self.score)
        self.score.removeAll()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(unit: CGFloat, destroyedRocks: Int, highscore: Int) {
        let scoreAsText = String(destroyedRocks)
        while self.score.count < scoreAsText.count {
            self.score.append(SKLabelNode(fontNamed: "Moon Light"))
            self.score[self.score.count - 1].fontSize = 7 * unit
            self.score[self.score.count - 1].fontColor = (self.score.count > 1) ? self.score[self.score.count - 2].fontColor : SKColor.white
            self.score[self.score.count - 1].zPosition = 30
            self.score[self.score.count - 1].horizontalAlignmentMode = .right
            self.score[self.score.count - 1].verticalAlignmentMode = .top
            self.score[self.score.count - 1].position.x = -3.5 * CGFloat(self.score.count - 1) * unit
            self.addChild(self.score[self.score.count - 1])
        }
        for digit in 0..<self.score.count {
            self.score[self.score.count - 1 - digit].text = String(scoreAsText[scoreAsText.index(scoreAsText.startIndex, offsetBy: digit)])
        }

        if (destroyedRocks > highscore) {
            for digit in self.score {
                digit.fontColor = SKColor(red: 1, green: 0.9, blue: 0, alpha: 1)
            }
        }
    }
}
