//
//  SXGNewsDAL.m
//  WYNews
//
//  Created by shaoxingguo on 2019/7/18.
//  Copyright © 2019 shaoxingguo. All rights reserved.
//

#import <FMDB/FMDB.h>

#import "SXGNewsDAL.h"

#import "SXGNetworkTools.h"

@implementation SXGNewsDAL
{
    /// 数据库操作队列
    FMDatabaseQueue *_queue;
}

#pragma mark - 构造方法

+ (instancetype)shared
{
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self openSQLite];
    }
    
    return self;
}

#pragma mark - 加载新闻网络数据

- (void)loadHeadLineListWithTid:(NSString *)tid completion:(void(^)(id __nullable responseObject))completion
{
    // 检查是否有缓存
    NSArray<NSDictionary *> *dictArr = [self loadNewsListFromCacheWithTid:tid];
    if (dictArr != nil && dictArr.count > 0) {
        if (dictArr.count > 5) {
            dictArr = [dictArr subarrayWithRange:NSMakeRange(0, 5)];
        }
        completion(dictArr);
        return;
    }
    
    // 没有缓存 进行网络加载
    NSString *apiString = @"article/headline/tid/0-10.html";
    apiString = [apiString stringByReplacingOccurrencesOfString:@"/tid/" withString:[NSString stringWithFormat:@"/%@/",tid]];
    [SXGNetworkTools GetRequest:apiString parameters:nil completionHandle:^(id  _Nullable responseObject, NSError * _Nullable error) {
        if (error != nil || responseObject == nil) {
            DEBUG_Log(@"加载头条数据失败%@",error.localizedDescription);
            completion(nil);
            return;
        }
        
        // 默认返回10条头条 只取5个
        NSString *key = [responseObject allKeys].firstObject;
        NSArray *arr = responseObject[key];
        if (arr.count > 5) {
            arr = [arr subarrayWithRange:NSMakeRange(0, 5)];
        }
       
        completion(arr);
    }];
}

- (void)loadNewsListWithTid:(NSString *)tid completion:(void(^)(id __nullable responseObject))completion
{
    // 检查是否有缓存
    NSArray<NSDictionary *> *dictArr = [self loadNewsListFromCacheWithTid:tid];
    if (dictArr != nil && dictArr.count > 0) {
        completion(dictArr);
        return;
    }
    
    // 没有缓存 进行网络加载
    NSString *apiString = @"article/headline/tid/0-20.html";
    apiString = [apiString stringByReplacingOccurrencesOfString:@"/tid/" withString:[NSString stringWithFormat:@"/%@/",tid]];
    __weak typeof(self) weakSelf = self;
    [SXGNetworkTools GetRequest:apiString parameters:nil completionHandle:^(id  _Nullable responseObject, NSError * _Nullable error) {
        if (error != nil || responseObject == nil) {
            DEBUG_Log(@"加载新闻数据失败%@",error.localizedDescription);
            completion(nil);
            return;
        }
        
        NSString *key = [responseObject allKeys].firstObject;
        NSArray *arr = responseObject[key];
        // 保存缓存
        [weakSelf saveNewsListWithTid:tid newsList:arr];
        completion(arr);
    }];
}

- (void)loadNewsDetailWithDocid:(NSString *)docid completion:(void (^)(id _Nullable))completion
{
    NSString *apiString = @"article/docid/full.html";
     apiString = [apiString stringByReplacingOccurrencesOfString:@"/docid/" withString:[NSString stringWithFormat:@"/%@/",docid]];
    [SXGNetworkTools GetRequest:apiString parameters:nil completionHandle:^(id  _Nullable responseObject, NSError * _Nullable error) {
        if (error != nil || responseObject == nil) {
            DEBUG_Log(@"加载新闻详情失败%@",error.localizedDescription);
            completion(nil);
            return;
        }
        
        NSString *key = [responseObject allKeys].firstObject;
        NSDictionary *dict = responseObject[key];
        completion(dict);
    }];
}

#pragma mark - 数据库相关

- (void)openSQLite
{
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *dbPath = [documentPath stringByAppendingPathComponent:@"newsList.sqlite"];
    // 打开数据库连接
    _queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    if (_queue != nil) {
        DEBUG_Log(@"数据库打开成功!  %@",dbPath);
        [self createTables];
    } else {
        DEBUG_Log(@"数据库打开失败");
    }
    
    // 应用程序退出时 关闭数据库连接
    __weak typeof(self) weakSelf = self;
    __weak NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserverForName:UIApplicationWillTerminateNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf->_queue close];
        [center removeObserver:strongSelf];
    }];
}

- (void)createTables
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"news.sql" ofType:nil];
    NSString *sql = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSAssert(sql != nil, @"数据表文件为空");
    // 创建数据表
    [_queue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        BOOL result = [db executeStatements:sql];
        if (!result) {
            *rollback = YES;
        }
    }];
}

- (void)saveNewsListWithTid:(NSString *)tid newsList:(NSArray<NSDictionary *> *)newsList
{
    if (_queue == nil) {
        return;
    }
    
    NSString *insertSQL = @"INSERT OR REPLACE INTO T_News ('tid','postid','news') VALUES (?,?,?);";
    [_queue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        for (NSDictionary *dict in newsList) {
            if ([NSJSONSerialization isValidJSONObject:dict]) {
                NSString *postid = dict[@"postid"];
                NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
                NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                BOOL result = [db executeUpdate:insertSQL withArgumentsInArray:@[tid,postid,str]];
                if (!result) {
                    *rollback = YES;
                    break;
                }
            }
        }
    }];
}

/**
 从缓存中读取新闻列表

 @param tid 新闻话题
 @return 新闻字典数组NSArray<NSDictionary *> * 没有缓存返回nil
 */
- (NSArray<NSDictionary *> * __nullable)loadNewsListFromCacheWithTid:(NSString *)tid
{
    if (_queue == nil) {
        return nil;
    }
    
    NSString *selectSQL = @"SELECT tid,postid,news FROM T_News WHERE tid = ?;";
    NSMutableArray<NSDictionary *> *newsList = [NSMutableArray arrayWithCapacity:20];
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet *resultSet = [db executeQuery:selectSQL withArgumentsInArray:@[tid]];
        if (!resultSet) return;
        while ([resultSet next]) {
            for (int i = 0; i < [resultSet columnCount]; i++) {
                NSString *key = [resultSet columnNameForIndex:i];
                id object = [resultSet objectForColumnIndex:i];
                if ([key isEqualToString:@"news"]) {
                    [newsList addObject:object];
                }
            }
        }
    }];
    
    return newsList;
}

@end
