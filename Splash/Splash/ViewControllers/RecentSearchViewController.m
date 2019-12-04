//
//  RecentSearchViewController.m
//  Splash
//
//  Created by Angie Chilmaza on 12/4/19.
//  Copyright © 2019 Angie Chilmaza. All rights reserved.
//

//------------------------------------------------------------
//  NOTES
//------------------------------------------------------------
// RecentSearchViewController handles cached list of recently
// used search strings. Cached list is managed by DAO.
// Once a search is done, string is placed on list and displayed
// in table view.
//
//------------------------------------------------------------

#import "RecentSearchViewController.h"
#import "RecentSearchTableViewCell.h"
#import "SearchItem.h"
#import "DAO.h"

#define HEIGHT_FOR_HEADER 40.0

@interface RecentSearchViewController () <UITableViewDelegate, UITableViewDataSource, DAODelegate>

@property (strong, nonatomic) IBOutlet UITableView *recentSearchesTableView;
@property (strong, nonatomic) NSArray * recentSearches;

@end

@implementation RecentSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Setup tableView's data source and delegate
    self.recentSearchesTableView.delegate = self;
    self.recentSearchesTableView.dataSource = self;
    self.recentSearchesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.recentSearches = [[NSArray alloc] init];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [self.recentSearches count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return HEIGHT_FOR_HEADER;
}

//Layout recent searches tableview section title
-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *tableViewHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, HEIGHT_FOR_HEADER)];
   tableViewHeaderView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];

    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.bounds.size.width - 10, HEIGHT_FOR_HEADER)];
    title.text = @"Recent Searches";
    title.font = [UIFont fontWithName:@"Avenir-Heavy" size:20];
    title.textColor = [UIColor colorWithRed:26.0/255.0 green:188.0/255.0 blue:156.0/255.0 alpha:1.0]; //sea green
    
    UIView *bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0, tableViewHeaderView.frame.size.height - 0.3, tableViewHeaderView.frame.size.width, 0.3)];
    bottomBorder.backgroundColor = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0];
    [tableViewHeaderView addSubview:title];
    [tableViewHeaderView addSubview:bottomBorder];
    
    return tableViewHeaderView;

}


- (RecentSearchTableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RecentSearchTableViewCell * cell = (RecentSearchTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"RecentSearchCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSInteger row = [indexPath row];
    SearchItem * searchItem = self.recentSearches[row];
    cell.queryLabel.text = searchItem.query;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger row = [indexPath row];
    SearchItem * searchItem = self.recentSearches[row];
    
    if(searchItem.query != nil){
        searchItem.query = [searchItem.query stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if(![searchItem.query isEqualToString:@""]){
            [self.delegate processSearchQuery:searchItem.query];
        }
    }
}

#pragma mark DAODelegate
-(void)reloadData{
    
    self.recentSearches = [[DAO sharedInstance] getRecentSearches];
    [self.recentSearchesTableView reloadData];

}


@end
