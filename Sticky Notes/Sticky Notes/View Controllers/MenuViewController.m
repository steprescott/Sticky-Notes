//
//  MenuViewController.m
//  Sticky Notes
//
//  Created by Ste Prescott on 21/03/2014.
//  Copyright (c) 2014 ste.me. All rights reserved.
//

#import "MenuViewController.h"
#import "NotesForBoardViewController.h"
#import "RegisterViewController.h"
#import "UIViewController+REFrostedViewController.h"

#import "CoreDataCategories.h"
#import "SKCoreDataManager.h"

typedef NS_ENUM(NSInteger, TableViewSection)
{
	TableViewSectionBoards,
	TableViewSectionAccount,
	TableViewSectionCount
};

typedef NS_ENUM(NSInteger, TableViewAccountRow)
{
	TableViewAccountRowSettings,
	TableViewAccountRowLogout,
	TableViewAccountRowCount
};

@interface MenuViewController ()

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) REFrostedViewController *rootViewController;

@property (nonatomic, strong) NSArray *boards;

@end

@implementation MenuViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
	
    if (self)
	{
		
    }
	
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self.tableView setSeparatorColor:[UIColor lightGrayColor]];
	[self.tableView setDelegate:self];
	[self.tableView setDataSource:self];
	[self.tableView setOpaque:NO];
	[self.tableView setBackgroundColor:[UIColor clearColor]];
	[self.tableView setTableHeaderView:({
		UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 184.0f)];
        
		UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, 100, 100)];
		[imageView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
		[imageView setImage:[UIImage imageNamed:@"avatar-silhouette"]];
		[[imageView layer] setMasksToBounds:YES];
		[[imageView layer] setCornerRadius:50.0];
		[[imageView layer] setBorderColor:[[UIColor whiteColor] CGColor]];
		[[imageView layer] setBorderWidth:3.0];
		[[imageView layer] setRasterizationScale:[[UIScreen mainScreen] scale]];
		[[imageView layer] setShouldRasterize:YES];
		[imageView setClipsToBounds:YES];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 0, 24)];
		[_nameLabel setText:[[User activeUser] fullName]];
		[_nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:21]];
		[_nameLabel setBackgroundColor:[UIColor clearColor]];
		[_nameLabel setTextColor:[UIColor darkGrayColor]];
		[_nameLabel sizeToFit];
		[_nameLabel setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];

        [view addSubview:imageView];
        [view addSubview:_nameLabel];
        view;
	})];

	self.rootViewController = self.frostedViewController;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[_nameLabel setText:[[User activeUser] fullName]];
	[_nameLabel sizeToFit];
	
	[Board boardsForUser:[User activeUser] success:^(NSDictionary *boardsDictionary) {
		NSLog(@"Boards %@", boardsDictionary);

		[[[User activeUser] boards] makeObjectsPerformSelector:@selector(setHasBeenUploaded:) withObject:[NSNumber numberWithBool:NO]];
		
		[boardsDictionary[@"boards"] enumerateObjectsUsingBlock:^(NSDictionary *boardDictionary, NSUInteger idx, BOOL *stop) {
			NSNumber *boardID = boardDictionary[@"id"];
			NSString *boardName = boardDictionary[@"name"];
			NSNumber *boardOwnerUserID = boardDictionary[@"owner_user_id"];
			
			Board *board = [Board createOrUpdateBoardWithID:boardID
												  boardName:boardName
										   boardOwnerUserID:boardOwnerUserID];
			
			[board setHasBeenUploaded:[NSNumber numberWithBool:YES]];
		}];
		
		[Board deleteInvalidBoards];
		
		self.boards = [[[[User activeUser] boards] allObjects] sortedArrayUsingDescriptors:@[[[NSSortDescriptor alloc]
																							  initWithKey:@"boardName"
																							  ascending:YES
																							  selector:@selector(localizedCaseInsensitiveCompare:)]]];
		[self.tableView reloadData];
		
	} failure:^(NSError *error) {
		NSLog(@"Boards error : %@", [error localizedDescription]);
		[SVProgressHUD showErrorWithStatus:@"Could not load your boards"];
	}];
}

- (void)showBoard:(Board *)board
{
	[Note notesForUser:[User activeUser]
			   onBoard:board
			   success:^(NSDictionary *notesDictionary) {
				   
				   NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
				   [dateFormatter setDateFormat:@"dd-MM-yyyy"];
				   
				   [notesDictionary[@"notes"] enumerateObjectsUsingBlock:^(NSDictionary *noteDictionary, NSUInteger idx, BOOL *stop) {
					   
					   [Note createOrUpdateNoteWithID:noteDictionary[@"id"]
												title:noteDictionary[@"title"]
												 body:[[NSAttributedString alloc] initWithString:noteDictionary[@"body"] attributes:@{}]
											 noteDate:[dateFormatter dateFromString:noteDictionary[@""]]
											 authorID:noteDictionary[@"author"]
											  boardID:noteDictionary[@"board_id"]];
				   }];
				   
				   [board setNotes:[NSSet setWithArray:[[board notes] allObjects]]];
				   
				   UINavigationController *navController = (UINavigationController *)[self.rootViewController contentViewController];
				   
				   NotesForBoardViewController *notesForBoardViewController = (NotesForBoardViewController*)[navController viewControllers][0];
				   
				   [notesForBoardViewController setBoard:board];
				   
			   } failure:^(NSError *error) {
				   NSLog(@"Could not load notes for board");
				   [SVProgressHUD showErrorWithStatus:@"Could not load notes for board"];
			   }];
}

