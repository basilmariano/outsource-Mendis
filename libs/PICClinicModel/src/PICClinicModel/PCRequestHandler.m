//
//  PCRequestHandler.m
//  PICClinic
//
//  Created by Wong Johnson on 2/9/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import "PCRequestHandler.h"
#import "ArticleVersionCheck.h"
#import "ArticleVersionData.h"
#import "ListVersionCheck.h"
#import "ListVersionData.h"
#import "ImageSlidersVersionCheck.h"
#import "ImageSlidersVersionData.h"
#import "ArticleData.h"
#import "ArticleDataCheck.h"
#import "ZipArchive.h"

@interface Request : NSObject
@property (nonatomic) NSUInteger version;
@property (nonatomic, retain) NSString *articleIdString;
@property (nonatomic, retain) NSString *groupListIdString;
@property (nonatomic, retain) NSString *imageSliderId;
@property (nonatomic, retain) NSString *formId;
@property (nonatomic, retain) NSString *urlString;
@property (nonatomic, retain) NSString *postDataString;
@property (nonatomic, retain) NSString *companyIdString;
@property (nonatomic) NSUInteger sortType;
@property (nonatomic, retain) URLConnection *connection;
+ request;
@end

@implementation Request

- (void)dealloc
{
    [_formId release];
    [_groupListIdString release];
    [_imageSliderId release];
    [_companyIdString release];
    [_articleIdString release];
    [_urlString release];
    [_postDataString release];
    [_connection cancel];
    [_connection release];
    [super dealloc];
}

+ request
{
    return [[[self alloc] init] autorelease];
}
@end

@interface PCRequestHandler(Private)<UITabBarControllerDelegate,UIAlertViewDelegate>

- (void)startRequest:(Request *)request;
- (void)requestFinished:(URLConnection *)connection;
- (void)requestFailed:(URLConnection *)connection;

@end

@implementation PCRequestHandler

DEFINE_SINGLETON(PCRequestHandler);

- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
    [_companyId release];
}
#pragma mark Public

+ (NSString *)documentPath
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return ([paths objectAtIndex:0]);
}


+(NSArray *)fetchRequestListIdNameVersionData
{
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init]autorelease];
    NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"list_id" ascending:YES]autorelease];
    NSArray *sortDescriptors = [[[NSArray alloc] initWithObjects:sortDescriptor, nil]autorelease];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ListIdNameVersionData" inManagedObjectContext:[[PCModelManager sharedManager] managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    NSArray *fetchedObjects = [[[PCModelManager sharedManager] managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    return fetchedObjects;
}

+(NSArray *)fetchRequestListItemsData
{
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init]autorelease];
    NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"sequence_id" ascending:YES]autorelease];
    NSArray *sortDescriptors = [[[NSArray alloc] initWithObjects:sortDescriptor, nil]autorelease];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ListItemsData" inManagedObjectContext:[[PCModelManager sharedManager] managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    NSArray *fetchedObjects = [[[PCModelManager sharedManager] managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    return fetchedObjects;
}

+ (NSArray*)fetchRequestImageSliderData
{
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init]autorelease];
    NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"imageSequenceId" ascending:YES]autorelease];
    NSArray *sortDescriptors = [[[NSArray alloc] initWithObjects:sortDescriptor, nil]autorelease];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ImageData" inManagedObjectContext:[[PCModelManager sharedManager] managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    NSArray *fetchedObjects = [[[PCModelManager sharedManager] managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    return fetchedObjects;
}

+ (NSArray*)fetchRequestArticleData
{
    NSFetchRequest *fetchRequestArticle = [[[NSFetchRequest alloc] init]autorelease];
    NSSortDescriptor *sortDescriptorArticle = [[[NSSortDescriptor alloc] initWithKey:@"articleId" ascending:YES]autorelease];
    NSArray *sortDescriptorsArticle = [[[NSArray alloc] initWithObjects:sortDescriptorArticle, nil]autorelease];
    [fetchRequestArticle setSortDescriptors:sortDescriptorsArticle];
    NSEntityDescription *entityArticle = [NSEntityDescription entityForName:@"ArticleData" inManagedObjectContext:[[PCModelManager sharedManager] managedObjectContext]];
    [fetchRequestArticle setEntity:entityArticle];
    NSError *errorArticle = nil;
    
    NSArray *fetchedObjectsArticleData = [[[PCModelManager sharedManager] managedObjectContext] executeFetchRequest:fetchRequestArticle error:&errorArticle];
    return fetchedObjectsArticleData;
}

