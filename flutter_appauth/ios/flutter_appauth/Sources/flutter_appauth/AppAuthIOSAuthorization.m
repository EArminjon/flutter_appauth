#import "AppAuthIOSAuthorization.h"

// Converts the `IOSModalPresentationStyle` Dart enum index (see
// ios_modal_presentation_style.dart) into the corresponding
// `UIModalPresentationStyle` raw value. Falls back to `defaultStyle` when
// `iosModalPresentationStyle` is nil or unrecognised.
static UIModalPresentationStyle ModalPresentationStyleFromNumber(
    NSNumber *_Nullable iosModalPresentationStyle,
    UIModalPresentationStyle defaultStyle) {
  if (!iosModalPresentationStyle) {
    return defaultStyle;
  }
  switch ((IOSModalPresentationStyle)[iosModalPresentationStyle integerValue]) {
    case ModalPresentationAutomatic:
      if (@available(iOS 13.0, *)) {
        return UIModalPresentationAutomatic;
      }
      return UIModalPresentationFullScreen;
    case ModalPresentationFullScreen:
      return UIModalPresentationFullScreen;
    case ModalPresentationPageSheet:
      return UIModalPresentationPageSheet;
    case ModalPresentationFormSheet:
      return UIModalPresentationFormSheet;
    case ModalPresentationCurrentContext:
      return UIModalPresentationCurrentContext;
    case ModalPresentationCustom:
      return UIModalPresentationCustom;
    case ModalPresentationOverFullScreen:
      return UIModalPresentationOverFullScreen;
    case ModalPresentationOverCurrentContext:
      return UIModalPresentationOverCurrentContext;
    case ModalPresentationPopover:
      return UIModalPresentationPopover;
    case ModalPresentationNone:
      if (@available(iOS 13.0, *)) {
        return UIModalPresentationNone;
      }
      return UIModalPresentationFullScreen;
  }
  return defaultStyle;
}

// Converts the `IOSModalTransitionStyle` Dart enum index (see
// ios_modal_transition_style.dart) into the corresponding
// `UIModalTransitionStyle` raw value. Falls back to `defaultStyle` when
// `iosModalTransitionStyle` is nil or unrecognised.
static UIModalTransitionStyle ModalTransitionStyleFromNumber(
    NSNumber *_Nullable iosModalTransitionStyle,
    UIModalTransitionStyle defaultStyle) {
  if (!iosModalTransitionStyle) {
    return defaultStyle;
  }
  switch ((IOSModalTransitionStyle)[iosModalTransitionStyle integerValue]) {
    case ModalTransitionCoverVertical:
      return UIModalTransitionStyleCoverVertical;
    case ModalTransitionFlipHorizontal:
      return UIModalTransitionStyleFlipHorizontal;
    case ModalTransitionCrossDissolve:
      return UIModalTransitionStyleCrossDissolve;
    case ModalTransitionPartialCurl:
      return UIModalTransitionStylePartialCurl;
  }
  return defaultStyle;
}

@implementation AppAuthIOSAuthorization

