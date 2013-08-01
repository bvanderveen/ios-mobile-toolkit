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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Async.h"

@interface License : NSObject
@property (nonatomic, strong) NSString *mediaId, *token, *licenseType, *projectReference, *transactionReference, *invoiceId, *email, *firstname, *lastname, *company, *address1, *address2, *city, *state, *postalCode, *country, *phone, *licenseeReference;
@property (nonatomic, assign) BOOL sendLicense;

@end

@interface Media : NSObject

@property (nonatomic, copy) NSString *title, *albumTitle, *genre;
@property (nonatomic, assign) BOOL isExplicit;
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, strong) NSURL *previewURL;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)dictionaryRepresentation;

@end

@interface RFPurchase : NSObject

@property (nonatomic, strong) License *license;
@property (nonatomic, copy) void(^didCompletePurchase)();
@property (nonatomic, copy) void(^didFailToCopletePurchase)();

- (id)initWithMedia:(Media *)media completion:(void(^)())completion;
- (void)commitPurchase;

@end

@interface Playlist : NSObject

@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, copy) NSString *title, *editorial;
@property (nonatomic, readonly) NSString *strippedEditorial;
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, copy) NSArray *media;

// note: accessing this performs a synchronous network request. 
// probably you should not do it on the main thread.
@property (nonatomic, readonly) UIImage *image;

@end

@interface Occasion : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, copy) NSArray 
    *children, // of Occasion
    *playlists; // of Playlist

@end

typedef enum RFAPIEnv {
    RFAPIEnvSandbox = 0,
    RFAPIEnvProduction
} RFAPIEnv;

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

typedef enum RFAPIVersion {
    RFAPIVersion2 = 2
} RFAPIVersion;

typedef enum RFAPIMethod {
    RFAPIMethodGET = 0,
    RFAPIMethodPOST
} RFAPIMethod;

@interface RFAPI : NSObject

@property (nonatomic) RFAPIVersion version;
@property (nonatomic) RFAPIEnv environment;
@property (nonatomic,strong) NSString *publicKey;
@property (nonatomic,strong) NSString *password;
@property (nonatomic,strong) NSString *accessToken;
@property (nonatomic,strong) NSString *ipAddress;
@property (nonatomic,strong) NSError *lastError;
@property (nonatomic, strong) NSURL *videoURL;
@property (nonatomic,strong) NSHTTPURLResponse *lastResponse;
@property (nonatomic, copy) void(^didInitiatePurchase)(RFPurchase *);

+ (void)rumbleWithEnvironment:(RFAPIEnv)env
                    publicKey:(NSString *)publicKey
                     password:(NSString *)password
                     videoURL:(NSURL *)url
          didInitiatePurchase:(void (^)(RFPurchase *purchase))didInitiatePurchase;

+ (RFAPI *)singleton;

- (Producer)getHome;
- (Producer)getPlaylistsWithOffset:(NSInteger)offset;
- (Producer)getPlaylist:(NSInteger)playlistID;
- (Producer)getOccasions;
- (Producer)getOccasion:(NSInteger)occasionID;
- (Producer)getImageAtURL:(NSURL *)url;
- (Producer)postLicense:(License *)license;

@end
