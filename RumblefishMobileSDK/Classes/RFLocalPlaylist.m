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

#import "RFLocalPlaylist.h"
#import "Sequence.h"
#import "RFAPI.h"

static NSString *playlistFilePath;
static RFLocalPlaylist *shared;

@interface RFLocalPlaylist ()

@property (nonatomic, strong) NSArray *contents;

@end

@implementation RFLocalPlaylist

@synthesize contents;

+ (void)initialize {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    playlistFilePath = [documentsDirectory stringByAppendingPathComponent:@"playlist.plist"];
}

+ (RFLocalPlaylist *)sharedPlaylist {
    if (!shared)
        shared = [RFLocalPlaylist new];
    return shared;
}

- (NSUInteger)count {
    return contents.count;
}

- (NSArray *)readPlaylist {
    return [[[NSMutableDictionary dictionaryWithContentsOfFile:playlistFilePath] objectForKey:@"media"] map:^ id (id m) {
        return [[RFMedia alloc] initWithDictionary:m];
    }];
}

- (void)flushPlaylist {
    [[NSDictionary dictionaryWithObject:[contents map:^ id (id m) { return [((RFMedia *)m) dictionaryRepresentation]; }] forKey:@"media"] writeToFile:playlistFilePath atomically:YES];
}

- (id)init {
    if (self = [super init]) {
        self.contents = [self readPlaylist];
        
        if (!self.contents)
            self.contents = [NSArray array];
    }
    return self;
}

- (void)addToPlaylist:(RFMedia *)media {
    self.contents = [self.contents arrayByAddingObject:media];
    [self flushPlaylist];
}

- (void)removeAtIndex:(NSUInteger)index {
    NSMutableArray *mutableCopy = [self.contents mutableCopy];
    [mutableCopy removeObjectAtIndex:index];
    self.contents = [mutableCopy copy];
}

- (void)removeFromPlaylist:(RFMedia *)media {
    self.contents = [contents filter:^ BOOL (id m) { return ![((RFMedia *)m) isEqual:media]; }];
    [self flushPlaylist];
}

- (BOOL)existsInPlaylist:(RFMedia *)media {
    return [contents any:^ BOOL (id m) { return [((RFMedia *)m) isEqual:media]; }];
}

- (RFMedia *)mediaAtIndex:(NSUInteger)index {
    return (RFMedia *)[self.contents objectAtIndex:index];
}

- (void)clear {
    self.contents = [NSArray array];
    [self flushPlaylist];
}

@end
