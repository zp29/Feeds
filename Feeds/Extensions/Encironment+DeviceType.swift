import UIKit
import SwiftUI

extension EnvironmentValues {
    var deviceType: UIUserInterfaceIdiom {
        UIDevice.current.userInterfaceIdiom
    }
}
