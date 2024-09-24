import 'package:flutter/material.dart';

class AuthscreenGradient {
 static Decoration? authGradient = const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Color(0xFF000000),
              Color(0xFF121212),
            ]));
}