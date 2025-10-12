import 'package:flutter/material.dart';

class ProfileButtonAppBar extends StatelessWidget {
  const ProfileButtonAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      maxRadius: 20,
      backgroundColor: Colors.transparent,
      child: Icon(Icons.person, color: Colors.white),
    );
  }
}
