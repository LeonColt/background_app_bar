# Widget Background App Bar

Love the material AppBar? Do you want to add more color to the appbar? Here's a BackgroundAppBar.

It works just like the normal AppBar. Also with actions, back buttons, titles. So it's just your normal AppBar, but with a Background!

inspired by GradientAppBar [GitHub](https://github.com/joostlek/GradientAppBar)

## Screenshots

[![Screenshot-1565398534.png](https://i.postimg.cc/WpF6z39h/Screenshot-1565398534.png)](https://postimg.cc/grp6BYbW)


## Getting Started

1. Depend on it by adding this to your pubspec.yaml file: ```background_app_bar: ^0.0.1```

2. Import it: ```import 'package:background_app_bar/background_app_bar.dart'```

3. Replace your current AppBar (In the scaffold) to BackgroundAppBar.


```
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
```