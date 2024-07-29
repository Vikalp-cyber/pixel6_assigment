import 'package:flutter/material.dart';
import 'package:pixel6_assigment/utils/size.dart';

class DropDownContainer extends StatelessWidget {
  String title;
  DropDownContainer({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(), borderRadius: BorderRadius.circular(10)),
      width: ScreenUtil.width(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FittedBox(fit: BoxFit.scaleDown, child: Text(title)),
          const Icon(
            Icons.keyboard_arrow_down_outlined,
            color: Colors.red,
          ),
        ],
      ),
    );
  }
}
