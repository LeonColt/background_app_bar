import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

const double _kLeadingWidth = kToolbarHeight;

class _ToolbarContainerLayout extends SingleChildLayoutDelegate {
	const _ToolbarContainerLayout();
	
	@override
	BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
		return constraints.tighten(height: kToolbarHeight);
	}
	
	@override
	Size getSize(BoxConstraints constraints) {
		return new Size(constraints.maxWidth, kToolbarHeight);
	}
	
	@override
	Offset getPositionForChild(Size size, Size childSize) {
		return new Offset(0.0, size.height - childSize.height);
	}
	
	@override
	bool shouldRelayout(_ToolbarContainerLayout oldDelegate) => false;
}


class _FloatingAppBar extends StatefulWidget {
	const _FloatingAppBar({Key key, this.child}) : super(key: key);
	final Widget child;
	@override _FloatingAppBarState createState() => new _FloatingAppBarState();
}

class _FloatingAppBarState extends State<_FloatingAppBar> {
	ScrollPosition _position;
	
	@override
	void didChangeDependencies() {
		super.didChangeDependencies();
		if (_position != null)
			_position.isScrollingNotifier.removeListener(_isScrollingListener);
		_position = Scrollable.of(context)?.position;
		if (_position != null)
			_position.isScrollingNotifier.addListener(_isScrollingListener);
	}
	
	@override
	void dispose() {
		if (_position != null)
			_position.isScrollingNotifier.removeListener(_isScrollingListener);
		super.dispose();
	}
	
	RenderSliverFloatingPersistentHeader _headerRenderer() {
		return context.ancestorRenderObjectOfType( const TypeMatcher<RenderSliverFloatingPinnedPersistentHeader>() ) as RenderSliverFloatingPersistentHeader;
	}
	
	void _isScrollingListener() {
		if (_position == null) return;
		final RenderSliverFloatingPersistentHeader header = _headerRenderer();
		if (_position.isScrollingNotifier.value)
			header?.maybeStopSnapAnimation(_position.userScrollDirection);
		else
			header?.maybeStartSnapAnimation(_position.userScrollDirection);
	}
	
	@override
	Widget build(BuildContext context) => widget.child;
}

class BackgroundAppBar extends StatefulWidget implements PreferredSizeWidget {
	BackgroundAppBar({
		Key key,
		this.leading,
		this.automaticallyImplyLeading = true,
		this.title,
		this.actions,
		this.flexibleSpace,
		this.bottom,
		this.elevation = 4.0,
		this.background,
		this.backgroundColor,
		this.backgroundHeight,
		this.brightness,
		this.iconTheme,
		this.textTheme,
		this.primary = true,
		this.centerTitle,
		this.titleSpacing = NavigationToolbar.kMiddleSpacing,
		this.toolbarOpacity = 1.0,
		this.bottomOpacity = 1.0,
	})  : assert(automaticallyImplyLeading != null),
			assert(elevation != null),
			assert(primary != null),
			assert(titleSpacing != null),
			assert(toolbarOpacity != null),
			assert(bottomOpacity != null),
			preferredSize = new Size.fromHeight(
				kToolbarHeight + (bottom?.preferredSize?.height ?? 0.0)),
			super(key: key);
	final Widget leading;
	final bool automaticallyImplyLeading;
	final Widget title;
	final List<Widget> actions;
	final Widget flexibleSpace;
	final PreferredSizeWidget bottom;
	final double elevation;
	final Widget background;
	final Color backgroundColor;
	final double backgroundHeight;
	final Brightness brightness;
	final IconThemeData iconTheme;
	final TextTheme textTheme;
	final bool primary;
	final bool centerTitle;
	final double titleSpacing;
	final double toolbarOpacity;
	final double bottomOpacity;
	@override final Size preferredSize;
	bool _getEffectiveCenterTitle(ThemeData themeData) {
		if (centerTitle != null) return centerTitle;
		assert(themeData.platform != null);
		switch (themeData.platform) {
			case TargetPlatform.android:
			case TargetPlatform.fuchsia:
				return false;
			case TargetPlatform.iOS:
				return actions == null || actions.length < 2;
		}
		return null;
	}
	@override _BackgroundAppBarState createState() => new _BackgroundAppBarState();
}

