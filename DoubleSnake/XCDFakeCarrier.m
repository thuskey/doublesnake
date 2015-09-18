//
// Copyright (c) 2012 Cédric Luthi / @0xced. All rights reserved.
//

#if 0 //TARGET_IPHONE_SIMULATOR

static NSString * const FakeCarrier = @"Charles";

#import <objc/runtime.h>

typedef struct {
	char itemIsEnabled[23];
	char timeString[64];
	int gsmSignalStrengthRaw;
	int gsmSignalStrengthBars;
	char serviceString[100];
	// ...
} StatusBarData;

@interface XCDFakeCarrier : NSObject
@end

@implementation XCDFakeCarrier

+ (void) load
{
	BOOL success = NO;
	Class UIStatusBarComposedData = objc_getClass("UIStatusBarComposedData");
	SEL selector = @selector(rawData);
	SEL fakeSelector = @selector(fake_rawData);
	Method method = class_getInstanceMethod(UIStatusBarComposedData, selector);
	Method fakeMethod = class_getInstanceMethod(self, fakeSelector);
	const char *statusBarDataTypeEncoding = "^{?=[23c][64c]ii[100c]";
	if (method && strncmp(method_getTypeEncoding(method), statusBarDataTypeEncoding, strlen(statusBarDataTypeEncoding)) == 0)
	{
		success = class_addMethod(UIStatusBarComposedData, fakeSelector, method_getImplementation(fakeMethod), method_getTypeEncoding(fakeMethod));
		fakeMethod = class_getInstanceMethod(UIStatusBarComposedData, fakeSelector);
		method_exchangeImplementations(method, fakeMethod);
	}
	
	if (success) {
		//NSLog(@"Using \"%@\" fake carrier", FakeCarrier);
    }
	else
		NSLog(@"XCDFakeCarrier failed to initialize");
}

- (StatusBarData *) fake_rawData
{
	StatusBarData *rawData = [self fake_rawData];
	strlcpy(rawData->serviceString, [FakeCarrier UTF8String], sizeof(rawData->serviceString));
	return rawData;
}

@end

#endif
