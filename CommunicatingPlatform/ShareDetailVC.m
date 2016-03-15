//
//  ShareDetailVC.m
//  CommunicatingPlatform
//
//  Created by baoshengfeng on 16/1/13.
//  Copyright (c) 2016年 baoshengfeng. All rights reserved.
//

#import "ShareDetailVC.h"
#import "ShareDetailCell.h"
#import "TeamShareModel.h"
#import "SDCHeadView.h"
#import "HTTPRequestForFirst.h"
#import "LoginAndRegisterVC.h"

#define CellHeight 35

@interface ShareDetailVC ()<httpRequestDelegate ,changeDataDelegate, UIGestureRecognizerDelegate,UIAlertViewDelegate>
@property (strong ,nonatomic) NSArray *commentArray;

@property (strong ,nonatomic) HTTPRequestForFirst *httpRquest;
@property (strong ,nonatomic) DataReform *dataReform;

@property (strong, nonatomic) UIView *replyCommentView;
@property (strong, nonatomic) UITextView *commentTV;               //点击回复按钮后跳出的评论栏
@property (strong, nonatomic) UIButton *sendCommentBt;                   //发送分享按钮

@property (strong, nonatomic) UITapGestureRecognizer *dismissGesture;

@property (strong, nonatomic) UIAlertView *userLoginAlert;

@end

@implementation ShareDetailVC

static NSString *const reuseIdentifier = @"shareDetailCellResing";

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:YES animated:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:NO animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self customInit];
}

- (void)customInit
{
    [self setBottomToolBar];
    
    [self.tableView registerClass:[ShareDetailCell class] forCellReuseIdentifier:reuseIdentifier];
        
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    
    _commentArray = [[NSArray alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    _httpRquest = [[HTTPRequestForFirst alloc] init];
    _httpRquest.requestDelegate = self;
    
    _dataReform = [[DataReform alloc] init];
    _dataReform.changeDelegate = self;
    
    _dismissGesture = [[UITapGestureRecognizer alloc]init];
    _dismissGesture.delegate = self;
    [self.view addGestureRecognizer:_dismissGesture];

    [self getComment];
}

- (void)setBottomToolBar
{
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"评论" style:UIBarButtonItemStyleDone target:self action:@selector(displayTextboxForMakingComment)];
    
    UIBarButtonItem *item3 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

    NSArray *itemsArray = [NSArray arrayWithObjects:item1,item2,item3,nil];
    
    self.toolbarItems = itemsArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//获取发表的评论
- (void)getComment
{
    [_httpRquest getCommentOfTheShareWithPostId:_model.postId];
}

//发表评论
- (void)makeComment
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] stringForKey:@"uid"];
    
    [_httpRquest makeCommentWithUid:uid PostId:_model.postId Content:_commentTV.text];
}

//点击评论按钮
- (void)displayTextboxForMakingComment
{
    //如果用户没有登录，提示用户登录
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"username"]) {
        if(!_userLoginAlert){
            _userLoginAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"请先登录" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        }
        [_userLoginAlert show];
        
        return;
    }
    
    if (!_replyCommentView) {
        _replyCommentView = [[UIView alloc] init];
        _replyCommentView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    }
    
    if (!_commentTV) {
        _commentTV = [[UITextView alloc] init];
        _commentTV.font = [UIFont systemFontOfSize:15];
        _commentTV.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    }
    
    if (!_sendCommentBt) {
        _sendCommentBt = [[UIButton alloc] init];
        [_sendCommentBt setTitle:@"发送" forState:UIControlStateNormal];
        [_sendCommentBt setTitleColor:[UIColor colorWithRed:106.0/255 green:90.0/255 blue:205.0/255 alpha:1] forState:UIControlStateNormal];
        [_sendCommentBt addTarget:self action:@selector(makeComment) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [_replyCommentView addSubview:_commentTV];
    [_replyCommentView addSubview:_sendCommentBt];
    [self.view addSubview:_replyCommentView];
    
    [_commentTV becomeFirstResponder];
}

-(void)parseDataOfComments:(NSData *)data
{
    NSArray *parsedData = (NSArray *)[_dataReform jsonSerialization:data];
    NSLog(@"parsedDataGet = %@",parsedData);
    
    _commentArray = [_dataReform reformDataForComments:parsedData];
    
    [self.tableView reloadData];
}

//键盘显示时的回调函数(采用了通知者模式的形式)
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    _replyCommentView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - kbSize.height - 150, self.view.frame.size.width, 150);
    _commentTV.frame = CGRectMake(0, 0, _replyCommentView.frame.size.width - 50, _replyCommentView.frame.size.height);
    _sendCommentBt.frame = CGRectMake(_commentTV.frame.size.width, 0, 50, 50);
}

#pragma mark- UIGestureRecognizerDelegate

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UITextView class]] || [touch.view isKindOfClass:[UITextField class]]) {
        return NO; //屏蔽手势
    }
    
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    
    [_commentTV resignFirstResponder];
    
    [_replyCommentView removeFromSuperview];
    
    return YES;
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == _userLoginAlert) {
        LoginAndRegisterVC *loAndReVC = [[LoginAndRegisterVC alloc] init];
        [self.navigationController pushViewController:loAndReVC animated:YES];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        if (_commentArray.count < 1) {
            return 2;
        }
        
        return _commentArray.count;
    }
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShareDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];

    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [cell setFirstCell:_model];
        }
        
    } else if (indexPath.section == 1) {
        if (_commentArray.count > 0 && _commentArray.count >= indexPath.row) {
            [cell setCommentCell:[_commentArray objectAtIndex:indexPath.row] andIndexPath:indexPath];
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if (!cell) {
        NSLog(@"cell不存在,默认返回cell高度为50");
        return 50;
    }
    
    return cell.frame.size.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return CellHeight;
        
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        SDCHeadView *headView = [[SDCHeadView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, CellHeight)];
        
        return headView;
    }
    
    return nil;
}

#pragma mark - httpRequestDelegate
-(void)successedWithResponse:(NSData *)data tag:(NSString *)tag
{
    if ([tag isEqualToString:@"2"]) {
        [self parseDataOfComments:data];
        
    }
}

@end
