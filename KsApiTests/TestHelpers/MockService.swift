@testable import KsApi
@testable import Models
@testable import Models_TestHelpers
import ReactiveCocoa

internal struct MockService: ServiceType {
  internal let serverConfig: ServerConfigType
  internal let oauthToken: OauthTokenAuthType?
  internal let language: String

  private let fetchActivitiesResponse: [Activity]?
  private let fetchActivitiesError: ErrorEnvelope?

  private let fetchCommentsResponse: [Comment]?
  private let fetchCommentsError: ErrorEnvelope?

  private let postCommentResponse: Comment?
  private let postCommentError: ErrorEnvelope?

  private let loginResponse: AccessTokenEnvelope?
  private let loginError: ErrorEnvelope?
  private let resendCodeResponse: ErrorEnvelope?
  private let resendCodeError: ErrorEnvelope?

  internal init(serverConfig: ServerConfigType,
                oauthToken: OauthTokenAuthType?,
                language: String) {

    self.init(
      serverConfig: serverConfig,
      oauthToken: oauthToken,
      language: language,
      fetchActivitiesResponse: nil
    )
  }

  internal init(serverConfig: ServerConfigType = ServerConfig.production,
                oauthToken: OauthTokenAuthType? = nil,
                language: String = "en",
                fetchActivitiesResponse: [Activity]? = nil,
                fetchActivitiesError: ErrorEnvelope? = nil,
                fetchCommentsResponse: [Comment]? = nil,
                fetchCommentsError: ErrorEnvelope? = nil,
                postCommentResponse: Comment? = nil,
                postCommentError: ErrorEnvelope? = nil,
                loginResponse: AccessTokenEnvelope? = nil,
                loginError: ErrorEnvelope? = nil,
                resendCodeResponse: ErrorEnvelope? = nil,
                resendCodeError: ErrorEnvelope? = nil) {

    self.serverConfig = serverConfig
    self.oauthToken = oauthToken
    self.language = language

    self.fetchActivitiesResponse = fetchActivitiesResponse ?? [
      ActivityFactory.updateActivity,
      ActivityFactory.backingActivity,
      ActivityFactory.successActivity
    ]

    self.fetchActivitiesError = fetchActivitiesError

    self.fetchCommentsResponse = fetchCommentsResponse ?? [
      CommentFactory.comment(id: 2),
      CommentFactory.comment(id: 1)
    ]

    self.fetchCommentsError = fetchCommentsError

    self.postCommentResponse = postCommentResponse ?? CommentFactory.comment()
    
    self.postCommentError = postCommentError

    self.loginResponse = loginResponse

    self.loginError = loginError

    self.resendCodeResponse = resendCodeResponse

    self.resendCodeError = resendCodeError
  }

  internal func fetchComments(project project: Project) -> SignalProducer<CommentsEnvelope, ErrorEnvelope> {

    if let error = fetchCommentsError {
      return SignalProducer(error: error)
    } else if let comments = fetchCommentsResponse {
      return SignalProducer(value: CommentsEnvelope(comments: comments))
    }
    return .empty
  }

  internal func login(oauthToken: OauthTokenAuthType) -> MockService {
    return MockService(
      serverConfig: self.serverConfig,
      oauthToken: oauthToken,
      language: self.language,
      fetchActivitiesResponse: self.fetchActivitiesResponse,
      fetchActivitiesError: self.fetchActivitiesError,
      fetchCommentsResponse: self.fetchCommentsResponse,
      fetchCommentsError: self.fetchCommentsError,
      postCommentResponse: self.postCommentResponse,
      postCommentError: self.postCommentError,
      loginResponse: self.loginResponse,
      loginError: self.loginError,
      resendCodeResponse: self.resendCodeResponse,
      resendCodeError: self.resendCodeError
    )
  }

  internal func logout() -> MockService {
    return MockService(
      serverConfig: self.serverConfig,
      oauthToken: nil,
      language: self.language,
      fetchActivitiesResponse: self.fetchActivitiesResponse,
      fetchActivitiesError: self.fetchActivitiesError,
      fetchCommentsResponse: self.fetchCommentsResponse,
      fetchCommentsError: self.fetchCommentsError,
      postCommentResponse: self.postCommentResponse,
      postCommentError: self.postCommentError,
      loginResponse: self.loginResponse,
      loginError: self.loginError,
      resendCodeResponse: self.resendCodeResponse,
      resendCodeError: self.resendCodeError
    )
  }

  internal func fetchActivities() -> SignalProducer<ActivityEnvelope, ErrorEnvelope> {

    if let error = fetchActivitiesError {
      return SignalProducer(error: error)
    } else if let activities = fetchActivitiesResponse {
      return SignalProducer(
        value: ActivityEnvelope(
          activities: activities,
          urls: ActivityEnvelope.UrlsEnvelope(
            api: ActivityEnvelope.UrlsEnvelope.ApiEnvelope(
              moreActivities: ""
            )
          )
        )
      )
    }
    return .empty
  }

