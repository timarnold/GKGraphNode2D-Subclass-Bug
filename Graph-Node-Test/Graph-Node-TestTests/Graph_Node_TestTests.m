@import XCTest;

#import "CheapNode.h"
#import "ExpensiveNode.h"

@interface Graph_Node_TestTests : XCTestCase

@end

@implementation Graph_Node_TestTests

- (void)testNodeCostsUsed {
    /*
     This is the graph we are creating:
     
     A---B---C
     |       |
     F---E---D
     
     where all of the nodes are `CheapNode` objects, except 'B', which is an
     `ExpensiveNode` object.
     
     This test finds a path from node A to node C.
     
     If the cost methods in the `CheapNode` and `ExpensiveNode` subclasses
     are used, the route going from A to C around B (down, then right, then up)
     should be used, since the cost of going from B to C is 100, and the cost of
     going from any other node to any other node is 1 
     (see implementation of these classes).
     
     Instead, we see `GKGraph` choosing the "shortest" route in terms of number
     of nodes, from the top left immediately to the right to the top right.
     */
    
    CheapNode     *nodeA = [[CheapNode alloc]     initWithPoint:(vector_float2){0, 0}];
    ExpensiveNode *nodeB = [[ExpensiveNode alloc] initWithPoint:(vector_float2){1, 0}];
    CheapNode     *nodeC = [[CheapNode alloc]     initWithPoint:(vector_float2){2, 0}];
    CheapNode     *nodeD = [[CheapNode alloc]     initWithPoint:(vector_float2){2, 1}];
    CheapNode     *nodeE = [[CheapNode alloc]     initWithPoint:(vector_float2){1, 1}];
    CheapNode     *nodeF = [[CheapNode alloc]     initWithPoint:(vector_float2){0, 1}];
    
    [nodeA addConnectionsToNodes:@[ nodeB, nodeF ] bidirectional:YES];
    [nodeC addConnectionsToNodes:@[ nodeB, nodeD ] bidirectional:YES];
    [nodeE addConnectionsToNodes:@[ nodeF, nodeD ] bidirectional:YES];

    NSArray *allNodes = @[ nodeA, nodeB, nodeC, nodeD, nodeE, nodeF ];
    
    GKGraph *graph = [GKGraph graphWithNodes:allNodes];
    NSArray *nodes = [graph findPathFromNode:nodeA toNode:nodeC];
    
    NSArray *expectedPath   = @[ nodeA, nodeF, nodeE, nodeD, nodeC ];
    NSArray *prohibitedPath = @[ nodeA, nodeB, nodeC ];
    
    XCTAssert([nodes isEqualToArray:expectedPath], @"");
    XCTAssertFalse([nodes isEqualToArray:prohibitedPath], @"");

}

@end
