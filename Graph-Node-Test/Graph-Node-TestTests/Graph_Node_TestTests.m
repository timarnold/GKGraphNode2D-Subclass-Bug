@import XCTest;

#import "GeometricNode.h"

@interface Graph_Node_TestTests : XCTestCase

@property (nonatomic, strong) GKGraph *graph;
@property (nonatomic, strong) NSArray <GeometricNode *>* nodes;

@end


@implementation Graph_Node_TestTests

- (void)setUp {
    /*
     This is the graph we are creating:
     
     A---B---C
     | X | X |
     F---E---D
     
     where all of the nodes are `GeometricNode` objects.
     
     The nodes' cost to each other is determined by simple geometry, assuming
     the nodes are spaced in a grid all one unit away from their top-left-bottom-right
     neighbors. Diagonal nodes are spaced sqrt(2) ~ 1.414 away from one another.
     */
    
    GeometricNode *nodeA = [[GeometricNode alloc]  initWithPoint:(vector_float2){0, 0}];
    GeometricNode *nodeB = [[GeometricNode alloc]  initWithPoint:(vector_float2){1, 0}];
    GeometricNode *nodeC = [[GeometricNode alloc]  initWithPoint:(vector_float2){2, 0}];
    GeometricNode *nodeD = [[GeometricNode alloc]  initWithPoint:(vector_float2){2, 1}];
    GeometricNode *nodeE = [[GeometricNode alloc]  initWithPoint:(vector_float2){1, 1}];
    GeometricNode *nodeF = [[GeometricNode alloc]  initWithPoint:(vector_float2){0, 1}];
    
    [nodeA addConnectionsToNodes:@[ nodeB, nodeF, nodeE ] bidirectional:YES];
    [nodeC addConnectionsToNodes:@[ nodeB, nodeD, nodeE ] bidirectional:YES];
    [nodeE addConnectionsToNodes:@[ nodeF, nodeD, nodeB ] bidirectional:YES];
    [nodeB addConnectionsToNodes:@[ nodeF, nodeD ] bidirectional:YES];
    
    self.nodes = @[ nodeA, nodeB, nodeC, nodeD, nodeE, nodeF ];
    self.graph = [GKGraph graphWithNodes:self.nodes];
}

- (void)testNodeCosts {
    /*
     A---B---C
     | X | X |
     F---E---D
     
     We would expect, for example, the path from A to C to be A-B-C, at a cost of
     2, to be chosen over a path of A-E-C, at a cost of 2.828.
     
     Instead, GKGraph chooses this latter incorrect path.
     */
    GeometricNode *nodeA = self.nodes[0];
    GeometricNode *nodeB = self.nodes[1];
    GeometricNode *nodeC = self.nodes[2];
    GeometricNode *nodeE = self.nodes[4];
    
    XCTAssert([nodeA.connectedNodes containsObject:nodeB], @"Node A is connected to Node B");
    XCTAssert([nodeB.connectedNodes containsObject:nodeC], @"Node B is connected to Node C");
    XCTAssert([nodeA.connectedNodes containsObject:nodeE], @"Node A is connected to Node E");
    XCTAssert([nodeE.connectedNodes containsObject:nodeC], @"Node E is connected to Node C");
    
    XCTAssertEqualWithAccuracy([nodeA costToNode:nodeB], 1, 0.001, @"Cost from A-B should be 1");
    XCTAssertEqualWithAccuracy([nodeB costToNode:nodeC], 1, 0.001, @"Cost from B-C should be 1");
    
    XCTAssertEqualWithAccuracy([nodeA costToNode:nodeE], sqrt(2), 0.001, @"Cost from A-E should be sqrt(2) ~ 1.414");
    XCTAssertEqualWithAccuracy([nodeE costToNode:nodeC], sqrt(2), 0.001, @"Cost from E-C should be sqrt(2) ~ 1.414");
    
    // The actual path calculated by GKGraph, and the expected and actual (incorrect) paths
    NSArray <GeometricNode *>* actualPath    = [self.graph findPathFromNode:nodeA toNode:nodeC];
    NSArray <GeometricNode *>* expectedPath  = @[ nodeA, nodeB, nodeC ];
    NSArray <GeometricNode *>* incorrectPath = @[ nodeA, nodeE, nodeC ];

    // We would expect GKGraph to choose this lowest-cost path: A-B-C
    CGFloat totalExpectedCost = [nodeA costToNode:nodeB] + [nodeB costToNode:nodeC];
    XCTAssertEqualWithAccuracy(totalExpectedCost, 2, 0.001, @"Lowest cost path cost should be 2");

    // GKGraph is actually choosing this more costly path: A-E-C
    CGFloat totalIncorrectCost = [nodeA costToNode:nodeE] + [nodeE costToNode:nodeC];
    CGFloat totalActualCost = 0;
    for (NSInteger i = 0; i < actualPath.count - 1; i++) {
        totalActualCost += [((GeometricNode *)actualPath[i]) costToNode:actualPath[i + 1]];
    }

    XCTAssert([actualPath isEqualToArray:expectedPath], @"Actual found path should be equal to A-B-C");
    XCTAssert(![actualPath isEqualToArray:incorrectPath], @"Actual found path should not be equal to A-E-C");
    XCTAssertGreaterThan(totalIncorrectCost, totalActualCost);
    XCTAssertLessThanOrEqual(totalActualCost, totalExpectedCost);
}

@end
