import 'package:flutter/material.dart';
import 'package:story_app/ui/add_story_page.dart';
import 'package:story_app/widget/card_story_widget.dart';

class ListStoryPage extends StatelessWidget {
  const ListStoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Story'),
        actions: [
          IconButton(
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddStoryPage(),
                  ),
                );
              },
              icon: const Icon(Icons.add),
          ),
          IconButton(
              onPressed: (){},
              icon: const Icon(Icons.settings),
          ),
          IconButton(
            onPressed: (){},
            icon: const Icon(Icons.logout),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: const CardStoryWidget(),
      ),
    );
  }
}
