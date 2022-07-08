
import 'package:intl/intl.dart';

String doubleFormat(double value){
  final rs = NumberFormat.currency(locale: "pt_BR", symbol: "", name: "Real");
  return rs.format(value); // retorna string já com "R$ 12.620,21"
}

String reaisFormat(double value){
  final rs = NumberFormat.currency(locale: "pt_BR", symbol: "R\$", name: "Real");
  return rs.format(value);
}

double forceDouble(String value){
  final rs = NumberFormat.currency(locale: "pt_BR", symbol: "", name: "Real");
  return rs.parse(value);
}