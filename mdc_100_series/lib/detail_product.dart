import 'package:Shrine/model/product.dart';
import 'package:Shrine/review_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpandableDescription extends StatefulWidget {
  final String text;

  ExpandableDescription({Key key, this.text}) : super(key: key);

  _ExpandableDescriptionState createState() => _ExpandableDescriptionState();
}

class _ExpandableDescriptionState extends State<ExpandableDescription>
    with SingleTickerProviderStateMixin {
  static AnimationController _controller;
  static bool _expanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      value: 0,
      duration: Duration(milliseconds: 400),
      vsync: this,
    );
  }

  void _toggleCollapse() {
    _controller.fling(velocity: _expanded ? -1 : 1);
    setState(() {
      _expanded = !_expanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AnimatedContainer(
          duration: Duration(milliseconds: 400),
          curve: Curves.easeOut,
          height: _expanded ? null : 46,
          child: Text(
            widget.text,
            style: Theme.of(context).textTheme.body1,
            overflow: TextOverflow.fade,
          ),
        ),
        Center(
          child: FlatButton(
            onPressed: _toggleCollapse,
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                Text(
                  _expanded ? 'Show Less' : 'Show More',
                  style: Theme.of(context).textTheme.button,
                ),
                RotationTransition(
                  turns: Tween(begin: 0.0, end: -.5).animate(_controller.view),
                  child: Icon(Icons.arrow_drop_down),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class DetailProduct extends StatelessWidget {
  const DetailProduct({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Product product = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Flexible(
              flex: 3,
              fit: FlexFit.tight,
              child: FlatButton(
                onPressed: () {
                  print('add to cart');
                },
                color: Colors.white,
                child: Text('Add to Cart'),
                shape: BeveledRectangleBorder(
                  side: BorderSide(width: 1.4),
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                ),
              ),
            ),
            SizedBox(width: 10),
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: RaisedButton(
                onPressed: () {
                  print('buy');
                },
                child: Text('Buy'),
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool scrolled) => <Widget>[
              SliverAppBar(
                floating: true,
                pinned: true,
                expandedHeight: MediaQuery.of(context).textScaleFactor * 240,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(product.name),
                  background: Hero(
                    tag: 'image' + product.id.toString(),
                    child: Image.asset(
                      product.assetName,
                      package: product.assetPackage,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          NumberFormat.simpleCurrency(
                                  decimalDigits: 0,
                                  locale: Localizations.localeOf(context)
                                      .toString())
                              .format(product.price),
                          style: Theme.of(context).textTheme.display1,
                          textAlign: TextAlign.left,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(Icons.star,
                                    size: 16, color: Colors.orangeAccent),
                                Icon(Icons.star,
                                    size: 16, color: Colors.orangeAccent),
                                Icon(Icons.star,
                                    size: 16, color: Colors.orangeAccent),
                                Icon(Icons.star_half,
                                    size: 16, color: Colors.orangeAccent),
                                Icon(Icons.star_border,
                                    size: 16, color: Colors.orangeAccent),
                                Text(
                                  '(136)',
                                  style: Theme.of(context).textTheme.overline,
                                ),
                              ],
                            ),
                            SizedBox(height: 6),
                            Row(
                              children: <Widget>[
                                Text('New York'),
                                Icon(
                                  Icons.location_on,
                                  size: 18,
                                  color: Theme.of(context).accentColor,
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Description',
                      style: Theme.of(context).textTheme.title,
                    ),
                    SizedBox(height: 8),
                    ExpandableDescription(
                      text:
                          'This product is so great, you should buy it right now. Before it\'s too late. You would never dissapointed. What are you waiting for! Just buy it already!',
                    ),
                    Text(
                      'Review',
                      style: Theme.of(context).textTheme.title,
                    ),
                    SizedBox(height: 8),
                    ReviewCard(
                      name: 'John',
                      message: 'Great product! Same with the description',
                      rating: 5,
                    ),
                    ReviewCard(
                      name: 'Karen',
                      message: 'Not as good as I expect',
                      rating: 1,
                    ),
                    ReviewCard(
                      name: 'Derp',
                      rating: 5,
                    ),
                    Center(
                      child: FlatButton(
                        onPressed: () {
                          print('Show Reviews');
                        },
                        child: Text('Show All'),
                      ),
                    ),
                    SizedBox(height: 70),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}