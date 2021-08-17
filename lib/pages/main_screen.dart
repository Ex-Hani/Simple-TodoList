import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          title: Text('Main Screen'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Text('Main Screen',style: TextStyle(fontSize: 20, color: Colors.white)),
            ElevatedButton(onPressed: () {
              Navigator.pushNamed(context, '/todo');
            }, child: Text('Next page'))
          ],
        ));
  }
}
