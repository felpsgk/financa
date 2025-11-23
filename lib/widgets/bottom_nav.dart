import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/navigation_provider.dart';
import '../features/auth/auth_provider.dart';

class BottomNavBar extends ConsumerWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int index = ref.watch(bottomNavIndexProvider);
    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(0, -2))]),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool showLabels = constraints.maxWidth >= 520;
            return Row(
              children: [
                _NavButton(
                  label: 'Resumo',
                  icon: Icons.dashboard,
                  selected: index == 0,
                  showLabel: showLabels,
                  onTap: () => _go(context, ref, 0, '/summary'),
                ),
                _NavButton(
                  label: 'Movimentações',
                  icon: Icons.list_alt,
                  selected: index == 1,
                  showLabel: showLabels,
                  onTap: () => _go(context, ref, 1, '/movements'),
                ),
                _NavButton(
                  label: 'Nova',
                  icon: Icons.add_circle_outline,
                  selected: index == 2,
                  showLabel: showLabels,
                  onTap: () => _go(context, ref, 2, '/create'),
                ),
                const Spacer(),
                _LogoutButton(showLabel: showLabels),
              ],
            );
          },
        ),
      ),
    );
  }

  void _go(BuildContext context, WidgetRef ref, int idx, String route) {
    HapticFeedback.selectionClick();
    Feedback.forTap(context);
    ref.read(bottomNavIndexProvider.notifier).state = idx;
    if (route == '/create') {
      Navigator.of(context).pushNamed(route);
    } else {
      Navigator.of(context).pushReplacementNamed(route);
    }
  }
}

class _NavButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final bool showLabel;
  final VoidCallback onTap;
  const _NavButton({required this.label, required this.icon, required this.selected, required this.showLabel, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Color color = selected ? scheme.primary : scheme.onSurfaceVariant;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Icon(icon, color: color),
              if (showLabel) const SizedBox(width: 8),
              if (showLabel) Text(label, style: TextStyle(color: color)),
            ],
          ),
        ),
      ),
    );
  }
}

class _LogoutButton extends ConsumerWidget {
  final bool showLabel;
  const _LogoutButton({required this.showLabel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10)),
      onPressed: () async {
        HapticFeedback.selectionClick();
        Feedback.forTap(context);
        final NavigatorState nav = Navigator.of(context);
        final bool? confirm = await showDialog<bool>(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Text('Confirmar saída'),
              content: const Text('Deseja sair e selecionar outro usuário?'),
              actions: [
                TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancelar')),
                FilledButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Sair')),
              ],
            );
          },
        );
        if (confirm == true) {
          ref.read(userIdProvider.notifier).state = null;
          ref.read(bottomNavIndexProvider.notifier).state = 0;
          nav.pushNamedAndRemoveUntil('/login', (route) => false);
        }
      },
      icon: const Icon(Icons.logout),
      label: Text(showLabel ? 'Sair' : ''),
    );
  }
}