import 'package:Shrine/model/product.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailProduct extends StatelessWidget {
  const DetailProduct({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Product product = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      floatingActionButton: ButtonBar(
        alignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          OutlineButton(
            onPressed: () {
              print('add to cart');
            },
            child: Text('Add to Cart'),
            shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(7)),
            ),
            borderSide: BorderSide(width: 2),
            highlightedBorderColor: ThemeData.light().hintColor,
            padding: EdgeInsets.symmetric(horizontal: 50),
          ),
          RaisedButton(
            onPressed: () {
              print('buy');
            },
            child: Text('Buy'),
            shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(7)),
            ),
            padding: EdgeInsets.symmetric(horizontal: 50),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).textScaleFactor * 200,
                width: MediaQuery.of(context).size.width,
                child: Hero(
                  tag: 'image' + product.id.toString(),
                  child: Image.asset(
                    product.assetName,
                    package: product.assetPackage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Hero(
                      tag: 'name' + product.id.toString(),
                      child: Transform.scale(
                        alignment: Alignment.topLeft,
                        scale: 1.6,
                        child: Text(
                          product.name,
                          style: Theme.of(context).textTheme.button,
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Hero(
                      tag: 'price' + product.id.toString(),
                      child: Text(
                        NumberFormat.simpleCurrency(
                                decimalDigits: 0,
                                locale:
                                    Localizations.localeOf(context).toString())
                            .format(product.price),
                        style: Theme.of(context).textTheme.caption,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ],
      ),
    );
  }
}
