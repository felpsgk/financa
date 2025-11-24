import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../auth/auth_provider.dart';
import '../../movements/controllers/movements_controller.dart';
import '../../../core/navigation_provider.dart';
import '../../../widgets/bottom_nav.dart';

class SummaryPage extends ConsumerWidget {
  const SummaryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int? userId = ref.watch(userIdProvider);
    final MovementsState state = ref.watch(movementsControllerProvider);
    ref.read(bottomNavIndexProvider.notifier).state = 0;

    // Cálculos
    final double income = state.movements
        .where((m) => m.valor >= 0)
        .fold(0.0, (p, m) => p + m.valor);
    final double expense = state.movements
        .where((m) => m.valor < 0)
        .fold(0.0, (p, m) => p + m.valor.abs());
    final double balance = income - expense;

    return Scaffold(
      appBar: AppBar(title: const Text('Resumo')),
      body: SingleChildScrollView(
        // <--- SCROLL AQUI
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // ==== LINHA DE CARDS ====
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _SummaryCard(
                        title: 'Ganhos',
                        value: income,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 16),
                      _SummaryCard(
                        title: 'Gastos',
                        value: expense,
                        color: Colors.red,
                      ),
                      const SizedBox(width: 16),
                      _SummaryCard(
                        title: 'Saldo',
                        value: balance,
                        color: Colors.indigo,
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // ==== GRÁFICO DE PIZZA INTERATIVO ====
                  SizedBox(
                    height: 260,
                    child: SummaryPieChart(income: income, expense: expense),
                  ),

                  const SizedBox(height: 32),

                  // ==== GRÁFICO DE BARRAS ====
                  SizedBox(
                    height: 220,
                    child: BarChart(
                      BarChartData(
                        barTouchData: BarTouchData(
                          enabled: true,
                          touchTooltipData: BarTouchTooltipData(
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              final value = rod.toY;

                              return BarTooltipItem(
                                'R\$ ${value.toStringAsFixed(2)}',
                                const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                switch (value.toInt()) {
                                  case 0:
                                    return const Text("Ganhos");
                                  case 1:
                                    return const Text("Gastos");
                                  case 2:
                                    return const Text("Saldo");
                                  default:
                                    return const Text("");
                                }
                              },
                            ),
                          ),
                        ),
                        barGroups: [
                          BarChartGroupData(
                            x: 0,
                            barRods: [
                              BarChartRodData(
                                toY: income,
                                color: Colors.green,
                                width: 22,
                              ),
                            ],
                          ),
                          BarChartGroupData(
                            x: 1,
                            barRods: [
                              BarChartRodData(
                                toY: expense,
                                color: Colors.red,
                                width: 22,
                              ),
                            ],
                          ),
                          BarChartGroupData(
                            x: 2,
                            barRods: [
                              BarChartRodData(
                                toY: balance,
                                color: Colors.indigo,
                                width: 22,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  ElevatedButton(
                    onPressed: () => _load(ref, userId),
                    child: const Text('Atualizar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  void _load(WidgetRef ref, int? userId) {
    if (userId == null) return;
    ref.read(movementsControllerProvider.notifier).load();
  }
}

// ===============================================
// CARD
// ===============================================
class _SummaryCard extends StatelessWidget {
  final String title;
  final double value;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(
                value.toStringAsFixed(2),
                style: Theme.of(
                  context,
                ).textTheme.headlineSmall?.copyWith(color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ===============================================
// PIE CHART INTERATIVO
// ===============================================
class SummaryPieChart extends StatefulWidget {
  final double income;
  final double expense;

  const SummaryPieChart({
    super.key,
    required this.income,
    required this.expense,
  });

  @override
  State<SummaryPieChart> createState() => _SummaryPieChartState();
}

class _SummaryPieChartState extends State<SummaryPieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: PieChart(
        PieChartData(
          pieTouchData: PieTouchData(
            touchCallback: (event, pieTouchResponse) {
              setState(() {
                if (!event.isInterestedForInteractions ||
                    pieTouchResponse == null ||
                    pieTouchResponse.touchedSection == null) {
                  touchedIndex = -1;
                  return;
                }
                touchedIndex =
                    pieTouchResponse.touchedSection!.touchedSectionIndex;
              });
            },
          ),
          borderData: FlBorderData(show: false),
          sectionsSpace: 0,
          centerSpaceRadius: 40,
          sections: showingSections(),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    final isIncomeTouched = touchedIndex == 0;
    final isExpenseTouched = touchedIndex == 1;

    final total = widget.income + widget.expense;
    final incomePct = total == 0 ? 0 : (widget.income / total) * 100;
    final expensePct = total == 0 ? 0 : (widget.expense / total) * 100;
    final praForaTxt = 2.00;
    return [
      PieChartSectionData(
        color: Colors.green,
        value: widget.income,
        radius: isIncomeTouched ? 70 : 60,

        title:
            "R\$ ${widget.income.toStringAsFixed(2)}\n${incomePct.toStringAsFixed(1)}%",
        titleStyle: const TextStyle(
          color: Colors.black, // 🔥 TEXTO PRETO
          fontSize: 16, // 🔥 TEXTO MAIOR
          fontWeight: FontWeight.bold,
        ),

        titlePositionPercentageOffset: praForaTxt, // 🔥 EMPURRA O TEXTO PRA FORA
      ),

      PieChartSectionData(
        color: Colors.red,
        value: widget.expense,
        radius: isExpenseTouched ? 70 : 60,

        title:
            "R\$ ${widget.expense.toStringAsFixed(2)}\n${expensePct.toStringAsFixed(1)}%",
        titleStyle: const TextStyle(
          color: Colors.black, // 🔥 TEXTO PRETO
          fontSize: 16, // 🔥 TEXTO MAIOR
          fontWeight: FontWeight.bold,
        ),

        titlePositionPercentageOffset: praForaTxt, // 🔥 EMPURRA O TEXTO PRA FORA
      ),
    ];
  }
}
