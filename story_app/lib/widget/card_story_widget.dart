import 'package:flutter/material.dart';

class CardStoryWidget extends StatelessWidget {
  const CardStoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        splashColor: const ColorScheme.light().primary.withAlpha(30),
        highlightColor: const ColorScheme.light().primary.withAlpha(30),
        onTap: () {},
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
              height: 150,
              cacheWidth: 512,
              cacheHeight: 512,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('This is your Name'),
                  SizedBox(height: 10),
                  Text('This is Your Description but limited'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
