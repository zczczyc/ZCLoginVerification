//
//  ZCLoginViewController.m
//  LoginView
//
//  Created by Zc on 2018/6/20.
//  Copyright © 2018年 Zc. All rights reserved.
//

#import "ZCLoginViewController.h"
#import "Masonry.h"
#import "ZCVerificationCodeView.h"
#import "FFToast.h"

NSString *const loginNameString = @"zc";
NSString *const passWordString = @"123456";

@interface ZCLoginViewController () <UITextFieldDelegate>

/**
 背景图片
 */
@property (nonatomic, strong) UIImageView *backGroundImg;

/**
 账号
 */
@property (nonatomic, strong) UITextField *loginNameTF;

/**
 账号线
 */
@property (nonatomic, strong) UIImageView *loginNameLine;

/**
 密码
 */
@property (nonatomic, strong) UITextField *passWordTF;

/**
 密码线
 */
@property (nonatomic, strong) UIImageView *passWordLine;

/**
 验证码
 */
@property (nonatomic, strong) UITextField *verificationTF;

/**
 验证码线
 */
@property (nonatomic, strong) UIImageView *verificationLine;

/**
 验证码view
 */
@property (nonatomic, strong) ZCVerificationCodeView *verificationCodeView;

/**
 登录按钮
 */
@property (nonatomic, strong) UIButton *loginButton;

/**
 记录当前验证码状态(隐藏，显示)
 */
@property (nonatomic ) BOOL verificationHidden;

@end

@implementation ZCLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self p_setupUI];
    [self p_setupFrame];
}

/**
 添加页面UI控件
 */
- (void)p_setupUI {
    
    [self.view addSubview:self.backGroundImg];
    [self.view addSubview:self.loginNameTF];
    [self.view addSubview:self.loginNameLine];
    [self.view addSubview:self.passWordTF];
    [self.view addSubview:self.passWordLine];
    [self.view addSubview:self.verificationTF];
    [self.view addSubview:self.verificationLine];
    [self.view addSubview:self.verificationCodeView];
    [self.view addSubview:self.loginButton];
    [self p_setupHidden:YES];
}

/**
 设置验证码布局是否隐藏
 
 @param hidden yes 隐藏 no显示
 */
- (void)p_setupHidden:(BOOL)hidden {
    self.verificationHidden = hidden;
    self.verificationTF.hidden = hidden;
    self.verificationLine.hidden = hidden;
    self.verificationCodeView.hidden = hidden;
    [self p_setupUpdateFrame];
}

/**
 登录按钮Click
 */
- (void)loginBtnClick {
    
    if (self.verificationTF.hidden == NO) {
        if (self.verificationTF.text.length <= 0) {
            
            [self p_showError:@"请输入验证码"];
            return;
        }
        
        int result1 = [self.verificationCodeView.changeString compare:self.verificationTF.text options:NSCaseInsensitiveSearch];
        
        if (!((self.verificationCodeView.changeString.length == self.verificationTF.text.length ) && (result1 == 0))) {
            
            [self p_showError:@"验证码输入错误，请重新输"];
            self.verificationTF.text = @"";
            
            [self.verificationCodeView changeCode];
            return;
        }
        
        [self loginNameString:self.loginNameTF.text password:self.passWordTF.text];
        
    }else{
        [self loginNameString:self.loginNameTF.text password:self.passWordTF.text];
    }
    
}


/**
 模拟正常登录
 
 @param loginName 账号
 @param password 密码
 */
- (void)loginNameString:(NSString *)loginName password:(NSString *)password {
    
    if ([loginName isEqualToString:@"zc"] && [password isEqualToString:@"123456"]) {
        
        [self p_showError:@"登录成功"];
        [self p_loginSuccess];
    }else{
        
        [self p_setupHidden:NO];
        [self p_showError:@"用户名或密码不正确"];
        [self.verificationCodeView changeCode];
        
    }
}

- (void)p_loginSuccess {
    
    self.passWordTF.text = @"";
    [self p_setupHidden:YES];
}

/**
 监听textfield输入
 
 @param theTextField theTextField
 */
- (void)textFieldDidChange :(UITextField *)theTextField {
    
    if (self.loginNameTF.text.length > 0 && self.passWordTF.text.length > 0) {
        if (self.verificationTF.hidden == NO) {
            if (self.verificationTF.text.length > 0) {
                
                [self p_loginButtonEnabled:YES];
            }else{
                
                [self p_loginButtonEnabled:NO];
            }
            
        }else{
            
            [self p_loginButtonEnabled:YES];
        }
    }else{
        
        [self p_loginButtonEnabled:NO];
    }
}

