import 'package:flutter/material.dart';
import 'package:flutter_srpg_app/controllers/posicao_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

final appKey = GlobalKey();

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: appKey,
      appBar: AppBar(
        title: const Column(
          children: [
            Text(
              'Minha localização',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.white),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0A6D92),
        elevation: 0,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(32),
        )),
      ),
      body: Container(
        margin: const EdgeInsets.all(16),
        // padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
                color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))
          ],
        ),
        child: ChangeNotifierProvider<PosicaoController>(
          create: (context) => PosicaoController(),
          child: Builder(builder: (context) {
            final local = context.watch<PosicaoController>();

            return ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                    target: LatLng(local.lat, local.long), zoom: 30),
                zoomControlsEnabled: false,
                mapType: MapType.normal,
                myLocationEnabled: true,
                onMapCreated: local.onMapCreated,
                markers: local.markers,
              ),
            );
          }),
        ),
      ),
      extendBody: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        backgroundColor: const Color(0xFF0A6D92),
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      bottomNavigationBar: ClipRRect(
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
      ),
    );
  }
}
