//
//  DownloadModel.m
//  PWBreakpointTool
//
//  Created by Tony_Zhao on 4/22/15.
//  Copyright (c) 2015 TonyZPW. All rights reserved.
//

#import "DownloadModel.h"

@implementation DownloadModel


- (void)setReusumData:(NSData *)reusumData
{
    _reusumData = reusumData;
    
    //持久化到本地做真正的断点续传
    BOOL result = [NSKeyedArchiver archiveRootObject:_reusumData toFile:[self archievePath]];
}


- (NSString *)archievePath{
    NSMutableString *path = [[self filePathURL].absoluteString mutableCopy];
    [path appendString:@"-archieveData"];
    return path;
}

- (NSURL *)filePathURL{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSMutableString *documentsDirectory = [[paths objectAtIndex:0] mutableCopy];

    [documentsDirectory appendString:[NSString stringWithFormat:@"/%@",self.fileName]];
    return [NSURL fileURLWithPath:documentsDirectory];
}

- (void)downloadRequestWithUrl:(NSURL *)url success:(DownloadSuccess)success fail:(DownloadFail)fail
{
    if(self.manager){
        [self resumeTask];
        return;
    }
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:[NSString stringWithFormat:@"com.zpw.www-%d",arc4random()]];
    
    self.manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    __weak DownloadModel *weakSelf = self;
    
    [self.manager setDownloadTaskDidWriteDataBlock:^(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        
        NSLog(@"%f",(double)totalBytesWritten / (double)totalBytesExpectedToWrite);
        weakSelf.progress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
        
    }];
    
    [self.manager setDownloadTaskDidResumeBlock:^(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, int64_t fileOffset, int64_t expectedTotalBytes) {

        weakSelf.progress = (double)fileOffset / (double)expectedTotalBytes;
    }];
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    self.reusumData = (self.reusumData == nil? [NSKeyedUnarchiver unarchiveObjectWithFile:[self archievePath]]: self.reusumData);
    if(self.reusumData){
        
        
        [self.manager downloadTaskWithResumeData:self.reusumData progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            NSLog(@"%@",targetPath);
            
            return [self filePathURL];
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            if(error){
                [weakSelf.task cancelByProducingResumeData:^(NSData *resumeData) {
                    weakSelf.reusumData = resumeData;
                }];
                if(fail)fail(error);
            }else{
                self.manager = nil;
                self.task = nil;

                if(success)success();
            }

        }];
    }else{
        
        self.task = [self.manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            NSLog(@"%@",targetPath);
            
            return [self filePathURL];
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            NSLog(@"%@",filePath.absoluteString);
            if(error){
                [weakSelf.task cancelByProducingResumeData:^(NSData *resumeData) {
                    weakSelf.reusumData = resumeData;
                }];
                if(fail)fail(error);
            }else{
                self.manager = nil;
                self.task = nil;
                if(success)success();
            }
        }];
    }
   
    [self.task resume];
}

- (void)pauseTask
{
    [self.task suspend];
}

- (void)resumeTask
{
    [self.task resume];
}


@end
