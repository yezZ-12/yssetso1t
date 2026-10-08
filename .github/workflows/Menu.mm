#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define KEYAUTH_NAME @"SoftboxiOS"
#define KEYAUTH_OWNER @"z1HNHScsTk"
#define KEYAUTH_SECRET @"ОРНЫНА_ҚҰПИЯ_КІЛТТІ_ЖАЗЫҢЫЗ"
#define KEYAUTH_VERSION @"1.0"

@interface Menu : NSObject
@end

@implementation Menu

+ (void)load {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showKeyAuthAlert];
    });
}

+ (void)showKeyAuthAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"SoftboxiOS Активация"
                                                                   message:@"Жалғастыру үшін KeyAuth кілтін енгізіңіз:"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Кілтті осы жерге жазыңыз";
    }];
    
    UIAlertAction *activateAction = [UIAlertAction actionWithTitle:@"Белсендіру" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *keyField = alert.textFields.firstObject;
        NSString *enteredKey = keyField.text;
        
        if (enteredKey.length == 0) {
            [self showErrorAndExit:@"Кілт бос болмауы керек!"];
            return;
        }
        
        [self verifyKeyWithKeyAuth:enteredKey];
    }];
    
    [alert addAction:activateAction];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

+ (void)verifyKeyWithKeyAuth:(NSString *)key {
    NSString *urlString = [NSString stringWithFormat:@"https://keyauth.win%@", 
                           key, KEYAUTH_VERSION, KEYAUTH_NAME, KEYAUTH_OWNER, KEYAUTH_SECRET];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error || !data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showErrorAndExit:@"Сервермен байланыс үзілді!"];
            });
            return;
        }
        
        NSError *jsonError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (json && [json[@"success"] boolValue] == YES) {
                UIAlertController *successAlert = [UIAlertController alertControllerWithTitle:@"Сәтті!"
                                                                                      message:@"Кілт қабылданды."
                                                                               preferredStyle:UIAlertControllerStyleAlert];
                [successAlert addAction:[UIAlertAction actionWithTitle:@"ОК" style:UIAlertActionStyleDefault handler:nil]];
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:successAlert animated:YES completion:nil];
            } else {
                [self showErrorAndExit:@"Енгізілген кілт қате!"];
            }
        });
    }];
    
    [task resume];
}

+ (void)showErrorAndExit:(NSString *)message {
    UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"Қате!"
                                                                          message:message
                                                                   preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *exitAction = [UIAlertAction actionWithTitle:@"Шығу" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        exit(0);
    }];
    
    [errorAlert addAction:exitAction];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:errorAlert animated:YES completion:nil];
}

@end
