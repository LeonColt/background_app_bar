import 'dart:ui';

import 'package:background_app_bar/background_app_bar.dart';
import 'package:flutter/material.dart';

const _APP_BAR_SIZE = 250.0;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp();
  @override Widget build(BuildContext context) => new MaterialApp(
    title: 'Flutter Demo',
    theme: new ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: new MyHomePage(title: 'Flutter Demo Home Page'),
  );
}

class MyHomePageSliver extends StatefulWidget {
  MyHomePageSliver({Key? key, this.title, this.counter}) : super(key: key);
  final String? title;
  final int? counter;
  @override State<StatefulWidget> createState() => new _MyHomePageSliverState();
}

class _MyHomePageSliverState extends State<MyHomePageSliver> {

  int _counter = 0;

  @override Widget build(BuildContext context) => new Scaffold(
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
            title: widget.title != null ? new Text( widget.title! ) : null,
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
                    image: new DecorationImage(
                        image: new AssetImage(
                          "images/bg.jpg",
                        ),
                        fit: BoxFit.fill,
                    )
                ),
              ),
            ),
          ),
        ),
      ],
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              "Photo by Matt Artz on Unsplash",
            ),
            new Text(
              "You have pushed the button this many times:",
            ),
            new Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
    ),
    floatingActionButton: new FloatingActionButton(
      onPressed: _incrementCounter,
      tooltip: 'Increment',
      child: new Icon(Icons.add),
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
  MyHomePage({Key? key, this.title, this.counter}) : super(key: key);
  final String? title;
  final int? counter;
  @override _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
    return new Scaffold(
      appBar: new AppBar(
        title: widget.title != null ? new Text(widget.title!) : null,
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
                image: new DecorationImage(
                    image: new AssetImage(
                      "images/bg.jpg",
                    ),
                    fit: BoxFit.fitWidth
                )
            ),
          ),
        ),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              "Photo by Matt Artz on Unsplash",
            ),
            new Text(
              "You have pushed the button this many times:",
            ),
            new Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),
    );
  }
}
