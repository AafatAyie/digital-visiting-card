import 'package:flutter/material.dart';

class TextEnterField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final double width;
  final FocusNode node;
  final TextInputAction action;
  final TextInputType inputType;
  final FocusNode nextNode;
  final TextCapitalization capital;
  final int maxlines;

  TextEnterField(
      {this.controller,
      this.maxlines,
      this.labelText,
      this.inputType,
      this.action,
      this.capital,
      this.hintText,
      @required this.node,
      this.nextNode,
      this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width == null ? MediaQuery.of(context).size.width * 0.95 : width,
      child: TextFormField(
          maxLines: maxlines == null ? 1 : maxlines,
          textCapitalization:
              capital == null ? TextCapitalization.sentences : capital,
          controller: controller,
          keyboardType: inputType == null ? TextInputType.text : inputType,
          textInputAction: action == null ? TextInputAction.next : action,
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(nextNode);
          },
          focusNode: node,
          validator: (val) {
            if (val.trim().length < 2 || val.isEmpty) {
              return "Name too short";
            } else if (val.trim().length > 30) {
              return "Name too long";
            } else if (val.length == 0) {
              return "Name can't be empty";
            } else {
              return null;
            }
          },
          // textCapitalization: capital == null ||  capital == false ?TextCapitalization.none : TextCapitalization.words,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'WorkSans',
              fontSize: 20),
          decoration: InputDecoration(
            // border: OutlineInputBorder(),
            labelText: labelText,
            labelStyle: TextStyle(
              fontSize: 15.0,
              color: Colors.grey,
              fontFamily: 'WorkSans',
            ),
            hintText: hintText == null ? "Enter Text" : hintText,
            hintStyle: TextStyle(fontFamily: 'WorkSans', color: Colors.grey),
          )),
    );
  }
}