  internal func fetchDiscovery(params: DiscoveryParams) -> SignalProducer<DiscoveryEnvelope, ErrorEnvelope> {

    let projects = (1...10).map { ProjectFactory.live(id: $0 + params.hashValue) }

    return SignalProducer(value:
      DiscoveryEnvelope(
        projects: projects,
        urls: DiscoveryEnvelope.UrlsEnvelope(
          api: DiscoveryEnvelope.UrlsEnvelope.ApiEnvelope(
            more_projects: ""
          )
        ),
        stats: DiscoveryEnvelope.StatsEnvelope(
          count: 200
        )
      )
    )
  }

  internal func fetchProjects(params: DiscoveryParams) -> SignalProducer<[Project], ErrorEnvelope> {
    return fetchDiscovery(params)
      .map { $0.projects }
  }

  internal func fetchProject(params: DiscoveryParams) -> SignalProducer<Project, ErrorEnvelope> {
    return fetchDiscovery(params)
      .map { $0.projects.first }
      .ignoreNil()
  }

  internal func fetchProject(project: Project) -> SignalProducer<Project, ErrorEnvelope> {
    return SignalProducer(value: project)
  }

  internal func fetchUserSelf() -> SignalProducer<User, ErrorEnvelope> {
    if self.oauthToken == nil {
      return SignalProducer(
        error: ErrorEnvelope(
          errorMessages: ["Something went wrong"],
          ksrCode: .AccessTokenInvalid,
          httpCode: 401,
          exception: nil
        )
      )
    }

    return SignalProducer(value: UserFactory.user)
  }

  internal func fetchUser(user: User) -> SignalProducer<User, ErrorEnvelope> {
    return SignalProducer(value: user)
  }

  internal func fetchCategories() -> SignalProducer<[Models.Category], ErrorEnvelope> {

    return SignalProducer(value: [
      CategoryFactory.art,
      CategoryFactory.comics,
      CategoryFactory.illustration,
      ]
    )
  }

  internal func fetchCategory(category: Models.Category) -> SignalProducer<Models.Category, ErrorEnvelope> {
    return SignalProducer(value: category)
  }

  internal func toggleStar(project: Project) -> SignalProducer<Project, ErrorEnvelope> {
    return .init(value: project.isStarred == true ? ProjectFactory.notStarred : ProjectFactory.starred)
  }

  internal func star(project: Project) -> SignalProducer<Project, ErrorEnvelope> {
    return .init(value: ProjectFactory.starred)
  }

  internal func login(email email: String, password: String, code: String?) -> SignalProducer<AccessTokenEnvelope, ErrorEnvelope> {

    if let error = loginError {
      return SignalProducer(error: error)
    } else if let accessTokenEnvelope = loginResponse {
      return SignalProducer(value: accessTokenEnvelope)
    } else if let resendCodeResponse = resendCodeResponse {
      return SignalProducer(error: resendCodeResponse)
    } else if let resendCodeError = resendCodeError {
      return SignalProducer(error: resendCodeError)
    }

    return SignalProducer(value:
      AccessTokenEnvelope(
        access_token: "deadbeef",
        user: UserFactory.user
      )
    )
  }

  internal func login(facebookAccessToken facebookAccessToken: String, code: String?) -> SignalProducer<AccessTokenEnvelope, ErrorEnvelope> {

    if let error = loginError {
      return SignalProducer(error: error)
    } else if let accessTokenEnvelope = loginResponse {
      return SignalProducer(value: accessTokenEnvelope)
    } else if let resendCodeResponse = resendCodeResponse {
      return SignalProducer(error: resendCodeResponse)
    } else if let resendCodeError = resendCodeError {
      return SignalProducer(error: resendCodeError)
    }

    return SignalProducer(value:
      AccessTokenEnvelope(
        access_token: "deadbeef",
        user: UserFactory.user
      )
    )
  }

  internal func postComment(body: String, toProject project: Project) -> SignalProducer<Comment, ErrorEnvelope> {

    if let error = postCommentError {
      return SignalProducer(error: error)
    } else if let comment = postCommentResponse {
      return SignalProducer(value: comment)
    }
    return .empty
  }

  func resetPassword(email email: String) -> SignalProducer<User, ErrorEnvelope> {
    return SignalProducer(value: UserFactory.user)
  }

  func signup(facebookAccessToken facebookAccessToken: String, sendNewsletters: Bool) -> SignalProducer<AccessTokenEnvelope, ErrorEnvelope> {

    return SignalProducer(value:
      AccessTokenEnvelope(
        access_token: "deadbeef",
        user: UserFactory.user
      )
    )
  }

}