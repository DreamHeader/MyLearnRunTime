//
//  ViewController.m
//  关于runtime的个人学习
//
//  Created by gubeidianzi on 2018/1/17.
//  Copyright © 2018年 dreamHeader. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
@interface ViewController ()<UITableViewDelegate,UITextDragRequest>{
    int vairA ;
    double vairB;
}
@property (nonatomic,strong) UIView * view1;
@property (nonatomic,strong) UITableView * view2;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self runtimeLearn];
    [self runtimeSEL];
    // Do any additional setup after loading the view, typically from a nib.
}
#pragma mark - runtime的基础支持讲义
-(void)runtimeLearn{
//   Runtime 是一个比较底层的C语言的API，可以翻译为“运行时”。作为使用运行时机制的OC语言的底层，它在程序运行时把OC语言转换成了runtime的C语言代码。学习并理解runtime是OC学习历程中的不可或缺的一大块儿。
    
#warning Learn_Page_1
    
//    /// 描述类中的一个方法
//    typedef struct objc_method *Method;
//
//    /// 实例变量
//    typedef struct objc_ivar *Ivar;
//
//    /// 类别Category
//    typedef struct objc_category *Category;
//
//    /// 类中声明的属性
//    typedef struct objc_property *objc_property_t;
 
//    获取列表
    
//    有时候会有这样的需求，我们需要知道当前类中每个属性的名字（比如字典转模型，字典的Key和模型对象的属性名字不匹配）。
//    我们可以通过runtime的一系列方法获取类的一些信息（包括属性列表，方法列表，成员变量列表，和遵循的协议列表）。
    
    unsigned int count;
    /* 获取属性列表*/
    objc_property_t  * property_list = class_copyPropertyList([self class], &count);
    for (unsigned int i = 0; i<count; i++) {
        
        const char *propertyName = property_getName(property_list[i]);
         NSLog(@"property---->%@", [NSString stringWithUTF8String:propertyName]);
    }
    /*获取方法列表*/
    Method *methodlist = class_copyMethodList([self class], &count);
    for (unsigned int i = 0; i<count; i++) {
        Method method = methodlist[i];
        NSLog(@"method---->%@", NSStringFromSelector(method_getName(method)));
    }
 
    //获取成员变量列表
    Ivar *ivarList = class_copyIvarList([self class], &count);
    for (unsigned int i = 0; i<count; i++) {
        Ivar myIvar = ivarList[i];
        const char *ivarName = ivar_getName(myIvar);
        NSLog(@"Ivar---->%@", [NSString stringWithUTF8String:ivarName]);
    }
   //获取协议列表
    __unsafe_unretained Protocol **protoclList = class_copyProtocolList([self class], &count);
    for (unsigned int i; i<count; i++) {
        Protocol *myProtocal = protoclList[i];
        const char *protocolName = protocol_getName(myProtocal);
        NSLog(@"protocol---->%@", [NSString stringWithUTF8String:protocolName]);
    }
    
}
#pragma mark - 方法调用
-(void)runtimeSEL{
//    让我们看一下方法调用在运行时的过程（参照前文类在runtime中的表示）
//
//    如果用实例对象调用实例方法，会到实例的isa指针指向的对象（也就是类对象）操作。
//    如果调用的是类方法，就会到类对象的isa指针指向的对象（也就是元类对象）中操作。
//
//    首先，在相应操作的对象中的缓存方法列表中找调用的方法，如果找到，转向相应实现并执行。
//    如果没找到，在相应操作的对象中的方法列表中找调用的方法，如果找到，转向相应实现执行
//    如果没找到，去父类指针所指向的对象中执行1，2.
//    以此类推，如果一直到根类还没找到，转向拦截调用。
//    如果没有重写拦截调用的方法，程序报错。
}
#pragma mark - 拦截调用
-(void)SELlanjie{
//    在方法调用中说到了，如果没有找到方法就会转向拦截调用。
//    那么什么是拦截调用呢。
//    拦截调用就是，在找不到调用的方法程序崩溃之前，你有机会通过重写NSObject的四个方法来处理。
    
    
   /* + (BOOL)resolveClassMethod:(SEL)sel;
      + (BOOL)resolveInstanceMethod:(SEL)sel;
    //后两个方法需要转发到其他的类处理
    - (id)forwardingTargetForSelector:(SEL)aSelector;
    - (void)forwardInvocation:(NSInvocation *)anInvocation;*/
    
//    第一个方法是当你调用一个不存在的类方法的时候，会调用这个方法，默认返回NO，你可以加上自己的处理然后返回YES。
//    第二个方法和第一个方法相似，只不过处理的是实例方法。
//    第三个方法是将你调用的不存在的方法重定向到一个其他声明了这个方法的类，只需要你返回一个有这个方法的target。
//    第四个方法是将你调用的不存在的方法打包成NSInvocation传给你。做完你自己的处理后，调用invokeWithTarget:方法让某个target触发这个方法。
 
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
