/*
 Rumblefish Mobile Toolkit for iOS
 
 Copyright 2012 Rumblefish, Inc.
 
 Licensed under the Apache License, Version 2.0 (the "License"); you may
 not use this file except in compliance with the License. You may obtain
 a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 License for the specific language governing permissions and limitations
 under the License.
 
 Use of the Rumblefish Sandbox in connection with this file is governed by
 the Sandbox Terms of Use found at https://sandbox.rumblefish.com/agreement
 
 Use of the Rumblefish API for any commercial purpose in connection with
 this file requires a written agreement with Rumblefish, Inc.
 */

#import "RFAPI.h"
#import "SBJson/SBJson.h"
#import "SMWebRequest+Async.h"
#import "Sequence.h"
#import "UIImage+Undeferred.h"

typedef enum RFAPIResource {
    RFAPIResourceArtist = 0,
    RFAPIResourceAuthenticate,
    RFAPIResourceCatalog,
    RFAPIResourceClear,
    RFAPIResourceLicense,
    RFAPIResourceMedia,
    RFAPIResourceOccasion,
    RFAPIResourcePlaylist,
    RFAPIResourcePortal,
    RFAPIResourceSearch,
    RFAPIResourceSFXCategory
} RFAPIResource;

typedef enum RFAPIMethod {
    RFAPIMethodGET = 0,
    RFAPIMethodPOST
} RFAPIMethod;

#warning dev: for home screen testing
#import "NSObject+AssociateProducer.h"

#define StringOrEmpty(X) ([(X) isKindOfClass:[NSString class]] ? (X) : @"")

@implementation RFLicense

- (NSDictionary *)dictionaryRepresentation {
    return @{@"media_id" : StringOrEmpty(_mediaId),
             @"token" : StringOrEmpty(_token),
             @"license_type" : StringOrEmpty(_licenseType),
             @"project_reference" : StringOrEmpty(_projectReference),
             @"transaction_reference" : StringOrEmpty(_transactionReference),
             @"invoice_id" : StringOrEmpty(_invoiceId),
             @"email" : StringOrEmpty(_email),
             @"firstname" : StringOrEmpty(_firstname),
             @"lastname" : StringOrEmpty(_lastname),
             @"company" : StringOrEmpty(_company),
             @"address1" : StringOrEmpty(_address1),
             @"address2" : StringOrEmpty(_address2),
             @"city" : StringOrEmpty(_city),
             @"state" : StringOrEmpty(_state),
             @"postal_code" : StringOrEmpty(_postalCode),
             @"country" : StringOrEmpty(_country),
             @"phone" : StringOrEmpty(_phone),
             @"licensee_reference" : StringOrEmpty(_licenseeReference),
             @"send_license" : _sendLicense ? @"true" : @"face"
             };
}

@end

@interface RFPurchase ()

@property (nonatomic, copy) void(^completion)();
@property (nonatomic, strong) RFMedia *media;
@property (nonatomic, copy) CancelCallback cancelCallback;

@end

@implementation RFPurchase

- (void)setCancelCallback:(CancelCallback)cancelCallback {
    if (_cancelCallback)
        _cancelCallback();
    
    _cancelCallback = [cancelCallback copy];
}

- (id)initWithMedia:(RFMedia *)media completion:(void(^)())completion {
    if (self = [super init]) {
        assert(completion);
        _media = media;
        _completion = completion;
    }
    return self;
}

- (void)commitPurchase {
    RFLicense *license = [[RFLicense alloc] init];
    license.mediaId = [@(_media.ID) stringValue];
    Producer producer = [[RFAPI singleton] postLicense:license];
    self.cancelCallback = producer(^(id result) {
        _completion();
        if (self.didCompletePurchase) {
            self.didCompletePurchase();
        }
    }, ^(NSError *error) {
        if (self.didFailToCompletePurchase) {
            self.didFailToCompletePurchase(error);
        }
    });

}

@end

@implementation RFMedia

@synthesize title, albumTitle, genre, price, isExplicit, ID, previewURL;