+ (NSArray *)fetchRequestArticleVersionData
{
    NSFetchRequest *fetchRequestArticleVersion = [[[NSFetchRequest alloc] init]autorelease];
    NSSortDescriptor *sortDescriptorArticleVersion = [[[NSSortDescriptor alloc] initWithKey:@"articleId" ascending:YES]autorelease];
    NSArray *sortDescriptorsArticleVersion = [[[NSArray alloc] initWithObjects:sortDescriptorArticleVersion, nil]autorelease];
    [fetchRequestArticleVersion setSortDescriptors:sortDescriptorsArticleVersion];
    NSEntityDescription *entityArticleVersion = [NSEntityDescription entityForName:@"ArticleVersionData" inManagedObjectContext:[[PCModelManager sharedManager] managedObjectContext]];
    [fetchRequestArticleVersion setEntity:entityArticleVersion];
    NSError *errorArticleVersion = nil;
    
    NSArray *fetchedObjectsArticleVersion = [[[PCModelManager sharedManager] managedObjectContext] executeFetchRequest:fetchRequestArticleVersion error:&errorArticleVersion];
    
    return fetchedObjectsArticleVersion;
}

+ (NSArray*)fetchRequestImageSliderVersionData
{
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init]autorelease];
    NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"imageSliderId" ascending:YES]autorelease];
    NSArray *sortDescriptors = [[[NSArray alloc] initWithObjects:sortDescriptor, nil]autorelease];
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSError *errorImageSlider = nil;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ImageSlidersVersionData" inManagedObjectContext:[[PCModelManager sharedManager] managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    NSArray *fetchedObjectsImage = [[[PCModelManager sharedManager] managedObjectContext] executeFetchRequest:fetchRequest error:&errorImageSlider];
    return fetchedObjectsImage;
}

+ (NSArray*)fetchRequestListVersionData
{
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init]autorelease];
    NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"listId" ascending:YES]autorelease];
    NSArray *sortDescriptors = [[[NSArray alloc] initWithObjects:sortDescriptor, nil]autorelease];
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSError *errorList = nil;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ListVersionData" inManagedObjectContext:[[PCModelManager sharedManager] managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    NSArray *fetchedObjectsList = [[[PCModelManager sharedManager] managedObjectContext] executeFetchRequest:fetchRequest error:&errorList];
    return fetchedObjectsList;
}

+ (NSArray *)fetchRequestListData
{
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init]autorelease];
    NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"sequenceId" ascending:YES]autorelease];
    NSArray *sortDescriptors = [[[NSArray alloc] initWithObjects:sortDescriptor, nil]autorelease];
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSError *errorList = nil;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ListData" inManagedObjectContext:[[PCModelManager sharedManager] managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    NSArray *fetchedObjectsList = [[[PCModelManager sharedManager] managedObjectContext] executeFetchRequest:fetchRequest error:&errorList];
    return fetchedObjectsList;
}

#pragma mark - Request Methods

- (void)requestArticle:(NSString *)articleIdString andCompanyId:(NSString *)companyId
{
    NSArray *fetchedObjectsArticleVersion = [PCRequestHandler fetchRequestArticleVersionData];
    NSString *version = nil;
    NSString *bundleFilePath = [[NSBundle mainBundle] pathForResource:articleIdString ofType:@"zip"];
    NSString *lastVersion = nil;
    
    NSArray *fetchedObjectsArticle = [PCRequestHandler fetchRequestArticleData];
    if (fetchedObjectsArticle.count) {
        for (NSManagedObject *info in fetchedObjectsArticle) {
            if ([[[info valueForKey:@"articleId"]stringValue] isEqualToString:articleIdString]) {
                lastVersion = [[info valueForKey:@"articleIdVersion"]stringValue];
            }
        }
    }
    
    if (fetchedObjectsArticleVersion.count) {
        for (NSManagedObject *info in fetchedObjectsArticleVersion)
        {
            if ([[[info valueForKey:@"articleId"]stringValue] isEqualToString:articleIdString]) {
                version = [[info valueForKey:@"articleVersion"]stringValue];
            }
        }
    }
    
    [self getArticleVersion:&version andFilePath:nil andFolderPath:nil andArticleIdString:articleIdString];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:bundleFilePath]) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            bundleFilePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@_iphone", articleIdString] ofType:@"zip"];
        } else { // UIUserInterfaceIdiomPad
            bundleFilePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@_ipad", articleIdString] ofType:@"zip"];
        }
    }
    
    if (version && [version integerValue] == 1 && [[NSFileManager defaultManager] fileExistsAtPath:bundleFilePath]) {
        [self showArticleFromLastOrBundle:articleIdString andCompanyId:companyId];
        return;
    } else  {
        if (!lastVersion || [version integerValue] > [lastVersion integerValue]) {
            [self requestDownloadArticle:articleIdString andCompanyId:companyId];
            return;
        }
    }
    [self showArticleFromLastOrBundle:articleIdString andCompanyId:companyId];
}

