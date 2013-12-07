//
//  NotesListViewController.m
//  Sticky Notes
//
//  Created by Ste Prescott on 06/12/2013.
//  Copyright (c) 2013 ste.me. All rights reserved.
//

#import "NotesListViewController.h"
#import "NewNoteViewController.h"

#import "CoreDataCategories.h"

typedef enum
{
    TableViewSectionNotes = 0,
    TableViewSectionTotal
}TableViewSection;

typedef enum
{
    NoteCellSubviewTitle = 101,
    NoteCellSubviewBody = 102
}NoteCellSubview;

static NSString *cellIdentifier = @"notesCell";

@interface NotesListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) Note *selectedNote;
@end

@implementation NotesListViewController

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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.selectedNote = nil;
    
    NSArray *notesToBeSorted = ([User activeUser]) ? [[[User activeUser] notes] allObjects] : [Note allNotesWithNoUser];
    
    self.notes = [[notesToBeSorted sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"noteDate" ascending:NO]]] mutableCopy];
    
    [_tableView reloadData];
}

#pragma mark- TableView Delegates

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [_notes removeObjectAtIndex:indexPath.row];
        [_tableView reloadData];
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedNote = _notes[indexPath.row];
    
    return indexPath;
}

#pragma mark- TableView Data Source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return TableViewSectionTotal;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ([_notes count] > 0) ? [_notes count] : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    UILabel *noteTitleLabel = (UILabel *)[cell viewWithTag:NoteCellSubviewTitle];
    UILabel *noteBodyLabel = (UILabel *)[cell viewWithTag:NoteCellSubviewBody];
    
    if([_notes count] == 0)
    {
        [noteTitleLabel setText:@"No notes"];
        [noteBodyLabel setText:@"Add a new one by using the create button at the top right of the navigation bar."];
    }
    else
    {
        Note *note = _notes[indexPath.row];
        
        [noteTitleLabel setText:[note noteTitle]];
        [noteBodyLabel setText:[note noteBody]];
    }
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"showNote"])
    {
        NewNoteViewController *newNoteViewController = (NewNoteViewController *)[segue destinationViewController];
        [newNoteViewController setNote:_selectedNote];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
