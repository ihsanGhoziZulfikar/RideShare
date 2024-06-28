import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

class MyBottomNavigationBarItem {
  final String title;
  final String icon;
  MyBottomNavigationBarItem({
    required this.title,
    required this.icon,
  });
}

class MyBottomNavigationBar extends StatefulWidget {
  final List<MyBottomNavigationBarItem> children;
  int curentIndex;
  final Color? backgroundColor;
  final Function(int)? onTap;

  MyBottomNavigationBar({
    super.key,
    required this.children,
    required this.curentIndex,
    this.backgroundColor,
    required this.onTap,
  });

  @override
  State<MyBottomNavigationBar> createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: Theme.of(context).colorScheme.primary,
      ),
      margin: const EdgeInsets.only(bottom: 10, left: 25, right: 25),
      height: 65,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          widget.children.length,
          (index) => NavBarItem(
            index: index,
            item: widget.children[index],
            selected: widget.curentIndex == index,
            onTap: () {
              setState(() {
                widget.curentIndex = index;
                widget.onTap!(widget.curentIndex);
              });
            },
          ),
        ),
      ),
    );
  }
}

class NavBarItem extends StatefulWidget {
  final MyBottomNavigationBarItem item;
  final int index;
  bool selected;
  final Function onTap;
  final Color? backgroundColor;

  NavBarItem({
    super.key,
    required this.item,
    this.selected = false,
    required this.onTap,
    this.backgroundColor,
    required this.index,
  });

  @override
  State<NavBarItem> createState() => _NavBarItemState();
}

class _NavBarItemState extends State<NavBarItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      child: AnimatedContainer(
        margin: const EdgeInsets.all(8),
        duration: const Duration(milliseconds: 300),
        constraints: BoxConstraints(minWidth: widget.selected ? 70 : 56),
        height: 56,
        decoration: BoxDecoration(
          color: widget.selected
              ? widget.backgroundColor ?? Colors.white
              : Colors.transparent,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Iconify(
              widget.item.icon,
              color: widget.selected
                  ? Theme.of(context).primaryColor
                  : Colors.white,
              size: 33,
            ),
          ],
        ),
      ),
    );
  }
}