- (id)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.title = [dictionary objectForKey:@"title"];
        self.albumTitle = [[dictionary objectForKey:@"album"] objectForKey:@"title"];
        self.genre = [dictionary objectForKey:@"genre"];
        self.isExplicit = [[dictionary objectForKey:@"explicit"] boolValue];
        self.ID = [[dictionary objectForKey:@"id"] intValue];
        self.previewURL = [NSURL URLWithString:[dictionary objectForKey:@"preview_url"]];
        // eventually this should be sent in
        self.price = @"$0.99";
    }
    return self;
}

- (NSDictionary *)dictionaryRepresentation {
    return [NSDictionary dictionaryWithObjectsAndKeys:
        [NSNumber numberWithInt:self.ID], @"id",
        self.title, @"title",
        [self.previewURL absoluteString], @"preview_url", nil];
}

- (NSUInteger)hash {
    return self.ID;
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[RFMedia class]])
        return NO;
    
    return self.ID == ((RFMedia *)object).ID;
}

@end

@implementation RFPlaylist

@synthesize title, editorial, ID, imageURL, image = _image, media, hasImage;

- (id)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.title = [dictionary objectForKey:@"title"];
        self.ID = [[dictionary objectForKey:@"id"] intValue];
        
        NSString *imageURLString = [[dictionary objectForKey:@"image_url"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        imageURLString = [imageURLString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        
        if (imageURLString && ![imageURLString isEqual:@""])
            self.imageURL = [NSURL URLWithString:imageURLString];
        
        hasImage = (self.imageURL) ? YES : NO;
        
        self.editorial = [dictionary objectForKey:@"editorial"];
        self.media = [[dictionary objectForKey:@"media"] map:^ id (id m) { return [[RFMedia alloc] initWithDictionary:m]; }];
    }
    return self;
}

- (UIImage *)image {
    if (!_image)
        _image = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.imageURL]];
    return _image;
}

- (NSString *)strippedEditorial {
    if (!editorial)
        return @"";
    
    NSRange h2range = [editorial rangeOfString:@"<h2>"];
    NSRange h3range = [editorial rangeOfString:@"<h3>"];
    NSRange notFound = NSMakeRange(NSNotFound, 0);
    if (NSEqualRanges(notFound, h2range) || NSEqualRanges(notFound, h3range)) {
        return @"";
    }
    else {
        NSString *h2 = [editorial substringFromIndex:h2range.location+4];
        NSString *h3 = [editorial substringFromIndex:h3range.location+4];
        h2range = [h2 rangeOfString:@"</h2"];
        h3range = [h3 rangeOfString:@"</h3"];
        
        if (NSEqualRanges(h2range, notFound)) {
            h2 = @"";
        }
        else {
            h2 = [[h2 substringToIndex:h2range.location] stringByAppendingString:@"."];
        }
        
        if (NSEqualRanges(h3range, notFound)) {
            h3 = @"";
        }
        else {
            h3 = [h3 substringToIndex:h3range.location];
        }
        return [NSString stringWithFormat:@"%@%@%@", h2, h2.length && h3.length ? @" " : @"", h3];
    }
}

@end

@implementation RFOccasion

@synthesize name, ID, children, playlists;

- (id)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.name = [dictionary objectForKey:@"name"];
        self.ID = [[dictionary objectForKey:@"id"] intValue];
        self.children = [[dictionary objectForKey:@"children"] map:^ id (id c) { 
            return [[RFOccasion alloc] initWithDictionary:c]; }];
        
        if ([[dictionary allKeys] containsObject:@"playlists"])
            self.playlists = [[dictionary objectForKey:@"playlists"] map:^ id (id p) {
                return [[RFPlaylist alloc] initWithDictionary:p]; }];
    }
    return self;
}

@end

@interface NSData (ParseJson)

- (id)parseJson;

@end

@implementation NSData (ParseJson)

- (id)parseJson {
    SBJsonParser *parser = [SBJsonParser new];
    return [parser objectWithData:self];
}

@end


@implementation RFAPI

@synthesize environment = _environment;
@synthesize publicKey = _publicKey;
@synthesize password = _password;
@synthesize accessToken = _accessToken;
@synthesize version = _version;
@synthesize lastError = _lastError;
@synthesize lastResponse = _lastResponse;
@synthesize ipAddress = _ipAddress;