class _BackgroundAppBarState extends State<BackgroundAppBar> {
	void _handleDrawerButton() => Scaffold.of(context).openDrawer();
	void _handleDrawerButtonEnd() => Scaffold.of(context).openEndDrawer();
	
	@override
	Widget build(BuildContext context) {
		assert(!widget.primary || debugCheckHasMediaQuery(context));
		final ThemeData themeData = Theme.of(context);
		final ScaffoldState scaffold = Scaffold.of(context, nullOk: true);
		final ModalRoute<dynamic> parentRoute = ModalRoute.of(context);
		
		final bool hasDrawer = scaffold?.hasDrawer ?? false;
		final bool hasEndDrawer = scaffold?.hasEndDrawer ?? false;
		final bool canPop = parentRoute?.canPop ?? false;
		final bool useCloseButton =
			parentRoute is PageRoute<dynamic> && parentRoute.fullscreenDialog;
		
		IconThemeData appBarIconTheme =
			widget.iconTheme ?? themeData.primaryIconTheme;
		TextStyle centerStyle =
			widget.textTheme?.title ?? themeData.primaryTextTheme.title;
		TextStyle sideStyle =
			widget.textTheme?.body1 ?? themeData.primaryTextTheme.body1;
		
		if (widget.toolbarOpacity != 1.0) {
			final double opacity =
			const Interval(0.25, 1.0, curve: Curves.fastOutSlowIn)
				.transform(widget.toolbarOpacity);
			if (centerStyle?.color != null)
				centerStyle =
					centerStyle.copyWith(color: centerStyle.color.withOpacity(opacity));
			if (sideStyle?.color != null)
				sideStyle =
					sideStyle.copyWith(color: sideStyle.color.withOpacity(opacity));
			appBarIconTheme = appBarIconTheme.copyWith(
				opacity: opacity * (appBarIconTheme.opacity ?? 1.0));
		}
		
		Widget leading = widget.leading;
		if (leading == null && widget.automaticallyImplyLeading) {
			if (hasDrawer) {
				leading = new IconButton(
					icon: const Icon(Icons.menu),
					onPressed: _handleDrawerButton,
					tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
				);
			} else {
				if (canPop)
					leading = useCloseButton ? const CloseButton() : const BackButton();
			}
		}
		if (leading != null) {
			leading = new ConstrainedBox(
				constraints: const BoxConstraints.tightFor(width: _kLeadingWidth),
				child: leading,
			);
		}
		
		Widget title = widget.title;
		if (title != null) {
			bool namesRoute;
			switch (defaultTargetPlatform) {
				case TargetPlatform.android:
				case TargetPlatform.fuchsia:
					namesRoute = true;
					break;
				case TargetPlatform.iOS:
					break;
			}
			title = new DefaultTextStyle(
				style: centerStyle,
				softWrap: false,
				overflow: TextOverflow.ellipsis,
				child: new Semantics(
					namesRoute: namesRoute,
					child: title,
					header: true,
				),
			);
		}
		
		Widget actions;
		if (widget.actions != null && widget.actions.isNotEmpty) {
			actions = new Row(
				mainAxisSize: MainAxisSize.min,
				crossAxisAlignment: CrossAxisAlignment.stretch,
				children: widget.actions,
			);
		} else if (hasEndDrawer) {
			actions = new IconButton(
				icon: const Icon(Icons.menu),
				onPressed: _handleDrawerButtonEnd,
				tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
			);
		}
		
		final Widget toolbar = new NavigationToolbar(
			leading: leading,
			middle: title,
			trailing: actions,
			centerMiddle: widget._getEffectiveCenterTitle(themeData),
			middleSpacing: widget.titleSpacing,
		);
		
		Widget appBar = new ClipRect(
			child: new CustomSingleChildLayout(
				delegate: const _ToolbarContainerLayout(),
				child: IconTheme.merge(
					data: appBarIconTheme,
					child: new DefaultTextStyle(
						style: sideStyle,
						child: toolbar,
					),
				),
			),
		);
		if (widget.bottom != null) {
			appBar = new Column(
				mainAxisAlignment: MainAxisAlignment.spaceBetween,
				children: <Widget>[
					new Flexible(
						child: new ConstrainedBox(
							constraints: const BoxConstraints(maxHeight: kToolbarHeight),
							child: appBar,
						),
					),
					widget.bottomOpacity == 1.0
						? widget.bottom
						: new Opacity(
						opacity:
						const Interval(0.25, 1.0, curve: Curves.fastOutSlowIn)
							.transform(widget.bottomOpacity),
						child: widget.bottom,
					),
				],
			);
		}
		
		// The padding applies to the toolbar and tabbar, not the flexible space.
		if (widget.primary) {
			appBar = new SafeArea(
				top: true,
				child: appBar,
			);
		}
		
		appBar = new Align(
			alignment: Alignment.topCenter,
			child: appBar,
		);
		
		if (widget.flexibleSpace != null) {
			appBar = new Stack(
				fit: StackFit.passthrough,
				children: <Widget>[
					widget.flexibleSpace,
					appBar,
				],
			);
		}
		final Brightness brightness =
			widget.brightness ?? themeData.primaryColorBrightness;
		final SystemUiOverlayStyle overlayStyle = brightness == Brightness.dark
			? SystemUiOverlayStyle.light
			: SystemUiOverlayStyle.dark;
		
		return new Semantics(
			container: true,
			explicitChildNodes: true,
			child: new AnnotatedRegion<SystemUiOverlayStyle>(
				value: overlayStyle,
				child: new Material(
					color: Color(0x00000000),
					elevation: widget.elevation,
					child: Container(
						decoration: BoxDecoration(
							color: widget.background != null ? null : widget.backgroundColor,
						),
						child: new Stack(
							children: <Widget>[
								new Container(
									height: widget.backgroundHeight,
									child: _getBackground(),
								),
								appBar,
							].where( ( widget ) => widget != null ).toList(growable: false),
						),
						//child: appBar,
					),
				),
			),
		);
	}
	
