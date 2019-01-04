import 'package:flutter/material.dart';
import 'dart:async';

final controller = new StreamController<DateTime>();
final timeStream = controller.stream;

void main() {
  updateStream(controller);
  runApp(MyApp());
  
}

void updateStream(controller) async {
  for (int i = 0; i < 10000; i++) {
  	await Future.delayed(
  	  const Duration(milliseconds: 1),
  	  () => controller.add(DateTime.now())
  	);
  }
}

Stream<String> streamToRadix2(Stream<DateTime> stream) {
  return stream.map(
    (time) => time.millisecondsSinceEpoch.toRadixString(2)
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: MyHomePage(title: 'Time Stream in Flutter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Current time in binary:',
            ),
            StreamBuilder<String>(
              stream: streamToRadix2(timeStream),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none: return Text('None: ${snapshot.data}');
                    case ConnectionState.waiting: return Text('Awaiting data...');
                    case ConnectionState.active: return Text('Data: ${snapshot.data}');
                    case ConnectionState.done: return Text('${snapshot.data} (closed)');
                  }
                  return Text('null');
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        child: Icon(Icons.timer),
      ),
    );
  }
}
