class Correios {
  int codigo;
  double valor;
  int prazoEntrega;
  double valorMaoPropria;
  double valorAvisoRecebimento;
  double valorValorDeclarado;
  String entregaDomiciliar;
  String entregaSabado;
  double valorSemAdicionais;

  Correios(
      {this.codigo,
      this.valor = 0,
      this.prazoEntrega = 0,
      this.valorMaoPropria,
      this.valorAvisoRecebimento,
      this.valorValorDeclarado,
      this.entregaDomiciliar,
      this.entregaSabado,
      this.valorSemAdicionais});

  Correios.fromMap(Map<dynamic, dynamic> map) {
    codigo = int.parse(map['Codigo']['\$t']);
    valor = double.parse(map['Valor']['\$t'].replaceAll(',', '.'));
    prazoEntrega = int.parse(map['PrazoEntrega']['\$t']);
    valorMaoPropria =
        double.parse(map['ValorMaoPropria']['\$t'].replaceAll(',', '.'));
    valorAvisoRecebimento =
        double.parse(map['ValorAvisoRecebimento']['\$t'].replaceAll(',', '.'));
    valorValorDeclarado =
        double.parse(map['ValorValorDeclarado']['\$t'].replaceAll(',', '.'));
    entregaDomiciliar = map['EntregaDomiciliar']['\$t'];
    entregaSabado = map['EntregaSabado']['\$t'];
    valorSemAdicionais =
        double.parse(map['ValorSemAdicionais']['\$t'].replaceAll(',', '.'));
  }
}
