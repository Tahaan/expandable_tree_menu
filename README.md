# expandable_tree_menu

Builds a Tree of Sub-menus that can be expanded/collapsed, where each node can recursively 
contain another tree, using a recursive list of "Nodes".

Each Node has a value payload that will be passed to the onSelect handler.  

Nodes are rendered using a nodeBuilder which will use the value of the node.


```
ExpandableTree(
    nodes: [
     TreeNode('Category A', subNodes: [
       TreeNode('CatA first item'),
       TreeNode('CatA second item'),
     ]),
     TreeNode('Category B', subNodes: [
       TreeNode('Cat B first item'),
       TreeNode('Cat B sub-category 1', subNodes: [
         TreeNode('Cat B1 first item'),
         TreeNode('Cat B1 second item'),
         TreeNode('Cat B1 third item'),
         TreeNode('Cat B1 final item'),
       ]),
     ]),
   ],
    nodeBuilder: (context, nodeValue) => Card(child: Text(nodeValue.toString()),
    onSelect: (node) => _nodeSelected(context, node),
  ), 
```
