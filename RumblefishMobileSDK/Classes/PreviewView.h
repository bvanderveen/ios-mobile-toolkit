
@interface PreviewView : UIView

- (void)startPlayback;
- (void)stopPlayback;

- (id)initWithMovieURL:(NSURL *)movieURL musicURL:(NSURL *)musicURL;

@end
