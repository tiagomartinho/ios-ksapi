// swiftlint:disable type_name
import Prelude

extension Update {
  public enum lens {
    public static let body = Lens<Update, String>(
      view: { $0.body },
      set: { Update(body: $0, commentsCount: $1.commentsCount, hasLiked: $1.hasLiked, id: $1.id,
        isPublic: $1.isPublic, likesCount: $1.likesCount, projectId: $1.projectId,
        publishedAt: $1.publishedAt, sequence: $1.sequence, title: $1.title, urls: $1.urls, user: $1.user,
        visible: $1.visible) }
    )

    public static let id = Lens<Update, Int>(
      view: { $0.id },
      set: { Update(body: $1.body, commentsCount: $1.commentsCount, hasLiked: $1.hasLiked, id: $0,
        isPublic: $1.isPublic, likesCount: $1.likesCount, projectId: $1.projectId,
        publishedAt: $1.publishedAt, sequence: $1.sequence, title: $1.title, urls: $1.urls, user: $1.user,
        visible: $1.visible) }
    )

    public static let projectId = Lens<Update, Int>(
      view: { $0.projectId },
      set: { Update(body: $1.body, commentsCount: $1.commentsCount, hasLiked: $1.hasLiked, id: $1.id,
        isPublic: $1.isPublic, likesCount: $1.likesCount, projectId: $0,
        publishedAt: $1.publishedAt, sequence: $1.sequence, title: $1.title, urls: $1.urls, user: $1.user,
        visible: $1.visible) }
    )

    public static let sequence = Lens<Update, Int>(
      view: { $0.sequence },
      set: { Update(body: $1.body, commentsCount: $1.commentsCount, hasLiked: $1.hasLiked, id: $1.id,
        isPublic: $1.isPublic, likesCount: $1.likesCount, projectId: $1.projectId,
        publishedAt: $1.publishedAt, sequence: $0, title: $1.title, urls: $1.urls, user: $1.user,
        visible: $1.visible) }
    )

    public static let title = Lens<Update, String>(
      view: { $0.title },
      set: { Update(body: $1.body, commentsCount: $1.commentsCount, hasLiked: $1.hasLiked, id: $1.id,
        isPublic: $1.isPublic, likesCount: $1.likesCount, projectId: $1.projectId,
        publishedAt: $1.publishedAt, sequence: $1.sequence, title: $0, urls: $1.urls, user: $1.user,
        visible: $1.visible) }
    )

    public static let user = Lens<Update, User?>(
      view: { $0.user },
      set: { Update(body: $1.body, commentsCount: $1.commentsCount, hasLiked: $1.hasLiked, id: $1.id,
        isPublic: $1.isPublic, likesCount: $1.likesCount, projectId: $1.projectId,
        publishedAt: $1.publishedAt, sequence: $1.sequence, title: $1.title, urls: $1.urls, user: $0,
        visible: $1.visible) }
    )
  }
}
