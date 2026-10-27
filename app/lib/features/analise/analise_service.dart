import 'dart:io';
import 'dart:math';

import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

import '../../core/constants.dart';
import '../../data/models/analise_model.dart';

/// Serviço de análise: faz o GATING por modo e executa a inferência on-device.
///
/// Enquanto os modelos .tflite ainda não existem (pré-treino), cai no modo MOCK,
/// que gera resultados plausíveis para validar o fluxo do app ponta a ponta.
/// A inferência real (NMS + mapeamento de classes) é finalizada na Etapa 13/14.
class AnaliseService {
  Future<AnaliseResult> analisar(File imageFile, Modo modo, Variedade variedade) async {
    final asset = modo.isDoenca
        ? 'assets/models/modelo_doenca.tflite'
        : 'assets/models/modelo_arvore.tflite';

    try {
      final interpreter = await Interpreter.fromAsset(asset);
      final result = await _runInference(interpreter, imageFile, modo);
      interpreter.close();
      return result;
    } catch (_) {
      // Sem modelo embarcado ainda -> mock.
      return _mock(imageFile, modo);
    }
  }

  // Real on-device. Shape de saída depende do export; parser completo na Etapa 14.
  Future<AnaliseResult> _runInference(
      Interpreter interpreter, File imageFile, Modo modo) async {
    final bytes = await imageFile.readAsBytes();
    final decoded = img.decodeImage(bytes);
    if (decoded == null) return _mock(imageFile, modo);

    const inputSize = 640; // padrão YOLOv8
    final resized =
        img.copyResize(decoded, width: inputSize, height: inputSize);

    final input = List.generate(
      1,
      (_) => List.generate(
        inputSize,
        (y) => List.generate(inputSize, (x) {
          final p = resized.getPixel(x, y);
          return [p.r / 255.0, p.g / 255.0, p.b / 255.0];
        }),
      ),
    );

    final output = List.filled(1, List.filled(1, 0.0));
    try {
      interpreter.run(input, output);
    } catch (_) {
      return _mock(imageFile, modo);
    }

    // TODO(Etapa 14): NMS + mapear saídas para classes do modelo real.
    return _mock(imageFile, modo);
  }

  AnaliseResult _mock(File imageFile, Modo modo) {
    final rand = Random(
        imageFile.lengthSync() + DateTime.now().millisecondsSinceEpoch % 1000);
    final confianca = 0.70 + rand.nextDouble() * 0.29; // 0.70–0.99
    final conf = double.parse(confianca.toStringAsFixed(2));

    if (modo.isDoenca) {
      final doenca = rand.nextDouble() < 0.5
          ? DiagnosticoDoenca.saudavel
          : DiagnosticoDoenca.greening;
      return AnaliseResult(modo: modo, doenca: doenca, confianca: conf, mock: true);
    }

    final contagem = 5 + rand.nextInt(30);
    final verde = (contagem * 0.4).round();
    final maduro = (contagem * 0.4).round();
    final sobremaduro = contagem - verde - maduro;
    return AnaliseResult(
      modo: modo,
      contagemFrutos: contagem,
      maturacao: {
        Maturacao.verde: verde,
        Maturacao.maduro: maduro,
        Maturacao.sobremaduro: sobremaduro,
      },
      estimativaFrutos: (contagem * 1.2).round(),
      saude: rand.nextDouble() < 0.8 ? SaudeArvore.saudavel : SaudeArvore.doente,
      confianca: conf,
      mock: true,
    );
  }
}
