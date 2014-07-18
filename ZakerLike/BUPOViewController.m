//
//  BUPOViewController.m
//  ZakerLike
//
//  Created by bupo Jung on 12-5-15.
//  Copyright (c) 2012年 Wuxi Smart Sencing Star. All rights reserved.
//

#import "BUPOViewController.h"
#define columns 2
#define rows 3
#define itemsPerPage 6
#define space 20
#define gridHight 100
#define gridWith 100
#define unValidIndex  -1
#define threshold 30


@interface BUPOViewController(private)
-(NSInteger)indexOfLocation:(CGPoint)location;
-(CGPoint)orginPointOfIndex:(NSInteger)index;
-(void) exchangeItem:(NSInteger)oldIndex withposition:(NSInteger) newIndex;
@end

@implementation BUPOViewController
@synthesize backgoundImage;
@synthesize scrollview;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	page = 0;
    isEditing = NO;
    addbutton = [[BJGridItem alloc] initWithTitle:nil withImageName:@"blueButton.jpg" atIndex:0 editable:YES];
    
    [addbutton setFrame:CGRectMake(20, 20, 100, 100)];
    addbutton.delegate = self;
    [scrollview addSubview: addbutton];
    
    gridItems = [[NSMutableArray alloc] initWithCapacity:6];
    [gridItems addObject:addbutton];
    
    scrollview.delegate = self;
    [scrollview setPagingEnabled:YES];
    
    singletap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [singletap setNumberOfTapsRequired:1];
    singletap.delegate = self;
    [scrollview addGestureRecognizer:singletap];
    

}

- (void)viewDidUnload
{
    [self setBackgoundImage:nil];
    [self setScrollview:nil];
    addbutton = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
#pragma mark-- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGRect frame = self.backgoundImage.frame;

    frame.origin.x = preFrame.origin.x + (preX - scrollView.contentOffset.x)/10 ;
   
    
    if (frame.origin.x <= 0 && frame.origin.x > scrollView.frame.size.width - frame.size.width ) {
        self.backgoundImage.frame = frame;
    }
    NSLog(@"offset:%f",(scrollView.contentOffset.x - preX));
    NSLog(@"origin.x:%f",frame.origin.x);
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    preX = scrollView.contentOffset.x;
    preFrame = backgoundImage.frame;
    NSLog(@"prex:%f",preX);
}
- (void)Addbutton {
    CGRect frame = CGRectMake(20, 20, 100, 100);
    int n = [gridItems count];
    int row = (n-1) / 2;
    int col = (n-1) % 2;
    int curpage = (n-1) / itemsPerPage;
    row = row % 3;
    if (n / 6 + 1 > 6) {
        NSLog(@"不能创建更多页面");
    }else{    
        frame.origin.x = frame.origin.x + frame.size.width * col + 20 * col + scrollview.frame.size.width * curpage;
        frame.origin.y = frame.origin.y + frame.size.height * row + 20 * row;
        
        BJGridItem *gridItem = [[BJGridItem alloc] initWithTitle:[NSString stringWithFormat:@"%d",n-1] withImageName:@"blueButton.jpg" atIndex:n-1 editable:YES];
        [gridItem setFrame:frame];
        [gridItem setAlpha:0.5];
        gridItem.delegate = self;
        [gridItems insertObject:gridItem atIndex:n-1];
        [scrollview addSubview:gridItem];
        gridItem = nil;
        
        //move the add button
        row = n / 2;
        col = n % 2;
        curpage = n / 6;
        row = row % 3;
        frame = CGRectMake(20, 20, 100, 100);
        frame.origin.x = frame.origin.x + frame.size.width * col + 20 * col + scrollview.frame.size.width * curpage;
        frame.origin.y = frame.origin.y + frame.size.height * row + 20 * row;
        NSLog(@"add button col:%d,row:%d,page:%d",col,row,curpage);
        [scrollview setContentSize:CGSizeMake(scrollview.frame.size.width * (curpage + 1), scrollview.frame.size.height)];
        [scrollview scrollRectToVisible:CGRectMake(scrollview.frame.size.width * curpage, scrollview.frame.origin.y, scrollview.frame.size.width, scrollview.frame.size.height) animated:NO];
        [UIView animateWithDuration:0.2f animations:^{
            [addbutton setFrame:frame];
        }];
        addbutton.index += 1;
        }

}
#pragma mark-- BJGridItemDelegate
- (void)gridItemDidClicked:(BJGridItem *)gridItem{
    NSLog(@"grid at index %d did clicked",gridItem.index);
    if (gridItem.index == [gridItems count]-1) {
        [self Addbutton];
    }
}

- (void)gridItemDidDeleted:(BJGridItem *)gridItem atIndex:(NSInteger)index{
    NSLog(@"grid at index %d did deleted",gridItem.index);
    BJGridItem * item = [gridItems objectAtIndex:index];

    [gridItems removeObjectAtIndex:index];
    [UIView animateWithDuration:0.2 animations:^{
        CGRect lastFrame = item.frame;
        CGRect curFrame;
        for (int i=index; i < [gridItems count]; i++) {
            BJGridItem *temp = [gridItems objectAtIndex:i];
            curFrame = temp.frame;
            [temp setFrame:lastFrame];
            lastFrame = curFrame;
            [temp setIndex:i];
        }
        [addbutton setFrame:lastFrame];
    }];
    [item removeFromSuperview];
    item = nil;
}

