//
//  NotesListViewController.h
//  Sticky Notes
//
//  Created by Ste Prescott on 06/12/2013.
//  Copyright (c) 2013 ste.me. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotesListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *notes;

@end
