#import "RFAPI.h"

@interface SongCell : UITableViewCell

@property (nonatomic, assign) BOOL songIsSaved;

+ (SongCell *)cellForMedia:(RFMedia *)media tableView:(UITableView *)tableView buttonAction:(void(^)())action;
+ (SongCell *)removeButtonCellForMedia:(RFMedia *)media tableView:(UITableView *)tableView buttonAction:(void(^)())action;

@end
