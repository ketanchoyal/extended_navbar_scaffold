part of extended_navbar_scaffold;

double bottomBarVisibleHeight = 55.0;
double bottomBarOriginalHeight = 80.0;
double bottomBarExpandedHeight = 300.0;

class MoreButtonModel {
  final IconData icon;
  final String label;
  final Function onTap;

  MoreButtonModel({
    @required this.icon,
    @required this.label,
    @required this.onTap,
  });
}

class ExtendedNavigationBarScaffold extends StatefulWidget {
  ExtendedNavigationBarScaffold({
    Key key,
    this.onTap,
    this.currentBottomBarCenterPercent,
    this.currentExternalAnimationPercentage = 0.0,
    this.currentBottomBarMorePercent,
    this.currentBottomBarSearchPercent,
    this.moreButtons,
    this.searchWidget,
    this.parallexCardPageTransformer,
    this.appBar,
    this.body,
    this.elevation,
    this.navBarColor,
    this.navBarIconColor,
    this.floatingAppBar = false,
  })  : assert(moreButtons != null ? moreButtons.length <= 9 : true),
        assert(body != null),
        super(key: key);

  final Function(int) onTap;
  final Function(double) currentBottomBarCenterPercent;
  final Function(double) currentBottomBarMorePercent;
  final Function(double) currentBottomBarSearchPercent;
  final double currentExternalAnimationPercentage;
  final Widget searchWidget;

  final PreferredSizeWidget appBar;
  final Widget body;

  final double elevation;

  final Color navBarColor;

  final Color navBarIconColor;

  final bool floatingAppBar;

  ///If you want Empty Space then put null.
  ///Maximum 9 buttons can be added.
  ///Buttons will be placed according to the list order.
  final List<MoreButtonModel> moreButtons;

  /// Parallex Cards

  /// ```dart
  /// PageTransformer(
  ///  pageViewBuilder: (context, visibilityResolver) {
  ///     return PageView.builder(
  ///       controller: PageController(viewportFraction: 0.85),
  ///       itemCount: parallaxCardItemsList.length,
  ///       itemBuilder: (context, index) {
  ///         final item = parallaxCardItemsList[index];
  ///         final pageVisibility =
  ///             visibilityResolver.resolvePageVisibility(index);
  ///         return ParallaxCardsWidget(
  ///           item: item,
  ///           pageVisibility: pageVisibility,
  ///         );
  ///       },
  ///     );
  ///   },
  /// ),
  /// ```
  final PageTransformer parallexCardPageTransformer;

  _ExtendedNavigationBarScaffoldState createState() =>
      _ExtendedNavigationBarScaffoldState();
}

