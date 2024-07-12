import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/src/theme.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          width: double.infinity,
          //height: double.infinity,
          alignment: const Alignment(0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //const SizedBox(height: 80),
              const SizedBox(
                width: double.infinity,
                height: 150,
                child: Image(
                  fit: BoxFit.fitHeight,
                  image: AssetImage('assets/images/drawly.png'),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                child: Text(
                  'Bring your artistic imagination to life with Drawly.',
                  style: AppTheme.text18(),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),

              //REGISTER
              InkWell(
                child: AppTheme.blackButtonContainer('Continue'),
                onTap: () {
                  context.go('/welcome/addprofile');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
