#import "RFAPI.h"

@interface RFSongCell : UITableViewCell

@property (nonatomic, assign) BOOL songIsSaved;

+ (RFSongCell *)cellForMedia:(RFMedia *)media tableView:(UITableView *)tableView buttonAction:(void(^)())action;
+ (RFSongCell *)removeButtonCellForMedia:(RFMedia *)media tableView:(UITableView *)tableView buttonAction:(void(^)())action;

@end
