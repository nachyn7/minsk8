import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:minsk8/import.dart';

class ItemScreen extends StatefulWidget {
  @override
  _ItemScreenState createState() {
    return _ItemScreenState();
  }
}

enum _ShowHero { forShowcase, forOpenZoom, forCloseZoom }

class _ItemScreenState extends State<ItemScreen> {
  var _showHero = _ShowHero.forShowcase;
  var _isCarouselSlider = true;
  var _currentIndex = 0;
  GlobalKey _panelColumnKey = GlobalKey();
  double _panelMaxHeight;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
  }

  void _afterLayout(_) {
    final RenderBox renderBox =
        _panelColumnKey.currentContext.findRenderObject();
    setState(() {
      _panelMaxHeight = renderBox.size.height;
    });
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context).settings.arguments as ItemRouteArguments;
    final item = arguments.item;
    final tag = arguments.tag;
    final size = MediaQuery.of(context).size;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final bodyHeight = size.height - statusBarHeight - kToolbarHeight;
    final carouselSliderHeight = bodyHeight * kGoldenRatio -
        ItemCarouselSliderSettings.verticalPadding * 2;
    final panelMinHeight = bodyHeight - bodyHeight * kGoldenRatio;
    final panelChildWidth = size.width - 32.0; // for padding
    final panelSlideLabelWidth = 30.0;
    final panelSlideLabelHeight = 4.0;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Завершено'),
          centerTitle: true,
          backgroundColor: Colors.pink.withOpacity(0.8),
          actions: [
            IconButton(
              icon: Icon(Icons.account_box),
              onPressed: () {},
            )
          ],
        ),
        body: SlidingUpPanel(
          body: Column(
            children: [
              SizedBox(
                height: ItemCarouselSliderSettings.verticalPadding,
              ),
              Stack(
                children: [
                  Container(),
                  if (tag != null && _showHero != null)
                    Center(
                      child: SizedBox(
                        height: carouselSliderHeight,
                        width: size.width *
                                ItemCarouselSliderSettings.viewportFraction -
                            ItemCarouselSliderSettings.itemHorizontalMargin * 2,
                        child: Hero(
                          tag: tag,
                          child: ExtendedImage.network(
                            item.images[_currentIndex].getDummyUrl(item.id),
                            fit: BoxFit.cover,
                            enableLoadState: false,
                          ),
                          flightShuttleBuilder: (
                            BuildContext flightContext,
                            Animation<double> animation,
                            HeroFlightDirection flightDirection,
                            BuildContext fromHeroContext,
                            BuildContext toHeroContext,
                          ) {
                            animation.addListener(() {
                              if ([
                                AnimationStatus.completed,
                                AnimationStatus.dismissed,
                              ].contains(animation.status)) {
                                setState(() {
                                  _showHero = null;
                                });
                              }
                            });
                            final Hero hero =
                                flightDirection == HeroFlightDirection.pop &&
                                        _showHero != _ShowHero.forCloseZoom
                                    ? fromHeroContext.widget
                                    : toHeroContext.widget;
                            return hero.child;
                          },
                        ),
                      ),
                    ),
                  if (_isCarouselSlider)
                    GestureDetector(
                      onTap: () async {
                        setState(() {
                          _showHero = _ShowHero.forOpenZoom;
                          _isCarouselSlider = false;
                        });
                        await SystemChrome.setPreferredOrientations([
                          DeviceOrientation.landscapeRight,
                          DeviceOrientation.landscapeLeft,
                          DeviceOrientation.portraitUp,
                          DeviceOrientation.portraitDown,
                        ]);
                        await Future.delayed(Duration(milliseconds: 100));
                        Navigator.pushNamed(
                          context,
                          '/zoom',
                          arguments: ZoomRouteArguments(
                            item,
                            tag: tag,
                            index: _currentIndex,
                            onWillPop: _onWillPopForZoom,
                          ),
                        );
                      },
                      child: CarouselSlider(
                        initialPage: _currentIndex,
                        height: carouselSliderHeight,
                        autoPlay: item.images.length > 1,
                        enableInfiniteScroll: item.images.length > 1,
                        pauseAutoPlayOnTouch: Duration(seconds: 10),
                        enlargeCenterPage: true,
                        viewportFraction:
                            ItemCarouselSliderSettings.viewportFraction,
                        onPageChanged: (index) {
                          _currentIndex = index;
                        },
                        items: List.generate(item.images.length, (index) {
                          return Container(
                            width: size.width,
                            margin: EdgeInsets.symmetric(
                                horizontal: ItemCarouselSliderSettings
                                    .itemHorizontalMargin),
                            child: ExtendedImage.network(
                              item.images[index].getDummyUrl(item.id),
                              fit: BoxFit.cover,
                              loadStateChanged: loadStateChanged,
                            ),
                          );
                        }),
                      ),
                    ),
                ],
              ),
            ],
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
          // parallaxEnabled: true,
          // parallaxOffset: .8,
          maxHeight: _panelMaxHeight == null
              ? size.height
              : max(_panelMaxHeight, panelMinHeight),
          minHeight: panelMinHeight,
          panel: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                key: _panelColumnKey,
                children: [
                  SizedBox(
                    height: 16.0,
                  ),
                  Row(
                    children: [
                      Container(
                        width: (panelChildWidth - panelSlideLabelWidth) / 2,
                        child: Row(
                          children: [
                            Hero(
                              tag: tag + '_price',
                              child: Price(item),
                            ),
                            Expanded(
                              child: Container(),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: panelSlideLabelWidth,
                        height: panelSlideLabelHeight,
                        margin: EdgeInsets.only(
                            bottom: kButtonHeight - panelSlideLabelHeight),
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0))),
                      ),
                      Container(
                        width: (panelChildWidth - panelSlideLabelWidth) / 2,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(),
                            ),
                            Distance(item.location),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  // TODO: как-то показывать текст, если не влезло (для маленьких экранов)
                  Container(
                    width: panelChildWidth,
                    child: Text(
                      item.text,
                      maxLines: 8,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Center(
                    child: Text("This is the sliding Widget"),
                  ),
                  SizedBox(
                    height: 500.0,
                  ),
                  Center(
                    child: Text("This is the sliding Widget"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    setState(() {
      _currentIndex = 0;
      _showHero = _ShowHero.forShowcase;
      _isCarouselSlider = false;
    });
    // await Future.delayed(Duration(milliseconds: 100));
    return true;
  }

  Future<bool> _onWillPopForZoom(index) async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    await Future.delayed(Duration(milliseconds: 100));
    setState(() {
      _currentIndex = index;
      _showHero = _ShowHero.forCloseZoom;
      _isCarouselSlider = true;
    });
    return true;
  }
}

class ItemRouteArguments {
  final ItemModel item;
  final String tag;

  ItemRouteArguments(this.item, {this.tag});
}

class ItemCarouselSliderSettings {
  static const itemHorizontalMargin = 8.0;
  static const viewportFraction = 0.8;
  static const verticalPadding = 16.0;
}
