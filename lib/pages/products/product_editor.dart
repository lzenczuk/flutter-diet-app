import 'package:diet_app/models/product.dart';
import 'package:flutter/material.dart';

class ProductEditorPage extends StatefulWidget {
  final Product product;

  const ProductEditorPage({Key key, this.product}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ProductEditorState(product);
  }
}

class _ProductEditorState extends State<ProductEditorPage> {
  final _formKey = GlobalKey<FormState>();

  Product _product;

  FocusNode nameFocusNode;
  FocusNode fatFocusNode;
  FocusNode carbohydrateFocusNode;
  FocusNode proteinFocusNode;

  _ProductEditorState(Product product) {
    if (product != null) {
      _product = product;
    } else {
      _product = Product();
    }
  }

  @override
  void initState() {
    nameFocusNode = FocusNode();
    fatFocusNode = FocusNode();
    carbohydrateFocusNode = FocusNode();
    proteinFocusNode = FocusNode();
  }

  @override
  void dispose() {
    nameFocusNode.dispose();
    fatFocusNode.dispose();
    carbohydrateFocusNode.dispose();
    proteinFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Text("Product"),
          actions: <Widget>[
            FlatButton(
              child: Text("save"),
              onPressed: () {
                validateAndSave(context);
              },
            )
          ],
        ),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Product name'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter product name';
                    }
                  },
                  onSaved: (value){
                    setState(() => _product.name = value);
                  },
                  textInputAction: TextInputAction.next,
                  focusNode: nameFocusNode,
                  onFieldSubmitted: (term) {
                    nameFocusNode.unfocus();
                    FocusScope.of(context).requestFocus(fatFocusNode);
                  },
                ),
                Text('Nutritions'),
                NumberFormField(
                  fieldName: 'Fat',
                  messageWhenEmpty: 'Please enter amount of fat',
                  onSaved: (value) => setState(() => _product.fat = value),
                  textInputAction: TextInputAction.next,
                  focusNode: fatFocusNode,
                  onFieldSubmitted: (term) {
                    fatFocusNode.unfocus();
                    FocusScope.of(context).requestFocus(carbohydrateFocusNode);
                  },
                ),
                NumberFormField(
                  fieldName: 'Carbohydrate',
                  messageWhenEmpty: 'Please enter amount of carbohydrate',
                  onSaved: (value) =>
                      setState(() => _product.carbohydrates = value),
                  textInputAction: TextInputAction.next,
                  focusNode: carbohydrateFocusNode,
                  onFieldSubmitted: (term) {
                    carbohydrateFocusNode.unfocus();
                    FocusScope.of(context).requestFocus(proteinFocusNode);
                  },
                ),
                NumberFormField(
                  fieldName: 'Protein',
                  messageWhenEmpty: 'Please enter amount of protein',
                  onSaved: (value) => setState(() => _product.protein = value),
                  textInputAction: TextInputAction.done,
                  focusNode: proteinFocusNode,
                )
              ],
            ),
          ),
        ));
  }

  void validateAndSave(BuildContext context) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Navigator.pop(context, _product);
    }
  }
}

class NumberFormField extends StatelessWidget {
  final String fieldName;
  final String messageWhenEmpty;
  final FormFieldSetter<double> onSaved;
  final TextInputAction textInputAction;
  final FocusNode focusNode;
  final ValueChanged<String> onFieldSubmitted;

  const NumberFormField(
      {Key key,
      this.fieldName,
      this.messageWhenEmpty,
      this.onSaved,
      this.textInputAction,
      this.focusNode,
      this.onFieldSubmitted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(labelText: fieldName, hintText: '0'),
      keyboardType: TextInputType.number,
      textInputAction: this.textInputAction,
      focusNode: this.focusNode,
      validator: (value) {
        if (value.isEmpty) {
          return messageWhenEmpty;
        }

        var num = double.tryParse(value);
        if (num == null) {
          return 'Only numbers allowed';
        }

        if (num < 0) {
          return 'Numbers smaller then 0 not allowed';
        }
      },
      onSaved: (value) {
        double num = double.parse(value);
        onSaved(num);
      },
      onFieldSubmitted: (term) => onFieldSubmitted(term),
    );
  }
}
