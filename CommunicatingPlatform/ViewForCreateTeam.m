//
//  ViewForCreateTeam.m
//  CommunicatingPlatform
//
//  Created by baoshengfeng on 16/1/5.
//  Copyright (c) 2016年 baoshengfeng. All rights reserved.
//

#import "ViewForCreateTeam.h"
#import "HTTPRequestForFourth.h"

#define screenW self.frame.size.width
#define screenH self.frame.size.height
#define intervalTop 5   //顶部控件与上框的间隙
#define intervalLeft 10   //控件与左边框的间隙
#define intervalH 20      //控件之间的上下间隙
#define intervalW 0      //控件之间的水平间隙

@interface ViewForCreateTeam() <UIGestureRecognizerDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) UITextField *teamNameField;       //团队名称
@property (strong, nonatomic) UIImageView *teamImageView;       //团队画报
@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (strong, nonatomic) UITextField *teamOfficeField;     //办公地点
@property (strong, nonatomic) UIDatePicker *buildTimePicker;    //团队成立时间
@property (strong, nonatomic) UITextView *teamInfoTextView;      //团队介绍

@property (strong, nonatomic) UITapGestureRecognizer *resignGesture;

@property (strong, nonatomic) HTTPRequestForFourth *httpRequest;

@end

@implementation ViewForCreateTeam

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setView];
    }
    return self;
}

-(void)setView
{
    //点击当前页面自动隐藏键盘
    self.resignGesture = [[UITapGestureRecognizer alloc] init];
    self.resignGesture.delegate = self;
    [self addGestureRecognizer:self.resignGesture];
    
    UIScrollView *mainView = [[UIScrollView alloc] initWithFrame:self.frame];
    
    //团队名称
    UILabel *teamNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(intervalLeft, intervalTop , screenW*3/10, screenH / 11)];
    teamNameLabel.text = @"车队主题";
    
    _teamNameField = [[UITextField alloc] initWithFrame:CGRectMake(teamNameLabel.frame.origin.x+teamNameLabel.frame.size.width+intervalW, intervalTop, screenW*6/10, screenH/11)];
    _teamNameField.layer.borderWidth = 1;
    _teamNameField.layer.cornerRadius = 8;
    
    //团队画报
    UILabel *posterLabel = [[UILabel alloc] initWithFrame:CGRectMake(intervalLeft, _teamNameField.frame.origin.y+_teamNameField.frame.size.height+intervalH, screenW*3/10, screenH/11)];
    posterLabel.text = @"车队画报";
    
    _teamImageView = [[UIImageView alloc] initWithFrame:CGRectMake(posterLabel.frame.origin.x+posterLabel.frame.size.width+intervalW, posterLabel.frame.origin.y, screenW*5/10, screenH*3/11)];
    _teamImageView.layer.borderWidth = 1;
    
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate = self;
    self.imagePicker.allowsEditing = YES;
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    UIButton *selectImageBn = [[UIButton alloc] initWithFrame:CGRectMake(posterLabel.frame.origin.x+posterLabel.frame.size.width+intervalW, posterLabel.frame.origin.y, 40, 30)];
    [selectImageBn setTitle:@"添加" forState:UIControlStateNormal];
    [selectImageBn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [selectImageBn addTarget:self action:@selector(selectImageBnClicked) forControlEvents:UIControlEventTouchUpInside];

    //办公地点(出发地点当办公地点)
    UILabel *placeLabel = [[UILabel alloc] initWithFrame:CGRectMake(intervalLeft, _teamImageView.frame.origin.y+_teamImageView.frame.size.height+intervalH, screenW*3/10, screenH/11)];
    placeLabel.text = @"办公地点";

    _teamOfficeField = [[UITextField alloc] initWithFrame:CGRectMake(placeLabel.frame.origin.x+placeLabel.frame.size.width+intervalW, placeLabel.frame.origin.y, screenW*6/10, screenH/11)];
    _teamOfficeField.layer.borderWidth = 1;
    _teamOfficeField.layer.cornerRadius = 8;
    
    //成立时间(出发时间当作成立时间)
    UILabel *establishLabel = [[UILabel alloc] initWithFrame:CGRectMake(intervalLeft, _teamOfficeField.frame.origin.y+_teamOfficeField.frame.size.height+intervalH, screenW*3/10, screenH/11)];
    establishLabel.text = @"成立时间";

    _buildTimePicker = [[UIDatePicker alloc] init];
    _buildTimePicker.frame = CGRectMake(establishLabel.frame.origin.x+establishLabel.frame.size.width, establishLabel.frame.origin.y, screenW*7/10, screenH*3/11);
    [_buildTimePicker setDatePickerMode:UIDatePickerModeDate];
    
    //团队介绍
    UILabel *teamInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(intervalLeft, _buildTimePicker.frame.origin.y+_buildTimePicker.frame.size.height+intervalH, screenW*3/10, screenH/11)];
    //_introductionLabel.backgroundColor = [UIColor redColor];
    teamInfoLabel.text = @"活动详情";

    _teamInfoTextView = [[UITextView alloc] initWithFrame:CGRectMake(teamInfoLabel.frame.origin.x+teamInfoLabel.frame.size.width+intervalW, teamInfoLabel.frame.origin.y, screenW*6/10, screenH*3/11)];
    _teamInfoTextView.layer.borderWidth = 1;
    _teamInfoTextView.layer.cornerRadius = 8;
    _teamInfoTextView.font = [UIFont systemFontOfSize:15];
    
    [mainView addSubview:teamNameLabel];
    [mainView addSubview:_teamNameField];
    [mainView addSubview:posterLabel];
    [mainView addSubview:_teamImageView];
    [mainView addSubview:selectImageBn];
    [mainView addSubview:placeLabel];
    [mainView addSubview:_teamOfficeField];
    [mainView addSubview:establishLabel];
    [mainView addSubview:_buildTimePicker];
    [mainView addSubview:teamInfoLabel];
    [mainView addSubview:_teamInfoTextView];
    
    mainView.contentSize = CGSizeMake(screenW, CGRectGetMaxY(_teamInfoTextView.frame)+intervalTop*2);
    
    [self addSubview:mainView];
}

