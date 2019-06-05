import 'package:diet_app/models/product.dart';
import 'package:flutter/material.dart';

class ProductTitle extends StatelessWidget {
  final Product product;
  final GestureTapCallback onTap;

  const ProductTitle({Key key, this.product, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              product.name,
              style: Theme.of(context).textTheme.title,
            ),
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _NutritionInfo(
                    name: 'Fat',
                    value: product.fat,
                  ),
                  VerticalDivider(),
                  _NutritionInfo(
                    name: 'Carbs',
                    value: product.carbohydrates,
                  ),
                  VerticalDivider(),
                  _NutritionInfo(
                    name: 'Protein',
                    value: product.protein,
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

class _NutritionInfo extends StatelessWidget {
  final String name;
  final double value;

  const _NutritionInfo({Key key, this.name, this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          name,
          style: Theme.of(context).textTheme.caption,
        ),
        Text(
          value.toString(),
          style: Theme.of(context).textTheme.subhead,
        ),
      ],
    );
  }
}
