//
//  SuggestedSearchViewController.m
//  Splash
//
//  Created by Angie Chilmaza on 12/4/19.
//  Copyright © 2019 Angie Chilmaza. All rights reserved.
//

//------------------------------------------------------------
//  NOTES
//------------------------------------------------------------
// SuggestedSearchViewController handles static list of suggested
// searches. This list is filtered and displayed based on
// search string supplied. 
//
//------------------------------------------------------------


#import "SuggestedSearchViewController.h"
#import "SuggestedSearchTableViewCell.h"
#define HEIGHT_FOR_HEADER 40.0

@interface SuggestedSearchViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *suggestedTableView;
@property (strong, nonatomic) NSArray * suggestedSearches;
@property (strong, nonatomic) NSMutableArray * filteredSuggestedSearch;

@end

@implementation SuggestedSearchViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Setup tableView's data source and delegate
    self.suggestedTableView.delegate = self;
    self.suggestedTableView.dataSource = self;
    self.suggestedTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //Static string array would need to be replaced with an api that returns
    //real-time search suggestions.
    self.suggestedSearches = @[@"A dog is a man's best friend", @"Black Friday", @"Christmas", @"Disney", @"Football", @"Hello", @"Happy", @"Holidays", @"Imagination", @"Let's Play", @"Movie", @"Primaries", @"Star Wars", @"Thank God It's Friday", @"Yeah, how about some lunch?"];
    self.filteredSuggestedSearch = [[NSMutableArray alloc] initWithArray:self.suggestedSearches];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [self.filteredSuggestedSearch count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return HEIGHT_FOR_HEADER;
}

//Layout recent searches tableview section title
-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *tableViewHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, HEIGHT_FOR_HEADER)];
   tableViewHeaderView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];

    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.bounds.size.width - 10, HEIGHT_FOR_HEADER)];
    title.text = @"Suggested Search";
    title.font = [UIFont fontWithName:@"Avenir-Heavy" size:20];
    title.textColor = [UIColor colorWithRed:26.0/255.0 green:188.0/255.0 blue:156.0/255.0 alpha:1.0]; //sea green
    
    UIView *bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0, tableViewHeaderView.frame.size.height - 0.3, tableViewHeaderView.frame.size.width, 0.3)];
    bottomBorder.backgroundColor = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0];
    [tableViewHeaderView addSubview:title];
    [tableViewHeaderView addSubview:bottomBorder];
    
    return tableViewHeaderView;

}


- (SuggestedSearchTableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SuggestedSearchTableViewCell * cell = (SuggestedSearchTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"SuggestedSearchTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  
    NSInteger row = [indexPath row];
    NSString * query  = self.filteredSuggestedSearch[row];
    cell.suggestedQuery.text = query;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger row = [indexPath row];
    NSString * suggestedSearch = self.filteredSuggestedSearch[row];
    
    if(suggestedSearch != nil){
        suggestedSearch = [suggestedSearch stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if(![suggestedSearch isEqualToString:@""]){
            [self.delegate processSearchQuery:suggestedSearch];
        }
    }
}

-(void)searchQuery:(NSString*)searchString{

    NSInteger totalSuggestions= [self.suggestedSearches count];
    self.filteredSuggestedSearch = [[NSMutableArray alloc ] initWithCapacity:totalSuggestions];
    NSString * normalizedSearch = nil;
    
    if(searchString!=nil && [searchString isEqualToString:@""]){
       normalizedSearch = nil;
    }
    else{
       normalizedSearch = [searchString lowercaseString];
    }

    for(int count = 0; count < totalSuggestions; count++){
        
        NSString * suggestedSearch = self.suggestedSearches[count];
    
        if(suggestedSearch == nil){
            [self.filteredSuggestedSearch addObject:suggestedSearch];
        }
        else if([[suggestedSearch lowercaseString] containsString:normalizedSearch]){
             [self.filteredSuggestedSearch addObject:suggestedSearch];
        }
    }
    
    //scroll to top of tableview
    //Yes, two contentOffset calls are needed
    [self.suggestedTableView setContentOffset:CGPointZero animated:NO];
    [self.suggestedTableView reloadData];
    [self.suggestedTableView layoutIfNeeded];
    [self.suggestedTableView setContentOffset:CGPointZero animated:NO];
}


@end
