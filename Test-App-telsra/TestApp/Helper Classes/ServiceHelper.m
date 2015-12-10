//
//  AppDelegate.h
//  TestApp
//
//  Created by Arun on 12/9/15.
//  Copyright (c) 2015 Arun. All rights reserved.
//


#import "ServiceHelper.h"
#import "ConstantFile.h"

@implementation ServiceHelper

#pragma mark ============HTTP Methods======================

+ (NSDictionary *)stringUrl:(NSURL *)url postData:(NSData *)postData httpMethod:(NSString *)method withCallback:(void (^)(NSError *error)) callback
{
    NSDictionary *returResponse=[[NSDictionary alloc]init];
    @try
    {
        
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
        
        [urlRequest setHTTPMethod:method];
        
        if(postData != nil)
        {
            [urlRequest setHTTPBody:postData];
        }
        
        [urlRequest setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
        [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        // Fetch the JSON response
        NSData *urlData;
        NSURLResponse *response;
        
        NSError *error;
        
        // Sending the request
        // Make synchronous request
        urlData = [NSURLConnection sendSynchronousRequest:urlRequest
                                        returningResponse:&response
                                                    error:&error];
        NSString *strFileContent = [[NSString alloc] initWithData:urlData encoding:kNilOptions];
        
        returResponse=[NSJSONSerialization JSONObjectWithData:[strFileContent dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];

        return returResponse;
    }
    @catch (NSException *exception)
    {
        returResponse = nil;
    }
    @finally
    {
        return returResponse;
    }
}

#pragma ==================Service requset ==========================

+(NSMutableArray *)feedList:(void (^)(NSError *error)) callback
{
    FeedsData *feeds;
    NSMutableArray *allFeedData = nil;
    
    @try
    {
        NSError *error;

        NSString *serviceOperationUrl = [NSString stringWithFormat:kServiceURL];
        
        NSURL *serviceUrl = [NSURL URLWithString:[serviceOperationUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
        
        id response = [ServiceHelper stringUrl:serviceUrl postData:nil httpMethod:@"GET"withCallback:^(NSError *error){
            callback(nil);
        }];
        
        response=[response valueForKey:@"rows"];
        if ((response != nil) && [response count]>0)
        {
            id List=nil;
            
            if(allFeedData == nil)
            {
                allFeedData = [[NSMutableArray alloc] init];
            }
            
            NSEnumerator *enumerator = [response objectEnumerator];
            
            while(List=[enumerator nextObject])
            {
                feeds= [[FeedsData alloc] init];
                //Parsing Data
                [feeds setFeedTitle:[self checkForEmpty:[List valueForKey:@"title"]]];
                [feeds setFeedDescription:[self checkForEmpty:[List valueForKey:@"description"]]];
                [feeds setFeedImageUrl:[self checkForEmpty:[List valueForKey:@"imageHref"]]];
                [allFeedData addObject:feeds];
            }
        }
        else{
            [ServiceHelper createErrorCode:0 errorString:kErrorMsgURL errorObject:&error];
            callback(error);
        }
    }
    @catch (NSException *exception)
    {
        allFeedData=nil;
    }
    @finally
    {
        return allFeedData;
    }
}


+(void)downloadImageURL:(NSURL *)url completion:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
}

#pragma mark - ==========Check for empty values and NSNull check======


+(NSString *)checkForEmpty:(id )string
{
    NSString *displayNameType = @"";
    if (string != [NSNull null])
        displayNameType = (NSString *)string;
    
    return displayNameType;
}


#pragma mark - ==========Error code with Message====================

+ (BOOL)createErrorCode:(NSInteger)errCode errorString:(NSString *)aString errorObject:(NSError **)anObject {
    if (anObject) {
        NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
        [errorDetail setValue:aString forKey:NSLocalizedDescriptionKey];
        *anObject = [NSError errorWithDomain:aString code:errCode userInfo:errorDetail];
        return TRUE;
    }
    
    return FALSE;
}
@end
