//
//  HTMIChangePasswordViewController.m
//  ChangePassword
//
//  Created by Zc on 2018/6/14.
//  Copyright © 2018年 Zc. All rights reserved.
//

#import "HTMIChangePasswordViewController.h"
#import "Masonry.h"
#import "HTMISettingManager.h"
#import "HTMIDeviceChangePasswordApi.h"
#import "SVProgressHUD.h"
#import "HTMIAppDelegate.h"
#import "HTMIAppDelegate+PrivateMethod.h"

@interface HTMIChangePasswordViewController () <UITextFieldDelegate,HTMIBaseRequestCallBackDelegate>

/**
 旧密码
 */
@property (nonatomic, strong) UILabel *oldPassword;

/**
 旧密码父view
 */
@property (nonatomic, strong) UIView *oldTextfieldView;

/**
 输入旧密码文本框
 */
@property (nonatomic, strong) UITextField *inputOldTextField;

/**
 新密码父view
 */
@property (nonatomic, strong) UIView *inputNewTextfieldView;

/**
 新密码
 */
@property (nonatomic, strong) UILabel *ChangeNewPassword;

/**
 输入新密码文本框
 */
@property (nonatomic, strong) UITextField *inputNewTextField;

/**
 提示旧密码   密码长度不能小于6位
 */
@property (nonatomic, strong) UILabel *alertOldPasswordLabel;
/**
 提示新密码   密码长度不能小于6位
 */
@property (nonatomic, strong) UILabel *alertNewPasswordLabel;

/**
 确定按钮
 */
@property (nonatomic, strong) UIButton *determineButton;

/**
 显示密码
 */
@property (nonatomic, strong) UIButton *showPasswordButton;

/**
 显示密码标记
 */
@property (nonatomic ) BOOL isShow;

@property (nonatomic, strong) HTMIDeviceChangePasswordApi *changePasswordApi;

@end

@implementation HTMIChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customNavigationController:YES title:@"修改密码"];
    self.view.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0];
    self.isShow = YES;
    [self p_setupUI];
    [self p_setupFrame];
}

- (void)p_setupUI {
    
    [self.view addSubview:self.oldPassword];
    [self.view addSubview:self.inputOldTextField];
    [self.view addSubview:self.alertOldPasswordLabel];
    [self.view addSubview:self.ChangeNewPassword];
    [self.view addSubview:self.inputNewTextField];
    [self.view addSubview:self.oldTextfieldView];
    [self.view addSubview:self.inputNewTextfieldView];
    [self.oldTextfieldView addSubview:self.inputOldTextField];
    [self.inputNewTextfieldView addSubview:self.inputNewTextField];
    [self.view addSubview:self.alertNewPasswordLabel];
    [self.view addSubview:self.determineButton];
    [self.view addSubview:self.showPasswordButton];
}


- (void)p_setupFrame {
    
    [self.oldPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).with.offset(20);
        make.top.equalTo(self.view.mas_top).with.offset(25);
    }];
    
    [self.oldTextfieldView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.top.equalTo(self.oldPassword.mas_bottom).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, 50));
    }];
    
    [self.inputOldTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.oldTextfieldView.mas_left).with.offset(20);
        make.top.right.bottom.equalTo(self.oldTextfieldView).with.offset(0);
    }];
    
    [self.alertOldPasswordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(20);
        make.top.equalTo(self.inputOldTextField.mas_bottom).with.offset(5);
    }];
    
    [self.ChangeNewPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).with.offset(20);
        make.top.equalTo(self.oldTextfieldView.mas_bottom).with.offset(35);
    }];
    
    [self.inputNewTextfieldView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.top.equalTo(self.ChangeNewPassword.mas_bottom).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, 50));
    }];
    
    [self.inputNewTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.inputNewTextfieldView.mas_left).with.offset(20);
        make.top.right.bottom.equalTo(self.inputNewTextfieldView).with.offset(0);
    }];
    
    [self.alertNewPasswordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(20);
        make.top.equalTo(self.inputNewTextField.mas_bottom).with.offset(5);
    }];
    
    [self.determineButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(63);
        make.right.equalTo(self.view.mas_right).with.offset(-63);
        make.top.equalTo(self.alertNewPasswordLabel.mas_bottom).with.offset(35);
        make.height.mas_equalTo(@50);
    }];
    
    [self.showPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(15);
        make.top.equalTo(self.determineButton.mas_bottom).with.offset(10);
    }];
    
}

