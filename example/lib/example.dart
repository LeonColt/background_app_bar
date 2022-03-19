import 'dart:ui';

import 'package:background_app_bar/background_app_bar.dart';
import 'package:flutter/material.dart';

const _kAppBarSize = 250.0;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      );
}

class MyHomePageSliver extends StatefulWidget {
  const MyHomePageSliver({Key? key, this.title, this.counter})
      : super(key: key);
  final String? title;
  final int? counter;
  @override
  State<StatefulWidget> createState() => _MyHomePageSliverState();
}

class _MyHomePageSliverState extends State<MyHomePageSliver> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (_, __) => <Widget>[
            SliverAppBar(
              expandedHeight: _kAppBarSize,
              floating: false,
              pinned: true,
              snap: false,
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              flexibleSpace: BackgroundFlexibleSpaceBar(
                title: widget.title != null ? Text(widget.title!) : null,
                centerTitle: false,
                titlePadding: const EdgeInsets.only(left: 20.0, bottom: 20.0),
                background: ClipRect(
                  child: Container(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ),
                    ),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/bg.jpg"),
                        fit: BoxFit.fill,
                      ),
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
                const Text(
                  "Photo by Matt Artz on Unsplash",
                ),
                const Text(
                  "You have pushed the button this many times:",
                ),
                Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
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
    if (_counter % 7 == 0) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => MyHomePage(
          title: widget.title,
          counter: _counter,
        ),
      ));
    }
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.title, this.counter}) : super(key: key);
  final String? title;
  final int? counter;
  @override
  _MyHomePageState createState() => _MyHomePageState();
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
    if (_counter % 5 == 0) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => MyHomePageSliver(
          title: widget.title,
          counter: _counter,
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.title != null ? Text(widget.title!) : null,
        flexibleSpace: ClipRect(
          child: Container(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            ),
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      "images/bg.jpg",
                    ),
                    fit: BoxFit.fitWidth)),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "Photo by Matt Artz on Unsplash",
            ),
            const Text(
              "You have pushed the button this many times:",
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
