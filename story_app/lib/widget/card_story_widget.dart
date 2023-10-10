import 'package:flutter/material.dart';

class CardStoryWidget extends StatelessWidget {
  final String photo;
  final String name;
  final String description;
  final Function() onTap;

  const CardStoryWidget({
    super.key,
    required this.photo,
    required this.name,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    var owlPhoto =
        'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg';

    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        splashColor: const ColorScheme.light().primary.withAlpha(30),
        highlightColor: const ColorScheme.light().primary.withAlpha(30),
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              photo,
              height: 150,
              cacheWidth: 512,
              cacheHeight: 512,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name),
                  const SizedBox(height: 10),
                  Text(
                    description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
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
