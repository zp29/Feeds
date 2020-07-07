import SwiftUI
import KingfisherSwiftUI

struct Feed: View {
    let posts: [Post]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(posts) { post in
                    Content(post: post)
                        .padding()
                    Divider()
                }
            }
        }
    }
}

struct Content: View {
    let post: Post
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                HStack {
                    KFImage(post.avatar)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20)
                        .clipShape(Circle())
                    
                    Text(post.username)
                        .font(.system(size: 15))
                    
                    Spacer()
                    
                    Text(post.datePosted, style: .relative)
                        .font(.system(size: 15))
                }
                
                if post.containsMedia {
                    VStack(alignment: .center) {
                        KFImage(post.media.first!.source)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                            .layoutPriority(100)
                    }
                }
                
                if let title = post.title {
                    Text(title)
                }
                
                if let body = post.body {
                    Text(body)
                }
            }.padding()
        }
    }
}
