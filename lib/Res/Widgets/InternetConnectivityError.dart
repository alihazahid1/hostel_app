import 'package:flutter/material.dart';

class InternetConnectivityError extends StatefulWidget {
  const InternetConnectivityError({super.key});

  @override
  State<InternetConnectivityError> createState() =>
      _InternetConnectivityErrorState();
}

class _InternetConnectivityErrorState extends State<InternetConnectivityError> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Card(
      elevation: 8,
      shadowColor: Colors.grey,
      surfaceTintColor: Colors.white,
      child: Container(
        height: 60,
        width: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: 30,
                width: 30,
                child: CircularProgressIndicator(
                  color: Colors.green,
                )),
            SizedBox(
              width: 20,
            ),
            Text('Please Check Your Internet'),
          ],
        ),
      ),
    ));
  }
}
