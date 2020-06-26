import SwiftUI
import KingfisherSwiftUI

struct InstagramCard: View {
    let viewModel: IGPostViewModel
    
    @Environment(\.colorScheme) var colorScheme
    
    var cardColor: Color {
        colorScheme == .dark ? Color(hex: "1B1C1E") : Color.white
    }
    
    var body: some View {
        ZStack {
            cardColor
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                .shadow(color: Color.black.opacity(0.15), radius: 15, x: 0, y: 8)
            
            InstagramContent(viewModel: viewModel)
                .layoutPriority(150)
        }
            .padding(.horizontal, 16)
            .padding(.vertical, 6)
    }
}

struct InstagramContent: View {
    let viewModel: IGPostViewModel
    
    @State var scale: CGFloat = 1.0
    
    private var pinchGesture: some Gesture {
        MagnificationGesture()
            .onChanged { scale *= $0 }
            .onEnded { _ in scale = 1.0 }
    }
    
    private var header: some View {
        HStack {
            KFImage(viewModel.profilePicture)
                .resizable()
                .scaledToFit()
                .frame(width: 20)
                .clipShape(Circle())
            
            Text("@\(viewModel.username)")
                .font(.system(size: 15))
            
            
            Spacer()
            
            Text(viewModel.formattedDate)
                .font(.system(size: 15))

            // FIXME: This causes a crash for some reason...
            // Text(viewModel.datePosted, style: .relative)
            //    .font(.system(size: 15))
        }
    }
    
    private var images: some View {
        VStack(alignment: .center) {
            KFImage(viewModel.images.first!)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                .layoutPriority(100)
                .gesture(pinchGesture)
                .scaleEffect(scale)
        }
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                header
                images
                
                if let caption = viewModel.caption {
                    Text(caption).zIndex(-1000)
                }
            }.padding()
        }
    }
}
