//
//  AppDelegate.h
//  TestApp
//
//  Created by Arun on 12/09/15.
//  Copyright (c) 2015 Arun. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FeedsData.h"

@interface ServiceHelper : NSObject<NSURLConnectionDelegate>
{
    NSMutableData *receivedData;
    NSURLConnection *connection;
    id currentReceivedData;
    
}


+ (NSDictionary *)stringUrl:(NSURL *)url postData:(NSData *)postData httpMethod:(NSString *)method withCallback:(void (^)(NSError *error)) callback;

+(NSString *)checkForEmpty:(id )string;

+(NSMutableArray *)feedList:(void (^)(NSError *error)) callback;

+(void)downloadImageURL:(NSURL *)url completion:(void (^)(BOOL succeeded, UIImage *image))completionBlock;

+ (BOOL)createErrorCode:(NSInteger)errCode errorString:(NSString *)aString errorObject:(NSError **)anObject;

@end
