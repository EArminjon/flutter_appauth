#if TARGET_OS_OSX
#import <FlutterMacOS/FlutterMacOS.h>
#else
#import <Flutter/Flutter.h>
#endif

#ifdef SWIFT_PACKAGE
@import AppAuth;
#else
#import <AppAuth/AppAuth.h>
#endif

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FlutterAppAuth : NSObject

+ (NSMutableDictionary *)processResponses:(OIDTokenResponse *)tokenResponse
                             authResponse:(OIDAuthorizationResponse *_Nullable)
                                              authResponse;
+ (void)finishWithError:(NSString *)errorCode
                message:(NSString *)message
                 result:(FlutterResult)result
                  error:(NSError *_Nullable)error;
+ (NSString *)formatMessageWithError:(NSString *)messageFormat
                               error:(NSError *_Nullable)error;

@end

static NSString *const AUTHORIZE_METHOD = @"authorize";
static NSString *const AUTHORIZE_AND_EXCHANGE_CODE_METHOD =
    @"authorizeAndExchangeCode";
static NSString *const TOKEN_METHOD = @"token";
static NSString *const END_SESSION_METHOD = @"endSession";
static NSString *const AUTHORIZE_ERROR_CODE = @"authorize_failed";
static NSString *const AUTHORIZE_AND_EXCHANGE_CODE_ERROR_CODE =
    @"authorize_and_exchange_code_failed";
static NSString *const DISCOVERY_ERROR_CODE = @"discovery_failed";
static NSString *const TOKEN_ERROR_CODE = @"token_failed";
static NSString *const END_SESSION_ERROR_CODE = @"end_session_failed";
static NSString *const DISCOVERY_ERROR_MESSAGE_FORMAT =
    @"Error retrieving discovery document: %@";
static NSString *const TOKEN_ERROR_MESSAGE_FORMAT = @"Failed to get token: %@";
static NSString *const AUTHORIZE_ERROR_MESSAGE_FORMAT =
    @"Failed to authorize: %@";
static NSString *const END_SESSION_ERROR_MESSAGE_FORMAT =
    @"Failed to end session: %@";

@interface EndSessionRequestParameters : NSObject
@property(nonatomic, strong) NSString *idTokenHint;
@property(nonatomic, strong) NSString *postLogoutRedirectUrl;
@property(nonatomic, strong) NSString *state;
@property(nonatomic, strong) NSString *issuer;
@property(nonatomic, strong) NSString *discoveryUrl;
@property(nonatomic, strong) NSDictionary *serviceConfigurationParameters;
@property(nonatomic, strong) NSDictionary *additionalParameters;
@property(nonatomic, strong) NSNumber *externalUserAgent;
@property(nonatomic, strong) NSNumber *iosModalPresentationStyle;
@property(nonatomic, strong) NSNumber *iosModalTransitionStyle;
@end

typedef NS_ENUM(NSInteger, ExternalUserAgent) {
  ASWebAuthenticationSession,
  EphemeralASWebAuthenticationSession,
  SafariViewController,
  CustomBrowserSafari,
  CustomBrowserChrome,
  CustomBrowserFirefox,
  CustomBrowserOpera
};

// Mirrors the order of the `IOSModalPresentationStyle` Dart enum. The values
// are intentionally not a 1:1 mapping to `UIModalPresentationStyle`'s raw
// values, since those aren't contiguous (e.g. `UIModalPresentationNone` is
// `-1`). See `ModalPresentationStyleFromNumber` in AppAuthIOSAuthorization.m.
typedef NS_ENUM(NSInteger, IOSModalPresentationStyle) {
  ModalPresentationAutomatic,
  ModalPresentationFullScreen,
  ModalPresentationPageSheet,
  ModalPresentationFormSheet,
  ModalPresentationCurrentContext,
  ModalPresentationCustom,
  ModalPresentationOverFullScreen,
  ModalPresentationOverCurrentContext,
  ModalPresentationPopover,
  ModalPresentationNone
};

// Mirrors the order of the `IOSModalTransitionStyle` Dart enum, which in turn
// mirrors `UIModalTransitionStyle`'s raw values.
typedef NS_ENUM(NSInteger, IOSModalTransitionStyle) {
  ModalTransitionCoverVertical,
  ModalTransitionFlipHorizontal,
  ModalTransitionCrossDissolve,
  ModalTransitionPartialCurl
};

@interface AppAuthAuthorization : NSObject

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
                   nonce:(NSString *)nonce;

- (id<OIDExternalUserAgentSession>)
    performEndSessionRequest:(OIDServiceConfiguration *)serviceConfiguration
           requestParameters:(EndSessionRequestParameters *)requestParameters
                      result:(FlutterResult)result;

@end

NS_ASSUME_NONNULL_END
