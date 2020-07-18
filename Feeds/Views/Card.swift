import SwiftUI
import KingfisherSwiftUI

struct Card: View {
    let post: Post
    
    @Environment(\.colorScheme) var colorScheme
    
    var cardColor: Color {
        colorScheme == .dark ? Color(hex: "1B1C1E") : Color.white
    }
    
    var body: some View {
        ZStack {
            cardColor
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                .shadow(color: Color.black.opacity(0.15), radius: 15, x: 0, y: 8)
            
            content(post)
                .layoutPriority(150)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 6)
    }
}

extension Card {
    func header(_ post: Post) -> some View {
        HStack {
            KFImage(post.avatar)
                .resizable()
                .scaledToFit()
                .frame(width: 20)
                .clipShape(Circle())
            
            Text("@\(post.username)")
                .font(.system(size: 15))
            
            
            Spacer()
            
            Text(post.formattedDateTime)
                .font(.system(size: 15))
        }
    }
    
    func content(_ post: Post) -> some View {
        ZStack {
            VStack(alignment: .leading) {
                header(post)
                
                if let image = post.media.first {
                    VStack(alignment: .center) {
                        KFImage(image.source)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                            .layoutPriority(100)
                    }
                }
                
                if let body = post.body {
                    Text(body)
                }
            }.padding()
        }
    }
}
