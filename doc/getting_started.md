
Step 1:
Convert the source data into a Tree structure

```dart
List<TreeNode> menuData() => [
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
    ];
```


Step 2: Create a builder to render each node

```dart
Widget _nodeBuilder(context, nodeValue) {
    return Card(
        margin: EdgeInsets.symmetric(vertical: 1),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(nodeValue.toString()),
        ));
  }
```
  
Step 3: Use the menu:

```dart
Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      Flexible(
        child: SingleChildScrollView(
          child: ExpandableTree(
            nodes: menuData(),
            nodeBuilder: _nodeBuilder,
            onSelect: (dynamic node) => _nodeSelected(context, node),
          ),
        ),
      ),
    ],
  )
```
      
