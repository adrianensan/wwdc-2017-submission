import PlaygroundSupport
import SpriteKit

#if os(watchOS)
    import WatchKit
    // <rdar://problem/26756207> SKColor typealias does not seem to be exposed on watchOS SpriteKit
    typealias SKColor = UIColor
#endif

public class GameScene: SKScene {

    var settings: [String: Bool] {
        didSet {
            saveSettings()
            self.introOverlay.changeMoveControls(adControls: self.settings["useADKeys"] == true)
        }
    }
    let world: SKNode
    var destroyedRocks: Int
    var targetMoveSpeed: CGFloat
    var moveSpeed: CGFloat
    var angle: CGFloat
    let screenDiagonal: CGFloat
    var leftKeyDown, rightKeyDown, upKeyDown, downKeyDown: Bool
    var smokeCounter: UInt8
    var enemySpawnCounter: Int
    var enemyShootFrequencyCounter: Int
    let unit: CGFloat
    var highscores: [(score: Int, name: String)]
    var currentHighScore: Int
    var laserTexture: SKTexture?
    var theme: Theme

    let player: Player
    var playerSmokeTrail: [SKSpriteNode]
    var lasers: [SKSpriteNode]
    var planets: [Planet]
    var asteroids: [Asteroid]
    let stars: [[SKSpriteNode]]

    let lightning: SKSpriteNode

    let scoreDisplay: ScoreDisplay

    let introOverlay: IntroOverlay
    let gameOverOverlay: GameOverOverlay
    let settingsOverlay: SettingsOverlay

    let settingsButton: SettingsButton

