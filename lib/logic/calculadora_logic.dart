import 'dart:math' as math;

import '../models/calculadora.dart';

/// Lógica pura de la calculadora: solo cálculo, sin nada de Flutter.
/// Esto la hace fácil de testear y reutilizar sin depender de la UI.
class CalculatorLogic {
  // ==================== OPERACIONES BÁSICAS ====================

  double sumar(double a, double b) => a + b;

  double restar(double a, double b) => a - b;

  double multiplicar(double a, double b) => a * b;

  /// División con cociente y residuo. Admite decimales en [a] y [b].
  /// El cociente siempre es entero (trunca hacia 0) y el residuo puede
  /// tener decimales si los números ingresados los tienen.
  /// Lanza [DivisionPorCeroException] si [b] es 0.
  ResultadoConResiduo dividir(double a, double b) {
    if (b == 0) {
      throw DivisionPorCeroException();
    }
    final cociente = a ~/ b; // división entera (trunca hacia 0)
    final residuo = a - (cociente * b); // consistente con el cociente truncado
    return ResultadoConResiduo(cociente, residuo);
  }

  // ==================== POTENCIACIÓN ====================

  /// Potenciación: [exponente] es el primer número (la potencia),
  /// [base] es el segundo número.
  /// Resultado = base ^ exponente
  double potenciar(num exponente, num base) {
    return math.pow(base, exponente).toDouble();
  }

  // ==================== RAÍZ ====================

  /// Raíz enésima con residuo. [radicando] admite decimales.
  /// [indice] = primer número (2 = raíz cuadrada, 3 = cúbica, etc.) y se
  /// mantiene entero porque el "grado" de una raíz es conceptualmente un
  /// número entero (no existe una raíz de índice 2.5 en el uso habitual).
  /// [radicando] = segundo número, ahora puede tener decimales.
  /// Retorna la raíz entera (parte entera del resultado real) y el residuo,
  /// que será decimal si el radicando lo es.
  ResultadoConResiduo raiz(int indice, double radicando) {
    if (indice == 0) {
      throw ArgumentError('El índice de la raíz no puede ser 0');
    }
    if (radicando < 0 && indice % 2 == 0) {
      throw ArgumentError(
        'No existe raíz real de índice par para un número negativo',
      );
    }

    // Cálculo aproximado de la raíz real, luego se ajusta a la raíz entera correcta
    final raizAproximada = math.pow(radicando.abs(), 1 / indice);
    int raizEntera = raizAproximada.round();

    // Corrección de errores de precisión de punto flotante
    while (math.pow(raizEntera, indice) > radicando.abs()) {
      raizEntera--;
    }
    while (math.pow(raizEntera + 1, indice) <= radicando.abs()) {
      raizEntera++;
    }

    final residuo = radicando.abs() - math.pow(raizEntera, indice);

    return ResultadoConResiduo(
      radicando < 0 ? -raizEntera : raizEntera,
      residuo,
    );
  }

  // ==================== LOGARITMO NATURAL ====================

  /// Logaritmo natural (ln) de uno de los dos números ingresados.
  /// [usarPrimero] = true aplica ln al primer número, false al segundo.
  double logaritmoNatural(num primero, num segundo, {bool usarPrimero = true}) {
    final numero = usarPrimero ? primero : segundo;
    if (numero <= 0) {
      throw ArgumentError(
        'El logaritmo natural solo está definido para números mayores a 0',
      );
    }
    return math.log(numero);
  }

  // ==================== FUNCIÓN ADICIONAL: NÚMEROS PRIMOS ====================

  /// Determina si un número entero es primo.
  bool esPrimo(int numero) {
    if (numero < 2) return false;
    if (numero == 2) return true;
    if (numero % 2 == 0) return false;
    for (int i = 3; i * i <= numero; i += 2) {
      if (numero % i == 0) return false;
    }
    return true;
  }

  /// Compara si el primer y segundo número son primos y arma un mensaje
  /// contemplando los 3 casos: ambos primos, solo uno primo, ninguno primo.
  ResultadoPrimos compararPrimos(int primero, int segundo) {
    final primerEsPrimo = esPrimo(primero);
    final segundoEsPrimo = esPrimo(segundo);

    String mensaje;
    if (primerEsPrimo && segundoEsPrimo) {
      mensaje = 'Ambos números ($primero y $segundo) son primos.';
    } else if (primerEsPrimo && !segundoEsPrimo) {
      mensaje =
          'Solo el primer número ($primero) es primo. El segundo ($segundo) no lo es.';
    } else if (!primerEsPrimo && segundoEsPrimo) {
      mensaje =
          'Solo el segundo número ($segundo) es primo. El primero ($primero) no lo es.';
    } else {
      mensaje = 'Ninguno de los dos números ($primero y $segundo) es primo.';
    }

    return ResultadoPrimos(primerEsPrimo, segundoEsPrimo, mensaje);
  }
}
