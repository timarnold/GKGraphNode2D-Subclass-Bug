@import XCTest;

#import "CheapNode.h"
#import "ExpensiveNode.h"

@interface Graph_Node_TestTests : XCTestCase

@end

@implementation Graph_Node_TestTests

- (void)testNodeCostsUsed {
    /*
     This is the graph we are creating:
     
     o---o---o    // `secondRowNodes`
     |       |
     o---X---o    // `firstRowNodes`
     
     where o are `CheapNode` objects, and X are `ExpensiveNode` objects.
     
     This test finds a path from the bottom left corner to the top right corner.
     
     If the cost methods in the `CheapNode` and `ExpensiveNode` subclasses
     are used, the route going around X (up, then right, then down)
     should be used, since the cost of going from X to o is 100, and the cost of
     going from o to o is 1 (see implementation of these classes).
     
     Instead, we see `GKGraph` choosing the "shortest" route in terms of number
     of nodes, from the bottom left immediately to the right to the bottom
     right.
     */
    NSArray *firstRowNodes = @[
                               [[CheapNode alloc]     initWithPoint:(vector_float2){0, 0}],
                               [[ExpensiveNode alloc] initWithPoint:(vector_float2){0, 1}],
                               [[CheapNode alloc]     initWithPoint:(vector_float2){0, 2}],
                               ];
    NSArray *secondRowNodes = @[
                                [[CheapNode alloc] initWithPoint:(vector_float2){1, 0}],
                                [[CheapNode alloc] initWithPoint:(vector_float2){1, 1}],
                                [[CheapNode alloc] initWithPoint:(vector_float2){1, 2}],
                                ];

    [firstRowNodes.firstObject addConnectionsToNodes:@[ secondRowNodes.firstObject, firstRowNodes[1] ] bidirectional:YES];
    [firstRowNodes.lastObject  addConnectionsToNodes:@[ firstRowNodes[1],  secondRowNodes.lastObject ] bidirectional:YES];

    [secondRowNodes.firstObject addConnectionsToNodes:@[ secondRowNodes[1] ] bidirectional:YES];
    [secondRowNodes.lastObject  addConnectionsToNodes:@[ secondRowNodes[1] ] bidirectional:YES];
    
    GKGraph *graph = [GKGraph graphWithNodes:[firstRowNodes arrayByAddingObjectsFromArray:secondRowNodes]];
    NSArray *nodes = [graph findPathFromNode:firstRowNodes.firstObject toNode:firstRowNodes.lastObject];
    
    XCTAssert(nodes.count == 5, "We should traverse 5 nodes in this configuration");
    XCTAssertFalse([[nodes valueForKey:@"class"] containsObject:[ExpensiveNode class]], @"Should not contain an ExpensiveNode class in our route");
}

@end
