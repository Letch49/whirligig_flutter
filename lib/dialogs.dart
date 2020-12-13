import 'package:flutter/material.dart';


class QuestionDialog extends StatelessWidget {
  final String questionName;
  final bool isCloseButtonDisabled;

  QuestionDialog({
    @required this.questionName,
    @required this.isCloseButtonDisabled
  });

  dialogContent(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min, // To make the card compact
        children: <Widget>[
          SizedBox(height: 32.0),
          Text(
            'СЕКТОР',
            style: TextStyle(
              fontSize: 14.0,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            this.questionName,
            style: TextStyle(
              fontSize: 42.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 16.0),
          RaisedButton(
            onPressed: isCloseButtonDisabled ? null : () {Navigator.pop(context);},
            child: const Text('ПРОДОЛЖИТЬ', style: TextStyle(fontSize: 14)),
          ),
          SizedBox(height: 16.0),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0.0,
      backgroundColor: Colors.white,
      child: dialogContent(context),
    );
  }
}