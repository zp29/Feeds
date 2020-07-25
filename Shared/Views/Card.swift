import SwiftUI
import KingfisherSwiftUI

extension URL: Identifiable {
    public var id: URL { self }
}

struct Card: View {
    let post: Post
    let cornerRadius: CGFloat = 15
    
    @Environment(\.colorScheme) var colorScheme

    var cardColor: Color {
        colorScheme == .dark ? Color(hex: "1B1C1E") : Color.white
    }
    
    var body: some View {
        ZStack {
            cardColor
                .rounded(corners: .allCorners, cornerRadius)
                .shadow(color: Color.black.opacity(0.15), radius: 15, y: 8)
            
            Content(post: post, cornerRadius: cornerRadius)
                .layoutPriority(150)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 6)
    }
}

// MARK:- Content
struct Content: View {
    let post: Post
    let cornerRadius: CGFloat
    
    init(post: Post, cornerRadius: CGFloat = 0) {
        self.post = post
        self.cornerRadius = cornerRadius
    }
    
    @Environment(\.colorScheme) var colorScheme
    
    @State var shareSheetIsPresented = false
    @State private var isBookmarked = false
    @State private var bodyURL: URL? = nil
    
    var cardColor: Color {
        colorScheme == .dark ? Color(hex: "1B1C1E") : Color.white
    }
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                header
                Spacer().frame(height: 12)
                title
                Spacer().frame(height: 8)
                contentBody
                Spacer().frame(height: 12)
                images
                Spacer().frame(height: 12)
                bottomRow
            }.padding(.init(top: 10, leading: 5, bottom: 10, trailing: 5))
            
            
        }
        .sheet(item: $bodyURL) { url in
            // FIXME: SVC displays oddly this way, with a few visual bugs requiring `edgesIgnoringSafeArea`
            // I would rather have it slide in from the side, maybe in a NavigationLink?
            SafariView(url: url).edgesIgnoringSafeArea(.all)
        }
    }
}

extension Content {
    @ViewBuilder
    var images: some View {
        if let image = post.media.first {
            VStack(alignment: .center) {
                KFImage(image.source)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
//                    .rounded(corners: [.topLeft, .topRight], cornerRadius)
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
                    .lineLimit(1)
                    .truncationMode(.tail)
                
                Text(post.username)
                    // FIXME: Make this a semantic computed property
                    .fontWeight(.light)
                    .fontSize(15)
                    .opacity(0.5)
                    .lineLimit(1)
                    .truncationMode(.tail)
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
                .lineLimit(2)
                .truncationMode(.tail)
        }
    }
    
    @ViewBuilder
    var contentBody: some View {
        if let body = post.body, !body.isEmpty {
            if let url = post.bodyURL {
                Button { bodyURL = url } label: {
                    Text(body)
                        .font(.body)
                        .lineLimit(3)
                        .truncationMode(.tail)
                }
            } else {
                Text(body)
                    .font(.body)
                    .lineLimit(3)
                    .truncationMode(.tail)
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
}

struct Card_Previews: PreviewProvider {
    static var previews: some View {
        Card(post: Post.demo)
            .previewLayout(.sizeThatFits)
        
        Card(post: Post.demo)
            .colorScheme(.dark)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
}
