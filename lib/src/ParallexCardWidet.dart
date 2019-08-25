part of extended_navbar_scaffold;

class ParallaxCardItem {
  ParallaxCardItem({
    this.title,
    this.body,
    this.background,
  });

  final String title;
  final String body;
  final Widget background;
}

class ParallaxCardsWidget extends StatefulWidget {
  ParallaxCardsWidget({
    @required this.item,
    @required this.pageVisibility,
  });

  final ParallaxCardItem item;
  final PageVisibility pageVisibility;

  @override
  _ParallaxCardsWidgetState createState() => _ParallaxCardsWidgetState();
}

class _ParallaxCardsWidgetState extends State<ParallaxCardsWidget> {

  Widget _applyTextEffects({
    @required double translationFactor,
    @required Widget child,
  }) {
    final double xTranslation =
        widget.pageVisibility.pagePosition * translationFactor;

    return Opacity(
      opacity: widget.pageVisibility.visibleFraction,
      child: Transform(
        alignment: FractionalOffset.topLeft,
        transform: Matrix4.translationValues(
          xTranslation,
          0.0,
          0.0,
        ),
        child: child,
      ),
    );
  }

  _buildTextContainer(BuildContext context) {
    var categoryText = _applyTextEffects(
      translationFactor: 300.0,
      child: Padding(
        padding: EdgeInsets.all(3.0),
        child: Text(
          widget.item.body,
          style: ktitleStyle.copyWith(
            color: Colors.white,
            // fontWeight: FontWeight.w600,
            fontSize: 22.0,
          ),
          textAlign: TextAlign.left,
        ),
      ),
    );

    var titleText = _applyTextEffects(
      translationFactor: 200.0,
      child: Padding(
        padding: EdgeInsets.all(3.0),
        child: Text(
          widget.item.title,
          style: ksubtitleStyle.copyWith(
            color: Colors.white,
            // fontWeight: FontWeight.w700,
            fontSize: 20.0,
          ),
          textAlign: TextAlign.left,
        ),
      ),
    );

    return Positioned(
      // top: 5,
      bottom: 5.0,
      left: 10.0,
      // right: 10.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          categoryText,
          titleText,
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var imageOverlayGradient = DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black12,
            // Colors.transparent,
            // Colors.black12,
            // Colors.black26,
            // Colors.black38,
            Colors.black87,
            // Colors.black,
          ],
        ),
      ),
    );

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 20.0,
        horizontal: 5.0,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Material(
          shadowColor: Theme.of(context).accentColor,
          elevation: 10,
          type: MaterialType.card,
          child: Stack(
            fit: StackFit.expand,
            children: [
              widget.item.background,
              // centerMarker,
              imageOverlayGradient,
              _buildTextContainer(context),
            ],
          ),
        ),
      ),
    );
  }
}
