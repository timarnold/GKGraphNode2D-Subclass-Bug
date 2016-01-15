@import UIKit;
@import Foundation;
@import GameplayKit;

@interface GeometricNode : GKGraphNode2D

- (CGFloat)geometricDistanceToNode:(GeometricNode *)node;

@end
