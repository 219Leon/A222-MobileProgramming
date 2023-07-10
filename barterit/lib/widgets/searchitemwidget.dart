import 'package:flutter/material.dart';

class SearchItemWidget extends StatefulWidget {
  final Color color;
  final IconData icon;
  final String text;

  const SearchItemWidget(this.color, this.icon, this.text);

  @override
  State<SearchItemWidget> createState() => _SearchItemWidgetState();
}

class _SearchItemWidgetState extends State<SearchItemWidget> {
  late double screenHeight, screenWidth;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: screenWidth * 0.25,
      height: screenWidth * 0.25,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(
              color: Color.fromARGB(255, 214, 214, 214),
              width: 2.0,
            )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              widget.icon,
              size: screenWidth * 0.1,
              color: widget.color == Colors.black38 && isDark
                  ? Colors.grey
                  : widget.color,
            ),
            Text(
              widget.text,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
