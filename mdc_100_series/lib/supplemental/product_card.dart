// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/product.dart';

class ProductCard extends StatefulWidget {
  final double imageAspectRatio;
  final Product product;
  final double kTextBoxHeight;

  ProductCard(
      {this.imageAspectRatio: 33 / 49, this.product, this.kTextBoxHeight: 65})
      : assert(imageAspectRatio == null || imageAspectRatio > 0),
        assert(kTextBoxHeight == null || kTextBoxHeight > 0);

  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      value: 1,
      lowerBound: .9,
      upperBound: 1,
      vsync: this,
    );
  }

  bool get _animationStatus {
    final AnimationStatus status = _controller.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  void _toggleScale() {
    _controller.fling(velocity: _animationStatus ? -2 : 2);
  }

  @override
  Widget build(BuildContext context) {
    final NumberFormat formatter = NumberFormat.simpleCurrency(
        decimalDigits: 0, locale: Localizations.localeOf(context).toString());
    final ThemeData theme = Theme.of(context);

    Animation animation =
        CurvedAnimation(parent: _controller, curve: Curves.linear);

    final imageWidget = Image.asset(
      widget.product.assetName,
      package: widget.product.assetPackage,
      fit: BoxFit.cover,
    );

    return GestureDetector(
      onTap: () {
        _toggleScale();
        print('wohoo');
      },
      onTapCancel: _toggleScale,
      onTapDown: (detail) => _toggleScale(),
      child: ScaleTransition(
        scale: animation,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            AspectRatio(
              aspectRatio: widget.imageAspectRatio,
              child: imageWidget,
            ),
            SizedBox(
              height: widget.kTextBoxHeight *
                  MediaQuery.of(context).textScaleFactor,
              width: 121.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    widget.product == null ? '' : widget.product.name,
                    style: theme.textTheme.button,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    widget.product == null
                        ? ''
                        : formatter.format(widget.product.price),
                    style: theme.textTheme.caption,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
