import SpriteKit

public class Random {

    static var direction: CGFloat {
        return CGFloat(arc4random_uniform(100) < 50 ? 1 : -1)
    }

    static var percentage: CGFloat {
        return 0.01 * CGFloat(arc4random_uniform(100))
    }
}
