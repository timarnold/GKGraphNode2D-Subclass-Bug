#import "CheapNode.h"

@implementation CheapNode

- (float)estimatedCostToNode:(GKGraphNode *)node {
    return 1;
}

- (float)costToNode:(GKGraphNode *)node {
    return 1;
}

@end
