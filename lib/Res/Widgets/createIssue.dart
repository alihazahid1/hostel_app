import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonContainer extends StatelessWidget {
  final Map<String, dynamic>? userData;

  const CommonContainer({Key? key, this.userData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.green, width: 3),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Row(
          mainAxisSize: MainAxisSize.min, // Allow Row to take minimum height
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Flexible Column for user info
            Flexible(
              flex: 2,
              fit: FlexFit.loose,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // Shrink-wrap the column
                children: [
                  Text(
                    userData?['firstName']?.toUpperCase().substring(
                            0,
                            (userData!['firstName'].length > 15
                                ? 15
                                : userData!['firstName'].length)) ??
                        '',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Room No: ${userData?["room"] ?? 'N/A'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Block: ${userData?["block"] ?? 'N/A'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),

            // Flexible Column for the create issue button
            Flexible(
              flex: 1,
              fit: FlexFit.loose,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min, // Shrink-wrap the column
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.toNamed("/createIssueScreen");
                    },
                    child: Container(
                      height: 70,
                      width: 70,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green,
                      ),
                      child: const Icon(
                        Icons.note_add_outlined,
                        size: 33,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Create Issues',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
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
