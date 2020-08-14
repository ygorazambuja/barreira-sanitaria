import 'package:cpfcnpj/cpfcnpj.dart';

class CpfFormatter {
  final String cpf;

  CpfFormatter({
    this.cpf,
  });

  String call() {
    return CPF.format(cpf);
  }
}
