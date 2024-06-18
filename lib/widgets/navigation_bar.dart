import 'package:flutter/material.dart';
import 'package:flutter_srpg_app/pages/evento/adicionar_evento_page_1.dart';
import 'package:get/get.dart';

class SRPGNavigationBar extends StatefulWidget {
  const SRPGNavigationBar({Key? key}) : super(key: key);

  @override
  _SRPGNavigationBarState createState() => _SRPGNavigationBarState();
}

class _SRPGNavigationBarState extends State<SRPGNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
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
                      onPressed: () => Get.toNamed('/home'),
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
                    const SizedBox(
                        width: 50), // Espaço para o FloatingActionButton
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
        ),
        // Posicionando o FloatingActionButton no centro da BottomAppBar
        Positioned(
          bottom: 10,
          left: MediaQuery.of(context).size.width / 2 - 28,
          child: FloatingActionButton(
            onPressed: () {
              Get.off(() => const AdicionarEventoPage1());
            },
            backgroundColor: Colors.white,
            shape: const CircleBorder(),
            child: const Icon(
              Icons.add,
              color: Color(0xFF0A6D92),
            ),
          ),
        ),
      ],
    );
  }
}
