import UIKit

extension UIImage {
    func getCropRatio() -> CGFloat {
        CGFloat(self.size.width / self.size.height)
    }
}
