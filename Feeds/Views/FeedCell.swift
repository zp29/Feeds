import SwiftUI
import KingfisherSwiftUI

struct FeedCell: View {
    let post: Post
    
    var header: some View {
        HStack {
            KFImage(post.avatar)
                .resizable()
                .scaledToFit()
                .frame(width: 20)
                .clipShape(Circle())
            
            Text(post.username)
                .font(.system(size: 15))
            
            Spacer()
            
            Text(post.formattedDateTime)
                .font(.system(size: 15))
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            header
            
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
            
            Divider()
        }
    }
}
