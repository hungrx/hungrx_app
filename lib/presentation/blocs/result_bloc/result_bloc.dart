import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/core/utils/api_exception.dart';
import 'package:hungrx_app/data/repositories/tdee_repository.dart';
import 'package:hungrx_app/presentation/blocs/result_bloc/result_event.dart';
import 'package:hungrx_app/presentation/blocs/result_bloc/result_state.dart';


class TDEEBloc extends Bloc<TDEEEvent, TDEEState> {
  final TDEERepository repository;

  TDEEBloc(this.repository) : super(TDEEInitial()) {
    on<CalculateTDEE>(_onCalculateTDEE);
  }

  Future<void> _onCalculateTDEE(
    CalculateTDEE event,
    Emitter<TDEEState> emit,
  ) async {
    emit(TDEELoading());
    try {
      final result = await repository.calculateMetrics(event.userId);
      emit(TDEELoaded(result));
    } on ApiException catch (e) {
      emit(TDEEError(e.message));
    } catch (e) {
      emit(TDEEError('Unexpected error occurred: $e'));
    }
  }

  @override
  Future<void> close() {
    repository.dispose();
    return super.close();
  }
}