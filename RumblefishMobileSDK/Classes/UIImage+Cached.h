#import "Async.h"

@interface UIImage (Cached)

+ (Producer)cachedImageWithURL:(NSURL *)url;

@end