/**
 登录按钮是否可编辑
 
 @param enabled yes 可编辑 no不可编辑
 */
- (void)p_loginButtonEnabled:(BOOL)enabled {
    
    if (enabled) {
        self.loginButton.enabled = YES;
        [self.loginButton setBackgroundImage:[UIImage imageNamed:@"login_btn_selected"] forState:UIControlStateNormal];
    }else{
        self.loginButton.enabled = NO;
        [self.loginButton setBackgroundImage:[UIImage imageNamed:@"login_btn_normal"] forState:UIControlStateNormal];
    }
}

/**
 在背景view添加收回键盘操作
 */
- (void)tapBG {
    
    [self.loginNameTF resignFirstResponder];
    [self.passWordTF resignFirstResponder];
    [self.verificationTF resignFirstResponder];
}

/**
 错误信息提示
 
 @param errorMessage errorMessage
 */
- (void)p_showError:(NSString *)errorMessage {
    [FFToast showToastWithTitle:@"" message:errorMessage iconImage:nil duration:3 toastType:FFToastTypeDefault];
}

/**
 设置页面控件Frame
 */
- (void)p_setupFrame {
    
    [self.backGroundImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.bottom.equalTo(self.view).with.offset(0);
    }];
    
    [self.loginNameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(20);
        make.right.equalTo(self.view.mas_right).with.offset(-20);
        make.centerY.equalTo(self.view.mas_centerY).with.offset(-100);
        make.height.mas_equalTo(@40);
    }];
    
    [self.loginNameLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(20);
        make.right.equalTo(self.view.mas_right).with.offset(-20);
        make.top.equalTo(self.loginNameTF.mas_bottom).with.offset(1);
        make.height.mas_equalTo(@1.5);
    }];
    
    [self.passWordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(20);
        make.right.equalTo(self.view.mas_right).with.offset(-20);
        make.top.equalTo(self.loginNameLine.mas_bottom).with.offset(40);
        make.width.mas_equalTo(@50);
    }];
    
    [self.passWordLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(20);
        make.right.equalTo(self.view.mas_right).with.offset(-20);
        make.top.equalTo(self.passWordTF.mas_bottom).with.offset(10);
        make.height.mas_equalTo(@1.5);
    }];
    
    [self.verificationTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(40);
        make.right.equalTo(self.view.mas_right).with.offset(-120);
        make.top.equalTo(self.passWordLine.mas_bottom).with.offset(40);
    }];
    
    [self.verificationLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(20);
        make.right.equalTo(self.view.mas_right).with.offset(-20);
        make.top.equalTo(self.verificationTF.mas_bottom).with.offset(10);
        make.height.mas_equalTo(@1.5);
    }];
    
    [self.verificationCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.verificationTF.mas_right).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-20);
        make.top.equalTo(self.verificationTF.mas_top).with.offset(-10);
        make.bottom.equalTo(self.verificationTF.mas_bottom).with.offset(5);
    }];
    
    if (self.verificationHidden) {
        [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).with.offset(20);
            make.right.equalTo(self.view.mas_right).with.offset(-20);
            make.top.equalTo(self.passWordTF.mas_bottom).with.offset(40);
            make.height.mas_equalTo(@50);
        }];
    }else{
        [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).with.offset(20);
            make.right.equalTo(self.view.mas_right).with.offset(-20);
            make.top.equalTo(self.verificationTF.mas_bottom).with.offset(40);
            make.height.mas_equalTo(@50);
        }];
    }
}

/**
 显示验证码 更新登录按钮位置
 */
- (void)p_setupUpdateFrame {
    
    if (self.verificationHidden) {
        [self.loginButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).with.offset(20);
            make.right.equalTo(self.view.mas_right).with.offset(-20);
            make.top.equalTo(self.passWordTF.mas_bottom).with.offset(40);
            make.height.mas_equalTo(@50);
        }];
    }else{
        [self.loginButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).with.offset(20);
            make.right.equalTo(self.view.mas_right).with.offset(-20);
            make.top.equalTo(self.verificationTF.mas_bottom).with.offset(40);
            make.height.mas_equalTo(@50);
        }];
    }
}

#pragma mark ---------------懒加载页面控件---------------
- (UIImageView *)backGroundImg {
    if (!_backGroundImg) {
        _backGroundImg = [[UIImageView alloc]init];
        _backGroundImg.image = [UIImage imageNamed:@"login_bg_x"];
        _backGroundImg.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBG)];
        [_backGroundImg addGestureRecognizer:tap];
    }
    return _backGroundImg;
}

