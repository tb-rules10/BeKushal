import 'package:flutter/material.dart';

class CustomRadioButton extends StatefulWidget {
  final String label;
  final bool isSelected;
  final ValueChanged<bool> onChanged;

  CustomRadioButton({required this.label, required this.isSelected, required this.onChanged});

  @override
  _CustomRadioButtonState createState() => _CustomRadioButtonState();
}

class _CustomRadioButtonState extends State<CustomRadioButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onChanged(!widget.isSelected);
      },
      child: Row(
        children: [
          Container(
            width: 24.0,
            height: 24.0,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border.all(
                width: 2.0,
                color: widget.isSelected ? Colors.blue : Colors.grey,
              ),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Center(
              child: widget.isSelected
                  ? Container(
                width: 16.0,
                height: 16.0,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(2.0),
                ),
              )
                  : null,
            ),
          ),
          SizedBox(width: 8.0),
          Text(widget.label,style: TextStyle(fontFamily: 'Outfit',),),
        ],
      ),
    );
  }
}
