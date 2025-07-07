import 'package:flutter/material.dart';
import 'package:inspired_blog_panel/utils/functions.dart';

class SideBar extends StatefulWidget {
  const SideBar({
    super.key,
    required this.currentIndex,
    this.onTap,
    this.leadingBuilder,
    this.trailingBuilder,
  });

  final int currentIndex;
  final Function(int index)? onTap;
  final Widget Function(bool collapsed)? leadingBuilder;
  final Widget Function(bool collapsed)? trailingBuilder;

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  bool showMenu = true;
  bool collaped = false;
  int currentIndex = 0;

  Widget collapseToggle() {
    return ListTile(
      leading: Icon(
        collaped ? Icons.arrow_forward : Icons.arrow_back,
        color: Colors.black,
      ),
      hoverColor: Colors.black,
      textColor: Colors.black,
      title: collaped
          ? null
          : const Text(
              "Collapse",
              style: TextStyle(fontSize: 13),
            ),
      onTap: () {
        setState(() {
          collaped = !collaped;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
        crossFadeState:
            showMenu ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        duration: const Duration(milliseconds: 320),
        firstChild: const SizedBox.shrink(),
        secondChild: AnimatedContainer(
            width: collaped ? 70 : 200,
            duration: const Duration(milliseconds: 200),
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              // border: const Border(right: BorderSide(color: Colors.black12)),
              color: context.surfaceColor,
            ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        const SizedBox(height: 10),
                        widget.leadingBuilder?.call(collaped) ??
                            const SizedBox(height: 10),
                        SideBarTile(
                            icon: Icons.bookmarks,
                            title: "Magazines",
                            isSelected: currentIndex == 0,
                            isCollapsed: collaped,
                            onTap: () {
                              setState(() {
                                currentIndex = 0;
                              });
                              widget.onTap?.call(currentIndex);
                            }),
                        SideBarTile(
                            icon: Icons.category,
                            title: "Entertainments",
                            isSelected: currentIndex == 1,
                            isCollapsed: collaped,
                            onTap: () {
                              setState(() {
                                currentIndex = 1;
                              });
                              widget.onTap?.call(currentIndex);
                            }),
                        SideBarTile(
                            icon: Icons.image,
                            title: "Slide Images",
                            isSelected: currentIndex == 2,
                            isCollapsed: collaped,
                            onTap: () {
                              setState(() {
                                currentIndex = 2;
                              });
                              widget.onTap?.call(currentIndex);
                            }),
                        SideBarTile(
                            icon: Icons.bar_chart,
                            title: "Advertisements",
                            isSelected: currentIndex == 3,
                            isCollapsed: collaped,
                            onTap: () {
                              setState(() {
                                currentIndex = 3;
                              });
                              widget.onTap?.call(currentIndex);
                            }),
                         SideBarTile(
                        icon: Icons.edit_document,
                        title: "Documents",
                        isSelected: currentIndex == 4,
                        isCollapsed: collaped,
                        onTap: () {
                          setState(() {
                            currentIndex = 4;
                          });
                          widget.onTap?.call(currentIndex);
                        }),
                        SideBarTile(
                            icon: Icons.settings,
                            title: "Settings",
                            isSelected: currentIndex == 5,
                            isCollapsed: collaped,
                            onTap: () {
                              setState(() {
                                currentIndex = 5;
                              });
                              widget.onTap?.call(currentIndex);
                            }),
                      ],
                    ),
                  ),
                  widget.trailingBuilder?.call(collaped) ??
                      const SizedBox.shrink(),
                  collapseToggle(),
                ])));
  }
}

class SideBarTile extends StatefulWidget {
  const SideBarTile(
      {super.key,
      required this.icon,
      required this.isCollapsed,
      required this.title,
      required this.isSelected,
      required this.onTap});

  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isCollapsed;

  @override
  State<SideBarTile> createState() => _SideBarTileState();
}

class _SideBarTileState extends State<SideBarTile> {
  bool hovering = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      onHover: (value) => setState(() => hovering = value),
      child: Container(
          height: 35,
          width: widget.isCollapsed ? null : double.maxFinite,
          margin: widget.isCollapsed
              ? const EdgeInsets.symmetric(horizontal: 6, vertical: 4)
              : const EdgeInsets.symmetric(vertical: 4).copyWith(right: 6),
          decoration: BoxDecoration(
            borderRadius: widget.isCollapsed
                ? BorderRadius.circular(10)
                : const BorderRadius.horizontal(right: Radius.circular(40)),
            color: widget.isSelected
                ? context.highlightColor
                : hovering
                    ? const Color(0xfff1f1f1)
                    : Colors.transparent,
          ),
          alignment: Alignment.center,
          child: widget.isCollapsed
              ? Icon(widget.icon,
                  color: widget.isSelected ? context.primary : Colors.black)
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(width: 10),
                    Icon(widget.icon,
                        color:
                            widget.isSelected ? context.primary : Colors.black),
                    const SizedBox(width: 20),
                    Text(
                      widget.title,
                      style: TextStyle(
                          color: widget.isSelected
                              ? context.primary
                              : Colors.black),
                    )
                  ],
                )),
    );
  }
}