	Widget _getBackground() => new Container(
		height: widget.backgroundHeight,
		child: widget.background,
	);
}

class _SliverBackgroundAppBarDelegate extends SliverPersistentHeaderDelegate {
	_SliverBackgroundAppBarDelegate({
		@required this.leading,
		@required this.automaticallyImplyLeading,
		@required this.title,
		@required this.actions,
		@required this.flexibleSpace,
		@required this.bottom,
		@required this.elevation,
		@required this.forceElevated,
		@required this.background,
		@required this.backgroundColor,
		@required this.backgroundHeight,
		@required this.brightness,
		@required this.iconTheme,
		@required this.textTheme,
		@required this.primary,
		@required this.centerTitle,
		@required this.titleSpacing,
		@required this.expandedHeight,
		@required this.collapsedHeight,
		@required this.topPadding,
		@required this.floating,
		@required this.pinned,
		@required this.snapConfiguration,
	})  : assert(primary || topPadding == 0.0),
			_bottomHeight = bottom?.preferredSize?.height ?? 0.0;
	
	final Widget leading;
	final bool automaticallyImplyLeading;
	final Widget title;
	final List<Widget> actions;
	final Widget flexibleSpace;
	final PreferredSizeWidget bottom;
	final double elevation;
	final bool forceElevated;
	final Widget background;
	final Color backgroundColor;
	final double backgroundHeight;
	final Brightness brightness;
	final IconThemeData iconTheme;
	final TextTheme textTheme;
	final bool primary;
	final bool centerTitle;
	final double titleSpacing;
	final double expandedHeight;
	final double collapsedHeight;
	final double topPadding;
	final bool floating;
	final bool pinned;
	
