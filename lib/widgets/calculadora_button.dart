import 'package:flutter/material.dart';

/// Botón de acción reutilizable para las operaciones de la calculadora.
///
/// Diseñado a propósito para "sobresaltar" del resto de la interfaz:
/// color sólido, texto en negrita y esquinas suavemente redondeadas,
/// en contraste con los campos de texto simples de la pantalla.
class CalculadoraButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color color;
  final VoidCallback onPressed;

  /// Si es true, el botón ocupa todo el ancho disponible.
  final bool ancho;

  const CalculadoraButton({
    super.key,
    required this.label,
    required this.color,
    required this.onPressed,
    this.icon,
    this.ancho = false,
  });

  @override
  Widget build(BuildContext context) {
    final boton = ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        elevation: 2,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[Icon(icon, size: 18), const SizedBox(width: 8)],
          Flexible(
            child: Text(
              label,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );

    return ancho ? SizedBox(width: double.infinity, child: boton) : boton;
  }
}
