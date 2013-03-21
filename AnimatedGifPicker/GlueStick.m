/*
 * Copyright (C) MobiSocial Inc.
 * http://mobisocial.us
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "GlueStick.h"

@implementation ObjRepresentation {
}

@synthesize noun = _noun, displayTitle = _displayTitle, displayText = _displayText, displayThumbnail = _displayThumbnail, displayCaption = _displayCaption, json = _json, appName = _appName, callback = _callback, webCallback = _webCallback;

-(id) init {
    self = [super init];
    if (!self) return nil;
    
    _appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    _json = [NSMutableDictionary dictionary];
    return self;
}

-(void)setDisplayNoun:(NSString*)noun withText:(NSString *)text withTitle:(NSString *)title withThumbnail:(UIImage *)thumbnail {
    NSAssert(noun, @"Must set a noun for this object.");
    if(!text && !thumbnail) {
        text = @"is being rather mysterious";
    }
    
    _noun = noun;
    _displayText = text;
    _displayTitle = title;
    if (thumbnail) {
        _displayThumbnail = [ObjRepresentation resizeImage:thumbnail];
        _thumbnailData = UIImageJPEGRepresentation(_displayThumbnail, 0.85);
    }
}

-(void)setDisplayNoun:(NSString *)noun withTitle:(NSString *)title withThumbnail:(UIImage *)thumbnail withCaption:(NSString *)caption {
    NSAssert(noun, @"Must set a noun for this object.");
    NSAssert(thumbnail, @"Must set at least a thumbnail with a caption");
    
    _noun = noun;
    _displayCaption = caption;
    _displayTitle = title;
    if (thumbnail) {
        _displayThumbnail = [ObjRepresentation resizeImage:thumbnail];
        _thumbnailData = UIImageJPEGRepresentation(_displayThumbnail, 0.85);
    }
}

-(void)setDisplayNoun:(NSString*)noun withText:(NSString *)text withTitle:(NSString *)title withThumbnailData:(NSData *)thumbnailData {
    NSAssert(noun, @"Must set a noun for this object.");
    NSAssert(text || thumbnailData, @"Must set at least a thumbnail or text to display");
    
    _noun = noun;
    _displayText = text;
    _displayTitle = title;
    if (thumbnailData) {
        _thumbnailData = thumbnailData;
        _displayThumbnail = [UIImage imageWithData:thumbnailData];
    }
}

-(NSData*)getThumbnailData {
    return _thumbnailData;
}


#pragma mark Image resizing utilities

// Original source: UIImage+Resize.m
// Created by Trevor Harmon on 8/5/09.
// Free for personal or commercial use, with or without modification.
// No warranty is expressed or implied.

+(UIImage*) resizeImage:(UIImage*)image {
    CGSize bounds = CGSizeMake(320, 400);
    CGFloat horizontalRatio = bounds.width / image.size.width;
    CGFloat verticalRatio = bounds.height / image.size.height;
    CGFloat ratio = MIN(horizontalRatio, verticalRatio);
    
    CGSize newSize = CGSizeMake(image.size.width * ratio, image.size.height * ratio);
    
    BOOL drawTransposed;
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            drawTransposed = YES;
            break;
            
        default:
            drawTransposed = NO;
    }
    
    UIImage* resized = [ObjRepresentation resizedImage:image withSize:newSize
                                             transform:[ObjRepresentation transformForOrientation:image withSize:newSize]
                                        drawTransposed:drawTransposed
                                  interpolationQuality:0.8];
    return resized;
}

+ (CGAffineTransform)transformForOrientation:(UIImage*)image withSize:(CGSize)newSize {
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (image.imageOrientation) {
        case UIImageOrientationDown:           // EXIF = 3
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, newSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:           // EXIF = 6
        case UIImageOrientationLeftMirrored:   // EXIF = 5
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:          // EXIF = 8
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, 0, newSize.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (image.imageOrientation) {
        case UIImageOrientationUpMirrored:     // EXIF = 2
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:   // EXIF = 5
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, newSize.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    return transform;
}

+ (UIImage *)resizedImage:(UIImage*)image withSize:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality {
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGRect transposedRect = CGRectMake(0, 0, newRect.size.height, newRect.size.width);
    CGImageRef imageRef = image.CGImage;
    
    // Build a context that's the same dimensions as the new size
    CGColorSpaceRef genericColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                newRect.size.width,
                                                newRect.size.height,
                                                8, 0,
                                                genericColorSpace,
                                                kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(genericColorSpace);
    // Rotate and/or flip the image if required by its orientation
    CGContextConcatCTM(bitmap, transform);
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(bitmap, quality);
    
    // Draw into the context; this scales the image
    CGContextDrawImage(bitmap, transpose ? transposedRect : newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    // Clean up
    CGContextRelease(bitmap);
    CGImageRelease(newImageRef);
    
    return newImage;
}

@end


@implementation GlueStick

+(ObjRepresentation*) takeObjFromPasteboardWithURL:(NSURL*)url {
    UIPasteboard* pasteboard = [UIPasteboard pasteboardWithName:kMobisocialPasteboard create:YES];
    NSData* archive = [pasteboard dataForPasteboardType:@"mobisocial.app"];
    NSDictionary* objDict = [NSKeyedUnarchiver unarchiveObjectWithData:archive];
    
    if ([objDict isKindOfClass:[NSData class]]) {
        objDict = (NSDictionary*)[NSPropertyListSerialization propertyListWithData:(NSData*)objDict options:0 format:0 error:nil];
    }
    if (!objDict) {
        return nil;
    }
    
    ObjRepresentation* obj = [[ObjRepresentation alloc] init];
    NSDictionary *dict = [objDict objectForKey:@"json"];
    if (dict) {
        obj.json = [NSMutableDictionary dictionaryWithDictionary:dict];
    }
    
    NSData* thumbnailData = [objDict objectForKey:@"displayThumbnail"];
    [obj setDisplayNoun:[objDict objectForKey:@"noun"] withText:[objDict objectForKey:@"displayText"] withTitle:[objDict objectForKey:@"displayTitle"] withThumbnailData:thumbnailData];
    obj.displayCaption = [objDict objectForKey:@"displayCaption"];
    [obj setCallback:[objDict objectForKey:@"callback"]];
    obj.appName = [objDict objectForKey:@"appName"];
    
    [pasteboard setItems:nil];
    return obj;
}

+(void)putPasteboardObj:(ObjRepresentation*)obj {
    if (![[[NSBundle mainBundle] bundleIdentifier] hasPrefix:@"mobisocial"]) {
        NSAssert(obj.appName, @"Must specify the name of your app. You should also set a callback if you'd like your app to be launchable.");
        NSAssert(obj.noun, @"Must set a noun and at least a thumbnail or text representation.");
        NSAssert(obj.displayText || obj.displayThumbnail, @"Can't send an object with no display properties. Must set at least a thumbnail or text representation.");
    }
    
    UIPasteboard* pasteboard = [UIPasteboard pasteboardWithName:kMobisocialPasteboard create:YES];
    [pasteboard setPersistent:YES];
    
    NSMutableDictionary* pbDictionary = [NSMutableDictionary dictionary];
    if (obj.noun) [pbDictionary setObject:obj.noun forKey:@"noun"];
    if (obj.appName) [pbDictionary setObject:obj.appName forKey:@"appName"];
    if (obj.displayText) {
        [pbDictionary setObject:obj.displayText forKey:@"displayText"];
    }
    if (obj.displayCaption) {
        [pbDictionary setObject:obj.displayCaption forKey:@"displayCaption"];
    }
    if (obj.displayTitle) {
        [pbDictionary setObject:obj.displayTitle forKey:@"displayTitle"];
    }
    if (obj.displayThumbnail) {
        [pbDictionary setObject:[obj getThumbnailData] forKey:@"displayThumbnail"];
    }
    if (obj.json) {
        [pbDictionary setObject:obj.json forKey:@"json"];
    }
    if (obj.callback) {
        [pbDictionary setObject:obj.callback forKey:@"callback"];
    }
    
    NSData* archive = [NSKeyedArchiver archivedDataWithRootObject:pbDictionary];
    [pasteboard setData:archive forPasteboardType:@"mobisocial.app"];
}

+(void)launchTwoPlusWithObj:(ObjRepresentation *)obj {
    [GlueStick putPasteboardObj:obj];
    if (![GlueStick isTwoPlusInstalled]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"2Plus not installed." message:@"2Plus lets you share data with people in your address book, but it's not installed. Get it from the App Store." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [alert show];
    }
    
    NSURL* url = [NSURL URLWithString:@"twoplus://app/content"];
    [[UIApplication sharedApplication] openURL:url];
}

+(BOOL) isTwoPlusInstalled {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twoplus://app/content"]];
}

+(NSURL*) callbackURLFromPasteboardURL:(NSURL*)pasteboardURL {
    NSString* callback = [self queryParameterFromURL:pasteboardURL withKey:@"callback"];
    if (!callback) return nil;
    return [NSURL URLWithString:callback];
}

+(NSString*) urlDecodeString:(NSString*)encoded {
    return (NSString *)CFBridgingRelease(
                                         CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                                 (CFStringRef)encoded,
                                                                                                 CFSTR(""),
                                                                                                 kCFStringEncodingUTF8));
}

+(NSString*)queryParameterFromURL:(NSURL*)url withKey:(NSString*)key {
    NSRange range = [url.query rangeOfString:[NSString stringWithFormat:@"%@=", key]];
    if (range.location == NSNotFound) {
        return nil;
    }
    if (range.location > 0 && [url.query characterAtIndex:range.location] != '&') {
        range = [url.query rangeOfString:[NSString stringWithFormat:@"&%@=", key]];
    }
    if (range.location == NSNotFound) {
        return nil;
    }
    NSString* param = [url.query substringFromIndex:range.location+range.length];
    range = [param rangeOfString:@"&"];
    if (range.location != NSNotFound) {
        param = [param substringToIndex:range.location];
    }
    return [self urlDecodeString:param];
}

@end
