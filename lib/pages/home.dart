import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _userTodo = '';
  List todoList = [];

  void initFirebase() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  }

  void _menuOpen() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Menu'),
        ),
        body: Text('Main menu'),
      );
    }));
  }

  @override
  void initState() {
    super.initState();
    initFirebase();
    todoList.addAll(['Buy Milk', 'Wash Dishes', 'Купить картошку']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text('Список дел'),
        actions: [
          IconButton(onPressed: _menuOpen, icon: Icon(Icons.menu_rounded))
        ],
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('items').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return Text('No data');
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  key: Key(snapshot.data!.docs[index].id),
                  child: Card(
                    child: ListTile(
                      title: Text(snapshot.data!.docs[index].get('item')),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        color: Colors.deepOrangeAccent,
                        onPressed: () {
                          FirebaseFirestore.instance.collection('items').doc(snapshot.data!.docs[index].id).delete();
                        },
                      ),
                    ),
                  ),
                  onDismissed: (direction) {
                    FirebaseFirestore.instance.collection('items').doc(snapshot.data!.docs[index].id).delete();
                  },
                );
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent,
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Добавить элемент'),
                  content: TextField(
                    onChanged: (String value) {
                      setState(() {
                        _userTodo = value;
                      });
                    },
                  ),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('items')
                              .add({'item': _userTodo});
                          Navigator.of(context).pop();
                        },
                        child: Text('Добавить'))
                  ],
                );
              });
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
