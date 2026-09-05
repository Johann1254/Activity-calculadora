import 'package:flutter/material.dart';

import '../logic/calculadora_logic.dart';
import '../models/calculadora.dart';
import '../utils/constants.dart';
import '../widgets/calculadora_button.dart';
import '../widgets/calculadora_display.dart';

/// Pantalla principal de la calculadora.
///
/// Flujo: el usuario escribe dos números y presiona el botón de la
/// operación que quiere ejecutar. El resultado (o el error) se muestra
/// en una hoja modal que sube desde abajo, en vez de un texto fijo
/// en pantalla, para que cada cálculo se sienta como un evento propio.
class CalculadoraView extends StatefulWidget {
  const CalculadoraView({super.key});

  @override
  State<CalculadoraView> createState() => _CalculadoraViewState();
}

class _CalculadoraViewState extends State<CalculadoraView> {
  final CalculatorLogic _logic = CalculatorLogic();

  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();

  // Para el logaritmo natural: indica a cuál de los dos números aplicarlo.
  bool _usarPrimerNumeroParaLn = true;

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }

  // ==================== HELPERS DE LECTURA/FORMATO ====================

  double? _parseDouble(String texto) => double.tryParse(texto.trim());

  int? _parseInt(String texto) => int.tryParse(texto.trim());

  /// Formatea un double sin decimales innecesarios (ej: 8.0 -> "8").
  String _formatear(double valor) {
    if (valor == valor.roundToDouble() && valor.abs() < 1e15) {
      return valor.toInt().toString();
    }
    return valor.toStringAsFixed(4);
  }

  // ==================== RESULTADO EN MODAL ====================

  void _mostrarResultado({
    required String titulo,
    required String mensaje,
    bool esError = false,
  }) {
    final color = esError ? AppColors.errorRust : AppColors.accentTeal;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(24, 22, 24, 28),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border(top: BorderSide(color: color, width: 4)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    esError ? Icons.error_outline : Icons.check_circle_outline,
                    color: color,
                    size: 28,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      titulo,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.inkPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                mensaje,
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'monospace',
                  height: 1.5,
                  color: AppColors.inkPrimary,
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    AppStrings.botonCerrar,
                    style: TextStyle(color: color, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _mostrarEntradaInvalida(String detalle) {
    _mostrarResultado(
      titulo: AppStrings.tituloEntradaInvalida,
      mensaje: detalle,
      esError: true,
    );
  }

  // ==================== HANDLERS DE CADA OPERACIÓN ====================

  void _onSumar() {
    final a = _parseDouble(_controller1.text);
    final b = _parseDouble(_controller2.text);
    if (a == null || b == null) {
      _mostrarEntradaInvalida(AppStrings.mensajeDosNumeros);
      return;
    }
    final resultado = _logic.sumar(a, b);
    _mostrarResultado(
      titulo: 'Suma',
      mensaje: '${_formatear(a)} + ${_formatear(b)} = ${_formatear(resultado)}',
    );
  }

  void _onRestar() {
    final a = _parseDouble(_controller1.text);
    final b = _parseDouble(_controller2.text);
    if (a == null || b == null) {
      _mostrarEntradaInvalida(AppStrings.mensajeDosNumeros);
      return;
    }
    final resultado = _logic.restar(a, b);
    _mostrarResultado(
      titulo: 'Resta',
      mensaje: '${_formatear(a)} - ${_formatear(b)} = ${_formatear(resultado)}',
    );
  }

  void _onMultiplicar() {
    final a = _parseDouble(_controller1.text);
    final b = _parseDouble(_controller2.text);
    if (a == null || b == null) {
      _mostrarEntradaInvalida(AppStrings.mensajeDosNumeros);
      return;
    }
    final resultado = _logic.multiplicar(a, b);
    _mostrarResultado(
      titulo: 'Multiplicación',
      mensaje: '${_formatear(a)} × ${_formatear(b)} = ${_formatear(resultado)}',
    );
  }

  void _onDividir() {
    final a = _parseDouble(_controller1.text);
    final b = _parseDouble(_controller2.text);
    if (a == null || b == null) {
      _mostrarEntradaInvalida(AppStrings.mensajeDosNumeros);
      return;
    }
    try {
      final resultado = _logic.dividir(a, b);
      _mostrarResultado(
        titulo: 'División',
        mensaje:
            '${_formatear(a)} ÷ ${_formatear(b)}\n\n'
            'Cociente: ${resultado.valorPrincipal}\n'
            'Residuo: ${_formatear(resultado.residuo.toDouble())}',
      );
    } on DivisionPorCeroException catch (e) {
      _mostrarResultado(
        titulo: 'Error de división',
        mensaje: e.mensaje,
        esError: true,
      );
    }
  }

  void _onPotenciar() {
    final exponente = _parseDouble(_controller1.text);
    final base = _parseDouble(_controller2.text);
    if (exponente == null || base == null) {
      _mostrarEntradaInvalida(
        'Ingresa dos números válidos.\nNúmero 1 = exponente, Número 2 = base.',
      );
      return;
    }
    final resultado = _logic.potenciar(exponente, base);
    _mostrarResultado(
      titulo: 'Potenciación',
      mensaje:
          'Base: ${_formatear(base)}\n'
          'Exponente: ${_formatear(exponente)}\n\n'
          'Resultado: ${_formatear(resultado)}',
    );
  }

  void _onRaiz() {
    final indice = _parseInt(_controller1.text);
    final radicando = _parseDouble(_controller2.text);
    if (indice == null || radicando == null) {
      _mostrarEntradaInvalida(
        'Número 1 (índice) debe ser un entero.\nNúmero 2 (radicando) puede tener decimales.',
      );
      return;
    }
    try {
      final resultado = _logic.raiz(indice, radicando);
      _mostrarResultado(
        titulo: 'Raíz',
        mensaje:
            'Índice: $indice   Radicando: ${_formatear(radicando)}\n\n'
            'Raíz entera: ${resultado.valorPrincipal}\n'
            'Residuo: ${_formatear(resultado.residuo.toDouble())}',
      );
    } on ArgumentError catch (e) {
      _mostrarResultado(
        titulo: 'Error en la raíz',
        mensaje: e.message.toString(),
        esError: true,
      );
    }
  }

  void _onLogaritmo() {
    final n1 = _parseDouble(_controller1.text);
    final n2 = _parseDouble(_controller2.text);
    if (n1 == null || n2 == null) {
      _mostrarEntradaInvalida(AppStrings.mensajeDosNumeros);
      return;
    }
    try {
      final resultado = _logic.logaritmoNatural(
        n1,
        n2,
        usarPrimero: _usarPrimerNumeroParaLn,
      );
      final numeroUsado = _usarPrimerNumeroParaLn ? n1 : n2;
      _mostrarResultado(
        titulo: 'Logaritmo natural',
        mensaje: 'ln(${_formatear(numeroUsado)}) = ${_formatear(resultado)}',
      );
    } on ArgumentError catch (e) {
      _mostrarResultado(
        titulo: 'Error en el logaritmo',
        mensaje: e.message.toString(),
        esError: true,
      );
    }
  }

  void _onPrimos() {
    final a = _parseInt(_controller1.text);
    final b = _parseInt(_controller2.text);
    if (a == null || b == null) {
      _mostrarEntradaInvalida(
        'Ingresa dos números enteros para comprobar si son primos.',
      );
      return;
    }
    final resultado = _logic.compararPrimos(a, b);
    _mostrarResultado(titulo: 'Números primos', mensaje: resultado.mensaje);
  }

  // ==================== WIDGETS AUXILIARES DE LA UI ====================

  Widget _tituloSeccion(String texto) {
    return Text(
      texto,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppColors.inkSecondary,
      ),
    );
  }

  Widget _filaDeBotones(List<Widget> botones) {
    return Row(
      children: [
        for (int i = 0; i < botones.length; i++) ...[
          if (i != 0) const SizedBox(width: 12),
          Expanded(child: botones[i]),
        ],
      ],
    );
  }

  Widget _chipSeleccionLn() {
    return Row(
      children: [
        Expanded(
          child: ChoiceChip(
            label: const Text('Usar número 1'),
            selected: _usarPrimerNumeroParaLn,
            onSelected: (_) => setState(() => _usarPrimerNumeroParaLn = true),
            selectedColor: AppColors.accentTeal,
            backgroundColor: AppColors.surface,
            side: const BorderSide(color: AppColors.border),
            labelStyle: TextStyle(
              fontWeight: FontWeight.w600,
              color: _usarPrimerNumeroParaLn
                  ? Colors.white
                  : AppColors.inkPrimary,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ChoiceChip(
            label: const Text('Usar número 2'),
            selected: !_usarPrimerNumeroParaLn,
            onSelected: (_) => setState(() => _usarPrimerNumeroParaLn = false),
            selectedColor: AppColors.accentTeal,
            backgroundColor: AppColors.surface,
            side: const BorderSide(color: AppColors.border),
            labelStyle: TextStyle(
              fontWeight: FontWeight.w600,
              color: !_usarPrimerNumeroParaLn
                  ? Colors.white
                  : AppColors.inkPrimary,
            ),
          ),
        ),
      ],
    );
  }

  // ==================== BUILD ====================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Calculadora'),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.inkPrimary,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ---------- Campos de entrada ----------
              CalculadoraDisplay(
                controller: _controller1,
                label: AppStrings.labelNumero1,
              ),
              const SizedBox(height: 14),
              CalculadoraDisplay(
                controller: _controller2,
                label: AppStrings.labelNumero2,
              ),

              const SizedBox(height: 30),

              // ---------- Operaciones básicas ----------
              _tituloSeccion('Operaciones básicas'),
              const SizedBox(height: 12),
              _filaDeBotones([
                CalculadoraButton(
                  label: 'Suma',
                  icon: Icons.add,
                  color: AppColors.accentTeal,
                  onPressed: _onSumar,
                ),
                CalculadoraButton(
                  label: 'Resta',
                  icon: Icons.remove,
                  color: AppColors.accentTeal,
                  onPressed: _onRestar,
                ),
              ]),
              const SizedBox(height: 12),
              _filaDeBotones([
                CalculadoraButton(
                  label: 'Multiplicación',
                  icon: Icons.close,
                  color: AppColors.accentTeal,
                  onPressed: _onMultiplicar,
                ),
                CalculadoraButton(
                  label: 'División',
                  icon: Icons.percent,
                  color: AppColors.accentTeal,
                  onPressed: _onDividir,
                ),
              ]),

              const SizedBox(height: 30),

              // ---------- Funciones avanzadas ----------
              _tituloSeccion('Funciones avanzadas'),
              const SizedBox(height: 12),
              _filaDeBotones([
                CalculadoraButton(
                  label: 'Potenciación',
                  icon: Icons.superscript,
                  color: AppColors.accentTealDark,
                  onPressed: _onPotenciar,
                ),
                CalculadoraButton(
                  label: 'Raíz',
                  icon: Icons.square_foot,
                  color: AppColors.accentTealDark,
                  onPressed: _onRaiz,
                ),
              ]),
              const SizedBox(height: 14),
              _chipSeleccionLn(),
              const SizedBox(height: 10),
              CalculadoraButton(
                label: 'Logaritmo natural',
                icon: Icons.functions,
                color: AppColors.accentTealDark,
                onPressed: _onLogaritmo,
                ancho: true,
              ),

              const SizedBox(height: 30),

              // ---------- Función extra: números primos ----------
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.accentOchre, width: 1.4),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.auto_awesome,
                          color: AppColors.accentOchreDark,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Función extra',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.accentOchreDark,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Comprueba si el número 1 y el número 2 son primos.',
                      style: TextStyle(
                        color: AppColors.inkSecondary,
                        fontSize: 13.5,
                      ),
                    ),
                    const SizedBox(height: 14),
                    CalculadoraButton(
                      label: 'Comprobar primos',
                      icon: Icons.workspace_premium,
                      color: AppColors.accentOchre,
                      onPressed: _onPrimos,
                      ancho: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