- (void)showArticleFromLastOrBundle:(NSString *)articleIdString andCompanyId:(NSString *)companyId
{
    NSArray *fetchedObjectsArticleData = [PCRequestHandler fetchRequestArticleData];
    NSString *filePath = nil;
    NSString *folderPath = nil;
    NSString *lastFile = nil;
    NSString *lastFolder = nil;
    
    for (NSManagedObject *info in fetchedObjectsArticleData)
    {
        NSInteger articleId = [[info valueForKey:@"articleId"]integerValue];
        
        if (articleId  == [articleIdString integerValue]) {
            lastFile = [info valueForKey:@"filePath"];
            lastFolder = [info valueForKey:@"folderPath"];
        }
    }
    
    [self getArticleVersion:nil andFilePath:&filePath andFolderPath:&folderPath andArticleIdString:articleIdString];
    if (!folderPath || ![[NSFileManager defaultManager] fileExistsAtPath:folderPath]) {
        
        if (lastFile && lastFolder) {
            
            [self loadArticleToWebViewByFolderPath:lastFolder andArticleIdString:articleIdString];
            return;
        } else {
            // try to find available bundled archive's file path by article id
            NSString *bundleFilePath = [[NSBundle mainBundle] pathForResource:articleIdString ofType:@"zip"];
            if (![[NSFileManager defaultManager] fileExistsAtPath:bundleFilePath]) {
                bundleFilePath = nil;
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                    bundleFilePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@_iphone", articleIdString] ofType:@"zip"];
                } else { // UIUserInterfaceIdiomPad
                    bundleFilePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@_ipad", articleIdString] ofType:@"zip"];
                }
                if (![[NSFileManager defaultManager] fileExistsAtPath:bundleFilePath]) {
                    bundleFilePath = nil;
                }
            }
            
            if (bundleFilePath) {
                NSString *path = [PCRequestHandler documentPath];
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                    folderPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_1FolderIphone", articleIdString]];
                } else { //IPAD
                    folderPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_1FolderIpad", articleIdString]];
                }
                if ([self unzipArchiveFromFilePath:bundleFilePath toFolderPath:folderPath]) {
                    [self loadArticleToWebViewByFolderPath:folderPath andArticleIdString:articleIdString];
                    return;
                }
            }
        }
    } else  {
        [self loadArticleToWebViewByFolderPath:folderPath andArticleIdString:articleIdString];
        return;
    }
    [self loadArticleToWebViewByFolderPath:folderPath andArticleIdString:articleIdString];
}


- (void)getArticleVersion:(NSString **)version andFilePath:(NSString **)filePath andFolderPath:(NSString **)folderPath andArticleIdString:(NSString *)articleIdString {
    
    NSArray *fetchedObjectsArticleVersion = [PCRequestHandler fetchRequestArticleVersionData];
    NSString *articleVersion = nil;
    if (fetchedObjectsArticleVersion.count) {
        for (NSManagedObject *info in fetchedObjectsArticleVersion)
        {
            if ([[[info valueForKey:@"articleId"] stringValue] isEqualToString:articleIdString]) {
                articleVersion = [[info valueForKey:@"articleVersion"]stringValue];
                if (version) {
                    *version = articleVersion;
                }
            }
        }
        
        if (filePath || folderPath) {
            
            NSString *path = [PCRequestHandler documentPath];
            if (filePath) {
                *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@.zip", articleIdString, articleVersion]];
            }
            if (folderPath) {
                *folderPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@Folder", articleIdString, articleVersion]];
            }
        }
    }
}