-(void)textFieldDidChange :(UITextField *)theTextField{
    
    if (theTextField.tag == 1100) {
        
        if (theTextField.text.length > 0) {
            self.alertOldPasswordLabel.hidden = YES;
        }else{
            self.alertOldPasswordLabel.hidden = NO;
        }
    }else if (theTextField.tag == 2200) {
        
        if (self.inputOldTextField.text.length > 0) {
            self.alertOldPasswordLabel.hidden = YES;
        }else{
            self.alertOldPasswordLabel.hidden = NO;
        }
        
        if (theTextField.text.length < 6) {
            self.alertNewPasswordLabel.text = @"密码长度不能小于6位";
            self.determineButton.userInteractionEnabled=NO;//交互关闭
            self.determineButton.alpha=0.4;//透明度
        }else{
            self.alertNewPasswordLabel.text = @"";
            
        }
    }
    if (self.inputOldTextField.text.length > 0 &&
        self.inputNewTextField.text.length >= 6)  {
        self.determineButton.userInteractionEnabled=YES;//交互关闭
        self.determineButton.alpha=1.0;//透明度
    }
}

- (void)showPassWrodClick:(UIButton *)sender {
    
    if (self.isShow) {
        self.isShow = NO;
        [self.showPasswordButton setImage:[UIImage imageNamed:@"btn_todolist_check_normal_white"] forState:UIControlStateNormal];
        self.inputOldTextField.secureTextEntry = NO;
        self.inputNewTextField.secureTextEntry = NO;
        
    }else{
        self.isShow = YES;
        [self.showPasswordButton setImage:[UIImage imageNamed:@"btn_todolist_check_selected_blue"] forState:UIControlStateNormal];
        self.inputOldTextField.secureTextEntry = YES;
        self.inputNewTextField.secureTextEntry = YES;
    }
}


- (void)loginClick {
    
    if ([self.inputOldTextField.text isEqualToString:self.inputNewTextField.text]) {
        
        self.alertNewPasswordLabel.text = @"新旧密码不能相同";
        return;
    }
    [SVProgressHUD show];   
    [self.changePasswordApi setOldPassword:self.inputOldTextField.text newPassword:self.inputNewTextField.text];
    [self.changePasswordApi loadData];
    
}

#pragma mark --------- HTMIBaseRequestCallBackDelegate --------

- (void)requestDidSuccess:(HTMIBaseRequest *)request {
    
    HTMILogInfo(@"对应接口实现了requestSuccessDicWithClassStrAndSELStr， 则不用在这个方法里实现，如果本控制器相关接口全部分发出去，则可不写这个方法");
}

//写这个是为了演示多个接口， 实际本Demo只有一个，可以直接写requestDidSuccess里或者block
- (NSDictionary<NSString *, NSString *> *)requestSuccessDicWithClassStrAndSELStr {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setObject:NSStringFromSelector(@selector(handleDeviceChangePasswordApi:)) forKey:NSStringFromClass([HTMIDeviceChangePasswordApi class])];
    
    
    return [dic copy];
}



/**
 保存申请审核请求响应
 
 @param api 接口对象
 */
- (void)handleDeviceChangePasswordApi:(HTMIDeviceChangePasswordApi *)api{
    
    [SVProgressHUD dismiss];
    
    if (api.isSuccess) {
        
        [HTMIAPPDELEGATE logoutWithoutUI:NO];
        [HTMIAPPDELEGATE  showLoginViewController];
        [HTMIErrorTipTool showHTMIErrorTip:@"密码修改成功"];
//        [self.navigationController popViewControllerAnimated:YES];
    }
}

