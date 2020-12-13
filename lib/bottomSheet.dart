import 'package:flutter/material.dart';

import 'game.dart';

class BottomSheetWidget extends StatefulWidget {
  @override
  _BottomSheetWidgetState createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      color: Colors.black26,
      child: Wrap(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Настройки', style: TextStyle(fontSize: 22)),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.black, size: 26.0),
                  tooltip: 'Закрыть',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              onChanged: (String value) {
                print('Value changed as "$value"');
              },
              decoration: InputDecoration(
                  hintText: 'Код сервера'
              ),
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              OutlineButton(
                child: const Text('СБРОСИТЬ ВСЕ ДАННЫЕ'),
                onPressed: () {
                  GameHolder.instance.reset();
                },
              ),
              RaisedButton(
                child: const Text('ОК'),
                onPressed: () {

                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}