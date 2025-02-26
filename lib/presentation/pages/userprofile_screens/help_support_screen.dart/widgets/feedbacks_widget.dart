import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/presentation/blocs/feedback_bloc/feedback_bloc.dart';
import 'package:hungrx_app/presentation/blocs/feedback_bloc/feedback_event.dart';
import 'package:hungrx_app/presentation/blocs/feedback_bloc/feedback_state.dart';
import 'package:star_rating/star_rating.dart';

class FeedbackDialog extends StatefulWidget {
  const FeedbackDialog({super.key});

  @override
  FeedbackDialogState createState() => FeedbackDialogState();
}

class FeedbackDialogState extends State<FeedbackDialog> {
  double _rating = 0;
  final TextEditingController _feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<FeedbackBloc, FeedbackState>(
      listener: (context, state) {
        if (state is FeedbackSuccess) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Thank you for your feedback!')),
          );
        } else if (state is FeedbackError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.message}')),
          );
        }
      },
      child: Dialog(
        backgroundColor: Colors.grey[800],
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Container(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'We appreciate \nyour feedback',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                StarRating(
                  length: 5,
                  starSize: 30,
                  rating: _rating,
                  onRaitingTap: (rating) => setState(() => _rating = rating),
                  color: AppColors.buttonColors,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _feedbackController,
                  decoration: InputDecoration(
                    hintText: 'What can we do to improve your experience?',
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey[700],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  maxLines: 4,
                ),
                const SizedBox(height: 20),
                BlocBuilder<FeedbackBloc, FeedbackState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: state is FeedbackLoading
                          ? null
                          : () {
                              context.read<FeedbackBloc>().add(
                                    SubmitFeedbackEvent(
                                      rating: _rating,
                                      description: _feedbackController.text,
                                    ),
                                  );
                            },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: AppColors.buttonColors,
                        minimumSize: const Size(200, 50),
                      ),
                      child: state is FeedbackLoading
                          ? const CircularProgressIndicator()
                          : const Text('Submit My Feedback'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
