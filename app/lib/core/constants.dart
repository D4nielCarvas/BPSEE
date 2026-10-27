// Constantes e enums do BPSEE (Etapa 10/11)
// Variedade é input manual do usuário (não saída de CV). Modo define o gating de análise.

enum Variedade {
  pera('Laranja Pêra'),
  valenciaAmericana('Valência Americana'),
  valencia('Valência'),
  peraRio('Pêra Rio'),
  natal('Natal'),
  hamlin('Hamlin'),
  folhaMurcha('Folha Murcha');

  const Variedade(this.label);
  final String label;
}

enum Modo {
  arvore('Árvore'),
  folha('Folha'),
  fruta('Fruta');

  const Modo(this.label);
  final String label;

  /// Modos folha/fruta usam o modelo de doença.
  bool get isDoenca => this == Modo.folha || this == Modo.fruta;
}

enum Maturacao { verde, maduro, sobremaduro }

enum SaudeArvore { saudavel, doente }

enum DiagnosticoDoenca { saudavel, greening }
