import 'package:flutter/material.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:star_rating/star_rating.dart';

class FeedbackDialog extends StatefulWidget {
  final Function(double rating, String feedback) onSubmit;

  const FeedbackDialog({super.key, required this.onSubmit});

  @override
  FeedbackDialogState createState() => FeedbackDialogState();
}

class FeedbackDialogState extends State<FeedbackDialog> {
  double _rating = 0;
  final TextEditingController _feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.grey[800],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
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
                    'We appreciate your feedbacks',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'we are always looking for ways to improve your experience please take a moment to evaluate and tell us what you think.',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 20),
              StarRating(
                length: 5,
                  starSize: 30,
                rating: _rating,
                onRaitingTap: (rating) => setState(() => _rating = rating),
                // onRatingChanged: (rating) => setState(() => _rating = rating),
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
                maxLines: 10,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  widget.onSubmit(_rating, _feedbackController.text);
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: AppColors.buttonColors,
                  minimumSize: const Size(200, 50),
                ),
                child: const Text('Submit My Feedback'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
