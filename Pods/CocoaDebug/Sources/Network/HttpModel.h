//
//  Example
//  man
//
//  Created by man on 11/11/2018.
//  Copyright © 2018 man. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, RequestSerializer) {
    RequestSerializerJSON = 0,  //JSON格式
    RequestSerializerForm       //Form格式
};

@interface HttpModel : NSObject

@property (nonatomic, copy)      NSString    *requestId;
@property (nonatomic, strong)    NSURL       *url;
@property (nonatomic, copy)      NSData      *requestData;
@property (nonatomic, copy)      NSData      *responseData;
@property (nonatomic, copy)      NSString    *method;
@property (nonatomic, copy)      NSString    *statusCode;
@property (nonatomic, copy)      NSString    *mineType;
@property (nonatomic, strong)    NSDate      *startTime;
@property (nonatomic, copy)      NSString    *totalDuration;
@property (nonatomic, assign)    BOOL        isImage;


@property (nonatomic, copy)      NSDictionary<NSString*, id>     *requestHeaderFields;
@property (nonatomic, copy)      NSDictionary<NSString*, id>     *responseHeaderFields;
@property (nonatomic, assign)    BOOL                            isTag;
@property (nonatomic, assign)    BOOL                            isSelected;
@property (nonatomic, assign)    RequestSerializer               requestSerializer;//默认JSON格式
@property (nonatomic, copy)      NSString                        *errorDescription;
@property (nonatomic, copy)      NSString                        *errorLocalizedDescription;

@property (nonatomic, copy)      NSData                          *imageData;
@property (nonatomic, copy)      NSString                        *size;

@end
