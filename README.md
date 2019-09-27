# Widget Background App Bar

A background app bar plugin, use this plugin if you want to preserve background of sliver app bar when scrolling,

inspired by GradientAppBar [GitHub](https://github.com/joostlek/GradientAppBar)

## Screenshots
Don't forget to tap + button 5 times

[![Screenshot-1565398534.png](https://i.postimg.cc/WpF6z39h/Screenshot-1565398534.png)](https://postimg.cc/grp6BYbW)
[![Screenshot-1569417041.png](https://i.postimg.cc/28fWXhr0/Screenshot-1569417041.png)](https://postimg.cc/hhphXJJm)
[![Screenshot-1569417048.png](https://i.postimg.cc/bNzJtTzf/Screenshot-1569417048.png)](https://postimg.cc/yWbsq0gL)
[![Screenshot-1569417051.png](https://i.postimg.cc/s2Sy8QVJ/Screenshot-1569417051.png)](https://postimg.cc/yJVw3N3J)


## Getting Started

1. Depend on it by adding this to your pubspec.yaml file: ```background_app_bar: ^1.0.0```

2. Import it: ```import 'package:background_app_bar/background_app_bar.dart'```

3. Replace your current FlexibleSpaceBar (In the AppBar or SliverAppBar) to BackgroundFlexibleSpaceBar.


```
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
)
```