    override public init(size: CGSize) {
        self.settings = ["isAngleFixedOnWorld": false,
                         "useADKeys": false]
        self.world = SKNode()
        self.destroyedRocks = 0
        self.leftKeyDown = false
        self.rightKeyDown = false
        self.upKeyDown = false
        self.downKeyDown = false
        self.smokeCounter = 0
        self.enemySpawnCounter = 0
        self.enemyShootFrequencyCounter = 0
        self.unit = min(size.width, size.height) / 120
        self.highscores = [(score: Int, name: String)]()
        self.currentHighScore = -1
        self.theme = .red
        self.targetMoveSpeed = 0
        self.moveSpeed = 0
        self.angle = 0
        self.screenDiagonal = sqrt(size.width * size.width + size.height * size.height)
        self.player = Player(unit: self.unit)
        self.playerSmokeTrail = [SKSpriteNode(), SKSpriteNode(), SKSpriteNode(), SKSpriteNode(), SKSpriteNode(), SKSpriteNode(), SKSpriteNode(), SKSpriteNode()]
        self.lasers = [SKSpriteNode]()
        self.planets = [Planet]()
        self.asteroids = [Asteroid]()
        self.lightning = SKSpriteNode()
        self.scoreDisplay = ScoreDisplay()
        self.introOverlay = IntroOverlay(unit: self.unit, screenSize: size)
        self.gameOverOverlay = GameOverOverlay(unit: self.unit, screenSize: size)
        self.settingsOverlay = SettingsOverlay(unit: self.unit, screenSize: size)
        self.settingsButton = SettingsButton(unit: unit)
        var tempStars = [[SKSpriteNode]]()
        for i in 0..<3 {
            var starLayer = [SKSpriteNode]()
            for _ in 0..<10 + 5 * i {
                let star = SKSpriteNode()
                starLayer.append(star)
            }
            tempStars.append(starLayer)
        }
        self.stars = tempStars

        if let fontURL = Bundle.main.url(forResource: "Moon Bold", withExtension: "otf") {
            CTFontManagerRegisterFontsForURL(fontURL as CFURL, CTFontManagerScope.process, nil)
        }
        if let fontURL = Bundle.main.url(forResource: "Moon Light", withExtension: "otf") {
            CTFontManagerRegisterFontsForURL(fontURL as CFURL, CTFontManagerScope.process, nil)
        }
        super.init(size: size)

        self.loadScore()
        self.loadSettings()

        let planetTexture: SKTexture?
        let planetFeatureTexture: SKTexture?
        do { // Create Planet Textures
            let radius: CGFloat = 45 * self.unit
            let planetShape = SKShapeNode(circleOfRadius: radius)
            planetShape.fillColor = SKColor.white
            planetShape.lineWidth = 0

            let shadowAngle: CGFloat = 0.25 * .pi

            let planetShadowPath = CGMutablePath()
            planetShadowPath.addArc(center: CGPoint(x: 0, y: 0),
                                    radius: radius,
                                    startAngle: 0.5 * .pi,
                                    endAngle: -0.5 * .pi,
                                    clockwise: true)
            planetShadowPath.addArc(center: CGPoint(x: -radius * tan(shadowAngle), y: 0),
                                    radius: radius / cos(shadowAngle),
                                    startAngle: -0.5 * .pi + shadowAngle,
                                    endAngle: 0.5 * .pi - shadowAngle,
                                    clockwise: false)
            planetShadowPath.closeSubpath()
            let planetShadow = SKShapeNode()
            planetShadow.fillColor = SKColor.black
            planetShadow.alpha = 0.1
            planetShadow.lineWidth = 0
            planetShadow.zPosition = 2
            planetShadow.zRotation = -0.25 * .pi
            planetShadow.path = planetShadowPath

            planetShape.addChild(planetShadow)

            planetTexture = SKView().texture(from: planetShape,
                                             crop: CGRect(origin: CGPoint(x: -radius, y: -radius),
                                                          size: CGSize(width: 2 * radius, height: 2 * radius)))

            let planetFeatureShape = SKShapeNode(rectOf: CGSize(width: 0.4 * radius, height: 0.1 * radius),
                                                 cornerRadius: 0.049 * radius)
            planetFeatureShape.fillColor = SKColor.white
            planetFeatureShape.lineWidth = 0

            planetFeatureTexture = SKView().texture(from: planetFeatureShape)
        }

        do { // Create Laser Texture
            let laserPath = CGMutablePath()
            laserPath.addLines(between: [CGPoint(x: 0, y: 8 * self.unit),
                                         CGPoint(x: 0.25 * self.unit, y: 8.5 * self.unit),
                                         CGPoint(x: 0.5 * self.unit, y: 8 * self.unit),
                                         CGPoint(x: 0.5 * self.unit, y: 0),
                                         CGPoint(x: 0.25 * self.unit, y: -0.5 * self.unit),
                                         CGPoint(x: 0, y: 0),
                                         CGPoint(x: 0, y: 8 * self.unit)])
            let laserShape = SKShapeNode(path: laserPath)
            laserShape.fillColor = SKColor.white
            laserShape.strokeColor = SKColor(red: 1, green: 0.26, blue: 0.09, alpha: 1)
            laserShape.lineWidth = 0.05 * self.unit
            laserShape.glowWidth = 0.15 * self.unit

            self.laserTexture = SKView().texture(from: laserShape)
        }

        for _ in 0..<30 {
            let planet = Planet(unit: self.unit,
                                planetTexture: planetTexture,
                                planetFeatureTexture: planetFeatureTexture)
            planet.zPosition = 11
            self.planets.append(planet)
            self.world.addChild(planet)
        }

        for _ in 0..<10 {
            let asteroid = Asteroid(unit: self.unit)
            asteroid.zPosition = 15
            self.asteroids.append(asteroid)
            self.world.addChild(asteroid)
        }

        do { // Initialize Stars
            let starShape = SKShapeNode(circleOfRadius: 2 * self.unit)
            starShape.fillColor = SKColor.white
            starShape.lineWidth = 0
            let starTexture = SKView().texture(from: starShape)
            for i in 0..<self.stars.count {
                for star in self.stars[i] {
                    star.texture = starTexture
                    star.zPosition = 8
                    self.world.addChild(star)
                }
            }
        }

        self.world.addChild(self.player)

        for smoke in self.playerSmokeTrail {
            smoke.size = CGSize(width: 2.5 * self.unit, height: 2.5 * self.unit)
        }

        settingsButton.position.x = 0.5 * size.width - settingsButton.size.width - 2 * unit
        settingsButton.position.y = 0.5 * size.height - settingsButton.size.height - 2 * unit
        settingsButton.zPosition = 1

        self.lightning.size = size
        self.lightning.color = SKColor.white
        self.lightning.alpha = 0
        self.lightning.zPosition = 100
        self.addChild(self.lightning)

        self.scoreDisplay.position.x = 0.5 * size.width - self.unit
        self.scoreDisplay.position.y = 0.5 * size.height - self.unit

        self.scaleMode = .aspectFit
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)