	final double _bottomHeight;
	
	@override
	double get minExtent =>
		collapsedHeight ?? (topPadding + kToolbarHeight + _bottomHeight);
	
	@override
	double get maxExtent => math.max(
		topPadding + (expandedHeight ?? kToolbarHeight + _bottomHeight),
		minExtent);
	
	@override
	final FloatingHeaderSnapConfiguration snapConfiguration;
	
	@override
	Widget build(
		BuildContext context, double shrinkOffset, bool overlapsContent) {
		final double visibleMainHeight = maxExtent - shrinkOffset - topPadding;
		final double toolbarOpacity = (pinned && !floating
			? 1.0
			: ((visibleMainHeight - _bottomHeight) / kToolbarHeight)
			.clamp(0.0, 1.0)) as double;
		final Widget appBar = FlexibleSpaceBar.createSettings(
			minExtent: minExtent,
			maxExtent: maxExtent,
			currentExtent: math.max(minExtent, maxExtent - shrinkOffset),
			toolbarOpacity: toolbarOpacity,
			child: new BackgroundAppBar(
				leading: leading,
				automaticallyImplyLeading: automaticallyImplyLeading,
				title: title,
				actions: actions,
				flexibleSpace: (title == null && flexibleSpace != null)
					? new Semantics(child: flexibleSpace, header: true)
					: flexibleSpace,
				bottom: bottom,
				elevation: forceElevated ||
					overlapsContent ||
					(pinned && shrinkOffset > maxExtent - minExtent)
					? elevation ?? 4.0
					: 0.0,
				background: background,
				backgroundColor: backgroundColor,
				backgroundHeight: backgroundHeight,
				brightness: brightness,
				iconTheme: iconTheme,
				textTheme: textTheme,
				primary: primary,
				centerTitle: centerTitle,
				titleSpacing: titleSpacing,
				toolbarOpacity: toolbarOpacity,
				bottomOpacity: pinned ? 1.0 : ( visibleMainHeight / _bottomHeight ).clamp( 0.0, 1.0) as double,
			),
		);
		return floating ? new _FloatingAppBar(child: appBar) : appBar;
	}
	
	@override
	bool shouldRebuild(covariant _SliverBackgroundAppBarDelegate oldDelegate) {
		return leading != oldDelegate.leading ||
			automaticallyImplyLeading != oldDelegate.automaticallyImplyLeading ||
			title != oldDelegate.title ||
			actions != oldDelegate.actions ||
			flexibleSpace != oldDelegate.flexibleSpace ||
			bottom != oldDelegate.bottom ||
			_bottomHeight != oldDelegate._bottomHeight ||
			elevation != oldDelegate.elevation ||
			background != oldDelegate.background ||
			backgroundColor != oldDelegate.backgroundColor ||
			backgroundHeight != oldDelegate.backgroundHeight ||
			brightness != oldDelegate.brightness ||
			iconTheme != oldDelegate.iconTheme ||
			textTheme != oldDelegate.textTheme ||
			primary != oldDelegate.primary ||
			centerTitle != oldDelegate.centerTitle ||
			titleSpacing != oldDelegate.titleSpacing ||
			expandedHeight != oldDelegate.expandedHeight ||
			topPadding != oldDelegate.topPadding ||
			pinned != oldDelegate.pinned ||
			floating != oldDelegate.floating ||
			snapConfiguration != oldDelegate.snapConfiguration;
	}
}

