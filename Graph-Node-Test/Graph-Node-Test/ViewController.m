#import "ViewController.h"

#import "CustomNode.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CustomNode *firstNode  = [[CustomNode alloc] initWithPoint:(vector_float2){0, 1}];
    CustomNode *secondNode = [[CustomNode alloc] initWithPoint:(vector_float2){0, 0}];
    [firstNode addConnectionsToNodes:@[ secondNode ] bidirectional:YES];
    
    GKGraph *graph = [GKGraph graphWithNodes:@[ firstNode, secondNode ]];
    NSArray *nodes = [graph findPathFromNode:firstNode toNode:secondNode];
    NSLog(@"%@", nodes);
}

@end