/**
 请求失败响应方法
 
 @param request 请求
 */
- (void)requestDidFailed:(HTMIBaseRequest *)request {
    
    [HTMIErrorTipTool showHTMIErrorTip:request.response.responseMessage];
    [SVProgressHUD dismiss];
    
}

- (UILabel *)oldPassword {
    if (!_oldPassword) {
        NSArray *nameArray = @[@"旧密码:",@"新密码:"];
        _oldPassword = [[UILabel alloc]init];
        _oldPassword.text = nameArray[0];
        //    self.oldPassword.font = [UIFont systemFontOfSize:12.0f];
        _oldPassword.textAlignment = NSTextAlignmentLeft;
        _oldPassword.textColor = [UIColor colorWithRed:123/255.0 green:123/255.0 blue:123/255.0 alpha:1.0];
    }
    return _oldPassword;
}

- (UITextField *)inputOldTextField {
    if (!_inputOldTextField) {
        _inputOldTextField = [[UITextField alloc]init];
        [self.inputOldTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _inputOldTextField.tag = 1100;
        //设置输入框的背景颜色，此时设置为白色 如果使用了自定义的背景图片边框会被忽略掉
        _inputOldTextField.backgroundColor = [UIColor whiteColor];
        //当输入框没有内容时，水印提示 提示内容为password
        _inputOldTextField.placeholder = @"请输入旧密码";
        //设置输入框内容的字体样式和大小
        _inputOldTextField.font = [UIFont fontWithName:@"Arial" size:15.0f];
        //输入框中是否有个叉号，在什么时候显示，用于一次性删除输入框中的内容
        _inputOldTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        //每输入一个字符就变成点 用语密码输入
        //    _inputOldTextField.secureTextEntry = YES;
        //再次编辑就清空
        //    _inputOldTextField.clearsOnBeginEditing = YES;
        //首字母是否大写
        //    _inputOldTextField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
        //return键变成什么键
        _inputOldTextField.returnKeyType =UIReturnKeyNext;//标有Next的蓝色按钮
        //键盘外观
        _inputOldTextField.keyboardAppearance=UIKeyboardAppearanceAlert;
    }
    return _inputOldTextField;
}

- (UILabel *)alertOldPasswordLabel {
    if (!_alertOldPasswordLabel) {
        _alertOldPasswordLabel = [[UILabel alloc]init];
        _alertOldPasswordLabel.text = @"还未输出旧密码";
        _alertOldPasswordLabel.font = [UIFont systemFontOfSize:15.0];
        _alertOldPasswordLabel.textColor = [UIColor redColor];
        _alertOldPasswordLabel.hidden = YES;
    }
    return _alertOldPasswordLabel;
}

- (UILabel *)ChangeNewPassword {
    if (!_ChangeNewPassword) {
        NSArray *nameArray = @[@"旧密码:",@"新密码:"];
        _ChangeNewPassword = [[UILabel alloc]init];
        _ChangeNewPassword.text = nameArray[1];
        //    self.ChangeNewPassword.font = [UIFont systemFontOfSize:12.0f];
        _ChangeNewPassword.textAlignment = NSTextAlignmentLeft;
        _ChangeNewPassword.textColor = [UIColor colorWithRed:123/255.0 green:123/255.0 blue:123/255.0 alpha:1.0];
    }
    return _ChangeNewPassword;
}

- (UITextField *)inputNewTextField {
    if (!_inputNewTextField) {
        
        _inputNewTextField = [[UITextField alloc]init];
        [_inputNewTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _inputNewTextField.tag = 2200;
        //设置输入框的背景颜色，此时设置为白色 如果使用了自定义的背景图片边框会被忽略掉
        _inputNewTextField.backgroundColor = [UIColor whiteColor];
        //当输入框没有内容时，水印提示 提示内容为password
        _inputNewTextField.placeholder = @"密码长度不可小于6位";
        //设置输入框内容的字体样式和大小
        _inputNewTextField.font = [UIFont fontWithName:@"Arial" size:15.0f];
        //输入框中是否有个叉号，在什么时候显示，用于一次性删除输入框中的内容
        _inputNewTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        //每输入一个字符就变成点 用语密码输入
        //    self.inputOldTextField.secureTextEntry = YES;
        //再次编辑就清空
        //    self.inputNewTextField.clearsOnBeginEditing = YES;
        //设置键盘的样式
        _inputNewTextField.keyboardType = UIKeyboardTypeTwitter;
        //首字母是否大写
        //    _inputNewTextField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
        //return键变成什么键
        _inputNewTextField.returnKeyType =UIReturnKeyNext;//标有Next的蓝色按钮
        //键盘外观
        _inputNewTextField.keyboardAppearance=UIKeyboardAppearanceAlert;
    }
    return _inputNewTextField;
}

- (UIView *)oldTextfieldView {
    if (!_oldTextfieldView) {
        _oldTextfieldView = [[UIView alloc]init];
        _oldTextfieldView.backgroundColor = [UIColor whiteColor];
        _oldTextfieldView.layer.borderWidth = 1.0;
        _oldTextfieldView.layer.borderColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0].CGColor;
    }
    return _oldTextfieldView;
}

- (UIView *)inputNewTextfieldView {
    if (!_inputNewTextfieldView) {
        _inputNewTextfieldView = [[UIView alloc]init];
        _inputNewTextfieldView.backgroundColor = [UIColor whiteColor];
        _inputNewTextfieldView.layer.borderWidth = 1.0;
        _inputNewTextfieldView.layer.borderColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0].CGColor;
    }
    return _inputNewTextfieldView;
}