        self.addChild(self.gameOverOverlay)
        self.addChild(self.world)
        self.reset(background: true)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func reset(background: Bool = false) {
        self.world.zRotation = 0
        self.theme = Theme.random
        self.destroyedRocks = 0
        self.leftKeyDown = false
        self.rightKeyDown = false
        self.smokeCounter = 0
        self.enemySpawnCounter = 50 + Int(arc4random_uniform(100))
        self.enemyShootFrequencyCounter = 20
        self.targetMoveSpeed = background ? 0.5 : 1.5
        self.moveSpeed = 1.5
        self.angle = background ? Random.percentage * 2 * .pi : 0
        self.scoreDisplay.reset()
        self.scoreDisplay.update(unit: self.unit,
                                 destroyedRocks: self.destroyedRocks,
                                 highscore: self.highscores[0].score)
        self.gameOverOverlay.removeFromParent()
        if background {
            self.addChild(self.introOverlay)
            self.introOverlay.addChild(settingsButton)
        } else {
            self.player.reset(unit: self.unit)
            self.introOverlay.removeFromParent()
            settingsButton.removeFromParent()
            self.addChild(self.scoreDisplay)
            for smoke in self.playerSmokeTrail {
                smoke.position.y = -10000
                self.world.addChild(smoke)
            }
        }

        for planet in self.planets {
            planet.position.y = -100000
            planet.planet.zRotation = 0
        }

        for asteroid in self.asteroids {
            asteroid.position.y = -100000
        }

        self.player.position.y = -100 * self.unit

        for i in 0..<self.stars.count {
            for star in self.stars[i] {
                star.alpha = 0.8 - 0.2 * CGFloat(i + 1) * Random.percentage
                star.size.width = (1 + Random.percentage) * self.unit
                star.size.height = star.size.width
                star.position.x = Random.direction * Random.percentage * 0.5 * self.screenDiagonal
                star.position.y = Random.direction * Random.percentage * 0.5 * self.screenDiagonal
            }
        }

        self.backgroundColor = theme.background
    }

    func shoot() {
        guard self.player.position.y > -5 * self.unit else {
            return
        }

        let leftLaser = SKSpriteNode(texture: self.laserTexture)
        leftLaser.anchorPoint = CGPoint(x: 0.5, y: 1)
        leftLaser.position.x = 2.75 * unit * cos(self.angle) - 6 * unit * sin(self.angle)
        leftLaser.position.y = 6 * unit * cos(self.angle) + 2.75 * unit * sin(self.angle)
        leftLaser.zRotation = self.angle
        leftLaser.zPosition = 30
        self.lasers.append(leftLaser)
        self.world.addChild(leftLaser)


        let rightLaser = SKSpriteNode(texture: self.laserTexture)
        rightLaser.anchorPoint = CGPoint(x: 0.5, y: 1)
        rightLaser.position.x = -2.75 * unit * cos(self.angle) - 6 * unit * sin(self.angle)
        rightLaser.position.y = 6 * unit * cos(self.angle) - 2.75 * unit * sin(self.angle)
        rightLaser.zRotation = self.angle
        rightLaser.zPosition = 30
        self.lasers.append(rightLaser)
        self.world.addChild(rightLaser)
    }

