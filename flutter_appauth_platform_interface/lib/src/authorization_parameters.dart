import 'external_user_agent.dart';
import 'ios_modal_presentation_style.dart';
import 'ios_modal_transition_style.dart';

mixin AuthorizationParameters {
  /// Hint to the Authorization Server about the login identifier the End-User
  /// might use to log in.
  String? loginHint;

  /// List of ASCII string values that specifies whether the Authorization
  /// Server prompts the End-User for reauthentication and consent.
  List<String>? promptValues;

  /// Specifies the external user-agent to use.
  ExternalUserAgent? externalUserAgent;

  /// Specifies the response mode to use.
  String? responseMode;

  /// Specifies the presentation style to use for the external user-agent.
  ///
  /// This property is only applicable to iOS.
  IOSModalPresentationStyle? iosModalPresentationStyle;

  /// Specifies the transition style to use for the external user-agent.
  ///
  /// This property is only applicable to iOS.
  IOSModalTransitionStyle? iosModalTransitionStyle;
}