#pragma mark - UITableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
	switch ([indexPath section]) {
			
		case TableViewSectionBoards:
		{
			if(indexPath.row == [_boards count])
			{
				cell.textLabel.text = @"Add board";
			}
			else
			{
				Board *board = _boards[indexPath.row];
				cell.textLabel.text = [board boardName];
			}
			break;
		}
			
		case TableViewSectionAccount:
		{
			switch ([indexPath row]) {
				case TableViewAccountRowSettings:
				{
					cell.textLabel.text = @"Account";
					break;
				}
					
				case TableViewAccountRowLogout:
				{
					cell.textLabel.text = @"Log out";
					break;
				}
			}
			break;
		}
		default:
			break;
	}
	
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch ([indexPath section]) {
		case TableViewSectionBoards:
		{
			if(indexPath.row == [_boards count])
			{
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add new board"
																message: @"Please enter a name for the new board."
															   delegate: self
													  cancelButtonTitle:@"Cancel"
													  otherButtonTitles:@"Save", nil];
				
				[alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
				[alert show];
			}
			else
			{
				[self showBoard:_boards[indexPath.row]];
			}
			
			[self.frostedViewController hideMenuViewController];
			break;
		}
			
		case TableViewSectionAccount:
		{
			switch ([indexPath row]) {
				case TableViewAccountRowSettings:
				{
					RegisterViewController *registerViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"registerViewController"];
					[registerViewController setUser:[User activeUser]];
					
					UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:registerViewController];
					[[navController navigationBar] setBarTintColor:[UIColor colorWithRed:0.188 green:0.667 blue:0.875 alpha:1]];
					[[navController navigationBar] setTintColor:[UIColor whiteColor]];
					[[navController navigationBar] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
					
					[[self frostedViewController] presentViewController:navController animated:YES completion:nil];
					[[self frostedViewController] hideMenuViewController];
					
					break;
				}
				case TableViewAccountRowLogout:
				{
					[[User activeUser] logout];
					UINavigationController *navController = (UINavigationController *) [[self frostedViewController] contentViewController];
					NotesForBoardViewController *notesForBoardViewController = (NotesForBoardViewController *) [navController viewControllers][0];
					[notesForBoardViewController setBoard:nil];
					[[self frostedViewController] hideMenuViewController];
					UIViewController *login = [[self storyboard] instantiateViewControllerWithIdentifier:@"loginViewController"];
					[[[self frostedViewController] contentViewController] presentViewController:login animated:YES completion:nil];
					break;
				}
			}
			break;
		}
	}
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	[cell setBackgroundColor:[UIColor clearColor]];
	[[cell textLabel] setTextColor:[UIColor darkGrayColor]];
	[[cell textLabel] setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 34)];
	[view setBackgroundColor:[UIColor colorWithRed:0.729 green:0.769 blue:0.788 alpha:1]];
    
    UILabel *sectionTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 0, 0)];
	
	switch (sectionIndex) {
		case TableViewSectionBoards:
		{
			[sectionTitleLabel setText:@"Your boards"];
			break;
		}
			
		case TableViewSectionAccount:
		{
			[sectionTitleLabel setText:@"Account"];
			break;
		}
	}

	[sectionTitleLabel setFont:[UIFont systemFontOfSize:15]];
	[sectionTitleLabel setTextColor:[UIColor whiteColor]];
	[sectionTitleLabel setBackgroundColor:[UIColor clearColor]];
	[sectionTitleLabel sizeToFit];
    [view addSubview:sectionTitleLabel];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
    return 34;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return TableViewSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
	switch (sectionIndex) {
		case TableViewSectionBoards:
		{
			return [[[User activeUser] boards] count] + 1;
			break;
		}
			
		case TableViewSectionAccount:
		{
			return TableViewAccountRowCount;
			break;
		}
	}
	
	return 0;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex != [alertView cancelButtonIndex])
	{
		NSString *boardName = [[alertView textFieldAtIndex:0] text];
		
		Board *newBoard = [Board createOrUpdateBoardWithID:nil
												 boardName:boardName
										  boardOwnerUserID:[[User activeUser] userID]];
		
		[Board uploadBoard:newBoard
				   forUser:[User activeUser]
				   success:^(Board *board) {
					   [board setHasBeenUploaded:[NSNumber numberWithBool:YES]];
					   
					   [self showBoard:newBoard];
					   self.boards = [[[User activeUser] boards] allObjects];
					   [self.tableView reloadData];
					   
				   } failure:^(NSError *error) {
					   
					   NSLog(@"Could not upload board. %@", [error localizedDescription]);
					   [newBoard delete];
					   [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
				   }];
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
