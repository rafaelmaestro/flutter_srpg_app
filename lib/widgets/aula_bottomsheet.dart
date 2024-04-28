import 'package:flutter/material.dart';
import 'package:flutter_srpg_app/controllers/posicao_controller.dart';
import 'package:flutter_srpg_app/models/posto.dart';
import 'package:flutter_srpg_app/services/data_service.dart';
import 'package:flutter_srpg_app/services/localizacao_service.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class AulaBottomSheet extends StatelessWidget {
  Aula aula;
  AulaBottomSheet({super.key, required this.aula});
  LocalizacaoService service = LocalizacaoService();

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
                aula.nome,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Text(aula.descricao),
            ),
            Text(DataService()
                .calcularDuracaoEventoEmHoras(aula.dataInicio, DateTime.now())),
            Text('Você está a ${LocalizacaoService().calcularDistancia(
              {'latitude': local.lat, 'longitude': local.long, 'elevacao': 0},
              {
                'latitude': aula.latitude,
                'longitude': aula.longitude,
                'elevacao': 0
              },
            )}km de distância desse evento.'), // Novo texto adicionado
            Padding(
              padding: const EdgeInsets.only(top: 24, bottom: 24),
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
    // Adicione a lógica do botão aqui
    // 1 - liberar o check-in apenas se a pessoa estiver a 30m de distância
    // 2 - se o botão for clicado, seguir para tela de biometria.
    print('Realizar biometria');
  }
}
