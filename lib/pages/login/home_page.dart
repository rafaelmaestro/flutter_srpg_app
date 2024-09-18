import 'package:flutter/material.dart';
import 'package:flutter_srpg_app/controllers/posicao_controller.dart';
import 'package:flutter_srpg_app/widgets/navigation_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final mapKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Column(
          children: [
            Text(
              'Minha Localização',
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
          create: (context) => PosicaoController(loadEventosBool: true),
          child: Builder(builder: (context) {
            final local = context.watch<PosicaoController>();

            return ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: GoogleMap(
                key: mapKey,
                initialCameraPosition: CameraPosition(
                    target: LatLng(local.lat, local.long), zoom: 21),
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
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: const CustomFloatingActionButton(),
      bottomNavigationBar: const SRPGNavigationBar(),
    );
  }
}