class SliverBackgroundAppBar extends StatefulWidget {
	const SliverBackgroundAppBar({
		Key key,
		this.leading,
		this.automaticallyImplyLeading = true,
		this.title,
		this.actions,
		this.flexibleSpace,
		this.bottom,
		this.elevation,
		this.forceElevated = false,
		this.backgroundColor,
		this.background,
		this.backgroundHeight,
		this.brightness,
		this.iconTheme,
		this.textTheme,
		this.primary = true,
		this.centerTitle,
		this.titleSpacing = NavigationToolbar.kMiddleSpacing,
		this.expandedHeight,
		this.floating = false,
		this.pinned = false,
		this.snap = false,
	})  : assert(automaticallyImplyLeading != null),
			assert(forceElevated != null),
			assert(primary != null),
			assert(titleSpacing != null),
			assert(floating != null),
			assert(pinned != null),
			assert(snap != null),
			assert(floating || !snap,
			'The "snap" argument only makes sense for floating app bars.'),
			super(key: key);
	final Widget leading;
	final bool automaticallyImplyLeading;
	final Widget title;
	final List<Widget> actions;
	final Widget flexibleSpace;
	final PreferredSizeWidget bottom;
	final double elevation;
	final bool forceElevated;
	
	final Widget background;
	final Color backgroundColor;
	final double backgroundHeight;
	
	final Brightness brightness;
	final IconThemeData iconTheme;
	final TextTheme textTheme;
	final bool primary;
	final bool centerTitle;
	final double titleSpacing;
	final double expandedHeight;
	final bool floating;
	final bool pinned;
	final bool snap;
	
	@override
	_SliverBackgroundAppBarState createState() => new _SliverBackgroundAppBarState();
}

class _SliverBackgroundAppBarState extends State<SliverBackgroundAppBar> with TickerProviderStateMixin {
	FloatingHeaderSnapConfiguration _snapConfiguration;
	
	void _updateSnapConfiguration() {
		if (widget.snap && widget.floating) {
			_snapConfiguration = new FloatingHeaderSnapConfiguration(
				vsync: this,
				curve: Curves.easeOut,
				duration: const Duration(milliseconds: 200),
			);
		} else {
			_snapConfiguration = null;
		}
	}
	
	@override
	void initState() {
		super.initState();
		_updateSnapConfiguration();
	}
	
	@override
	void didUpdateWidget( SliverBackgroundAppBar oldWidget) {
		super.didUpdateWidget(oldWidget);
		if (widget.snap != oldWidget.snap || widget.floating != oldWidget.floating)
			_updateSnapConfiguration();
	}
	
	@override
	Widget build(BuildContext context) {
		assert(!widget.primary || debugCheckHasMediaQuery(context));
		final double topPadding =
		widget.primary ? MediaQuery.of(context).padding.top : 0.0;
		final double collapsedHeight =
		(widget.pinned && widget.floating && widget.bottom != null)
			? widget.bottom.preferredSize.height + topPadding
			: null;
		
		return new MediaQuery.removePadding(
			context: context,
			removeBottom: true,
			child: new SliverPersistentHeader(
				floating: widget.floating,
				pinned: widget.pinned,
				delegate: new _SliverBackgroundAppBarDelegate(
					leading: widget.leading,
					automaticallyImplyLeading: widget.automaticallyImplyLeading,
					title: widget.title,
					actions: widget.actions,
					flexibleSpace: widget.flexibleSpace,
					bottom: widget.bottom,
					elevation: widget.elevation,
					forceElevated: widget.forceElevated,
					background: widget.background,
					backgroundColor: widget.backgroundColor,
					backgroundHeight: widget.backgroundHeight,
					brightness: widget.brightness,
					iconTheme: widget.iconTheme,
					textTheme: widget.textTheme,
					primary: widget.primary,
					centerTitle: widget.centerTitle,
					titleSpacing: widget.titleSpacing,
					expandedHeight: widget.expandedHeight,
					collapsedHeight: collapsedHeight,
					topPadding: topPadding,
					floating: widget.floating,
					pinned: widget.pinned,
					snapConfiguration: _snapConfiguration,
				),
			),
		);
	}
}