import 'package:diet_app/products/product_model.dart';
import 'package:flutter/material.dart';

class ProductEditorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Product"),
      ),
      body: ProductForm(),
    );
  }
}

class ProductForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ProductFormState();
  }
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();

  Product _product = Product();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(hintText: 'Product name'),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter product name';
              }
            },
            onSaved: (value) => setState(() => _product.name = value),
          ),
          Text('Nutritions'),
          NumberFormField(
            fieldName: 'Fat',
            messageWhenEmpty: 'Please enter amount of fat',
            onSaved: (value) => setState(() => _product.fat = value),
          ),
          NumberFormField(
            fieldName: 'Carbohydrate',
            messageWhenEmpty: 'Please enter amount of carbohydrate',
            onSaved: (value) => setState(() => _product.carbohydrates = value),
          ),
          NumberFormField(
            fieldName: 'Protein',
            messageWhenEmpty: 'Please enter amount of protein',
            onSaved: (value) => setState(() => _product.protein = value),
          ),
          RaisedButton(
            child: Text('Submit'),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                Navigator.pop(context, _product);
              }
            },
          )
        ],
      ),
    );
  }
}

class NumberFormField extends StatelessWidget {
  final String fieldName;
  final String messageWhenEmpty;
  final FormFieldSetter<double> onSaved;

  const NumberFormField(
      {Key key, this.fieldName, this.messageWhenEmpty, this.onSaved})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        decoration: InputDecoration(hintText: fieldName),
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value.isEmpty) {
            return messageWhenEmpty;
          }

          var num = double.tryParse(value);
          if (num == null) {
            return 'Only numbers allowed';
          }

          if (num < 0) {
            return 'Only numbers bigger then 0 allowed';
          }
        },
        onSaved: (value) {
          double num = double.parse(value);
          onSaved(num);
        });
  }
}
