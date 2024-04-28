import 'dart:io';

import 'package:camera_camera/camera_camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_srpg_app/controllers/posicao_controller.dart';
import 'package:flutter_srpg_app/models/posto.dart';
import 'package:flutter_srpg_app/pages/preview_page.dart';
import 'package:flutter_srpg_app/services/data_service.dart';
import 'package:flutter_srpg_app/services/localizacao_service.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class AulaBottomSheet extends StatefulWidget {
  Aula aula;

  AulaBottomSheet({super.key, required this.aula});

  @override
  _AulaBottomSheetState createState() => _AulaBottomSheetState();
}

class _AulaBottomSheetState extends State<AulaBottomSheet> {
  File arquivo = File('');
  LocalizacaoService service = LocalizacaoService();

  showPreview(file) async {
    file = await Get.to(() => PreviewPage(file: file));

    if (file != null) {
      setState(() => arquivo = file);

      // se o arquivo for diferente de nulo, significa que o usuário já fez a biometria
      // nesse caso, pegaria a imagem e enviaria para o backend verificar, enquanto isso, mostraria o botão de check-in carregando
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    final local = context.watch<PosicaoController>();
    local.getPosicao();
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Text(
                widget.aula.nome,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Text(widget.aula.descricao),
            ),
            Text(DataService().calcularDuracaoEventoEmHoras(
                widget.aula.dataInicio, DateTime.now())),
            Text('Você está a ${LocalizacaoService().calcularDistancia(
              {'latitude': local.lat, 'longitude': local.long, 'elevacao': 0},
              {
                'latitude': widget.aula.latitude,
                'longitude': widget.aula.longitude,
                'elevacao': 0
              },
            )}km de distância desse evento.'), // Novo texto adicionado
            Padding(
              padding: const EdgeInsets.only(top: 24, bottom: 24),
              // child: CircularProgressIndicator()
              child: ElevatedButton(
                onPressed: () {
                  handleCheckIn();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A6D92),
                ),
                child: const Text('Realizar check-in',
                    style: TextStyle(
                      color: Colors.white,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  handleCheckIn() {
    Get.to(() => CameraCamera(onFile: ((file) => showPreview(file))));
    // Adicione a lógica do botão aqui
    // 1 - liberar o check-in apenas se a pessoa estiver a 30m de distância
    // 2 - se o botão for clicado, seguir para tela de biometria.
    print('Realizar biometria');
  }
}
