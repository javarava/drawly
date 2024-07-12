import 'package:flutter/material.dart';
import '/src/theme.dart';

class Me extends StatefulWidget {
  const Me({super.key});

  @override
  State<Me> createState() => _MeState();
}

class _MeState extends State<Me> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          width: double.infinity,
          alignment: const Alignment(0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                child: Text(
                  'My Profile',
                  style: AppTheme.text28ExtraBold(),
                ),
              ),
              const SizedBox(height: 40),
              Container(
                width: double.infinity,
                color: drawlyCream.shade300,
                height: 120,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
