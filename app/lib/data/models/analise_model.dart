import 'dart:convert';

import '../../core/constants.dart';

/// Resultado de uma análise de CV (on-device ou mock).
class AnaliseResult {
  final Modo modo;
  final int? contagemFrutos;
  final Map<Maturacao, int>? maturacao;
  final int? estimativaFrutos;
  final SaudeArvore? saude;
  final DiagnosticoDoenca? doenca;
  final double confianca;
  final bool mock;

  const AnaliseResult({
    required this.modo,
    required this.confianca,
    this.contagemFrutos,
    this.maturacao,
    this.estimativaFrutos,
    this.saude,
    this.doenca,
    this.mock = false,
  });

  Map<String, dynamic> toJson() => {
        'modo': modo.name,
        'contagemFrutos': contagemFrutos,
        'maturacao': maturacao?.map((k, v) => MapEntry(k.name, v)),
        'estimativaFrutos': estimativaFrutos,
        'saude': saude?.name,
        'doenca': doenca?.name,
        'confianca': confianca,
        'mock': mock,
      };

  factory AnaliseResult.fromJson(Map<String, dynamic> j) => AnaliseResult(
        modo: Modo.values.byName(j['modo'] as String),
        confianca: (j['confianca'] as num).toDouble(),
        contagemFrutos: j['contagemFrutos'] as int?,
        maturacao: (j['maturacao'] as Map<String, dynamic>?)
            ?.map((k, v) => MapEntry(Maturacao.values.byName(k), v as int)),
        estimativaFrutos: j['estimativaFrutos'] as int?,
        saude: j['saude'] == null ? null : SaudeArvore.values.byName(j['saude'] as String),
        doenca: j['doenca'] == null ? null : DiagnosticoDoenca.values.byName(j['doenca'] as String),
        mock: j['mock'] as bool? ?? false,
      );
}

/// Análise persistida localmente (SQLite).
class AnaliseModel {
  final int? id;
  final Variedade variedade;
  final Modo modo;
  final DateTime data;
  final String? imagePath;
  final AnaliseResult resultado;

  const AnaliseModel({
    this.id,
    required this.variedade,
    required this.modo,
    required this.data,
    this.imagePath,
    required this.resultado,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'variedade': variedade.name,
        'modo': modo.name,
        'data': data.toIso8601String(),
        'imagem_path': imagePath,
        'resultado': jsonEncode(resultado.toJson()),
      };

  factory AnaliseModel.fromMap(Map<String, dynamic> m) => AnaliseModel(
        id: m['id'] as int?,
        variedade: Variedade.values.byName(m['variedade'] as String),
        modo: Modo.values.byName(m['modo'] as String),
        data: DateTime.parse(m['data'] as String),
        imagePath: m['imagem_path'] as String?,
        resultado: AnaliseResult.fromJson(
            jsonDecode(m['resultado'] as String) as Map<String, dynamic>),
      );
}

/// Estado da sessão de análise em andamento (Riverpod).
class AnaliseSessionState {
  final Variedade? variedade;
  final Modo? modo;
  final String? imagePath;
  final AnaliseResult? resultado;
  final bool processing;

  const AnaliseSessionState({
    this.variedade,
    this.modo,
    this.imagePath,
    this.resultado,
    this.processing = false,
  });

  AnaliseSessionState copyWith({
    Variedade? variedade,
    Modo? modo,
    String? imagePath,
    AnaliseResult? resultado,
    bool? processing,
  }) =>
      AnaliseSessionState(
        variedade: variedade ?? this.variedade,
        modo: modo ?? this.modo,
        imagePath: imagePath ?? this.imagePath,
        resultado: resultado ?? this.resultado,
        processing: processing ?? this.processing,
      );
}
