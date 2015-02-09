//
//  SandQs.m
//  MapShapes
//
//  Created by Jon Vogel on 2/3/15.
//  Copyright (c) 2015 Jon Vogel. All rights reserved.
//

#import "SandQs.h"

@interface SandQs()




@end

@implementation SandQs

//MARK: Initalizer
-(instancetype)init{
  self = [super init];
  if (self){
    self.arrayForStack = [[NSMutableArray alloc] initWithObjects:@"Ant", @"Fly", @"Beetle", @"Worm", nil];
    self.arrayForQueue = [[NSMutableArray alloc] initWithObjects:@"Silver", @"Cobalt", @"Iron", nil];
  }
  return self;
}
//MARK: Methods to deal with a Stack

-(void)push:(NSString*)newBug{
  [self.arrayForStack addObject: newBug];
}

-(NSString*)pop{
  if (self.arrayForStack.count != 0){
    NSString *poppedItem = [NSString stringWithFormat:@"%@",[self.arrayForStack lastObject]];
    [self.arrayForStack removeLastObject];
    return poppedItem;
  }else{
    return nil;
  }
}

-(NSString*)peek{
  NSString *poppedItem = [NSString stringWithFormat:@"%@",[self.arrayForStack lastObject]];
  return poppedItem;
}

//MARK: Mathods to deal with a Queue
-(void)enQueue:(NSString*)metalToEnqueue{
  [self.arrayForQueue addObject:metalToEnqueue];
}

-(NSString*)deQueue{
  if (self.arrayForQueue.count !=0){
    NSString *deQueuedItem = [NSString stringWithFormat:@"%@", [self.arrayForQueue firstObject]];
    [self.arrayForQueue removeObjectAtIndex:0];
    return deQueuedItem;
  }else{
    return nil;
  }
}




@end