import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:google_fonts/google_fonts.dart';

String selectedValue = 'All Courses';

class DropdownButtonWidget extends StatefulWidget {
  final List<String> items;
  final Function(String) onChanged;

  DropdownButtonWidget({Key? key, required this.items, required this.onChanged}) : super(key: key);

  @override
  _DropdownButtonWidgetState createState() => _DropdownButtonWidgetState();
}

class _DropdownButtonWidgetState extends State<DropdownButtonWidget> {
  

  List<DropdownMenuItem<String>> _addDividersAfterItems(List<String> items) {
    final List<DropdownMenuItem<String>> menuItems = [];
    for (final String item in items) {
      menuItems.addAll(
        [
          DropdownMenuItem<String>(
            value: item,
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(
                  item,
                  style: GoogleFonts.inter(textStyle: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.secondary,
                  )
                  ),)
            ),
          ),
          // If it's the last item, we will not add Divider after it.
          if (item != items.last)
            const DropdownMenuItem<String>(
              enabled: false,
              child: Divider(),
            ),
        ],
      );
    }
    return menuItems;
  }

  List<double> _getCustomItemsHeights() {
    final List<double> itemsHeights = [];
    for (int i = 0; i < (widget.items.length * 2) - 1; i++) {
      if (i.isEven) {
        itemsHeights.add(40);
      }
      // Dividers indexes will be the odd indexes
      if (i.isOdd) {
        itemsHeights.add(4);
      }
    }
    return itemsHeights;
  }

  @override
  void initState() {
    super.initState();
    selectedValue = widget.items.first;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
        // side: BorderSide(color: Colors.black),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          // barrierColor: Colors.black,
          isExpanded: true,
          items: _addDividersAfterItems(widget.items),
          value: selectedValue,
          onChanged: (String? value) {
            setState(() {
              selectedValue = value!;
            });
            widget.onChanged(selectedValue);
          },
          buttonStyleData: const ButtonStyleData(
            padding: EdgeInsets.symmetric(horizontal: 10),
            height: 40,
            width: 140,
          ),
          dropdownStyleData: const DropdownStyleData(
            maxHeight: 200,
          ),
          menuItemStyleData: MenuItemStyleData(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            customHeights: _getCustomItemsHeights(),
          ),
          iconStyleData: const IconStyleData(
            iconSize: 30,
            openMenuIcon: Icon(Icons.arrow_drop_up,),
          ),
        ),
      ),
    );
  }
}