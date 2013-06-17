#import "SongCell.h"

@implementation SongCell

- (id)initWithReuseIdentifier:(NSString *)identifier {
    if (self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier]) {
        
    }
    return self;
}

+ (SongCell *)cellForMedia:(Media *)media tableView:(UITableView *)tableView {
    static NSString *ident = @"SongCell";
    
    SongCell *cell = (SongCell *)[tableView dequeueReusableCellWithIdentifier:ident];
    
    if (!cell)
        cell = [[SongCell alloc] initWithReuseIdentifier:ident];
    
    cell.textLabel.text = media.title;
    cell.detailTextLabel.text = media.genre;
    
    return cell;
}

@end