- (void)gridItemDidEnterEditingMode:(BJGridItem *)gridItem{
    NSLog(@"gridItems count:%d",[gridItems count]);
    for (BJGridItem *item in gridItems) {
        NSLog(@"%d",item.index);
        [item enableEditing];
    }
    //[addbutton enableEditing];
    isEditing = YES;
    
}

- (void)gridItemDidMoved:(BJGridItem *)gridItem withLocation:(CGPoint)point moveGestureRecognizer:(UILongPressGestureRecognizer *)recognizer{
    CGRect frame = gridItem.frame;
    CGPoint _point = [recognizer locationInView:self.scrollview];
    CGPoint pointInView = [recognizer locationInView:self.view];
    frame.origin.x = _point.x - point.x;
    frame.origin.y = _point.y - point.y;
    gridItem.frame = frame;
    NSLog(@"gridItemframe:%f,%f",frame.origin.x,frame.origin.y);
    NSLog(@"move to point(%f,%f)",point.x,point.y);
    
    NSInteger toIndex = [self indexOfLocation:_point];
    NSInteger fromIndex = gridItem.index;
    NSLog(@"fromIndex:%d toIndex:%d",fromIndex,toIndex);
    
    if (toIndex != unValidIndex && toIndex != fromIndex) {
        BJGridItem *moveItem = [gridItems objectAtIndex:toIndex];
        [scrollview sendSubviewToBack:moveItem];
        [UIView animateWithDuration:0.2 animations:^{
            CGPoint origin = [self orginPointOfIndex:fromIndex];
            //NSLog(@"origin:%f,%f",origin.x,origin.y);
            moveItem.frame = CGRectMake(origin.x, origin.y, moveItem.frame.size.width, moveItem.frame.size.height); 
        }];
        [self exchangeItem:fromIndex withposition:toIndex];
        //移动
        
    }
    //翻页
    if (pointInView.x >= scrollview.frame.size.width - threshold) {
        [scrollview scrollRectToVisible:CGRectMake(scrollview.contentOffset.x + scrollview.frame.size.width, 0, scrollview.frame.size.width, scrollview.frame.size.height) animated:YES];
    }else if (pointInView.x < threshold) {
        [scrollview scrollRectToVisible:CGRectMake(scrollview.contentOffset.x - scrollview.frame.size.width, 0, scrollview.frame.size.width, scrollview.frame.size.height) animated:YES];
    }

    
    
}
- (void) gridItemDidEndMoved:(BJGridItem *) gridItem withLocation:(CGPoint)point moveGestureRecognizer:(UILongPressGestureRecognizer*) recognizer{
    CGPoint _point = [recognizer locationInView:self.scrollview];
    NSInteger toIndex = [self indexOfLocation:_point];
    if (toIndex == unValidIndex) {
        toIndex = gridItem.index;
    }
    CGPoint origin = [self orginPointOfIndex:toIndex];
    [UIView animateWithDuration:0.2 animations:^{
        gridItem.frame = CGRectMake(origin.x, origin.y, gridItem.frame.size.width, gridItem.frame.size.height);
    }];
    NSLog(@"gridItem index:%d",gridItem.index);
}

- (void) handleSingleTap:(UITapGestureRecognizer *) gestureRecognizer{
    if (isEditing) {
        for (BJGridItem *item in gridItems) {
            [item disableEditing];
        }
        //[addbutton disableEditing];
    }
    isEditing = NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if(touch.view != scrollview){
        return NO;
    }else
        return YES;
}

#pragma mark-- private
- (NSInteger)indexOfLocation:(CGPoint)location{
    NSInteger index;
    NSInteger _page = location.x / 320;
    NSInteger row =  location.y / (gridHight + 20);
    NSInteger col = (location.x - _page * 320) / (gridWith + 20);
    if (row >= rows || col >= columns) {
        return  unValidIndex;
    }
    index = itemsPerPage * _page + row * 2 + col;
    if (index >= [gridItems count]) {
        return  unValidIndex;
    }
    
    return index;
}

- (CGPoint)orginPointOfIndex:(NSInteger)index{
    CGPoint point = CGPointZero;
    if (index > [gridItems count] || index < 0) {
        return point;
    }else{
        NSInteger _page = index / itemsPerPage;
        NSInteger row = (index - _page * itemsPerPage) / columns;
        NSInteger col = (index - _page * itemsPerPage) % columns;
        
        point.x = _page * 320 + col * gridWith + (col +1) * space;
        point.y = row * gridHight + (row + 1) * space;
        return  point;
    }
}

- (void)exchangeItem:(NSInteger)oldIndex withposition:(NSInteger)newIndex{
    ((BJGridItem *)[gridItems objectAtIndex:oldIndex]).index = newIndex;
    ((BJGridItem *)[gridItems objectAtIndex:newIndex]).index = oldIndex;
    [gridItems exchangeObjectAtIndex:oldIndex withObjectAtIndex:newIndex];
}
@end


