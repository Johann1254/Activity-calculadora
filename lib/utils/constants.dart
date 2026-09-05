import 'package:flutter/material.dart';

/// Constantes visuales y de texto de la calculadora.
///
/// Concepto de color: "cuaderno de cálculo" — tonos salvia/papel con
/// acentos de tinta verde-azulada y ocre. Ni tan opaco como un gris de
/// oficina, ni tan brillante como el naranja/verde de una calculadora
/// de teléfono.
class AppColors {
  AppColors._();

  // Fondo general y superficies
  static const Color background = Color(0xFFEFF3EE);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFD9DED7);

  // Texto
  static const Color inkPrimary = Color(0xFF2B2E2C);
  static const Color inkSecondary = Color(0xFF6E756F);

  // Acento principal (operaciones básicas y avanzadas)
  static const Color accentTeal = Color(0xFF3A6B63);
  static const Color accentTealDark = Color(0xFF2A4F49);

  // Acento secundario (función extra: números primos)
  static const Color accentOchre = Color(0xFFC98A3E);
  static const Color accentOchreDark = Color(0xFF9C6A2C);

  // Estado de error
  static const Color errorRust = Color(0xFFB1503A);
}

/// Textos fijos reutilizados en más de un lugar de la pantalla,
/// para no repetir strings sueltos dentro de los widgets.
class AppStrings {
  AppStrings._();

  static const String labelNumero1 = 'Número 1';
  static const String labelNumero2 = 'Número 2';
  static const String botonCerrar = 'Cerrar';
  static const String tituloEntradaInvalida = 'Entrada inválida';

  static const String mensajeDosNumeros =
      'Ingresa dos números válidos en ambos campos.';
  static const String mensajeDosEnteros =
      'Para esta operación, ingresa dos números enteros (sin decimales).';
}
