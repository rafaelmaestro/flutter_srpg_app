import 'package:flutter/material.dart';

class SRPGNavigationBar extends StatelessWidget {
  const SRPGNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
      child: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: const Color(0xFF0A6D92),
        child: IconTheme(
          data: const IconThemeData(color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.home,
                    color: Colors.white,
                  ),
                  onPressed: () => print('Home Button pressed!'),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.class_,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    print('List Button pressed!');
                  },
                ),
                const SizedBox(width: 50),
                IconButton(
                  icon: const Icon(
                    Icons.event,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    print('Person Button pressed!');
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    print('Person Button pressed!');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
