#import "GeometricNode.h"

@implementation GeometricNode

- (float)estimatedCostToNode:(GKGraphNode *)node {
    NSAssert(([node isKindOfClass:[GeometricNode class]]), @"Must Use GeometricNode");
    return [self geometricDistanceToNode:(GeometricNode *)node];
}

- (float)costToNode:(GKGraphNode *)node {
    NSAssert(([node isKindOfClass:[GeometricNode class]]), @"Must Use GeometricNode");
    return [self geometricDistanceToNode:(GeometricNode *)node];
}

- (CGFloat)geometricDistanceToNode:(GeometricNode *)node {
    return sqrtf( powf(self.position[0] - node.position[0], 2) + powf(self.position[1] - node.position[1], 2) );
}

@end
