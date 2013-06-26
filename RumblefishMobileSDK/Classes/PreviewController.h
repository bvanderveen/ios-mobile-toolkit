
@interface PreviewController : UIViewController

- (id)initWithMovieURL:(NSURL *)movieURL musicURL:(NSURL *)musicURL;
- (void)presentInView:(UIView *)view withCompletion:(void(^)())completion;

@end
