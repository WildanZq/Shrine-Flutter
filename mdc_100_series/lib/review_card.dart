import 'package:flutter/material.dart';

class ReviewCard extends StatelessWidget {
  final String name;
  final String message;
  final int rating;

  const ReviewCard(
      {Key key, this.name, this.message: '', this.rating})
      : assert(name != null),
        assert(rating != null && rating >= 1 && rating <= 5),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(50),
              ),
              width: 50,
              height: 50,
            ),
            SizedBox(width: 12),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    name,
                    style: Theme.of(context).textTheme.body2,
                  ),
                  SizedBox(height: 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: List<Widget>.generate(
                            rating,
                            (int i) => Icon(
                                  Icons.star,
                                  size: 16,
                                  color: Colors.orangeAccent,
                                )),
                      ),
                      Text(
                        '28 Aug \'19',
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ],
                  ),
                  SizedBox(height: message != '' ? 3 : 0),
                  Text(message),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