- (UITextField *)loginNameTF {
    if (!_loginNameTF) {
        
        _loginNameTF = [[UITextField alloc]init];
        _loginNameTF.tag = 1;
        [_loginNameTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        UIImageView *image=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_login_account"]];
        _loginNameTF.leftView = image;
        _loginNameTF.leftViewMode = UITextFieldViewModeAlways;
        _loginNameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _loginNameTF.borderStyle = UITextBorderStyleNone;
        _loginNameTF.placeholder = @"用户名";
        UIColor *color = [UIColor colorWithRed:122/255.0 green:214/255.0 blue:255/255.0 alpha:1.0];
        _loginNameTF.textColor = color;
        _loginNameTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_loginNameTF.placeholder attributes:@{NSForegroundColorAttributeName: color}];
        _loginNameTF.keyboardAppearance = UIKeyboardAppearanceAlert;
        _loginNameTF.text = @"zc";
    }
    return _loginNameTF;
}

- (UIImageView *)loginNameLine {
    if (!_loginNameLine) {
        _loginNameLine = [[UIImageView alloc]init];
        _loginNameLine.backgroundColor = [UIColor colorWithRed:192/255.0 green:235/255.0 blue:253/255.0 alpha:1.0];
    }
    return _loginNameLine;
}

- (UITextField *)passWordTF {
    if (!_passWordTF) {
        _passWordTF = [[UITextField alloc]init];
        _passWordTF.tag = 2;
        [_passWordTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        UIImageView *image=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_login_passwd"]];
        _passWordTF.leftView = image;
        _passWordTF.leftViewMode = UITextFieldViewModeAlways;
        _passWordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passWordTF.secureTextEntry = YES;
        _passWordTF.borderStyle = UITextBorderStyleNone;
        _passWordTF.placeholder = @"密码";
        UIColor *color = [UIColor colorWithRed:122/255.0 green:214/255.0 blue:255/255.0 alpha:1.0];
        _passWordTF.textColor = color;
        _passWordTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_passWordTF.placeholder attributes:@{NSForegroundColorAttributeName: color}];
        _passWordTF.keyboardAppearance = UIKeyboardAppearanceAlert;
    }
    return _passWordTF;
}

- (UIImageView *)passWordLine {
    if (!_passWordLine) {
        _passWordLine = [[UIImageView alloc]init];
        _passWordLine.backgroundColor = [UIColor colorWithRed:192/255.0 green:235/255.0 blue:253/255.0 alpha:1.0];
    }
    return _passWordLine;
}

- (UITextField *)verificationTF {
    if (!_verificationTF) {
        
        _verificationTF = [[UITextField alloc]init];
        _verificationTF.tag = 3;
        [_verificationTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        UIImageView *image=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
        _verificationTF.leftView = image;
        _verificationTF.leftViewMode = UITextFieldViewModeAlways;
        _verificationTF.borderStyle = UITextBorderStyleNone;
        _verificationTF.placeholder = @"请输入验证码";
        UIColor *color = [UIColor colorWithRed:122/255.0 green:214/255.0 blue:255/255.0 alpha:1.0];
        _verificationTF.textColor = color;
        _verificationTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_verificationTF.placeholder attributes:@{NSForegroundColorAttributeName: color}];
        _verificationTF.keyboardAppearance = UIKeyboardAppearanceAlert;
    }
    return _verificationTF;
}

- (UIImageView *)verificationLine {
    if (!_verificationLine) {
        _verificationLine = [[UIImageView alloc]init];
        _verificationLine.backgroundColor = [UIColor colorWithRed:192/255.0 green:235/255.0 blue:253/255.0 alpha:1.0];
    }
    return _verificationLine;
}

- (ZCVerificationCodeView *)verificationCodeView {
    if (!_verificationCodeView) {
        
        _verificationCodeView = [[ZCVerificationCodeView alloc]initWithFrame:CGRectZero andChangeArray:nil];
    }
    return _verificationCodeView;
}

- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _loginButton.frame = CGRectMake(100, 110, 100, 50);
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        _loginButton.enabled = NO;
        [_loginButton setBackgroundImage:[UIImage imageNamed:@"login_btn_normal"] forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _loginButton.titleLabel.font = [UIFont systemFontOfSize:18];
        _loginButton.contentEdgeInsets = UIEdgeInsetsMake(-5, 0, 0, 0);
        [_loginButton addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_loginButton];
    }
    return _loginButton;
}

@end