static RFAPI *rfAPIObject = nil; // use [RFAPI singleton]

static int RFAPI_TIMEOUT = 30.0; // request timeout

- (Producer)retrieveIPAddress {
    return [SMWebRequest producerWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://checkip.dyndns.org/"]] dataParser:^ id (NSData *data) {
        
        NSString *resultString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        // in the structure of 
        // <html><head><title>Current IP Check</title></head><body>Current IP Address: 199.223.126.116</body></html>
        
        // split at the : to get the trailing IP and HTML.
        NSArray *ipSplit = [resultString componentsSeparatedByString:@": "];
        
        // split at the < to separate the IP from the HTML. 
        NSArray *resultArray = [(NSString *)[ipSplit objectAtIndex:1] componentsSeparatedByString:@"<"];
        
        // return the IP section
        return [resultArray objectAtIndex:0];
    }];
}

- (Producer)getTokenForPublicKey:(NSString *)publicKey password:(NSString *)password {
    NSMutableURLRequest *request = [self requestResource:RFAPIResourceAuthenticate withMethod:RFAPIMethodPOST andParameters:nil];
    request.HTTPBody = [[NSString stringWithFormat:@"public_key=%@&password=%@", [publicKey stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [password stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] dataUsingEncoding:NSUTF8StringEncoding];
    
    return [SMWebRequest producerWithURLRequest:request dataParser:^id(NSData *result) {
        NSDictionary *jsonResult = [result JSONValue];
        if (![[jsonResult allKeys] containsObject:@"token"]) {
            NSLog(@"There was an error retrieving the Rumblefish API token: %@", jsonResult);
            return nil;
        }
        return [jsonResult objectForKey:@"token"];
    }];
}

+ (RFAPI *)apiWithEnvironment:(RFAPIEnv)environment
                      version:(RFAPIVersion)version
                    publicKey:(NSString *)publicKey
                     password:(NSString *)password
                     videoURL:(NSURL *)videoURL
          didInitiatePurchase:(void (^)(RFPurchase *purchase))didInitiatePurchase {
    
    RFAPI *api = [[RFAPI alloc] init];
    api.environment = environment;
    api.publicKey = publicKey;
    api.password = password;
    api.version = version;
    api.videoURL = videoURL;
    api.didInitiatePurchase = didInitiatePurchase;
    return api;
}

+ (void)rumbleWithEnvironment:(RFAPIEnv)env
                    publicKey:(NSString *)publicKey
                     password:(NSString *)password
                     videoURL:(NSURL *)videoURL
          didInitiatePurchase:(void (^)(RFPurchase *purchase))didInitiatePurchase {
    
    rfAPIObject = [self apiWithEnvironment:env
                                   version:RFAPIVersion2
                                 publicKey:publicKey
                                  password:password
                                  videoURL:videoURL
                       didInitiatePurchase:didInitiatePurchase];
}

+ (RFAPI *)singleton {
    if (!rfAPIObject)
        @throw [NSException exceptionWithName:@"SingletonNotInitializedException" reason:@"Please use initSingletonWithEnvironment to initialize the singleton." userInfo:nil];
        
    return rfAPIObject;
}

#pragma mark URL building methods.

- (NSString *)host {
    switch (self.environment) {
        case RFAPIEnvProduction:
            return @"api.rumblefish.com";
            break;
        case RFAPIEnvSandbox:
            return @"sandbox.rumblefish.com";
            break;
        default:
            // throw unknown environment exception.
            return @"unknown.com";
    }
}

- (NSString *)pathToResource:(RFAPIResource)resource {
    NSString *path = @"unknown";
    
    switch (resource) {
        case RFAPIResourceArtist:
            path = @"artist";
            break;
        case RFAPIResourceAuthenticate:
            path = @"authenticate";
            break;
        case RFAPIResourceCatalog:
            path = @"catalog";
            break;
        case RFAPIResourceClear:
            path = @"clear";
            break;
        case RFAPIResourceLicense:
            path = @"license";
            break;
        case RFAPIResourceMedia:
            path = @"media";
            break;
        case RFAPIResourceOccasion:
            path = @"occasion";
            break;
        case RFAPIResourcePlaylist:
            path = @"playlist";
            break;
        case RFAPIResourcePortal:
            path = @"portal";
            break;
        case RFAPIResourceSearch:
            path = @"search";
            break;
        case RFAPIResourceSFXCategory:
            path = @"sfx_category";
            break;
    }
    
    return [NSString stringWithFormat:@"/v%d/%@", self.version, path];
}

- (NSString *)queryStringFor:(NSDictionary *)parameters {
    parameters = [parameters mutableCopy];
    
    // ensure dictionary
    if (!parameters) {
        parameters = [[NSMutableDictionary alloc] init];
    }
    
    [parameters setValue:self.ipAddress forKey:@"ip"];
    
    if (self.accessToken)
        [parameters setValue:self.accessToken forKey:@"token"];
    
    NSMutableString *queryString = nil;
    NSArray *keys = [parameters allKeys];
    
    if ([keys count] > 0) {
        for (id key in keys) {
            id value = [parameters objectForKey:key];
            if (nil == queryString) {
                queryString = [[NSMutableString alloc] init];
                [queryString appendFormat:@"?"];
            } else {
                [queryString appendFormat:@"&"];
            }
            
            if (nil != key && nil != value) {
                [queryString appendFormat:@"%@=%@", [self escapeString:key], [self escapeString:value]];
            } else if (nil != key) {
                [queryString appendFormat:@"%@", [self escapeString:key]];
            }
        }
    }
    
    return queryString;
}

- (NSString *)urlStringForResource:(RFAPIResource)resource withParameters:(NSDictionary *)parameters {
    
    NSString *baseURL = [NSString stringWithFormat:@"https://%@%@", [self host], [self pathToResource:resource]];
    NSString *query = [self queryStringFor:parameters];
    
    return [NSString stringWithFormat:@"%@%@", baseURL, query];    
}

- (NSString *)escapeString:(NSString *)unencodedString {
    NSString *s = (__bridge NSString *) CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                      (__bridge CFStringRef)unencodedString,
                                                                      NULL,
                                                                      (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                      kCFStringEncodingUTF8);
    return s;
}


#pragma mark Request building methods.

- (NSMutableURLRequest *)requestWithURL:(NSURL *)url method:(RFAPIMethod)method {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:RFAPI_TIMEOUT];
    if (method == RFAPIMethodPOST)
        request.HTTPMethod = @"POST";
    else if (method == RFAPIMethodGET)
        request.HTTPMethod = @"GET";
    
    return request;
}

- (NSMutableURLRequest *)requestResource:(RFAPIResource)resource withMethod:(RFAPIMethod)method andParameters:(NSDictionary *)parameters {
    NSURL *url = [NSURL URLWithString:[self urlStringForResource:resource withParameters:parameters]];
    
    return [self requestWithURL:url method:method];
}

- (NSObject *)stringResponseToJson:(NSString *)stringResponse {
    SBJsonParser *jsonParser = [SBJsonParser new];
    return [jsonParser objectWithString:stringResponse error:NULL];
}

- (Producer)performRequestWithMethod:(RFAPIMethod *)method resource:(RFAPIResource)resource parameters:(NSDictionary *)parameters handler:(id(^)(id))resultHandler {
    
    
    Producer (^makeRequest)() = ^ Producer {
        NSURLRequest *request = [self requestResource:resource withMethod:method andParameters:parameters];
        return [SMWebRequest producerWithURLRequest:request dataParser:^id(NSData *data) {
            return resultHandler([data parseJson]);
        }];
    };
    
    if (!self.ipAddress) {
        return [Async continueAfterProducer:[self retrieveIPAddress] withSelector:^Producer(id ip) {
            self.ipAddress = ip;
            return [Async continueAfterProducer:[self getTokenForPublicKey:self.publicKey password:self.password] withSelector:^Producer(id token) {
                self.accessToken = token;
                NSLog(@"Initialized RFAPI singleton for host %@, publicKey %@, ipAddress %@, accessToken = %@", self.host, self.publicKey, self.ipAddress, self.accessToken);
                return makeRequest();
            }];
        }];
    }
    else
        return makeRequest();
}


- (void)yieldHome:(ResultCallback)r {
    
    
#warning dev
    __block id result;
    Producer getPlaylists = [[RFAPI singleton] getPlaylistsWithOffset:0];
    [self associateProducer:getPlaylists callback:^ (id results) {
        result = [(NSArray *)results filter:^ BOOL (id p) { return ((RFPlaylist *)p).imageURL != NULL; }];
        r(result);
    }];
    
    
//    NSMutableArray *playlists = [NSMutableArray array];
//    
//    for (int i = 0; i < 20; i++) {
//        Playlist *playlist = [[Playlist alloc] init];
//        playlist.title = [NSString stringWithFormat:@"Title %i", i];
//        playlist.editorial = @"<h3>This is a subtitle</h3>";
//        [playlists addObject:playlist];
//    }
//    
//    id result = playlists;
//    r(result);
}

- (Producer)getHome
{
    NSArray *playlists = @[@1343, @1902, @1622, @388, @370, @910, @425, @398, @424, @396, @728, @371, @409, @859, @417, @386];
    return [[playlists map:^id(NSNumber *n) {
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:n.stringValue, @"id", nil];
        return [self performRequestWithMethod:RFAPIMethodGET resource:RFAPIResourcePlaylist parameters:params handler:^id(id json) {
            NSDictionary *playlist = [json objectForKey:@"playlist"];
            return [[RFPlaylist alloc] initWithDictionary:playlist];
        }];
    }] parallelProducer];
}

