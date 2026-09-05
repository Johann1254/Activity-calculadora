/// Modelos de datos usados por la lógica de la calculadora.
///
/// Se separan de `calculadora_logic.dart` porque no son cálculo en sí,
/// son las estructuras que representan resultados y errores.

/// Resultado de una operación que incluye un valor principal y un residuo.
/// Se usa tanto para la división como para la raíz.
///
/// Se usa `num` (no `int`) porque ahora ambas operaciones aceptan
/// valores decimales, así que el residuo puede tener decimales
/// (ej: dividir 10.5 entre 3 deja residuo 1.5).
class ResultadoConResiduo {
  final num valorPrincipal;
  final num residuo;

  ResultadoConResiduo(this.valorPrincipal, this.residuo);

  @override
  String toString() => 'Resultado: $valorPrincipal, Residuo: $residuo';
}

/// Resultado del análisis de números primos.
class ResultadoPrimos {
  final bool primerEsPrimo;
  final bool segundoEsPrimo;
  final String mensaje;

  ResultadoPrimos(this.primerEsPrimo, this.segundoEsPrimo, this.mensaje);

  @override
  String toString() => mensaje;
}

/// Excepción personalizada para división entre cero.
class DivisionPorCeroException implements Exception {
  final String mensaje;
  DivisionPorCeroException([this.mensaje = 'No se puede dividir entre cero']);

  @override
  String toString() => mensaje;
}
