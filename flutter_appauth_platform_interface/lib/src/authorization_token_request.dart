import 'authorization_parameters.dart';
import 'external_user_agent.dart';
import 'grant_type.dart';
import 'ios_modal_presentation_style.dart';
import 'ios_modal_transition_style.dart';
import 'token_request.dart';

/// Details required for a combined authorization and code exchange request
class AuthorizationTokenRequest extends TokenRequest
    with AuthorizationParameters {
  AuthorizationTokenRequest(
    super.clientId,
    super.redirectUrl, {
    String? loginHint,
    super.clientSecret,
    super.scopes,
    super.serviceConfiguration,
    super.additionalParameters,
    super.issuer,
    super.discoveryUrl,
    List<String>? promptValues,
    super.allowInsecureConnections,
    ExternalUserAgent externalUserAgent =
        ExternalUserAgent.asWebAuthenticationSession,
    super.nonce,
    String? responseMode,
    IOSModalPresentationStyle? iosModalPresentationStyle,
    IOSModalTransitionStyle? iosModalTransitionStyle,
  }) : super(
          grantType: GrantType.authorizationCode,
        ) {
    this.loginHint = loginHint;
    this.promptValues = promptValues;
    this.externalUserAgent = externalUserAgent;
    this.responseMode = responseMode;
    this.iosModalPresentationStyle = iosModalPresentationStyle;
    this.iosModalTransitionStyle = iosModalTransitionStyle;
  }
}
