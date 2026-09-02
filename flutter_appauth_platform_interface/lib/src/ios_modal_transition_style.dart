/// The transition style to use when presenting the external user-agent on
/// iOS.
///
/// This mirrors Apple's [UIModalTransitionStyle](https://developer.apple.com/documentation/uikit/uimodaltransitionstyle)
/// and is only applicable to iOS.
///
/// Note that this is only honoured when the external user-agent presents a
/// view controller that can be customised, such as
/// [ExternalUserAgent.sfSafariViewController].
/// User-agents backed by `ASWebAuthenticationSession` (e.g.
/// [ExternalUserAgent.asWebAuthenticationSession] and
/// [ExternalUserAgent.ephemeralAsWebAuthenticationSession]) are presented and
/// managed entirely by the system and do not support this customisation.
enum IOSModalTransitionStyle {
  /// A transition style where the new view slides up from the bottom of
  /// the screen.
  ///
  /// Maps to [UIModalTransitionStyleCoverVertical](https://developer.apple.com/documentation/uikit/uimodaltransitionstyle/coververtical).
  coverVertical,

  /// A transition style where the current view flips horizontally, from
  /// left to right, revealing the new view.
  ///
  /// Maps to [UIModalTransitionStyleFlipHorizontal](https://developer.apple.com/documentation/uikit/uimodaltransitionstyle/fliphorizontal).
  flipHorizontal,

  /// A transition style where the current view fades out while the new
  /// view fades in.
  ///
  /// Maps to [UIModalTransitionStyleCrossDissolve](https://developer.apple.com/documentation/uikit/uimodaltransitionstyle/crossdissolve).
  crossDissolve,

  /// A transition style where the current view is dismissed using a
  /// vertical partial curl, revealing the new view underneath.
  ///
  /// Maps to [UIModalTransitionStylePartialCurl](https://developer.apple.com/documentation/uikit/uimodaltransitionstyle/partialcurl).
  partialCurl,
}
