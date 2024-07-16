import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/src/theme.dart';

class ErrorRoute extends StatelessWidget {
  final GoException? error;
  const ErrorRoute(this.error, {super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('Error: $error');

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              children: [
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    '$error',
                    style: AppTheme.text22ExtraBold(),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Something went wrong',
                    style: AppTheme.text22ExtraBold(),
                  ),
                ),
                const SizedBox(height: 30),
                TextButton(
                  onPressed: () => context.go('/'),
                  child: const Text(
                    'Go Home',
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