- (UILabel *)alertNewPasswordLabel {
    if (!_alertNewPasswordLabel) {
        _alertNewPasswordLabel = [[UILabel alloc]init];
        //    self.alertNewPasswordLabel.text = @"密码长度不能小于6位";
        _alertNewPasswordLabel.font = [UIFont systemFontOfSize:15.0];
        _alertNewPasswordLabel.textColor = [UIColor redColor];
        //    self.alertNewPasswordLabel.hidden = YES;
    }
    return _alertNewPasswordLabel;
}

- (UIButton *)determineButton {
    
    if (!_determineButton) {
        _determineButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_determineButton setTitle:@"确定" forState:UIControlStateNormal];
        [_determineButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _determineButton.backgroundColor = kHTMI_HUEControlColor;
        [_determineButton addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
        _determineButton.layer.borderColor = kHTMI_HUEControlColor.CGColor;
        _determineButton.layer.borderWidth = 1.0;
        _determineButton.layer.cornerRadius = 5;
        _determineButton.userInteractionEnabled = NO;//交互关闭
        _determineButton.alpha = 0.4;//透明度
    }
    return _determineButton;
}

- (UIButton *)showPasswordButton {
    
    if (!_showPasswordButton) {
        _showPasswordButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_showPasswordButton setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_showPasswordButton setTitle:@"显示密码" forState:UIControlStateNormal];
        [_showPasswordButton setImage:[UIImage imageNamed:@"btn_todolist_check_selected_blue"] forState:UIControlStateNormal];
        [_showPasswordButton addTarget:self action:@selector(showPassWrodClick:) forControlEvents:UIControlEventTouchUpInside];
        _showPasswordButton.hidden = YES;
    }
    return _showPasswordButton;
}

/**
 修改密码
 
 @return api
 */
- (HTMIDeviceChangePasswordApi *)changePasswordApi {
    if (!_changePasswordApi) {
        _changePasswordApi = [[HTMIDeviceChangePasswordApi alloc]init];
        _changePasswordApi.delegate = self;
    }
    return _changePasswordApi;
}

@end
