import 'package:flutter/material.dart';

class EmptyResult extends StatelessWidget {
  final String leading;
  final String secondary;
  final double iconSize;
  final IconData iconData;

  const EmptyResult(
      {Key key, this.leading, this.secondary, this.iconSize, this.iconData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            iconData ?? Icons.list_alt,
            size: iconSize ?? 64,
            color: Colors.grey[350],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              leading ?? 'Empty Result',
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
          ),
          Flexible(
              child: Text(
            secondary ?? '',
            textAlign: TextAlign.center,
          ))
        ],
      ),
    );
  }
}
