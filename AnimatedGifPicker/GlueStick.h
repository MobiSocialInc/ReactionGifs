//
// Copyright (C) MobiSocial Inc.
// http://mobisocial.us
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import <Foundation/Foundation.h>

#define kMobisocialPasteboard @"mobisocial.pasteboard"

@interface ObjRepresentation : NSObject
@property (nonatomic, strong) NSString* noun;
@property (nonatomic, strong) NSString* displayTitle;
@property (nonatomic, strong) NSString* displayText;
@property (nonatomic, strong) UIImage* displayThumbnail;
@property (nonatomic, strong) NSString* displayCaption;
@property (nonatomic, strong) NSData* thumbnailData;
@property (nonatomic, strong) NSMutableDictionary* json;
@property (nonatomic, strong) NSString* appName;
@property (nonatomic, strong) NSString* callback;
@property (nonatomic, strong) NSString* webCallback;

-(id)init;
-(void) setDisplayNoun:(NSString*)noun withText:(NSString*)text withTitle:(NSString*)title withThumbnail:(UIImage*) thumbnail;
-(void) setDisplayNoun:(NSString*)noun withTitle:(NSString*)title withThumbnail:(UIImage*) thumbnail withCaption:(NSString*)caption;
@end


@interface GlueStick : NSObject

+(ObjRepresentation*) takeObjFromPasteboardWithURL:(NSURL*)url;
+(void) putPasteboardObj:(ObjRepresentation*)obj;
+(void) launchTwoPlusWithObj:(ObjRepresentation*) obj;
+(BOOL) isTwoPlusInstalled;

// assumes ARC
+ (NSURL*) callbackURLFromPasteboardURL:(NSURL*)pasteboardURL;
@end
