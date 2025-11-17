import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/movements_repository.dart';
import '../data/movements_api.dart';
import '../models/movement.dart';
import '../../auth/auth_provider.dart';

final movementsRepositoryProvider = Provider<MovementsRepository>((ref) {
  return MovementsRepository(api: const MovementsApi());
});

class MovementsState {
  final List<Movement> movements;
  final String? startDate;
  final String? endDate;
  final bool isLoading;
  final Object? error;

  const MovementsState({
    required this.movements,
    required this.startDate,
    required this.endDate,
    required this.isLoading,
    required this.error,
  });

  MovementsState copyWith({
    List<Movement>? movements,
    String? startDate,
    String? endDate,
    bool? isLoading,
    Object? error,
  }) {
    return MovementsState(
      movements: movements ?? this.movements,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

final movementsControllerProvider = StateNotifierProvider<MovementsController, MovementsState>((ref) {
  return MovementsController(ref);
});

class MovementsController extends StateNotifier<MovementsState> {
  final Ref ref;

  MovementsController(this.ref)
      : super(const MovementsState(movements: [], startDate: null, endDate: null, isLoading: false, error: null));

  Future<void> load() async {
    final int? idpessoa = ref.read(userIdProvider);
    if (idpessoa == null) {
      return;
    }
    state = state.copyWith(isLoading: true, error: null);
    try {
      final MovementsRepository repo = ref.read(movementsRepositoryProvider);
      final List<Movement> items = await repo.getMovements(idpessoa: idpessoa, startDate: state.startDate, endDate: state.endDate);
      state = state.copyWith(movements: items, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }

  void setDateRange({String? startDate, String? endDate}) {
    state = state.copyWith(startDate: startDate, endDate: endDate);
  }
}