    override public func keyDown(with event: NSEvent) {
        guard !event.isARepeat && self.settingsOverlay.parent == nil else {
            return
        }
        NSCursor.setHiddenUntilMouseMoves(true)
        if !self.player.isDead {
            if event.keyCode == leftKey && settings["useADKeys"] == false ||
               event.keyCode == aKey && settings["useADKeys"] == true {
                leftKeyDown = true
                rightKeyDown = false
            } else if event.keyCode == rightKey && settings["useADKeys"] == false ||
                      event.keyCode == dKey && settings["useADKeys"] == true {
                rightKeyDown = true
                leftKeyDown = false
            } else if !self.player.isDead && event.keyCode == spaceKey {
                self.shoot()
            }
        } else if self.gameOverOverlay.waitingForInput {
            if event.keyCode == backspaceKey && self.gameOverOverlay.editingLabel?.text?.characters.count ?? 0 > 0 {
                if let baseText = self.gameOverOverlay.editingLabel?.text {
                    var text = baseText
                    text.remove(at: text.index(before: text.endIndex))
                    self.gameOverOverlay.editingLabel?.text = text
                    self.gameOverOverlay.resizeLabel(nameLabel: self.gameOverOverlay.editingLabel!)
                }
            } else if event.keyCode == enterKey , let name = self.gameOverOverlay.editingLabel?.text?.trimmingCharacters(in: .whitespaces) {
                if name.characters.count > 0 {
                    self.highscores[self.currentHighScore].name = name
                    self.gameOverOverlay.enterName()
                    self.saveScores()
                    self.currentHighScore = -1
                }
            } else if self.gameOverOverlay.editingLabel?.text?.characters.count ?? 0 <= 20 && ![123, 124, 125, 126, enterKey, backspaceKey].contains(event.keyCode) {
                self.gameOverOverlay.editingLabel?.text = (self.gameOverOverlay.editingLabel?.text ?? "") + (event.characters ?? "")
                self.gameOverOverlay.resizeLabel(nameLabel: self.gameOverOverlay.editingLabel!)
            }
        } else if (self.introOverlay.parent == self || (self.player.explosion?.flash.alpha ?? 1) == 0) && event.keyCode == spaceKey {
            self.reset()
        }
    }

    override public func keyUp(with event: NSEvent) {
        if event.keyCode == leftKey && settings["useADKeys"] == false ||
           event.keyCode == aKey && settings["useADKeys"] == true {
            leftKeyDown = false
        } else if event.keyCode == rightKey && settings["useADKeys"] == false ||
                  event.keyCode == dKey && settings["useADKeys"] == true {
            rightKeyDown = false
        }
    }

    public override func mouseDown(with event: NSEvent) {
        if self.settingsOverlay.parent == self {
            let point = event.location(in: self.settingsOverlay.backButton)
            if abs(point.x) <= 0.5 * self.settingsOverlay.backButton.size.width &&
                abs(point.y) <= 0.5 * self.settingsOverlay.backButton.size.height {
                self.settingsOverlay.backButton.isSelected = true
            } else {
                self.settingsOverlay.click(at: event.location(in: self.settingsOverlay), settings: &self.settings)
            }
        } else if self.introOverlay.parent == self || self.gameOverOverlay.parent == self {
            let point = event.location(in: self.settingsButton)
            if abs(point.x) <= 0.5 * self.settingsButton.size.width &&
                abs(point.y) <= 0.5 * self.settingsButton.size.height {
                self.settingsButton.isSelected = true
            }
        }
    }

    public override func mouseDragged(with event: NSEvent) {
        if self.settingsOverlay.parent == self {
            let point = event.location(in: self.settingsOverlay.backButton)
            if abs(point.x) > 0.5 * self.settingsOverlay.backButton.size.width ||
                abs(point.y) > 0.5 * self.settingsOverlay.backButton.size.height {
                self.settingsOverlay.backButton.isSelected = false
            }
        } else if self.introOverlay.parent == self || self.gameOverOverlay.parent == self {
            let point = event.location(in: self.settingsButton)
            if abs(point.x) > 0.5 * self.settingsButton.size.width ||
                abs(point.y) > 0.5 * self.settingsButton.size.height {
                self.settingsButton.isSelected = false
            }
        }
    }

