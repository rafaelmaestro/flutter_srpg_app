import 'package:flutter/material.dart';
import 'package:flutter_srpg_app/models/posto.dart';

class AulasRepository extends ChangeNotifier {
  final List<Aula> _aulas = [
    Aula(
      nome: 'Aula de Gestão de TI',
      descricao: 'Turma 0004729A / 19h - 23h',
      foto:
          'https://lh5.googleusercontent.com/p/AF1QipP_xnSi5-sp9slSuMpSx-JlmvwvHGL1VJ_JcOGX=w408-h306-k-no',
      latitude: -22.350808540575265,
      longitude: -49.03217930003996,
      dataInicio: DateTime.now().subtract(const Duration(hours: 2)),
    )
  ];

  List<Aula> get aulas => _aulas;
}
