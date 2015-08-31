#import "CustomNode.h"

@implementation CustomNode

- (float)estimatedCostToNode:(GKGraphNode *)node {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    return 1;
}

- (float)costToNode:(GKGraphNode *)node {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    return 1;
}

@end