- (id<OIDExternalUserAgentSession>)
    performAuthorization:(OIDServiceConfiguration *)serviceConfiguration
                clientId:(NSString *)clientId
            clientSecret:(NSString *)clientSecret
                  scopes:(NSArray *)scopes
             redirectUrl:(NSString *)redirectUrl
    additionalParameters:(NSDictionary *)additionalParameters
       externalUserAgent:(NSNumber *)externalUserAgent
  iosModalPresentationStyle:(nullable NSNumber *)iosModalPresentationStyle
    iosModalTransitionStyle:(nullable NSNumber *)iosModalTransitionStyle
                  result:(FlutterResult)result
            exchangeCode:(BOOL)exchangeCode
                   nonce:(NSString *)nonce {
  NSString *codeVerifier = [OIDAuthorizationRequest generateCodeVerifier];
  NSString *codeChallenge =
      [OIDAuthorizationRequest codeChallengeS256ForVerifier:codeVerifier];

  OIDAuthorizationRequest *request = [[OIDAuthorizationRequest alloc]
      initWithConfiguration:serviceConfiguration
                   clientId:clientId
               clientSecret:clientSecret
                      scope:[OIDScopeUtilities scopesWithArray:scopes]
                redirectURL:[NSURL URLWithString:redirectUrl]
               responseType:OIDResponseTypeCode
                      state:[OIDAuthorizationRequest generateState]
                      nonce:nonce != nil
                                ? nonce
                                : [OIDAuthorizationRequest generateState]
               codeVerifier:codeVerifier
              codeChallenge:codeChallenge
        codeChallengeMethod:OIDOAuthorizationRequestCodeChallengeMethodS256
       additionalParameters:additionalParameters];
  UIViewController *rootViewController = [self rootViewController];
  if (exchangeCode) {
    id<OIDExternalUserAgent> agent =
        [self userAgentWithViewController:rootViewController
                        externalUserAgent:externalUserAgent
                   modalPresentationStyle:iosModalPresentationStyle
                     modalTransitionStyle:iosModalTransitionStyle];
    return [OIDAuthState
        authStateByPresentingAuthorizationRequest:request
                                externalUserAgent:agent
                                         callback:^(
                                             OIDAuthState *_Nullable authState,
                                             NSError *_Nullable error) {
                                           if (authState) {
                                             result([FlutterAppAuth
                                                 processResponses:
                                                     authState.lastTokenResponse
                                                     authResponse:
                                                         authState
                                                             .lastAuthorizationResponse]);

                                           } else {
                                             [FlutterAppAuth
                                                 finishWithError:
                                                     AUTHORIZE_AND_EXCHANGE_CODE_ERROR_CODE
                                                         message:
                                                             [FlutterAppAuth
                                                                 formatMessageWithError:
                                                                     AUTHORIZE_ERROR_MESSAGE_FORMAT
                                                                                  error:
                                                                                      error]
                                                          result:result
                                                           error:error];
                                           }
                                         }];
  } else {
    id<OIDExternalUserAgent> agent =
        [self userAgentWithViewController:rootViewController
                        externalUserAgent:externalUserAgent
                   modalPresentationStyle:iosModalPresentationStyle
                     modalTransitionStyle:iosModalTransitionStyle];
    return [OIDAuthorizationService
        presentAuthorizationRequest:request
                  externalUserAgent:agent
                           callback:^(OIDAuthorizationResponse
                                          *_Nullable authorizationResponse,
                                      NSError *_Nullable error) {
                             if (authorizationResponse) {
                               NSMutableDictionary *processedResponse =
                                   [[NSMutableDictionary alloc] init];
                               [processedResponse
                                   setObject:authorizationResponse
                                                 .additionalParameters
                                      forKey:
                                          @"authorizationAdditionalParameters"];
                               [processedResponse
                                   setObject:authorizationResponse
                                                 .authorizationCode
                                      forKey:@"authorizationCode"];
                               [processedResponse
                                   setObject:authorizationResponse.request
                                                 .codeVerifier
                                      forKey:@"codeVerifier"];
                               [processedResponse
                                   setObject:authorizationResponse.request.nonce
                                      forKey:@"nonce"];
                               result(processedResponse);
                             } else {
                               [FlutterAppAuth
                                   finishWithError:AUTHORIZE_ERROR_CODE
                                           message:
                                               [FlutterAppAuth
                                                   formatMessageWithError:
                                                       AUTHORIZE_ERROR_MESSAGE_FORMAT
                                                                    error:error]
                                            result:result
                                             error:error];
                             }
                           }];
  }
}

