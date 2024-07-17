import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '/providers/user_provider.dart';
import '/src/theme.dart';

class Me extends StatefulWidget {
  const Me({super.key});

  @override
  State<Me> createState() => _MeState();
}

class _MeState extends State<Me> {
  @override
  Widget build(BuildContext context) {
    //Get user drawings from provider
    Map? loggedInUser = context.watch<UserProvider>().loggedinUser;

    return loggedInUser != null
        ? SafeArea(
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                systemOverlayStyle: SystemUiOverlayStyle.light,
                title: const Text('My Profile'),
              ),
              body: SingleChildScrollView(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          'Your name: ${loggedInUser['fullname']}',
                          style: AppTheme.text22ExtraBold(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          'Your age: ${loggedInUser['age']}',
                          style: AppTheme.text22ExtraBold(),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          )
        : Container();
  }
}
