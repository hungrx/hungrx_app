import 'package:flutter/material.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedbackOption {
  final String title;
  final List<String>? additionalOptions;
  final String whatsappMessage;

  FeedbackOption({
    required this.title,
    this.additionalOptions,
    required this.whatsappMessage,
  });
}

class FeedbackBottomSheet extends StatefulWidget {
  final String phoneNumber;

  const FeedbackBottomSheet({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<FeedbackBottomSheet> createState() => _FeedbackBottomSheetState();
}

class _FeedbackBottomSheetState extends State<FeedbackBottomSheet> {
  int? selectedOptionIndex;
  bool showAdditionalOptions = false;
  
  final List<FeedbackOption> feedbackOptions = [
    FeedbackOption(
      title: 'Report a problem',
      additionalOptions: [
        'Share logs to help us debug the issue',
        'Include Screenshot',
      ],
      whatsappMessage: 'Hello HungrX team, I would like to report a problem: ',
    ),
    FeedbackOption(
      title: 'Share an idea',
      whatsappMessage: 'Hello HungrX team, I have a suggestion: ',
    ),
    FeedbackOption(
      title: 'Appreciate the Team',
      whatsappMessage: 'Hello HungrX team, I want to appreciate: ',
    ),
  ];

  Future<void> _launchWhatsApp() async {
    if (selectedOptionIndex == null) return;

    final option = feedbackOptions[selectedOptionIndex!];
    final message = Uri.encodeComponent(option.whatsappMessage);
    final url = 'https://wa.me/${widget.phoneNumber}?text=$message';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch WhatsApp')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1C1C1E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'How can we help you?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(color: AppColors.buttonColors, height: 1),
          const SizedBox(height: 10,),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: feedbackOptions.length,
            itemBuilder: (context, index) {
              final option = feedbackOptions[index];
              final isSelected = selectedOptionIndex == index;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C2C2E),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? AppColors.buttonColors : Colors.transparent,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        leading: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? AppColors.buttonColors : Colors.grey,
                              width: 2,
                            ),
                            color: isSelected ? AppColors.buttonColors : Colors.transparent,
                          ),
                          child: isSelected
                              ? const Icon(Icons.check, size: 16, color: Colors.white)
                              : null,
                        ),
                        title: Text(
                          option.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            selectedOptionIndex = index;
                            showAdditionalOptions = option.additionalOptions != null;
                          });
                        },
                      ),
                      if (isSelected && option.additionalOptions != null)
                        Container(
                          margin: const EdgeInsets.only(left: 56, right: 16, bottom: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3C3C3E),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: option.additionalOptions!.map((subOption) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: AppColors.buttonColors,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Icon(
                                        Icons.check,
                                        size: 16,
                                        color: AppColors.buttonColors,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        subOption,
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 
                MediaQuery.of(context).padding.bottom + 16),
            child: ElevatedButton(
              onPressed: selectedOptionIndex != null ? _launchWhatsApp : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                  side: BorderSide(
                    color:  Colors.grey.withOpacity(0.5),
                    width: 2,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Chat with HungrX team',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color:  Colors.grey,
                    ),
                  ),
                  if (selectedOptionIndex != null) ...[
                    const SizedBox(width: 8),
                    Image.asset(
                      'assets/icons/whatsapp_icon.png',
                      width: 24,
                      height: 24,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}