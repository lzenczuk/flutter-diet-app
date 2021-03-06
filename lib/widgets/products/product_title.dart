import 'package:diet_app/models/nutrition.dart';
import 'package:flutter/material.dart';

//TODO - fix name - tile not title
class NutritionTitle extends StatelessWidget {
  final String name;
  final Nutrition nutrition;
  final bool inSelectMode;
  final bool selected;
  final GestureTapCallback onTap;
  final ValueChanged<bool> onChanged;

  const NutritionTitle({Key key, this.onTap, this.inSelectMode = false, this.selected = false, this.onChanged, this.name, this.nutrition}) : super(key: key);

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
                      name,
                      style: Theme.of(context).textTheme.title,
                    ),
                  ),
                  IntrinsicHeight(
                    child: Row(
                      children: <Widget>[
                        _NutritionInfo(
                          name: 'Fat',
                          value: nutrition.fat,
                        ),
                        VerticalDivider(),
                        _NutritionInfo(
                          name: 'Carbs',
                          value: nutrition.carbs,
                        ),
                        VerticalDivider(),
                        _NutritionInfo(
                          name: 'Protein',
                          value: nutrition.protein,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: inSelectMode,
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

class IngredientTile extends StatelessWidget {
  final String name;
  final Nutrition nutrition;
  final double amount;
  final GestureTapCallback onTap;

  const IngredientTile({Key key, this.onTap, this.name, this.nutrition, this.amount}) : super(key: key);

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
                      name,
                      style: Theme.of(context).textTheme.title,
                    ),
                  ),
                  IntrinsicHeight(
                    child: Row(
                      children: <Widget>[
                        _NutritionInfo(
                          name: 'Fat',
                          value: nutrition.fat,
                        ),
                        VerticalDivider(),
                        _NutritionInfo(
                          name: 'Carbs',
                          value: nutrition.carbs,
                        ),
                        VerticalDivider(),
                        _NutritionInfo(
                          name: 'Protein',
                          value: nutrition.protein,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Text(amount.toString())
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
          value.toStringAsFixed(2),
          style: Theme.of(context).textTheme.caption.apply(fontWeightDelta: 100),
        ),
      ],
    );
  }
}
