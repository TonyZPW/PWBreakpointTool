//
//  DownloadModel.h
//  PWBreakpointTool
//
//  Created by Tony_Zhao on 4/22/15.
//  Copyright (c) 2015 TonyZPW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void(^DownloadSuccess)();
typedef void(^DownloadFail)(NSError *error);

extern NSString * const SessionConfigurationID;


@interface DownloadModel : NSObject

@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, strong) NSData *reusumData;
@property (nonatomic, copy) NSString *downloadUrl;
@property (nonatomic, strong) AFURLSessionManager *manager;
@property (nonatomic, strong) NSURLSessionDownloadTask *task;
@property (nonatomic, assign) CGFloat progress;

- (void)downloadRequestWithUrl:(NSURL *)url success:(DownloadSuccess)success fail:(DownloadFail)fail;

- (void)pauseTask;

- (void)resumeTask;


@end
