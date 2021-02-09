#import "KhaltiKhaltiPlugin.h"
#if __has_include(<khalti_khalti/khalti_khalti-Swift.h>)
#import <khalti_khalti/khalti_khalti-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "khalti_khalti-Swift.h"
#endif

@implementation KhaltiKhaltiPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftKhaltiKhaltiPlugin registerWithRegistrar:registrar];
}
@end