    public override func mouseUp(with event: NSEvent) {
        if self.settingsOverlay.parent == self {
            if self.settingsOverlay.backButton.isSelected {
                self.settingsOverlay.backButton.isSelected = false
                self.settingsOverlay.removeFromParent()
                self.introOverlay.isHidden = false
                self.gameOverOverlay.isHidden = false
            }
        } else if self.introOverlay.parent == self || self.gameOverOverlay.parent == self {
            if self.settingsButton.isSelected {
                self.settingsButton.isSelected = false
                self.introOverlay.isHidden = true
                self.gameOverOverlay.isHidden = true
                self.addChild(self.settingsOverlay)
            }
        }
    }

    func saveSettings() {
        if let path = Bundle.main.url(forResource: "settings", withExtension: nil) {
            var settingsString = ""
            if self.settings["isAngleFixedOnWorld"] == true {
                settingsString += "isAngleFixedOnWorld\n"
            }
            if self.settings["useADKeys"] == true {
                settingsString += "useADKeys\n"
            }
            do {
                try settingsString.write(to: path, atomically: false, encoding: .unicode)
            } catch {}
        }
    }

    func loadSettings() {
        if let path = Bundle.main.url(forResource: "settings", withExtension: nil) {
            var settingsString = ""
            do {
                settingsString = try String(contentsOf: path, encoding: .unicode)
            } catch {}
            for setting in settingsString.components(separatedBy: .newlines) {
                self.settings[setting] = true
            }
        }
    }

    func checkScore() {
        guard self.destroyedRocks > 0 else {
            return
        }
        var i = 0
        while i < self.highscores.count , self.destroyedRocks <= self.highscores[i].score {
            i += 1
        }
        if i < 5 {
            self.highscores.insert((score: self.destroyedRocks, name: ""), at: i)
            self.currentHighScore = i
            if self.highscores.count > 5 {
                self.highscores.removeLast()
            }
        }
    }

    func loadScore() {
        if let path = Bundle.main.url(forResource: "highscore", withExtension: nil) {
            var failed = false
            do {
                let highscoreFile = try String(contentsOf: path, encoding: .unicode)
                let highscoreStrings = highscoreFile.components(separatedBy: .newlines)
                var i: Int64 = 1
                for highscoreString in highscoreStrings where highscoreString.characters.count > 0 {
                    let fields = highscoreString.components(separatedBy: "|")
                    if fields.count == 3,
                        let score = Int(fields[0]),
                        let secret = Int64(fields[2]) {
                        var verification = secret
                        let name = fields[1]
                        for character in name.unicodeScalars.reversed() {
                            verification /= 2
                            verification -= i
                            verification -= Int64(character.value)
                        }
                        verification /= 12
                        verification -= 55
                        if Int64(score) == verification {
                            self.highscores.append((score: score, name: name))
                        } else {
                            failed = true
                        }
                    } else {
                        failed = true
                    }
                    i += 1
                }
            } catch {}
            if failed || self.highscores.count == 0 {
                self.highscores = [(score: 0, name: "")]
                if failed {
                    self.introOverlay.addChild(self.introOverlay.tamperedScoresMessage)
                }
            }
        }
    }

    func saveScores() {
        if let path = Bundle.main.url(forResource: "highscore", withExtension: nil) {
            do {
                var highscoresString = ""
                var i: Int64 = 1
                for (score, name) in self.highscores where score > 0 {
                    if highscoresString != "" {
                        highscoresString += "\n"
                    }
                    var secret: Int64 = Int64(score) + 55
                    secret *= 12
                    for character in name.unicodeScalars {
                        secret += Int64(character.value)
                        secret += i
                        secret *= 2
                    }
                    highscoresString += "\(score)|\(name)|\(secret)"
                    i += 1
                }
                try highscoresString.write(to: path, atomically: false, encoding: .unicode)
            } catch {}
        }
    }

