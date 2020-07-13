import SwiftUI

enum DeviceType {
    case mac
    case iPad
    case iPhone
    case appleTV
    case unknown
}

extension EnvironmentValues {
    var deviceType: DeviceType {
        #if os(macOS)
        return .mac
        #elseif os(iOS)
        switch UIDevice.current.userInterfaceIdiom {
        case .unspecified:
            return .unknown
        case .phone:
            return .iPhone
        case .pad:
            return .iPad
        case .tv:
            return .appleTV
        case .carPlay:
            return .unknown
        case .mac:
            return .mac
        @unknown default:
            return .unknown
        }
        #else
        return .unknown
        #endif
    }
}

//struct DeviceTypeView: View {
//    @Environment(\.deviceType) var device
//
//    @ViewBuilder var body: some View {
//        switch device {
//        case .mac:
//            Text("I'm running on macOS!")
//        case .iPad:
//            Text("I'm running iPadOS!")
//        case .iPhone:
//            Text("I'm running iOS!")
//        case .appleTV:
//            Text("I'm running tvOS!")
//        case .unknown:
//            Text("Who knows!")
//        }
//    }
//}
