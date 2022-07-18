import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppOutlineButton extends StatelessWidget {
  final String asset;
  final VoidCallback onTap;
  const AppOutlineButton({required this.asset, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Image.asset(
          asset,
          height: 24,
        ),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
      ),
      borderSide: const BorderSide(color: Colors.black12),
      onPressed: onTap,
    );
  }
}