    override public func update(_ currentTime: TimeInterval) {
        self.settingsButton.update()
        self.settingsOverlay.update(settings: self.settings)
        if self.lightning.alpha > 0 {
            self.lightning.alpha = 0
            if self.lightning.alpha > 0.984375 {
                self.lightning.alpha -= 0.0078125
            } else {
                self.lightning.alpha = 0
            }
        }
        self.player.update(unit: self.unit, angle: self.angle)
        self.player.position.y = 0.95 * self.player.position.y
        if self.player.flashIsFullscreen() {
            for smoke in self.playerSmokeTrail {
                smoke.removeFromParent()
            }
            self.player.player.removeFromParent()
            self.player.flame.removeFromParent()
            self.scoreDisplay.removeFromParent()
            self.addChild(self.gameOverOverlay)
            self.gameOverOverlay.addChild(settingsButton)
            if self.settings["isAngleFixedOnWorld"] == true {
                self.angle = 0
            }
        }
        let objectSpeed: CGFloat = -self.moveSpeed * self.unit * (self.player.isDead && self.introOverlay.parent != self ? 0 : 1)
        self.moveSpeed += (self.targetMoveSpeed - self.moveSpeed) / 15
        let objectMoveVector: [CGFloat] = [-objectSpeed * sin(self.angle), objectSpeed * cos(self.angle)]
        if self.settings["isAngleFixedOnWorld"] == false && self.introOverlay.parent != self && self.settingsOverlay.parent != self {
            self.world.zRotation += (-self.angle - self.world.zRotation) / 15
        }

        for laser in self.lasers {
            laser.position.x += -5 * self.unit * sin(laser.zRotation) + objectMoveVector[0]
            laser.position.y += 5 * self.unit * cos(laser.zRotation) + objectMoveVector[1]
            if distance(point1: self.player.position, point2: laser.position) > 0.5 * self.screenDiagonal + 6 * self.unit {
                laser.removeFromParent()
                self.lasers.remove(at: self.lasers.index(of: laser)!)
            }
        }

        for asteroid in self.asteroids {
            asteroid.update(unit: self.unit)
            asteroid.position.x += objectMoveVector[0]
            asteroid.position.y += objectMoveVector[1]
            if !asteroid.isDestroyed {
                let futureAsteroidPosition = CGPoint(x: asteroid.position.x + 50 * objectMoveVector[0],
                                                     y: asteroid.position.y + 50 * objectMoveVector[1])
                if distance(point1: self.player.position, point2: futureAsteroidPosition) > self.screenDiagonal {
                    asteroid.reset(unit: self.unit, theme: self.theme)
                    let random = Random.percentage
                    asteroid.position.x = Random.direction * 0.6 * self.screenDiagonal * (random > 0.5 ? 1 : Random.percentage)
                    asteroid.position.y = Random.direction * 0.6 * self.screenDiagonal * (random <= 0.5 ? 1 : Random.percentage)
                }
            } else if asteroid.explosion == nil {
                asteroid.reset(unit: self.unit, theme: self.theme)
                let random = Random.percentage
                asteroid.position.x = Random.direction * 0.6 * self.screenDiagonal * (random > 0.5 ? 1 : Random.percentage)
                asteroid.position.y = Random.direction * 0.6 * self.screenDiagonal * (random <= 0.5 ? 1 : Random.percentage)
            } else if asteroid.asteroid.alpha != 0 && (asteroid.explosion?.flash.alpha ?? 1) == 0 {
                asteroid.asteroid.alpha = 0
            }
        }

        for planet in self.planets {
            planet.update(unit: self.unit)
            if self.settings["isAngleFixedOnWorld"] == false && self.introOverlay.parent != self && self.settingsOverlay.parent != self {
                planet.planet.zRotation += (self.angle - planet.planet.zRotation) / 15
            }
            if !self.player.isDead || self.introOverlay.parent == self {
                planet.position.x += objectMoveVector[0]
                planet.position.y += objectMoveVector[1]
                let futurePlanetPosition = CGPoint(x: planet.position.x + 50 * objectMoveVector[0],
                                                   y: planet.position.y + 50 * objectMoveVector[1])
                if distance(point1: self.player.position, point2: futurePlanetPosition) > 2 * self.screenDiagonal {
                    planet.reset(unit: self.unit, theme: self.theme)
                    let newX: CGFloat = Random.direction * Random.percentage * 0.5 * self.screenDiagonal
                    var newY: CGFloat = self.screenDiagonal + CGFloat(arc4random_uniform(50)) * self.unit
                    planet.position.x = newX * cos(self.angle) - newY * sin(self.angle)
                    planet.position.y = newY * cos(self.angle) + newX * sin(self.angle)
                    var good = false
                    while !good {
                        good = true
                        for otherPlanet in self.planets where otherPlanet != planet {
                            var planetSpacing = distance(point1: otherPlanet.position,
                                                         point2: planet.position)
                            let desiredSpacing: CGFloat = (otherPlanet.radius + planet.radius + 50) * self .unit
                            while planetSpacing < desiredSpacing {
                                good = false
                                newY += desiredSpacing - planetSpacing + 1
                                planet.position.x = newX * cos(self.angle) - newY * sin(self.angle)
                                planet.position.y = newY * cos(self.angle) + newX * sin(self.angle)
                                planetSpacing = distance(point1: otherPlanet.position,
                                                         point2: planet.position)
                            }
                            if !good {
                                break
                            }
                        }
                    }
                }
            }
        }

        for i in 0..<self.stars.count {
            for star in self.stars[i] {
                star.position.x += objectMoveVector[0] / CGFloat(i + 2)
                star.position.y += objectMoveVector[1] / CGFloat(i + 2)
                if distance(point1: CGPoint(x: 0, y: 0),
                            point2: star.position) > 0.6 * self.screenDiagonal {
                    star.alpha = 0.8 - 0.2 * CGFloat(i + 1) * Random.percentage
                    star.size.width = (1 + Random.percentage) * self.unit
                    star.size.height = star.size.width
                    let newX: CGFloat = Random.direction * Random.percentage * 2 * self.screenDiagonal
                    let newY: CGFloat = 0.5 * self.screenDiagonal + CGFloat(arc4random_uniform(25)) * self.unit
                    star.position.x = newX * cos(self.angle) - newY * sin(self.angle)
                    star.position.y = newY * cos(self.angle) + newX * sin(self.angle)
                }
            }
        }

        if !self.player.isDead {
            self.targetMoveSpeed += 0.00006103515625
            if self.player.position.y > -5 * unit {
                self.angle += 0.025 * CGFloat.pi * (self.leftKeyDown || self.rightKeyDown ? (self.leftKeyDown ? 1 : -1) : 0)
            }
            self.smokeCounter = (self.smokeCounter + 1) % 5
            for smoke in self.playerSmokeTrail {
                smoke.position.x += objectMoveVector[0]
                smoke.position.y += objectMoveVector[1]
                smoke.zRotation += (0.3 + 0.05 * Random.percentage) * .pi
                smoke.size.width -= 0.04 * self.unit
                smoke.size.height -= 0.04 * self.unit
                smoke.alpha -= 0.02
            }

            if self.smokeCounter == 0 {
                if self.player.isDamaged {
                    let offset = Random.direction * Random.percentage * 3 * unit
                    let x: CGFloat = offset * cos(self.angle) + 10 * unit * sin(self.angle)
                    let y: CGFloat = -10 * unit * cos(self.angle) + offset * sin(self.angle)
                    let smokeVector = [x, y]
                    self.playerSmokeTrail.insert(self.playerSmokeTrail.removeLast(), at: 0)
                    self.playerSmokeTrail[0].position = self.player.position
                    self.playerSmokeTrail[0].position.x += smokeVector[0]
                    self.playerSmokeTrail[0].position.y += smokeVector[1]
                    self.playerSmokeTrail[0].color = SKColor.black
                    let size: CGFloat = (1 + 4 * Random.percentage) * unit
                    self.playerSmokeTrail[0].size = CGSize(width: size, height: size)
                    self.playerSmokeTrail[0].alpha = 0.8 - 0.4 * Random.percentage
                } else {
                    let smokeVector = [10 * self.unit * sin(self.player.zRotation), -10 * self.unit * cos(self.player.zRotation)]
                    self.playerSmokeTrail.insert(self.playerSmokeTrail.removeLast(), at: 0)
                    self.playerSmokeTrail[0].position = self.player.position
                    self.playerSmokeTrail[0].position.x += smokeVector[0]
                    self.playerSmokeTrail[0].position.y += smokeVector[1]
                    self.playerSmokeTrail[0].color = SKColor.white
                    self.playerSmokeTrail[0].size = CGSize(width: 3 * unit, height: 3 * unit)
                    self.playerSmokeTrail[0].alpha = 0.9
                }
            }

            for planet in self.planets {
                if planet.planetExplosion == nil && !self.player.isDead && distance(point1: self.player.position, point2: planet.position) < (planet.radius + 2.5) * self.unit {
                    self.player.hit(unit: self.unit, theme: self.theme)
                    self.player.hit(unit: self.unit, theme: self.theme)
                    self.lightning.alpha = 1
                    self.checkScore()
                    self.gameOverOverlay.setDeathMessage(deathType: .planet,
                                                         destroyedRocks: self.destroyedRocks,
                                                         highscores: self.highscores,
                                                         currentHighScore: self.currentHighScore)
                }
                for laser in self.lasers {
                    if planet.planetExplosion == nil && distance(point1: laser.position,
                                                                 point2: planet.position) < planet.radius * self.unit {
                        let xHit: CGFloat = laser.position.x - planet.position.x
                        let yHit: CGFloat = laser.position.y - planet.position.y
                        planet.hit(at: CGPoint(x: xHit, y: yHit), unit: self.unit, theme: self.theme)
                        if planet.planetExplosion != nil {
                            self.destroyedRocks += 100
                            self.scoreDisplay.update(unit: self.unit,
                                                     destroyedRocks: self.destroyedRocks,
                                                     highscore: self.highscores[0].score)
                            self.lightning.alpha = 1
                        }
                        laser.removeFromParent()
                        self.lasers.remove(at: self.lasers.index(of: laser)!)
                    }
                }
            }

            for asteroid in self.asteroids where !asteroid.isDestroyed {
                if !self.player.isDead && distance(point1: self.player.position,
                                                   point2: asteroid.position) < 0.5 * asteroid.size * self.unit {
                    self.player.hit(unit: self.unit, theme: self.theme)
                    self.moveSpeed = 0.25;
                    self.destroyedRocks += 1
                    self.scoreDisplay.update(unit: self.unit,
                                             destroyedRocks: self.destroyedRocks,
                                             highscore: self.highscores[0].score)
                    self.lightning.alpha = 1
                    asteroid.explode(unit: self.unit, theme: self.theme)
                    if self.player.isDead {
                        self.checkScore()
                        self.gameOverOverlay.setDeathMessage(deathType: .asteroid,
                                                             destroyedRocks: self.destroyedRocks,
                                                             highscores: self.highscores,
                                                             currentHighScore: self.currentHighScore)
                    }
                } else {
                    for laser in self.lasers {
                        if !asteroid.isDestroyed && distance(point1: laser.position,
                                                             point2: asteroid.position) < 0.5 * asteroid.size * self.unit {
                            asteroid.explode(unit: self.unit, theme: self.theme)
                            self.destroyedRocks += 1
                            self.scoreDisplay.update(unit: self.unit,
                                                     destroyedRocks: self.destroyedRocks,
                                                     highscore: self.highscores[0].score)
                            laser.removeFromParent()
                            self.lightning.alpha = 1
                            self.lasers.remove(at: self.lasers.index(of: laser)!)
                            break
                        }
                    }
                }
            }
            
        } else {
            if self.gameOverOverlay.waitingForInput {
                self.gameOverOverlay.update(unit: self.unit)
            }
        }
    }
}
