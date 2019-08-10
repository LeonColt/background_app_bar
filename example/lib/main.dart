import 'dart:ui';

import 'package:background_app_bar/background_app_bar.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			title: 'Flutter Demo',
			theme: ThemeData(
				primarySwatch: Colors.blue,
			),
			home: MyHomePage(title: 'Flutter Demo Home Page'),
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
	int _counter = 0;
	
	void _incrementCounter() {
		setState(() {
			_counter++;
		});
	}
	
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: BackgroundAppBar(
				title: Text(widget.title),
				background: new ClipRect(
					child: new Container(
						child: new BackdropFilter(
							filter: new ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
							child: new Container(
								decoration: new BoxDecoration(
									color: Colors.black.withOpacity(0.5),
								),
							),
						),
						decoration: new BoxDecoration(
							image: DecorationImage(
								image: AssetImage(
									"images/bg.jpg",
								),
								fit: BoxFit.fitWidth
							)
						),
					),
				),
			),
			body: Center(
				child: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					children: <Widget>[
						Text(
							"Photo by Matt Artz on Unsplash",
						),
						Text(
							"You have pushed the button this many times:",
						),
						Text(
							'$_counter',
							style: Theme.of(context).textTheme.display1,
						),
					],
				),
			),
			floatingActionButton: FloatingActionButton(
				onPressed: _incrementCounter,
				tooltip: 'Increment',
				child: Icon(Icons.add),
			),
		);
	}
}
