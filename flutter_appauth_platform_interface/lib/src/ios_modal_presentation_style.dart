/// The presentation style to use when presenting the external user-agent
/// on iOS.
///
/// This mirrors Apple's [UIModalPresentationStyle](https://developer.apple.com/documentation/uikit/uimodalpresentationstyle)
/// and is only applicable to iOS.
///
/// Note that this is only honoured when the external user-agent presents a
/// view controller that can be customised, such as
/// [ExternalUserAgent.sfSafariViewController].
/// User-agents backed by `ASWebAuthenticationSession` (e.g.
/// [ExternalUserAgent.asWebAuthenticationSession] and
/// [ExternalUserAgent.ephemeralAsWebAuthenticationSession]) are presented and
/// managed entirely by the system and do not support this customisation.
enum IOSModalPresentationStyle {
  /// Uses the system default presentation style.
  ///
  /// Maps to [UIModalPresentationAutomatic](https://developer.apple.com/documentation/uikit/uimodalpresentationstyle/automatic).
  automatic,

  /// A presentation style in which the presented view covers the screen.
  ///
  /// Maps to [UIModalPresentationFullScreen](https://developer.apple.com/documentation/uikit/uimodalpresentationstyle/fullscreen).
  fullScreen,

  /// A presentation style that partially covers the underlying content.
  ///
  /// Maps to [UIModalPresentationPageSheet](https://developer.apple.com/documentation/uikit/uimodalpresentationstyle/pagesheet).
  pageSheet,

  /// A presentation style where the content is displayed centered in the
  /// screen.
  ///
  /// Maps to [UIModalPresentationFormSheet](https://developer.apple.com/documentation/uikit/uimodalpresentationstyle/formsheet).
  formSheet,

  /// A presentation style where the content is displayed over another
  /// view controller's content.
  ///
  /// Maps to [UIModalPresentationCurrentContext](https://developer.apple.com/documentation/uikit/uimodalpresentationstyle/currentcontext).
  currentContext,

  /// A custom view presentation style.
  ///
  /// Maps to [UIModalPresentationCustom](https://developer.apple.com/documentation/uikit/uimodalpresentationstyle/custom).
  custom,

  /// A view presentation style in which the presented view covers the
  /// screen and the transition style is not animated.
  ///
  /// Maps to [UIModalPresentationOverFullScreen](https://developer.apple.com/documentation/uikit/uimodalpresentationstyle/overfullscreen).
  overFullScreen,

  /// A presentation style where the content is displayed over another
  /// view controller's content.
  ///
  /// Maps to [UIModalPresentationOverCurrentContext](https://developer.apple.com/documentation/uikit/uimodalpresentationstyle/overcurrentcontext).
  overCurrentContext,

  /// A presentation style where the content is displayed in a popover view.
  ///
  /// Maps to [UIModalPresentationPopover](https://developer.apple.com/documentation/uikit/uimodalpresentationstyle/popover).
  popover,

  /// Indicates no adaptations should be made.
  ///
  /// Maps to [UIModalPresentationNone](https://developer.apple.com/documentation/uikit/uimodalpresentationstyle/none).
  none,
}
