#import "ExpensiveNode.h"

@implementation ExpensiveNode

- (float)estimatedCostToNode:(GKGraphNode *)node {
    return 100;
}

- (float)costToNode:(GKGraphNode *)node {
    return 100;
}

@end
