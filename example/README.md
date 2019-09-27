```
import 'dart:ui';

import 'package:background_app_bar/background_app_bar.dart';
import 'package:flutter/material.dart';

const _APP_BAR_SIZE = 250.0;

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

class MyHomePageSliver extends StatefulWidget {
	MyHomePageSliver({Key key, this.title, this.counter}) : super(key: key);
	final String title;
	final int counter;
	@override State<StatefulWidget> createState() => _MyHomePageSliverState();
}

class _MyHomePageSliverState extends State\<MyHomePageSliver\> {

	int _counter = 0;

	@override Widget build(BuildContext context) => Scaffold(
		body: new NestedScrollView(
			headerSliverBuilder: ( _, __ ) => <Widget>[
				new SliverAppBar(
					expandedHeight: _APP_BAR_SIZE,
					floating: false,
					pinned: true,
					snap: false,
					elevation: 0.0,
					backgroundColor: Colors.transparent,
					flexibleSpace: new BackgroundFlexibleSpaceBar(
						title: new Text( widget.title ),
						centerTitle: false,
						titlePadding: const EdgeInsets.only(left: 20.0, bottom: 20.0),
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
				),
			],
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
		),
		floatingActionButton: FloatingActionButton(
			onPressed: _incrementCounter,
			tooltip: 'Increment',
			child: Icon(Icons.add),
		),
	);

	@override
	void initState() {
		_counter = widget.counter ?? 0;
		super.initState();
	}

	void _incrementCounter() {
		setState(() {
			_counter++;
		});
		if ( _counter % 7 == 0 ) {
			Navigator.of(context).pushReplacement(
				new MaterialPageRoute(
					builder: ( _ ) => new MyHomePage(
						title: widget.title,
						counter: _counter,
					),
				)
			);
		}
	}
}

class MyHomePage extends StatefulWidget {
	MyHomePage({Key key, this.title, this.counter}) : super(key: key);
	final String title;
	final int counter;
	@override
	_MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State\<MyHomePage\> {
	int _counter = 0;

	@override
	void initState() {
		_counter = widget.counter ?? 0;
		super.initState();
	}

	void _incrementCounter() {
		setState(() {
			_counter++;
		});
		if ( _counter % 5 == 0 ) {
			Navigator.of(context).pushReplacement(
				new MaterialPageRoute(
					builder: ( _ ) => new MyHomePageSliver(
						title: widget.title,
						counter: _counter,
					),
				)
			);
		}
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Text(widget.title),
				flexibleSpace: new ClipRect(
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
```