import SwiftUI
import KingfisherSwiftUI

extension URL: Identifiable {
    public var id: URL { self }
}

struct Card: View {
    let post: Post
    
    @Environment(\.colorScheme) var colorScheme
    @State var shareSheetIsPresented = false
    @State private var isBookmarked = false
    @State private var bodyURL: URL? = nil
    
    var cardColor: Color {
        colorScheme == .dark ? Color(hex: "1B1C1E") : Color.white
    }
    
    let cornerRadius: CGFloat = 15
    
    var body: some View {
        ZStack {
            cardColor
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                .shadow(color: Color.black.opacity(0.15), radius: 15, x: 0, y: 8)
            
            content
                .layoutPriority(150)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 6)
    }
}


// MARK:- Content
extension Card {
    @ViewBuilder
    var images: some View {
        if let image = post.media.first {
            VStack(alignment: .center) {
                KFImage(image.source)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(cornerRadius, corners: [.topLeft, .topRight])
                    .layoutPriority(100)
            }
        }
    }
    
    var header: some View {
        HStack {
            KFImage(post.avatar)
                .resizable()
                .scaledToFit()
                .frame(width: 36)
                .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text(post.displayName)
                    // FIXME: Make this a semantic computed property
                    .fontWeight(.medium)
                    .fontSize(15)
                
                Text(post.username)
                    // FIXME: Make this a semantic computed property
                    .fontWeight(.light)
                    .fontSize(15)
                    .opacity(0.5)
            }
            
            Spacer()
            
            Image(post.serviceImageName)
                .resizable()
                .scaledToFit()
                .frame(width: 36)
        }
    }
    
    @ViewBuilder
    var title: some View {
        if let title = post.title {
            Text(title)
                .font(.title3)
                .bold()
        }
    }
    
    @ViewBuilder
    var contentBody: some View {
        if let body = post.body {
            if let url = post.bodyURL {
                Button { bodyURL = url } label: {
                    Text(body)
                        .font(.body)
                }
            } else {
                Text(body)
                    .font(.body)
            }
        }
    }
    
    @ViewBuilder var buttons: some View {
        HStack {
            Button { shareSheetIsPresented.toggle() } label: {
                Image(systemName: "square.and.arrow.up")
                    .fontSize(22)
            }
            // FIXME: This makes the sheet present all the way up the screen, instead of halfway
            .sheet(isPresented: $shareSheetIsPresented) {
                ShareSheet(activityItems: [post.shareURL])
            }
            
            Spacer().frame(width: 20)
            
            Button { isBookmarked.toggle() } label: {
                if isBookmarked {
                    Image(systemName: "bookmark.fill")
                        // FIXME: Make this a semantic computed property
                        .fontSize(22)
                } else {
                    Image(systemName: "bookmark")
                        // FIXME: Make this a semantic computed property
                        .fontSize(22)
                }
            }
        }
    }
    
    var bottomRow: some View {
        HStack {
            Text(post.formattedDateTime)
                // FIXME: Make this a semantic computed property
                .fontSize(15)
                .opacity(0.5)
            
            Spacer()
            
            buttons
        }
    }
    
    var content: some View {
        VStack {
            images
            VStack(alignment: .leading) {
                header
                Spacer().frame(height: 12)
                title
                Spacer().frame(height: 8)
                contentBody
                Spacer().frame(height: 12)
                bottomRow
            }.padding(20)
        }.sheet(item: $bodyURL) { url in
            SafariView(url: url).edgesIgnoringSafeArea(.all)
        }
    }
}

struct Card_Previews: PreviewProvider {
    static let post = Post(
        id: UUID().description,
        avatar: URL(staticString: "https://scontent-dfw5-1.cdninstagram.com/v/t51.2885-19/s320x320/12080424_280912232240122_678835955_a.jpg?_nc_ht=scontent-dfw5-1.cdninstagram.com&_nc_ohc=9uSnxvBP1FMAX8yLvgt&oh=df760f6d918180ef2e850eca4ee13d80&oe=5F2C945D"),
        displayName: "Neven Mrgan",
        username: "@sardinebrunch",
        service: "instagram",
        media: [
            Post.Media(
                source: URL(staticString: "https://scontent-dfw5-1.cdninstagram.com/v/t51.2885-15/e35/s1080x1080/106495441_3063061667134461_2989484783314130514_n.jpg?_nc_ht=scontent-dfw5-1.cdninstagram.com&_nc_cat=109&_nc_ohc=MTDihLpID_sAX___QiL&oh=0425f9f2ca66016e804cac3cf578b5ed&oe=5F2DC39F"),
                isVideo: false
            )
        ],
        title: "Chicken!",
        body: "Tempura chicken tenders, Old Bay seasoned. Plus fries, homemade zucchini pickles, and a sauce of mayo + homemade smoked apricot BBQ sauce. Pic 2 is like 1/3 of the total amount I fried. Tempura is cool because it’s way simpler to batter with it than to bother with 3 different bowls, and it leaves the fry oil totally clean.",
        datePosted: Date(),
        shareURL: URL(staticString: "https://instagram.com/sardinebrunch")
    )
    
    static var previews: some View {
        Card(post: post)
            .previewLayout(.sizeThatFits)
        
        Card(post: post)
            .colorScheme(.dark)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
}
