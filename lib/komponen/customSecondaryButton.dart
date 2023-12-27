import 'package:chasier/constans.dart';
import 'package:flutter/material.dart';

class CustomSecondaryButton extends StatelessWidget {
  final Function() onpress;
  final String title;
  CustomSecondaryButton({required this.title, required this.onpress});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: theme == "dark" ? warnaAlertDark : warnaAlertLight,
      borderRadius: BorderRadius.circular(5),
      child: InkWell(
        splashColor: theme == "dark" ? warnaPrimerDark : warnaPrimerLight,
        onTap: onpress,
        child: Container(
          height: 50,
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                  color: theme == "dark" ? warnaTitleDark : warnaTitleLight,
                  fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
