// Purpose: This file contains the ComponentsSettingsItem widget which is used to display a user's profile picture and name in a card format.
/*
 * Modified from https://github.com/babstrap/babstrap_settings_screen (babstrap_settings_screen)
 * Licensed under the MIT license
 * Please support the original developer by starring the repository
*/

import 'package:flutter/material.dart';

class SettingsScreenUtils {
  static double? settingsGroupIconSize;
  static TextStyle? settingsGroupTitleStyle;
}

class IconStyle {
  Color? iconsColor;
  bool? withBackground;
  Color? backgroundColor;
  double? borderRadius;

  IconStyle({
    this.iconsColor = Colors.white,
    this.withBackground = true,
    this.backgroundColor = Colors.blue,
    this.borderRadius = 8,
  });
}

class SettingsItem extends StatefulWidget {
  final IconData icon;
  final IconStyle? iconStyle;
  final String title;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final ValueChanged<dynamic>? onChange;
  final Map<String, dynamic>? values;
  final String selected;
  final Color? backgroundColor;

  SettingsItem({
    required this.icon,
    this.iconStyle,
    required this.title,
    this.titleStyle,
    this.subtitleStyle,
    this.backgroundColor,
    required this.selected,
    required this.values,
    this.onChange,
  });

  @override
  _SettingsItemState createState() => _SettingsItemState();
}

class _SettingsItemState extends State<SettingsItem> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
        color: widget.backgroundColor,
        child: ListTile(
          leading: (widget.iconStyle != null &&
                  widget.iconStyle!.withBackground!)
              ? Container(
                  decoration: BoxDecoration(
                    color: widget.iconStyle!.backgroundColor,
                    borderRadius:
                        BorderRadius.circular(widget.iconStyle!.borderRadius!),
                  ),
                  padding: EdgeInsets.all(5),
                  child: Icon(
                    widget.icon,
                    size: SettingsScreenUtils.settingsGroupIconSize,
                    color: widget.iconStyle!.iconsColor,
                  ),
                )
              : Padding(
                  padding: EdgeInsets.all(5),
                  child: Icon(
                    widget.icon,
                    size: SettingsScreenUtils.settingsGroupIconSize,
                  ),
                ),
          title: Text(
            widget.title,
            style: widget.titleStyle ?? TextStyle(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: DropdownButton<String>(
            alignment: Alignment.centerRight,
            underline: Container(),
            value: widget.values!.keys.firstWhere(
              (key) => widget.values![key] == widget.selected,
              orElse: () => widget.selected,
            ),
            items: widget.values!.keys.map((String key) {
              return DropdownMenuItem<String>(
                value: key,
                child: Text(widget.values![key]),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                widget.onChange!(newValue);
              });
            },
            // },
          ),
        ),
      ),
    );
  }
}
