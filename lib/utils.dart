import 'package:flutter/material.dart';

TextFormField createTextField(TextEditingController controller,String name,Icon icon,
        {bool isObscure = false}) =>
    TextFormField(
      controller: controller,
      obscureText: isObscure,
      
      decoration: InputDecoration(prefixIcon: icon,labelText:name,hintText: name,border: OutlineInputBorder()),
    );
bool checkNullTextController(Map<String,TextEditingController> controller){
  for (TextEditingController item in controller.values) {
    if(item.text.isEmpty){
      return true;
    }
  }
  return false;
}
SnackBar createSnackbar(String message)=>SnackBar(
  content: Container(
    height: 25,
    child:Center(child:Text(message))
  ),
);