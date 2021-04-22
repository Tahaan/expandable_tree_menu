import 'package:expandable_tree_menu/expandable_tree_menu.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Getting Started',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final nodes = <TreeNode>[];

  void _addData(data) {
    setState(() {
      nodes.addAll(data);
    });
  }

  Future<List<TreeNode>> fetchData() async {
    // Load the data from somewhere;
    return await _dataLoad();
  }

  @override
  void initState() {
    super.initState();
    fetchData().then(_addData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu demo'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Flexible(
            child: SingleChildScrollView(
              child: ExpandableTree(
                nodes: nodes,
                nodeBuilder: _nodeBuilder,
                onSelect: (node) => _nodeSelected(context, node),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Handle the onTap event on a Node Widget
  void _nodeSelected(context, nodeValue) {
    final route =
        MaterialPageRoute(builder: (context) => DetailPage(value: nodeValue));
    Navigator.of(context).push(route);
  }

  /// Build the Node widget at a specific node in the tree
  Widget _nodeBuilder(context, nodeValue) {
    return Card(
        margin: EdgeInsets.symmetric(vertical: 1),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(nodeValue.toString()),
        ));
  }
}



// A less contrived example would use a DataModel as type for the value
class DetailPage extends StatelessWidget {
  final value;

  const DetailPage({Key? key, this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(value.toString()),
      ),
      body: Center(
        child: Text(value.toString()),
      ),
    );
  }
}

Future<List<TreeNode>> _dataLoad() async {
  // Fetch the data here

  // Then generate the TreeNode tree structure
  return [
    TreeNode<String>('Some String'),
    TreeNode<String>('Node with sub-items', subNodes: [
      TreeNode<String>('First sub node'),
      TreeNode<String>('Second sub node'),
    ])
  ];
}


