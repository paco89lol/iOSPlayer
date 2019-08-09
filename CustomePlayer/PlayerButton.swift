//

import Foundation
import UIKit

class PlayerButton: UIButton, PlayerButtonClickHandable {
    var flag: Bool = false
    var onClickHandler: ClickHandler?
    
}

protocol PlayerButtonClickHandable {
    typealias ClickHandler = ((UIButton) -> Swift.Void)
    var onClickHandler: ClickHandler? {get set}
}