- (id<OIDExternalUserAgentSession>)
    performEndSessionRequest:(OIDServiceConfiguration *)serviceConfiguration
           requestParameters:(EndSessionRequestParameters *)requestParameters
                      result:(FlutterResult)result {
  NSURL *postLogoutRedirectURL =
      requestParameters.postLogoutRedirectUrl
          ? [NSURL URLWithString:requestParameters.postLogoutRedirectUrl]
          : nil;

  OIDEndSessionRequest *endSessionRequest =
      requestParameters.state
          ? [[OIDEndSessionRequest alloc]
                initWithConfiguration:serviceConfiguration
                          idTokenHint:requestParameters.idTokenHint
                postLogoutRedirectURL:postLogoutRedirectURL
                                state:requestParameters.state
                 additionalParameters:requestParameters.additionalParameters]
          : [[OIDEndSessionRequest alloc]
                initWithConfiguration:serviceConfiguration
                          idTokenHint:requestParameters.idTokenHint
                postLogoutRedirectURL:postLogoutRedirectURL
                 additionalParameters:requestParameters.additionalParameters];

  UIViewController *rootViewController = [self rootViewController];
  id<OIDExternalUserAgent> externalUserAgent =
      [self userAgentWithViewController:rootViewController
                      externalUserAgent:requestParameters.externalUserAgent
                 modalPresentationStyle:requestParameters
                                            .iosModalPresentationStyle
                   modalTransitionStyle:requestParameters
                                            .iosModalTransitionStyle];

  return [OIDAuthorizationService
      presentEndSessionRequest:endSessionRequest
             externalUserAgent:externalUserAgent
                      callback:^(
                          OIDEndSessionResponse *_Nullable endSessionResponse,
                          NSError *_Nullable error) {
                        if (!endSessionResponse) {
                          NSString *message = [NSString
                              stringWithFormat:END_SESSION_ERROR_MESSAGE_FORMAT,
                                               [error localizedDescription]];
                          [FlutterAppAuth finishWithError:END_SESSION_ERROR_CODE
                                                  message:message
                                                   result:result
                                                    error:error];
                          return;
                        }
                        NSMutableDictionary *processedResponse =
                            [[NSMutableDictionary alloc] init];
                        [processedResponse setObject:endSessionResponse.state
                                              forKey:@"state"];
                        result(processedResponse);
                      }];
}

- (id<OIDExternalUserAgent>)
    userAgentWithViewController:(UIViewController *)rootViewController
              externalUserAgent:(NSNumber *)externalUserAgent
         modalPresentationStyle:(nullable NSNumber *)iosModalPresentationStyle
           modalTransitionStyle:(nullable NSNumber *)iosModalTransitionStyle {
  if ([externalUserAgent integerValue] == EphemeralASWebAuthenticationSession) {
    return [[OIDExternalUserAgentIOSNoSSO alloc]
        initWithPresentingViewController:rootViewController
                  modalPresentationStyle:ModalPresentationStyleFromNumber(
                                             iosModalPresentationStyle,
                                             UIModalPresentationFullScreen)
                    modalTransitionStyle:ModalTransitionStyleFromNumber(
                                             iosModalTransitionStyle,
                                             UIModalTransitionStyleCoverVertical)];
  }
  if ([externalUserAgent integerValue] == SafariViewController) {
    return [[OIDExternalUserAgentIOSSafariViewController alloc]
        initWithPresentingViewController:rootViewController
                  modalPresentationStyle:ModalPresentationStyleFromNumber(
                                             iosModalPresentationStyle,
                                             UIModalPresentationFormSheet)
                    modalTransitionStyle:ModalTransitionStyleFromNumber(
                                             iosModalTransitionStyle,
                                             UIModalTransitionStyleCoverVertical)];
  }
  if ([externalUserAgent integerValue] == CustomBrowserSafari) {
    return [OIDExternalUserAgentIOSCustomBrowser CustomBrowserSafari];
  }
  if ([externalUserAgent integerValue] == CustomBrowserChrome) {
    return [OIDExternalUserAgentIOSCustomBrowser CustomBrowserChrome];
  }
  if ([externalUserAgent integerValue] == CustomBrowserFirefox) {
    return [OIDExternalUserAgentIOSCustomBrowser CustomBrowserFirefox];
  }
  if ([externalUserAgent integerValue] == CustomBrowserOpera) {
    return [OIDExternalUserAgentIOSCustomBrowser CustomBrowserOpera];
  }
  return [[OIDExternalUserAgentIOS alloc]
      initWithPresentingViewController:rootViewController];
}

- (UIViewController *)rootViewController {
  if (@available(iOS 13, *)) {
    return [[UIApplication sharedApplication].windows
               filteredArrayUsingPredicate:[NSPredicate
                                               predicateWithBlock:^BOOL(
                                                   id window,
                                                   NSDictionary *bindings) {
                                                 return [window isKeyWindow];
                                               }]]
        .firstObject.rootViewController;
  }
  return [UIApplication sharedApplication].delegate.window.rootViewController;
}

@end
