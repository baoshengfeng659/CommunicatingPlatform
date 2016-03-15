//
//  FourthSectionRootController.m
//  CommunicatingPlatform
//
//  Created by baoshengfeng on 16/1/4.
//  Copyright © 2016年 baoshengfeng. All rights reserved.
//

#import "FourthSectionRootController.h"
#import "FourthSectionCell.h"
#import "MyTeamViewController.h"
#import "SettingViewController.h"

@interface FourthSectionRootController ()
@property (strong, nonatomic) NSMutableArray *informationArray_image;
@property (strong, nonatomic) NSMutableArray *informationArray_text;

@end

@implementation FourthSectionRootController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self customInit];
}

-(void)customInit
{
    self.tableView.scrollEnabled = NO;
    
    self.informationArray_image = [[NSMutableArray alloc] init];
    self.informationArray_text = [[NSMutableArray alloc] init];
    
    [self.informationArray_image addObject:[UIImage imageNamed:@"person.png"]];
    [self.informationArray_image addObject:[UIImage imageNamed:@"diary.png"]];
    [self.informationArray_image addObject:[UIImage imageNamed:@"discount.png"]];
    [self.informationArray_image addObject:[UIImage imageNamed:@"shoppingCart.png"]];
    [self.informationArray_image addObject:[UIImage imageNamed:@"setting.png"]];
    
    [self.informationArray_text addObject:[NSString stringWithFormat:@"个人信息"]];
    [self.informationArray_text addObject:[NSString stringWithFormat:@"自驾日记"]];
    [self.informationArray_text addObject:[NSString stringWithFormat:@"我的团队"]];
    [self.informationArray_text addObject:[NSString stringWithFormat:@"自驾装备"]];
    [self.informationArray_text addObject:[NSString stringWithFormat:@"设置"]];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.informationArray_text.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FourthSectionCell *cell = [FourthSectionCell cellWithTableView:tableView];

    [cell setCellImage:[_informationArray_image objectAtIndex:indexPath.row] andTitle:[_informationArray_text objectAtIndex:indexPath.row]];
    
    return cell;
}

//等一个Cell的tableView:cellForRowAtIndexPath完全执行好后再执行这个方法？
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return cell.frame.size.height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            break;
        case 1:
            break;
        case 2:
        {
            MyTeamViewController *myTeamVC = [[MyTeamViewController alloc] init];
            [self.navigationController pushViewController:myTeamVC animated:YES];
        }
            break;
        case 3:
            break;
        case 4:
        {
            SettingViewController *setVC = [[SettingViewController alloc] init];
            [self.navigationController pushViewController:setVC animated:YES];
        }
            break;
        default:
            break;
    }
}

@end
