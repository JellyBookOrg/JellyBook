// Purpose: This file contains the SmallUserCard widget which is used to display a user's profile picture and name in a card format.
/*
 * Modified from https://github.com/babstrap/babstrap_settings_screen (babstrap_settings_screen)
 * Licensed under the MIT license
 * Please support the original developer by starring the repository
*/
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class SimpleUserCard extends StatelessWidget {
  final Color? cardColor;
  final double? cardRadius;
  final Color? backgroundMotifColor;
  final VoidCallback? onTap;
  final String? userName;
  final Color? userNameColor;
  final Widget? userMoreInfo;
  final Widget? subtitle; // Modified to Text widget
  final ImageProvider userProfilePic;

  SimpleUserCard({
    required this.cardColor,
    this.cardRadius = 30,
    required this.userName,
    this.backgroundMotifColor = Colors.white,
    this.userMoreInfo,
    this.userNameColor = Colors.white,
    required this.userProfilePic,
    required this.onTap,
    this.subtitle, // Modified to Text widget
  });

  @override
  Widget build(BuildContext context) {
    var mediaQueryHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: mediaQueryHeight / 6,
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(cardRadius!),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomLeft,
              child: CircleAvatar(
                radius: 100,
                backgroundColor: backgroundMotifColor!.withOpacity(.1),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: 400,
                backgroundColor: backgroundMotifColor!.withOpacity(.05),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: CircleAvatar(
                          radius: mediaQueryHeight / 15,
                          backgroundImage: userProfilePic,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              userName!,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 26,
                                color: userNameColor,
                              ),
                            ),
                            if (userMoreInfo != null) ...[
                              userMoreInfo!,
                            ],
                            if (subtitle != null) ...[
                              // Display subtitle Text widget if provided
                              const SizedBox(height: 5),
                              subtitle!,
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
