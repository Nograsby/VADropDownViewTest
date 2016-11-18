//
//  VADropDownView.m
//  VADropDownList
//
//  Created by Vladimir Ananko on 11/17/16.
//  Copyright © 2016 Vladimir Ananko. All rights reserved.
//

#import "VADropDownView.h"

#import <QuartzCore/QuartzCore.h>

@implementation VADropDownView

- (id)showDropDown:(id)sender withHeight:(CGFloat)height withData:(NSArray *)arr animationDirection:(NSString *)direction {
    UIView *senderView = (UIView *)sender;
    self.senderView = senderView;
    animationDirection = direction;
    self.table = (UITableView *)[super init];
    if (self) {
        CGRect btn = senderView.frame;
        self.dataArray = [NSArray arrayWithArray:arr];
        if ([direction isEqualToString:@"up"]) {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y - 5.f, btn.size.width, 0);
        } else if ([direction isEqualToString:@"down"]) {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y + btn.size.height + 5.f, btn.size.width, 0);
        }
        self.layer.shadowOffset = CGSizeMake(0, 0);

        
        self.layer.masksToBounds = NO;
        self.layer.cornerRadius = 8;
        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = 0.5;
        
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, btn.size.width, 0)];
        _table.delegate = self;
        _table.dataSource = self;
        _table.layer.cornerRadius = 5;
        _table.backgroundColor = [UIColor colorWithRed:0.239 green:0.239 blue:0.239 alpha:1];
        _table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _table.separatorColor = [UIColor grayColor];
        _table.bounces = NO;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        if ([direction isEqualToString:@"up"]) {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y - height - 5.f, btn.size.width, height);
        } else if([direction isEqualToString:@"down"]) {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y + btn.size.height + 5.f, btn.size.width, height);
        }
        _table.frame = CGRectMake(0, 0, btn.size.width, height);
        [UIView commitAnimations];
        [senderView.superview addSubview:self];
        [self addSubview:_table];
    }
    return self;
}

- (void)hideDropDownView:(UIView *)view {
    CGRect viewFrame = view.frame;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.0];
    if ([animationDirection isEqualToString:@"up"]) {
        self.frame = CGRectMake(viewFrame.origin.x, viewFrame.origin.y, viewFrame.size.width, 0);
    } else if ([animationDirection isEqualToString:@"down"]) {
        self.frame = CGRectMake(viewFrame.origin.x, viewFrame.origin.y + viewFrame.size.height, viewFrame.size.width, 0);
    }
    _table.frame = CGRectMake(0, 0, viewFrame.size.width, 0);
    [UIView commitAnimations];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    }
    
    cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor blackColor];
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor grayColor];
    cell.selectedBackgroundView = view;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self hideDropDownView:self.senderView];
    
    for (UIView *subview in self.senderView.subviews) {
        if ([subview isKindOfClass:[UIImageView class]]) {
            [subview removeFromSuperview];
        }
    }
    
    [self.delegate hideDropDownView:self
                           withData:self.dataArray[indexPath.row]
                          andSender:self.senderView];
}

@end
