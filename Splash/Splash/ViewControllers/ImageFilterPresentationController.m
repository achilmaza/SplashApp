//
//  ImageFilterPresentationController.h
//  Splash
//
//  Created by Angie Chilmaza on 12/2/19.
//  Copyright © 2019 Angie Chilmaza. All rights reserved.
//


#import "ImageFilterPresentationController.h"

@interface ImageFilterPresentationController ()

@property (nonatomic, strong) UIView * dimmingView;

@end

@implementation ImageFilterPresentationController



-(void)presentationTransitionWillBegin {
    
    UIView * dimView = self.dimmingView;
    
    self.dimmingView.backgroundColor = [UIColor darkGrayColor];
    [self.containerView addSubview:dimView];
    [dimView addSubview:[self.presentedViewController view]];
    [dimView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissController)]];
    
    //Transition coordinator for animations
    id <UIViewControllerTransitionCoordinator> transitionCoordinator =
    [self.presentingViewController transitionCoordinator];
    
    [dimView setAlpha:0.0];
    
    [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
        [dimView setAlpha:0.5];
        
    } completion:nil];
    
}

-(void)dismissController{
    
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)presentationTransitionDidEnd:(BOOL)completed{
    
    //remove dimming view if presentation didn't complete
    if(!completed){
        [self.dimmingView removeFromSuperview];
    }
    
    
}

-(void)dismissalTransitionWillBegin{
    
    //configure any animations
    //animate the alpha value back to 0
    
    id<UIViewControllerTransitionCoordinator> transitionCoordinator =
    [self.presentingViewController transitionCoordinator];
    
    [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [self.dimmingView setAlpha:0.0];
    } completion:nil];
    
}

-(void)dismissalTransitionDidEnd:(BOOL)completed{
    
    //remove any custom views from view hierarchy
    
    if(completed){
        [self.dimmingView removeFromSuperview];
    }
    
}

-(CGRect) frameOfPresentedViewInContainerView{
    
    CGRect frame =  CGRectMake(self.containerView.bounds.origin.x+7,
                               CGRectGetMaxY(self.containerView.bounds)/3,
                               CGRectGetWidth(self.containerView.bounds)-14,
                               (CGRectGetHeight(self.containerView.bounds) - CGRectGetMaxY(self.containerView.bounds)/3) - 10) ;
    
    return frame;
}


//lazy loading
-(UIView*)dimmingView{
    
    
    if(_dimmingView == nil){
        
        _dimmingView = [[UIView alloc] initWithFrame: CGRectMake(self.containerView.bounds.origin.x,
                                                                 self.containerView.bounds.origin.y,
                                                                 CGRectGetWidth(self.containerView.bounds),
                                                                 CGRectGetHeight(self.containerView.bounds))];
        _dimmingView.backgroundColor = [UIColor grayColor];
    }
    
    return _dimmingView;
    
}

@end