-(void)selectImageBnClicked
{
    id target = self;
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[UIViewController class]]) {
            [target presentViewController:self.imagePicker animated:YES completion:nil];
            break;
        }
    }
}

-(void)createMyTeam
{
    //检查用户填写的信息是否完整
    if ([_teamNameField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请填写团队名称" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    if (!_teamImageView.image) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请上传团队画报" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    if ([_teamOfficeField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请填写办公地点" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    if ([_teamInfoTextView.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请填写团队介绍" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    NSString *teamName = _teamNameField.text;
    UIImage *teamImage = _teamImageView.image;
    NSString *teamOffice = _teamOfficeField.text;
    NSDate *teamDate = _buildTimePicker.date;
    NSString *teamInfo = _teamInfoTextView.text;
    NSArray *requestArray = @[teamName,teamImage,teamOffice,teamDate,teamInfo];
    
    if (!_httpRequest) {
        _httpRequest = [[HTTPRequestForFourth alloc] init];
    }
    
    id target = self;
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[UIViewController class]]) {
            ((UIViewController *)target).navigationItem.rightBarButtonItem.enabled = NO;
            break;
        }
    }
    
    [_httpRequest createKYTeam:requestArray];
}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    if (picker == self.imagePicker) {
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.teamImageView.image = image;
        });
    }
}

#pragma mark- UIGestureRecognizerDelegate
//手指一触碰屏幕就回调(手指离开屏幕不会再回调),NO表示不会触发手势，YES表示会出发手势
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UITextField class]] || [touch.view isKindOfClass:[UITextView class]]) {
        return NO;
    }
    
    [_teamNameField resignFirstResponder];
    [_teamOfficeField resignFirstResponder];
    [_teamInfoTextView resignFirstResponder];
    
    return YES;
}

@end
