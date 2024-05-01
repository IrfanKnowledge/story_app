import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:story_app/provider/material_theme_provider.dart';

class CardStory extends StatelessWidget {
  final String photo;
  final String name;
  final String description;
  final Function() onTap;

  const CardStory({
    super.key,
    required this.photo,
    required this.name,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorSchemeCustom =
        context.read<MaterialThemeProvider>().currentSelected;
    final textTheme = Theme.of(context).textTheme;

    return Stack(
      children: [
        Card(
          clipBehavior: Clip.hardEdge,
          color: colorSchemeCustom.surfaceContainerLow,
          surfaceTintColor: colorSchemeCustom.surfaceContainerLow,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.network(
                headers: const {
                  'Connection': 'keep-alive',
                },
                photo,
                height: 150,
                cacheWidth: 512,
                cacheHeight: 512,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return SizedBox(
                    height: 150,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.image,
                    size: 100,
                  );
                },
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: textTheme.bodyLarge!.copyWith(
                        color: colorSchemeCustom.onSurface,
                      ),
                    ),
                    const Gap(4),
                    Text(
                      description,
                      style: textTheme.bodyMedium!.copyWith(
                        color: colorSchemeCustom.onSurfaceVariant,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned.fill(
          child: Card(
            clipBehavior: Clip.hardEdge,
            color: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            child: InkWell(
              splashColor: colorSchemeCustom.primary.withOpacity(0.10),
              highlightColor: colorSchemeCustom.primary.withOpacity(0.10),
              onTap: onTap,
            ),
          ),
        ),
      ],
    );
  }
}