class _ExtendedNavigationBarScaffoldState
    extends State<ExtendedNavigationBarScaffold> with TickerProviderStateMixin {
  CurvedAnimation curve;

  //*Parallex Animation Code
  AnimationController animationControllerBottomBarParallex;
  var offsetBottomBarParallex = 0.0;
  get currentBottomBarCenterPercentage => max(
        0.0,
        min(
          1.0,
          offsetBottomBarParallex /
              (bottomBarExpandedHeight - bottomBarOriginalHeight),
        ),
      );
  bool isBottomBarParallexOpen = false;
  Animation<double> animationParallex;

  void onParallexVerticalDragUpdate(details) {
    offsetBottomBarParallex -= details.delta.dy;
    if (offsetBottomBarParallex > bottomBarExpandedHeight) {
      offsetBottomBarParallex = bottomBarExpandedHeight;
    } else if (offsetBottomBarParallex < 0) {
      offsetBottomBarParallex = 0;
    }
    if (widget.currentBottomBarCenterPercent != null)
      widget.currentBottomBarCenterPercent(currentBottomBarCenterPercentage);
    setState(() {});
  }

  void animateBottomBarParallex(bool open) {
    // if (isBottomBarParallexOpen) {
    //   isBottomBarParallexOpen = false;
    // }

    if (isBottomBarMoreOpen) {
      animateBottomBarMore(!isBottomBarMoreOpen);
    }

    if (isBottomBarSearchOpen) {
      animateBottomBarSearch(!isBottomBarSearchOpen);
    }

    animationControllerBottomBarParallex = AnimationController(
        duration: Duration(
            milliseconds: 1 +
                (800 *
                        (isBottomBarParallexOpen
                            ? currentBottomBarCenterPercentage
                            : (1 - currentBottomBarCenterPercentage)))
                    .toInt()),
        vsync: this);
    curve = CurvedAnimation(
        parent: animationControllerBottomBarParallex, curve: Curves.ease);
    animationParallex = Tween(
            begin: offsetBottomBarParallex,
            end: open ? bottomBarExpandedHeight : 0.0)
        .animate(curve)
          ..addListener(() {
            setState(() {
              offsetBottomBarParallex = animationParallex.value;
            });
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              isBottomBarParallexOpen = open;
            }
          });
    animationControllerBottomBarParallex.forward();
  }

  //* More Button Animation Code

  AnimationController animationControllerBottomBarMore;
  var offsetBottomBarMore = 0.0;
  get currentBottomBarMorePercentage => max(
        0.0,
        min(
          1.0,
          offsetBottomBarMore /
              (bottomBarExpandedHeight - bottomBarOriginalHeight),
        ),
      );
  bool isBottomBarMoreOpen = false;
  Animation<double> animationMore;

  void onMoreVerticalDragUpdate(details) {
    offsetBottomBarMore -= details.delta.dy;
    if (offsetBottomBarMore > bottomBarExpandedHeight) {
      offsetBottomBarMore = bottomBarExpandedHeight;
    } else if (offsetBottomBarMore < 0) {
      offsetBottomBarMore = 0;
    }

    if (widget.currentBottomBarMorePercent != null)
      widget.currentBottomBarMorePercent(currentBottomBarMorePercentage);
    setState(() {});
  }

  void animateBottomBarMore(bool open) {
    if (isBottomBarSearchOpen) {
      animateBottomBarSearch(!isBottomBarSearchOpen);
    }
    if (isBottomBarParallexOpen) {
      animateBottomBarParallex(!isBottomBarParallexOpen);
    }

    animationControllerBottomBarMore = AnimationController(
        duration: Duration(
            milliseconds: 1 +
                (1000 *
                        (isBottomBarMoreOpen
                            ? currentBottomBarMorePercentage
                            : (1 - currentBottomBarMorePercentage)))
                    .toInt()),
        vsync: this);
    curve = CurvedAnimation(
        parent: animationControllerBottomBarMore, curve: Curves.ease);
    animationMore = Tween(
            begin: offsetBottomBarMore,
            end: open ? bottomBarExpandedHeight : 0.0)
        .animate(curve)
          ..addListener(
            () {
              setState(() {
                offsetBottomBarMore = animationMore.value;
              });
            },
          )
          ..addStatusListener(
            (status) {
              if (status == AnimationStatus.completed) {
                isBottomBarMoreOpen = open;
              }
            },
          );
    animationControllerBottomBarMore.forward();
  }

  //* Search Button Animation(bring center button downwards) *//

  AnimationController animationControllerBottomBarSearch;
  var offsetBottomBarSearch = 0.0;
  get currentBottomBarSearchPercentage => max(
        0.0,
        min(
          1.0,
          offsetBottomBarSearch / 28.0,
        ),
      );
  bool isBottomBarSearchOpen = false;
  Animation<double> animationSearch;

  void onSearchVerticalDragUpdate(details) {
    offsetBottomBarSearch -= details.delta.dy;
    if (offsetBottomBarSearch > bottomBarExpandedHeight) {
      offsetBottomBarSearch = bottomBarExpandedHeight;
    } else if (offsetBottomBarSearch < 0) {
      offsetBottomBarSearch = 0;
    }

    if (widget.currentBottomBarSearchPercent != null)
      widget.currentBottomBarSearchPercent(currentBottomBarSearchPercentage);
    setState(() {});
  }

  void animateBottomBarSearch(bool open) {
    if (isBottomBarParallexOpen) {
      animateBottomBarParallex(!isBottomBarParallexOpen);
    }

    if (isBottomBarMoreOpen) {
      animateBottomBarMore(!isBottomBarMoreOpen);
    }

    animationControllerBottomBarSearch = AnimationController(
        duration: Duration(
            milliseconds: 1 +
                (1000 *
                        (isBottomBarSearchOpen
                            ? currentBottomBarSearchPercentage
                            : (1 - currentBottomBarSearchPercentage)))
                    .toInt()),
        vsync: this);
    curve = CurvedAnimation(
        parent: animationControllerBottomBarSearch, curve: Curves.ease);
    animationSearch =
        Tween(begin: offsetBottomBarSearch, end: open ? 28.0 : 0.0)
            .animate(curve)
              ..addListener(
                () {
                  setState(() {
                    offsetBottomBarSearch = animationSearch.value;
                  });
                },
              )
              ..addStatusListener(
                (status) {
                  if (status == AnimationStatus.completed) {
                    isBottomBarSearchOpen = open;
                  }
                },
              );
    animationControllerBottomBarSearch.forward();

    if (widget.currentBottomBarSearchPercent != null)
      widget.currentBottomBarSearchPercent(currentBottomBarSearchPercentage);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.currentExternalAnimationPercentage > 0.30) {
      if (isBottomBarParallexOpen) {
        animateBottomBarParallex(false);
      }
      if (isBottomBarMoreOpen) {
        animateBottomBarMore(false);
      }
    }
    return Scaffold(
      appBar: widget.floatingAppBar ? null : widget.appBar,
      // backgroundColor: ,
      extendBody: true,

      body: Stack(
        children: <Widget>[
          widget.body,
          // widget.appBar
          widget.floatingAppBar
              ? Positioned(
                  top: 0,
                  left: 10,
                  right: 10,
                  child: SafeArea(
                    // height: 50,
                    child: widget.appBar,
                  ),
                )
              : Container(),
          _CustomBottomNavigationBar(
            moreButtons: widget.moreButtons,
            searchWidget: widget.searchWidget,
            parallexCardPageTransformer: widget.parallexCardPageTransformer,
            elevation: widget.elevation,
            navBarColor: widget.navBarColor,
            navBarIconColor: widget.navBarIconColor,
            //* "Parallex" Animation
            animateBottomBarParallex: animateBottomBarParallex,
            currentBottomBarParallexPercentage:
                currentBottomBarCenterPercentage,
            isBottomBarParallexOpen: isBottomBarParallexOpen,
            onTap: widget.onTap,
            onParallexVerticalDragUpdate: onParallexVerticalDragUpdate,
            onParallexPanDown: () =>
                animationControllerBottomBarParallex?.stop(),
            //* "More" Animation
            animateBottomBarMore: animateBottomBarMore,
            currentBottomBarMorePercentage: currentBottomBarMorePercentage,
            isBottomBarMoreOpen: isBottomBarMoreOpen,
            onMoreVerticalDragUpdate: onMoreVerticalDragUpdate,
            onMorePanDown: () => animationControllerBottomBarMore?.stop(),
            //* Search
            animateBottomBarSearch: animateBottomBarSearch,
            currentBottomBarSearchPercentage: currentBottomBarSearchPercentage,
            isBottomBarSearchOpen: isBottomBarSearchOpen,
            onSearchVerticalDragUpdate: onSearchVerticalDragUpdate,
            onSearchPanDown: () => animationControllerBottomBarSearch?.stop(),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    animationControllerBottomBarParallex?.dispose();
    animationControllerBottomBarMore?.dispose();
    animationControllerBottomBarSearch?.dispose();
  }
}

class _CustomBottomNavigationBar extends StatelessWidget {
  _CustomBottomNavigationBar({
    Key key,
    this.onTap,
    this.searchWidget,
    this.parallexCardPageTransformer,
    this.elevation,
    this.navBarColor,
    this.navBarIconColor,
    //Parallex
    this.animateBottomBarParallex,
    this.currentBottomBarParallexPercentage,
    this.isBottomBarParallexOpen,
    this.onParallexPanDown,
    this.onParallexVerticalDragUpdate,
    //More
    this.animateBottomBarMore,
    this.currentBottomBarMorePercentage,
    this.isBottomBarMoreOpen,
    this.onMorePanDown,
    this.onMoreVerticalDragUpdate,
    this.moreButtons,
    //Search
    this.animateBottomBarSearch,
    this.currentBottomBarSearchPercentage,
    this.isBottomBarSearchOpen,
    this.onSearchPanDown,
    this.onSearchVerticalDragUpdate,
  }) : super(key: key);

  final Function(int) onTap;

  final Widget searchWidget;

  final List<MoreButtonModel> moreButtons;

  final double currentBottomBarParallexPercentage;
  final Function(bool) animateBottomBarParallex;
  final bool isBottomBarParallexOpen;
  final Function(DragUpdateDetails) onParallexVerticalDragUpdate;
  final Function() onParallexPanDown;

  final double currentBottomBarMorePercentage;
  final Function(bool) animateBottomBarMore;
  final bool isBottomBarMoreOpen;
  final Function(DragUpdateDetails) onMoreVerticalDragUpdate;
  final Function() onMorePanDown;

  final double currentBottomBarSearchPercentage;
  final Function(bool) animateBottomBarSearch;
  final bool isBottomBarSearchOpen;
  final Function(DragUpdateDetails) onSearchVerticalDragUpdate;
  final Function() onSearchPanDown;
  final PageTransformer parallexCardPageTransformer;
  final double elevation;

  final Color navBarColor;

  final Color navBarIconColor;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 10,
      left: 10,
      right: 10,
      // alignment: Alignment.bottomCenter,
      child: Card(
        // color: Colors.transparent,
        color: Colors.transparent,
        elevation: elevation ?? 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: SizedBox(
          height: bottomBarOriginalHeight +
              //* Increase height when parallex card is expanded *//
              (bottomBarExpandedHeight - bottomBarOriginalHeight) *
                  currentBottomBarParallexPercentage +
              //* Increase height when More Button is expanded *//
              (bottomBarExpandedHeight) * currentBottomBarMorePercentage +
              //* Increase Height For Search Bar */
              (bottomBarExpandedHeight) * currentBottomBarSearchPercentage,
          child: Stack(
            children: <Widget>[
              _buildBackgroundForParallexCard(context),
              _builtSearchBar(),
              _buildOtherButtons(context),
              isBottomBarParallexOpen
                  ? _buildParallexCards(context)
                  : Container(),
              _buildMoreExpandedCard(context),
              _buildCenterButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _builtSearchBar() {
    return Visibility(
      // maintainAnimation: true,
      // maintainInteractivity: false,
      // maintainSize: false,
      // maintainState: true,
      visible: isBottomBarSearchOpen,
      child: Positioned(
        left: 50 - 50 * currentBottomBarSearchPercentage,
        right: 50 - 50 * currentBottomBarSearchPercentage,
        bottom: 0 + 55 * currentBottomBarSearchPercentage,
        child: searchWidget ?? Container(),
      ),
    );
  }

  Widget _buildMoreExpandedCard(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 60,
      child: Opacity(
        opacity: currentBottomBarMorePercentage,
        child: Container(
          height: (bottomBarExpandedHeight - bottomBarVisibleHeight - 10) *
              currentBottomBarMorePercentage,
          // color: Colors.blue,
          child: Stack(
            // alignment: Alignment.center,
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: MoreButtons(
                  currentBottomBarMorePercentage:
                      currentBottomBarMorePercentage,
                  model: moreButtons[0],
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: MoreButtons(
                  currentBottomBarMorePercentage:
                      currentBottomBarMorePercentage,
                  model: moreButtons[1],
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: MoreButtons(
                  currentBottomBarMorePercentage:
                      currentBottomBarMorePercentage,
                  model: moreButtons[2],
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: MoreButtons(
                  currentBottomBarMorePercentage:
                      currentBottomBarMorePercentage,
                  model: moreButtons[3],
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: MoreButtons(
                  currentBottomBarMorePercentage:
                      currentBottomBarMorePercentage,
                  model: moreButtons[4],
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: MoreButtons(
                  currentBottomBarMorePercentage:
                      currentBottomBarMorePercentage,
                  model: moreButtons[5],
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: MoreButtons(
                  currentBottomBarMorePercentage:
                      currentBottomBarMorePercentage,
                  model: moreButtons[6],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: MoreButtons(
                  currentBottomBarMorePercentage:
                      currentBottomBarMorePercentage,
                  model: moreButtons[7],
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: MoreButtons(
                  currentBottomBarMorePercentage:
                      currentBottomBarMorePercentage,
                  model: moreButtons[8],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtherButtons(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: EdgeInsets.only(left: 0, right: 0),
        height: bottomBarVisibleHeight +
            (bottomBarExpandedHeight - 0) * currentBottomBarMorePercentage,
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[_buildMoreButton(), _buildSearchButton()],
        ),
      ),
    );
  }

  Widget _buildSearchButton() {
    return Expanded(
      child: Container(
        height: bottomBarVisibleHeight,
        child: GestureDetector(
          onPanDown: (_) => onSearchPanDown,
          onVerticalDragUpdate: onSearchVerticalDragUpdate,
          onVerticalDragEnd: (_) {
            _dispatchBottomBarSearchOffset();
          },
          onVerticalDragCancel: () {
            _dispatchBottomBarSearchOffset();
          },
          child: FloatingActionButton(
            backgroundColor: navBarColor,
            elevation: 0,
            heroTag: 'sdansiux',
            // padding: EdgeInsets.only(left: 35),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  EvaIcons.search,
                  size: 30,
                  color: navBarIconColor,
                ),
                Text(
                  'Search',
                  style: ktitleStyle.copyWith(
                    fontSize: 13,
                    color: navBarIconColor,
                  ),
                )
              ],
            ),
            onPressed: () {
              if (onTap != null) onTap(2);
              animateBottomBarSearch(!isBottomBarSearchOpen);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMoreButton() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            height: bottomBarVisibleHeight,
            child: GestureDetector(
              onPanDown: (_) => onMorePanDown,
              onVerticalDragUpdate: onMoreVerticalDragUpdate,
              onVerticalDragEnd: (_) {
                _dispatchBottomBarMoreOffset();
              },
              onVerticalDragCancel: () {
                _dispatchBottomBarMoreOffset();
              },
              child: FloatingActionButton(
                backgroundColor: navBarColor,
                heroTag: 'dsc',
                // padding: EdgeInsets.only(right: 35),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                  ),
                ),
                onPressed: () {
                  if (onTap != null) onTap(0);
                  animateBottomBarMore(!isBottomBarMoreOpen);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Transform(
                      alignment: FractionalOffset.center,
                      transform: new Matrix4.identity()
                        ..rotateZ(180 *
                            currentBottomBarMorePercentage *
                            3.1415927 /
                            180),
                      child: Icon(
                        EvaIcons.arrowCircleUpOutline,
                        size: 30,
                        color: navBarIconColor,
                      ),
                    ),
                    Text(
                      'More',
                      style: ktitleStyle.copyWith(
                        fontSize: 13,
                        color: navBarIconColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: (bottomBarExpandedHeight - bottomBarVisibleHeight) *
                currentBottomBarMorePercentage,
            // child: Container(
            //   color: Colors.red,
            // ),
          )
        ],
      ),
    );
  }

  Widget _buildBackgroundForParallexCard(BuildContext context) {
    return Positioned(
      top: 25,
      bottom: 55,
      left: 0,
      right: 0,
      child: Container(
        height: (bottomBarExpandedHeight - bottomBarOriginalHeight) *
            currentBottomBarParallexPercentage,
        color: Theme.of(context).canvasColor,
      ),
    );
  }

  Widget _buildCenterButton(BuildContext context) {
    return Positioned(
      left: currentBottomBarParallexPercentage > 0.0
          ? 0
          : (MediaQuery.of(context).size.width / 2) - 50,
      right: currentBottomBarParallexPercentage > 0.0
          ? 0
          : (MediaQuery.of(context).size.width / 2) - 50,
      // top: 0 +
      //     (28 + bottomBarExpandedHeight) * currentBottomBarMorePercentage +
      //     (28 + 350) * currentBottomBarSearchPercentage,
      bottom: 30 +
          (bottomBarExpandedHeight - bottomBarOriginalHeight) *
              currentBottomBarParallexPercentage -
          28 * currentBottomBarMorePercentage -
          28 * currentBottomBarSearchPercentage,
      // alignment: Alignment.topCenter,
      child: Container(
        height: 50,
        // color: Colors.red,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 50,
              width: 50,
              child: EaseInWidget(
                onTap: () {
                  if (onTap != null) onTap(1);
                  animateBottomBarParallex(!isBottomBarParallexOpen);
                },
                child: GestureDetector(
                  onPanDown: (_) => onParallexPanDown,
                  onVerticalDragUpdate: onParallexVerticalDragUpdate,
                  onVerticalDragEnd: (_) {
                    _dispatchBottomBarParallexOffset();
                  },
                  onVerticalDragCancel: () {
                    _dispatchBottomBarParallexOffset();
                  },
                  child: FloatingActionButton(
                    backgroundColor: Colors.black,
                    heroTag: 'adaojd',
                    elevation: 0,
                    onPressed: null,
                    child: Icon(
                      Icons.view_column,
                      color: Theme.of(context).canvasColor,
                    ),
                  ),
                ),
              ),
            ),
            // SizedBox(
            //   height: 300 * currentBottomBarParallexPercentage,
            //   // child: Container(
            //   //   color: Colors.red,
            //   // ),
            // )
          ],
        ),
      ),
    );
  }

  Widget _buildParallexCards(BuildContext context) {
    return Positioned(
      bottom: 30 * currentBottomBarParallexPercentage,
      left: 0,
      right: 0,
      child: Container(
        // height: (bottomBarExpandedHeight - bottomBarVisibleHeight - 10) *
        //     currentBottomBarParallexPercentage,
        child: Padding(
          padding: EdgeInsets.only(bottom: 25.0),
          child: SizedBox.fromSize(
            size: Size.fromHeight(210.0 * currentBottomBarParallexPercentage),
            child: parallexCardPageTransformer,
          ),
        ),
      ),
    );
  }

  void _dispatchBottomBarParallexOffset() {
    if (!isBottomBarParallexOpen) {
      if (currentBottomBarParallexPercentage < 0.3) {
        animateBottomBarParallex(false);
      } else {
        animateBottomBarParallex(true);
      }
    } else {
      if (currentBottomBarParallexPercentage > 0.6) {
        animateBottomBarParallex(true);
      } else {
        animateBottomBarParallex(false);
      }
    }
  }

  void _dispatchBottomBarMoreOffset() {
    if (!isBottomBarMoreOpen) {
      if (currentBottomBarMorePercentage < 0.3) {
        animateBottomBarMore(false);
      } else {
        animateBottomBarMore(true);
      }
    } else {
      if (currentBottomBarMorePercentage > 0.6) {
        animateBottomBarMore(true);
      } else {
        animateBottomBarMore(false);
      }
    }
  }

  void _dispatchBottomBarSearchOffset() {
    if (!isBottomBarSearchOpen) {
      if (currentBottomBarSearchPercentage < 0.2) {
        animateBottomBarSearch(false);
      } else {
        animateBottomBarSearch(true);
      }
    } else {
      if (currentBottomBarSearchPercentage > 0.6) {
        animateBottomBarSearch(true);
      } else {
        animateBottomBarSearch(false);
      }
    }
  }
}

class MoreButtons extends StatelessWidget {
  const MoreButtons({
    Key key,
    @required this.currentBottomBarMorePercentage,
    @required this.model,
  }) : super(key: key);

  final double currentBottomBarMorePercentage;
  final MoreButtonModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      height: (bottomBarExpandedHeight - bottomBarVisibleHeight) * 0.3,
      // color: Colors.red,
      child: model == null
          ? SizedBox()
          : FlatButton(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    model.icon,
                    size: MediaQuery.of(context).size.width *
                        0.33 *
                        currentBottomBarMorePercentage /
                        3,
                    // size: 45,
                  ),
                  // SizedBox(
                  //   height: 5,
                  // ),
                  Text(
                    model.label,
                    textAlign: TextAlign.center,
                    style: ktitleStyle.copyWith(
                      // fontSize: 14,
                      fontSize: MediaQuery.of(context).size.width *
                          0.1 *
                          currentBottomBarMorePercentage /
                          3,
                    ),
                  )
                ],
              ),
              onPressed: model.onTap,
            ),
    );
  }
}
