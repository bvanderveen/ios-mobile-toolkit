#import "UIImage+Cached.h"
#import "SMWebRequest+Async.h"
#import "UIImage+Undeferred.h"

@interface RFImageCache : NSObject

@property (nonatomic, strong) NSMutableDictionary *cache;

+ (RFImageCache *)shared;

- (UIImage *)cachedImageWithURL:(NSURL *)url;
- (void)cacheImage:(UIImage *)image withURL:(NSURL *)url;

@end

static RFImageCache *sharedCache;

@implementation RFImageCache

+ (RFImageCache *)shared {
    if (!sharedCache)
        sharedCache = [[RFImageCache alloc] init];
    
    return sharedCache;
}

- (id)init {
    if (self = [super init]) {
        _cache = [@{} mutableCopy];
    }
    return self;
}

- (UIImage *)cachedImageWithURL:(NSURL *)url {
    if ([[_cache allKeys] containsObject:url])
        return _cache[url][0];
    
    return nil;
}

- (void)cacheImage:(UIImage *)image withURL:(NSURL *)url {
    _cache[url] = @[ image, [NSDate date] ];
}

@end

@implementation UIImage (Cached)

+ (Producer)cachedImageWithURL:(NSURL *)url {
    UIImage *cached = [RFImageCache.shared cachedImageWithURL:url];
    if (cached)
        return ^ CancelCallback (ResultCallback r, ErrorCallback e) {
            r(cached);
            return  ^ { };
        };
    else {
        return [Async mapResultOfProducer:[SMWebRequest producerWithURLRequest:[NSURLRequest requestWithURL:url] dataParser:^id(NSData *d) {
            return [UIImage imageInVideoRamWithData:d];
        }] withSelector:^id(UIImage *image) {
            [RFImageCache.shared cacheImage:image withURL:url];
            return image;
        }];
    }
}

@end
