import Models

/**
 A list of possible requests that can be made for Kickstarter data.
 */
public enum Route {
  case Activities(categories: [Activity.Category])
  case Categories
  case Category(Int)
  case Config
  case Discover(DiscoveryParams)
  case FacebookLogin(facebookAccessToken: String, code: String?)
  case FacebookSignup(facebookAccessToken: String, sendNewsletters: Bool)
  case Login(email: String, password: String, code: String?)
  case Project(Int)
  case ProjectComments(Models.Project)
  case PostProjectComment(Models.Project, body: String)
  case PostUpdateComment(Update, body: String)
  case ResetPassword(email: String)
  case Star(Models.Project)
  case ToggleStar(Models.Project)
  case UpdateComments(Update)
  case UserSelf
  case User(Models.User)
  case UserNewsletters(weekly: Bool, promo: Bool, happening: Bool, games: Bool)

  internal var requestProperties: (method: KsApi.Method, path: String, query: [String:AnyObject]) {
    switch self {
    case let .Activities(categories):
      return (.GET, "/v1/activities", ["categories": categories.map { $0.rawValue }])

    case .Categories:
      return (.GET, "/v1/categories", [:])

    case let .Category(id):
      return (.GET, "/v1/categories/\(id)", [:])

    case .Config:
      return (.GET, "/v1/app/ios/config", [:])

    case let .Discover(params):
      return (.GET, "/v1/discover", params.queryParams)

    case let .FacebookLogin(facebookAccessToken, code):
      var params = ["access_token": facebookAccessToken, "intent": "login"]
      params["code"] = code
      return (.PUT, "/v1/facebook/access_token", params)

    case let .FacebookSignup(facebookAccessToken, sendNewsletters):
      let params: [String:AnyObject] = ["access_token": facebookAccessToken,
                                        "intent": "register",
                                        "send_newsletters": sendNewsletters,
                                        "newsletter_opt_in": sendNewsletters]
      return (.PUT, "/v1/facebook/access_token", params)

    case let .Login(email, password, code):
      var params = ["email": email, "password": password]
      params["code"] = code
      return (.POST, "/xauth/access_token", params)

    case let .Project(id):
      return (.GET, "/v1/projects/\(id)", [:])

    case let .ProjectComments(p):
      return (.GET, "/v1/projects/\(p.id)/comments", [:])

    case let .PostProjectComment(p, body):
      return (.POST, "/v1/projects/\(p.id)/comments", ["body": body])

    case let .PostUpdateComment(u, body):
      return (.POST, "/v1/projects/\(u.projectId)/updates/\(u.id)/comments", ["body": body])

    case let .ResetPassword(email):
      return (.POST, "/v1/users/reset", ["email": email])

    case let .Star(p):
      return (.PUT, "/v1/projects/\(p.id)/star", [:])

    case let .ToggleStar(p):
      return (.POST, "/v1/projects/\(p.id)/star/toggle", [:])

    case let UpdateComments(u):
      return (.GET, "/v1/projects/\(u.projectId)/updates/\(u.id)/comments", [:])

    case .UserSelf:
      return (.GET, "/v1/users/self", [:])

    case let .User(user):
      return (.GET, "/v1/users/\(user.id)", [:])

    case let .UserNewsletters(weekly, promo, happening, games):
      return (.PUT, "/v1/users/self", ["weekly_newsletter": weekly,
                                       "promo_newsletter": promo,
                                       "happening_newsletter": happening,
                                       "games_newsletter": games])
    }
  }
}