- (BOOL)unzipArchiveFromFilePath:(NSString *)filePath toFolderPath:(NSString *)folderPath {
    
    ZipArchive *zipper = [[ZipArchive alloc] init];
    if (![zipper UnzipOpenFile:filePath]) {
        [zipper release];
        return FALSE;
    }
    BOOL ret = [zipper UnzipFileTo:folderPath overWrite:YES];
    [zipper UnzipCloseFile];
    [zipper release];
    if (!ret) {
        return FALSE;
    }
    return YES;
}

- (void)loadArticleToWebViewByFolderPath:(NSString *)folderPath andArticleIdString:(NSString *)articleIdString {
    NSString *htmlPath = [folderPath stringByAppendingPathComponent:@"index.html"];
    NSString *pdfPath = [folderPath stringByAppendingPathComponent:@"index.pdf"];
    NSString *loadFile = nil;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:htmlPath]) {
        loadFile = htmlPath;
        // [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:htmlPath]]];
    } else if ([[NSFileManager defaultManager] fileExistsAtPath:pdfPath]) {
        loadFile = pdfPath;
    }
    
    if (loadFile) {
        [[NSNotificationCenter defaultCenter] postNotificationName:LOAD_WEBVIEW_KEY object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:loadFile, LOAD_WEBVIEW_CONTENT_KEY, articleIdString, LOAD_WEBVIEW_ARTICLE_ID_KEY, nil]];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:LOAD_WEBVIEW_KEY object:self userInfo:nil];
    }
    
}

- (void)requestFormWithCompanyId :(NSString *) companyId andFormId :(NSString *) formId
{
    Request *request = [Request request];
    request.urlString = @"form";
    request.formId = formId;
    request.postDataString = [NSString stringWithFormat:@"company_id=%@&form_id=%@",companyId,formId];
    request.companyIdString = companyId;
    
    [self startRequest:request];
}

- (void)requestVersionCheck:(NSString *)companyId
{
    Request *request = [Request request];
    request.urlString = @"versioncheck";
    request.postDataString = [NSString stringWithFormat:@"company_id=%@",companyId];
    request.companyIdString = companyId;
    self.companyId = companyId;
    [self startRequest:request];
}

- (void)requestImageSlider:(NSString *)imageSliderId andCompanyId:(NSString *)companyId
{
    Request *request = [Request request];
    request.urlString = @"imageslider";
    request.postDataString = [NSString stringWithFormat:@"company_id=%@&imageslider_id=%@",companyId,imageSliderId];
    request.companyIdString = companyId;
    request.imageSliderId = imageSliderId;
    
    [self startRequest:request];
}

- (void)requestGroupList:(NSString *)groupListId andCompanyId:(NSString *)companyId
{
    Request *request = [Request request];
    request.urlString = @"list";
    request.companyIdString = companyId;
    request.groupListIdString = groupListId;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        request.postDataString = [NSString stringWithFormat:@"company_id=%@&list_id=%@",companyId,groupListId];
    } else {//Ipad
        request.postDataString = [NSString stringWithFormat:@"company_id=%@&list_id=%@&device=ipad",companyId,groupListId];
    }
    [self startRequest:request];
}

- (void)requestDownloadArticle:(NSString *)articleIdString andCompanyId:(NSString *)companyId
{
    Request *request = [Request request];
    request.urlString = @"articledownload";
    request.articleIdString = articleIdString;
    request.companyIdString = companyId;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        request.postDataString = [NSString stringWithFormat:@"company_id=%@&article_id=%@",companyId,articleIdString];
    } else {//Ipad
        request.postDataString = [NSString stringWithFormat:@"company_id=%@&article_id=%@&device=ipad",companyId,articleIdString];
    }
    
    [self startRequest:request];
}


