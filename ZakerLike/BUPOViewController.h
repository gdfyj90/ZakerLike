//
//  BUPOViewController.h
//  ZakerLike
//
//  Created by bupo Jung on 12-5-15.
//  Copyright (c) 2012年 Wuxi Smart Sencing Star. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "BJGridItem.h"

@interface BUPOViewController : UIViewController<UIScrollViewDelegate,BJGridItemDelegate,UIGestureRecognizerDelegate>{
    NSMutableArray *gridItems;
    BJGridItem *addbutton;
    int page;
    float preX;
    BOOL isMoving;
    CGRect preFrame;
    BOOL isEditing;
    UITapGestureRecognizer *singletap;
//    CGRect MovingToFrame;
//    CGRect MovingFromFrame;
//    NSInteger MovingToIndex;
//    NSInteger MovingFromIndex; 
}
@property (weak, nonatomic) IBOutlet UIImageView *backgoundImage;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
- (void)Addbutton;

@end
