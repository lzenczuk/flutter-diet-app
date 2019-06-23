import 'package:flutter/material.dart';

class RecipeEditorPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RecipeEditorPageState();
  }

}

class _RecipeEditorPageState extends State<RecipeEditorPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}

class _RecipeForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RecipeFormState();
  }

}

class _RecipeFormState extends State<_RecipeForm>{

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(labelText: "Recipe name"),
          )
        ],
      ),
    );
  }

}