- (void)startRequest:(Request *)request
{
    NSString *urlString = request.urlString;
    NSString *postDataString = request.postDataString;
    URLConnection *connection = request.connection;
    
    if (connection) {
        [connection cancel];
        connection = nil;
    }
    
    
    
    
    NSMutableURLRequest *mutableRequest = [[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://pic.leappmobile.com/pic_healthcareapi/%@",urlString]]]autorelease];
    
    NSString *postData = [[NSString stringWithFormat:@"api_id=leapp&api_pwd=l3app&%@",postDataString]
                          stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    [mutableRequest setHTTPMethod:@"POST"];
    [mutableRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [mutableRequest setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    
    connection = [[[URLConnection alloc]initWithRequest:mutableRequest target:self finished:@selector(requestFinished:) failed:@selector(requestFailed:)]autorelease];
    connection.userInfo = request;
    [connection start];
    
    
}

- (void)requestFinished:(URLConnection *)connection
{
    Request *request = (Request *)connection.userInfo;
    NSString *urlString = request.urlString;
    NSString *articleIdString = request.articleIdString;
    URLConnection *connectionInfo = request.connection;
    NSDictionary *dataFromServer = [connection.receivedData objectFromJSONData];
    NSNumber *status = [dataFromServer valueForKey:@"status"];
    
    
    
    
    if([dataFromServer objectForKey:@"company_info"]) {
        NSArray *companyInfoList = (NSArray *) [dataFromServer objectForKey:@"company_info"];
        NSUserDefaults *companyInfoDefaults = [NSUserDefaults standardUserDefaults];
        [companyInfoDefaults setObject:companyInfoList forKey:@"companyInfo"];
    }
    
    
    
    if ([urlString isEqualToString:@"versioncheck"]) {
        
        ImageSlidersVersionCheck *imageSliderVersionCheck = (ImageSlidersVersionCheck *)[NSEntityDescription insertNewObjectForEntityForName:@"ImageSlidersVersionCheck" inManagedObjectContext:[[PCModelManager sharedManager] managedObjectContext]];
        ListVersionCheck *listVersionCheck = (ListVersionCheck *)[NSEntityDescription insertNewObjectForEntityForName:@"ListVersionCheck" inManagedObjectContext:[[PCModelManager sharedManager] managedObjectContext]];
        ArticleVersionCheck *articleVersionCheck = (ArticleVersionCheck *)[NSEntityDescription insertNewObjectForEntityForName:@"ArticleVersionCheck" inManagedObjectContext:[[PCModelManager sharedManager] managedObjectContext]];
        
        NSError *errorImage = nil;
        NSError *errorArticle = nil;
        NSError *errorList = nil;
        
        if (dataFromServer) {
            if (status && [status integerValue] == 0) {
                NSArray *versionCheckImageSlider = [dataFromServer valueForKey:@"imagesliders"];
                NSArray *versionCheckArticles = [dataFromServer valueForKey:@"articles"];
                NSArray *versionCheckList = [dataFromServer valueForKey:@"list"];
                
                NSMutableSet *imagesSet = [NSMutableSet set];
                NSMutableSet *articleSet = [NSMutableSet set];
                NSMutableSet *listSet = [NSMutableSet set];
                
                NSArray *fetchedObjectsImage = [PCRequestHandler fetchRequestImageSliderVersionData];
                NSArray *fetchedObjectsArticle = [PCRequestHandler fetchRequestArticleVersionData];
                NSArray *fetchedObjectsList = [PCRequestHandler fetchRequestListVersionData];
                
                if (fetchedObjectsImage.count) {
                    for (NSManagedObject *info in fetchedObjectsImage)
                    {
                        [[[PCModelManager sharedManager] managedObjectContext] deleteObject:info];
                    }
                    [[[PCModelManager sharedManager] managedObjectContext] save:&errorImage];
                }
                
                if (fetchedObjectsArticle.count) {
                    for (NSManagedObject *info in fetchedObjectsArticle)
                    {
                        [[[PCModelManager sharedManager] managedObjectContext] deleteObject:info];
                        
                    }
                    [[[PCModelManager sharedManager] managedObjectContext] save:&errorArticle];
                }
                
                if (fetchedObjectsList.count) {
                    for (NSManagedObject *info in fetchedObjectsList)
                    {
                        [[[PCModelManager sharedManager] managedObjectContext] deleteObject:info];
                        
                    }
                    [[[PCModelManager sharedManager] managedObjectContext] save:&errorList];
                }
                
                for (int i = 0; i < versionCheckImageSlider.count; ++i) {
                    
                    ImageSlidersVersionData *imageSliderVersionData = (ImageSlidersVersionData *)[NSEntityDescription insertNewObjectForEntityForName:@"ImageSlidersVersionData" inManagedObjectContext:[[PCModelManager sharedManager] managedObjectContext]];
                    NSDictionary *imageDic = [versionCheckImageSlider objectAtIndex:i];
                    
                    imageSliderVersionData.imageSliderId = [NSNumber numberWithInteger:[[imageDic valueForKey:@"imageslider_id"] integerValue]];
                    imageSliderVersionData.imageSliderVersion = [NSNumber numberWithInteger:[[imageDic valueForKey:@"version"] integerValue]];
                    [imagesSet addObject:imageSliderVersionData];
                }
                
                for (int i = 0; i < versionCheckArticles.count; ++i) {
                    
                    ArticleVersionData *articleVersionData = (ArticleVersionData *)[NSEntityDescription insertNewObjectForEntityForName:@"ArticleVersionData" inManagedObjectContext:[[PCModelManager sharedManager] managedObjectContext]];
                    NSDictionary *imageDic = [versionCheckArticles objectAtIndex:i];
                    
                    articleVersionData.articleId = [NSNumber numberWithInteger:[[imageDic valueForKey:@"article_id"] integerValue]];
                    articleVersionData.articleVersion = [NSNumber numberWithInteger:[[imageDic valueForKey:@"version"] integerValue]];
                    [articleSet addObject:articleVersionData];
                }
                
                for (int i = 0; i < versionCheckList.count; ++i) {
                    
                    ListVersionData *listVersionData = (ListVersionData *)[NSEntityDescription insertNewObjectForEntityForName:@"ListVersionData" inManagedObjectContext:[[PCModelManager sharedManager] managedObjectContext]];
                    NSDictionary *imageDic = [versionCheckList objectAtIndex:i];
                    
                    listVersionData.listId = [NSNumber numberWithInteger:[[imageDic valueForKey:@"list_id"] integerValue]];
                    listVersionData.listVersion = [NSNumber numberWithInteger:[[imageDic valueForKey:@"version"] integerValue]];
                    [listSet addObject:listVersionData];
                }
                
                if (imagesSet) {
                    [imageSliderVersionCheck addImageSlidersVersionData:imagesSet];
                    [[[PCModelManager sharedManager] managedObjectContext] save:&errorImage];
                    
                }
                
                if (articleSet) {
                    [articleVersionCheck addArticleVersionData:articleSet];
                    [[[PCModelManager sharedManager] managedObjectContext] save:&errorArticle];
                    
                }
                
                if (listSet) {
                    [listVersionCheck addListVersionData:listSet];
                    [[[PCModelManager sharedManager] managedObjectContext] save:&errorList];
                }
            }
            
            [PCModelManager sharedManager].versionCheckFinished = YES;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:VERSION_CHECK_READY object:self userInfo:nil];
            
            connectionInfo = nil;
            return;
            
        }
        
    } else if ([urlString isEqualToString:@"articledownload"]) {
        
        // init the file and folder variables
        NSString *version = nil;
        NSString *filePath = nil;
        NSString *folderPath = nil;
        NSMutableSet *articleDataSet = [NSMutableSet set];
        [self getArticleVersion:&version andFilePath:&filePath andFolderPath:&folderPath andArticleIdString:articleIdString];
        
        // save the new downloaded data document directory
        NSError *error = nil;
        [connection.receivedData writeToFile:filePath options:0 error:&error];
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:error.domain message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            [alertView release];
            return;
        }
        
        // make sure the unzip folder path is clear before you really unzip to there
        if ([[NSFileManager defaultManager] fileExistsAtPath:folderPath]) {
            [[NSFileManager defaultManager] removeItemAtPath:folderPath error:nil];
        }
        
        if (![self unzipArchiveFromFilePath:filePath toFolderPath:folderPath]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:LOAD_WEBVIEW_KEY object:self userInfo:nil];
            return;
        }
        
        [self loadArticleToWebViewByFolderPath:folderPath andArticleIdString:articleIdString];
        
        // remove the last file and folder and keep the current version, file and path as last
        NSString *lastFile = nil;
        NSString *lastFolder = nil;
        NSError *errorArticleDataDelete = nil;
        NSError *errorArticleDataGet = nil;
        
        NSArray *fetchedObjectsArticleData = [PCRequestHandler fetchRequestArticleData];
        
        for (NSManagedObject *info in fetchedObjectsArticleData) {
            NSInteger articleId = [[info valueForKey:@"articleId"]integerValue];
            if (articleId  == [articleIdString integerValue]) {
                lastFile = [info valueForKey:@"filePath"];
                lastFolder = [info valueForKey:@"folderPath"];
                [[NSFileManager defaultManager] removeItemAtPath:lastFile error:nil];
                [[NSFileManager defaultManager] removeItemAtPath:lastFolder error:nil];
                [[[PCModelManager sharedManager] managedObjectContext] deleteObject:info];
                [[[PCModelManager sharedManager] managedObjectContext] save:&errorArticleDataDelete];
            }
        }
        //------------------------------------------------------------------------------------------------------------------------------//
        
        ArticleData *articleData = (ArticleData *)[NSEntityDescription insertNewObjectForEntityForName:@"ArticleData" inManagedObjectContext:[[PCModelManager sharedManager] managedObjectContext]];
        ArticleDataCheck *articleDataCheck = (ArticleDataCheck *)[NSEntityDescription insertNewObjectForEntityForName:@"ArticleDataCheck" inManagedObjectContext:[[PCModelManager sharedManager] managedObjectContext]];
        
        articleData.filePath = filePath;
        articleData.folderPath = folderPath;
        articleData.articleIdVersion = [NSNumber numberWithInteger:[version integerValue]];
        articleData.articleId = [NSNumber numberWithInteger:[articleIdString integerValue]];
        [articleDataSet addObject:articleData];
        
        if (articleDataSet) {
            [articleDataCheck addArticleData:articleDataSet];
            [[[PCModelManager sharedManager] managedObjectContext] save:&errorArticleDataGet];
        }
        
        
        connectionInfo = nil;
        return;
    }
    
    if (status && [status integerValue] == 0) {
        
        if ([urlString isEqualToString:@"imageslider"]) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:DATA_KEY,urlString,request.imageSliderId] object:self userInfo:[NSDictionary dictionaryWithObject:dataFromServer forKey:urlString]];
            
        } else if ([urlString isEqualToString:@"list"]) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:DATA_KEY,urlString,request.groupListIdString] object:self userInfo:[NSDictionary dictionaryWithObject:dataFromServer forKey:urlString]];
        } else if ([urlString isEqualToString:@"form"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:DATA_KEY,urlString,request.formId] object:self userInfo:[NSDictionary dictionaryWithObject:dataFromServer forKey:urlString]];
        }
    } else {
        
        if ([urlString isEqualToString:@"imageslider"]) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:DATA_KEY,urlString,request.imageSliderId] object:self userInfo:nil];
        } else if ([urlString isEqualToString:@"list"]) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:DATA_KEY,urlString,request.groupListIdString] object:self userInfo:nil];
        }
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:[dataFromServer valueForKey:@"statusdesc"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alertView show];
        [alertView release];
    }
    connectionInfo = nil;
}