- (Producer)getPlaylistsWithOffset:(NSInteger)offset {
    NSString *offsetString = [NSString stringWithFormat:@"%u", offset];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:offsetString, @"start", @"all", @"filter", nil];
    
    return [self performRequestWithMethod:RFAPIMethodGET resource:RFAPIResourcePlaylist parameters:params handler:^id(id json) {
        NSArray *playlists = [json objectForKey:@"playlists"];
        return [playlists map: ^ id (id p) {
            RFPlaylist *playlist = [[RFPlaylist alloc] initWithDictionary:p];
            return playlist.hasImage ? playlist : nil;
        }];
    }];
}

- (Producer)getPlaylist:(NSInteger)playlistID {
    NSString *idString = [NSString stringWithFormat:@"%u", playlistID];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:idString, @"id", nil];
    
    return [self performRequestWithMethod:RFAPIMethodGET resource:RFAPIResourcePlaylist parameters:params handler:^id(id json) {
        NSDictionary *playlist = [json objectForKey:@"playlist"];
        return [[RFPlaylist alloc] initWithDictionary:playlist];
    }];
}

- (Producer)getOccasions {
    return [self performRequestWithMethod:RFAPIMethodGET resource:RFAPIResourceOccasion parameters:nil handler:^id(id json) {
        NSArray *occasions = [json objectForKey:@"occasions"];
        return [occasions map:^ id (id o) { return [[RFOccasion alloc] initWithDictionary:o]; }];
    }];
}

- (Producer)getOccasion:(NSInteger)occasionID {
    NSString *idString = [NSString stringWithFormat:@"%u", occasionID];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:idString, @"id", nil];
    
    return [self performRequestWithMethod:RFAPIMethodGET resource:RFAPIResourceOccasion parameters:params handler:^id(id json) {
        NSDictionary *occasion = [json objectForKey:@"occasion"];
        return [[RFOccasion alloc] initWithDictionary:occasion];
    }];
}

- (Producer)getImageAtURL:(NSURL *)url {
    return [SMWebRequest producerWithURLRequest:[NSURLRequest requestWithURL:url] dataParser:^ id (NSData *data) {
        return [UIImage imageInVideoRamWithData:data];
    }];
}

- (Producer)postLicense:(RFLicense *)license {
    return [self performRequestWithMethod:RFAPIMethodPOST resource:RFAPIResourceLicense parameters:license.dictionaryRepresentation handler:^id(id _) {
        return @0;
    }];
}

@end