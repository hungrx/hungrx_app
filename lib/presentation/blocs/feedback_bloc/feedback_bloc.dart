import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/data/Models/dashboad_screen/feedback_model.dart';
import 'package:hungrx_app/domain/usecases/submit_feedback_usecase.dart';
import 'package:hungrx_app/presentation/blocs/feedback_bloc/feedback_event.dart';
import 'package:hungrx_app/presentation/blocs/feedback_bloc/feedback_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  final SubmitFeedbackUseCase _submitFeedbackUseCase;

  FeedbackBloc(this._submitFeedbackUseCase) : super(FeedbackInitial()) {
    on<SubmitFeedbackEvent>(_onSubmitFeedback);
  }

  Future<void> _onSubmitFeedback(
    SubmitFeedbackEvent event,
    Emitter<FeedbackState> emit,
  ) async {
    try {
      emit(FeedbackLoading());
      
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');
      
      if (userId == null) {
        emit(FeedbackError('User not logged in'));
        return;
      }

      final feedback = FeedbackModel(
        userId: userId,
        stars: event.rating.round(),
        description: event.description,
      );

      final success = await _submitFeedbackUseCase.execute(feedback);
      
      if (success) {
        emit(FeedbackSuccess());
      } else {
        emit(FeedbackError('Failed to submit feedback'));
      }
    } catch (e) {
      emit(FeedbackError(e.toString()));
    }
  }
}