- (void)requestFailed:(URLConnection *)connection
{
    Request *request = (Request *)connection.userInfo;
    NSString *urlString = request.urlString;
    NSString *articleIdString = request.articleIdString;
    NSString *companyId = request.companyIdString;
    URLConnection *connectionInfo = request.connection;
    
    if ([urlString isEqualToString:@"articledownload"]) {
        [self showArticleFromLastOrBundle:articleIdString andCompanyId:companyId];
        
    } else {
        [PCModelManager sharedManager].versionCheckFinished = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:VERSION_CHECK_READY object:self userInfo:nil];
        
    }
    
    NSString *title = @"No Connection Detected"; //[NSString stringWithFormat:@"No Connection Detected(%@)",urlString];
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:title message:@"Network problem. Please check your WIFI or mobile network setting." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alertView show];
    [alertView release];
    
    if ([urlString isEqualToString:@"imageslider"]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:DATA_KEY,urlString,request.imageSliderId] object:self userInfo:nil];
    } else if ([urlString isEqualToString:@"list"]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:DATA_KEY,urlString,request.groupListIdString] object:self userInfo:nil];
    } else if ([urlString isEqualToString:@"form"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:DATA_KEY,urlString,request.formId] object:self userInfo:nil];
    }
    
    connectionInfo = nil;
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    alertView = nil;
}


@end
