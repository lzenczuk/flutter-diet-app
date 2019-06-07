import 'package:diet_app/models/product.dart';
import 'package:flutter/material.dart';

class ProductTitle extends StatelessWidget {
  final Product product;
  final bool selectable;
  final bool selected;
  final GestureTapCallback onTap;
  final ValueChanged<bool> onChanged;

  const ProductTitle({Key key, this.product, this.onTap, this.selectable = false, this.selected = false, this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.only(left: 16, top: 4),
      height: 6*8.0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              behavior: HitTestBehavior.translucent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(bottom: 4.0),
                    child: Text(
                      product.name,
                      style: Theme.of(context).textTheme.title,
                    ),
                  ),
                  IntrinsicHeight(
                    child: Row(
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
          ),
          Visibility(
            visible: selectable,
            child: Checkbox(
              value: selected,
              onChanged: onChanged,
            ),
          )
        ],
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
    return Row(
      children: <Widget>[
        Padding(
          child: Text(
            name,
            style: Theme.of(context).textTheme.caption,
          ),
          padding: EdgeInsets.only(right: 4.0),
        ),
        Text(
          value.toString(),
          style: Theme.of(context).textTheme.caption.apply(fontWeightDelta: 100),
        ),
      ],
    );
  }
}
