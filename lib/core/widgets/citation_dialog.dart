import 'package:flutter/material.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class CitationDialog extends StatelessWidget {
  final CitationData citation;

  const CitationDialog({
    super.key,
    required this.citation,
  });

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  static void show(BuildContext context, String metricType) {
    final citations = {
      'bmi': CitationData(
        title: 'Body Mass Index (BMI)',
        description:
            'BMI is a measure of body fat based on height and weight calculated as weight(kg) / height(m)².',
        source: 'World Health Organization (WHO)',
        link: 'https://www.hungrx.com/citations.html',
        categories: '''
• Underweight: < 18.5
• Normal weight: 18.5-24.9
• Overweight: 25-29.9
• Obese: ≥ 30''',
        reference:
            'WHO Technical Report Series 854. Geneva: World Health Organization, 1995',
      ),
      'bmr': CitationData(
        title: 'Basal Metabolic Rate (BMR)',
        description:
            '''BMR calculation uses the Mifflin-St Jeor Equation (1990):
• For males: BMR = (10 × weight[kg]) + (6.25 × height[cm]) - (5 × age) + 5
• For females: BMR = (10 × weight[kg]) + (6.25 × height[cm]) - (5 × age) - 161''',
        source: 'Mifflin-St Jeor',
        link: 'https://www.hungrx.com/citations.html',
        reference:
            'Mifflin MD, St Jeor ST, et al. Am J Clin Nutr 1990; 51:241-247',
      ),
      'tdee': CitationData(
        title: 'Total Daily Energy Expenditure (TDEE)',
        description:
            'TDEE is calculated by multiplying BMR with an activity factor.',
        source: 'Harris-Benedict',
        link: 'https://www.hungrx.com/citations.html',
        categories: '''
• Sedentary (1.2) - Little or no exercise
• Lightly active (1.375) - Light exercise 1-3 days/week
• Moderately active (1.55) - Moderate exercise 3-5 days/week
• Very active (1.725) - Heavy exercise 6-7 days/week
• Extra active (1.9) - Very heavy exercise, physical job or training twice per day''',
        reference:
            'Harris JA, Benedict FG. Proc Natl Acad Sci USA 1918; 4(12):370-373',
      ),
      'water_intake': CitationData(
        title: 'Daily Water Intake',
        description: '''Base calculation: 30ml per kg of body weight
• Activity level adjustments: 10-40% increase based on activity
• Age adjustment: 10% increase for individuals over 55''',
        source: 'Institute of Medicine & American College of Sports Medicine',
        link: 'https://www.hungrx.com/citations.html',
        categories: '''
• Adult men: ~3.7 L (15.5 cups)
• Adult women: ~2.7 L (11.5 cups)
• Pregnant women: ~3.0 L (12.5 cups)
• Breastfeeding women: ~3.8 L (16 cups)''',
        reference:
            'Institute of Medicine. Dietary Reference Intakes 2005 & ACSM Med Sci Sports Exerc 2007',
      ),
      'minimum_calories': CitationData(
        title: 'Minimum Daily Caloric Requirements',
        description:
            'Evidence-based minimum daily caloric intake requirements for safe weight management.',
        source: 'National Institute of Health (NIH)',
        link: 'https://www.hungrx.com/citations.html',
        categories: '''
• Minimum for males: 1500 calories per day
• Minimum for females: 1200 calories per day''',
        reference: 'NIH Weight-control Information Network, 2012',
      ),
      'weight_change': CitationData(
        title: 'Weight Change Calculations',
        description: '''Based on energy balance principle:
• 1 kg of body fat ≈ 7700 calories
• Recommended safe weight loss/gain rate: 0.25-0.5 kg per week''',
        source:
            'The Lancet & Journal of the Academy of Nutrition and Dietetics',
        link: 'https://www.hungrx.com/citations.html',
        reference: 'Hall KD, et al. Lancet 2011; 378(9793):826-837',
      ),
      'all_metrics': CitationData(
        title: 'Health Metrics Information',
        description:
            'Comprehensive overview of health measurements and calculations used in your profile.',
        source: 'Multiple Medical Organizations',
        link: 'https://www.hungrx.com/citations.html',
        sections: [
          MetricSection(
            title: 'Body Mass Index (BMI)',
            description: 'BMI is calculated as weight(kg) / height(m)²',
            source: 'World Health Organization (WHO)',
            categories: '''
• Underweight: < 18.5
• Normal weight: 18.5-24.9
• Overweight: 25-29.9
• Obese: ≥ 30''',
            reference: 'WHO Technical Report Series 854, 1995',
          ),
          MetricSection(
            title: 'Basal Metabolic Rate (BMR)',
            description: 'Uses Mifflin-St Jeor Equation (1990)',
            source: 'Mifflin-St Jeor',
            reference: 'Am J Clin Nutr 1990; 51:241-247',
          ),
          MetricSection(
            title: 'Total Daily Energy Expenditure (TDEE)',
            description: 'Based on Harris-Benedict principle',
            source: 'Harris-Benedict',
            categories: '''
• Sedentary (1.2)
• Lightly active (1.375)
• Moderately active (1.55)
• Very active (1.725)
• Extra active (1.9)''',
            reference: 'Proc Natl Acad Sci USA 1918; 4(12):370-373',
          ),
          MetricSection(
            title: 'Minimum Daily Calories',
            description: 'Safe minimum caloric intake levels',
            source: 'National Institute of Health (NIH)',
            categories: '''
• Males: 1500 calories/day
• Females: 1200 calories/day''',
            reference: 'NIH Weight-control Information Network, 2012',
          ),
          MetricSection(
            title: 'Weight Change Calculations',
            description: 'Energy balance principles',
            source: 'The Lancet',
            categories: '''
• 1 kg fat ≈ 7700 calories
• Safe rate: 0.25-0.5 kg/week''',
            reference: 'Lancet 2011; 378(9793):826-837',
          ),
        ],
      ),
    };

    final citation = citations[metricType];
    if (citation == null) return;

    showDialog(
      context: context,
      builder: (context) => CitationDialog(citation: citation),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: AppColors.buttonColors,
          width: 1,
        ),
      ),
      title: Text(
        citation.title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              citation.description,
              style: const TextStyle(
                color: Colors.white70,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Source: ${citation.source}',
              style: TextStyle(
                color: AppColors.buttonColors,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (citation.categories != null) ...[
              const SizedBox(height: 8),
              const Text(
                'Categories:',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                citation.categories!,
                style: const TextStyle(color: Colors.white70),
              ),
            ],
            if (citation.reference != null) ...[
              const SizedBox(height: 8),
              const Text(
                'Reference:',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                citation.reference!,
                style: const TextStyle(color: Colors.white70),
              ),
            ],
            if (citation.sections != null) ...[
              const SizedBox(height: 16),
              ...citation.sections!.map((section) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white.withOpacity(0.05),
                    ),
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          section.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          section.description,
                          style: const TextStyle(
                            color: Colors.white70,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Source: ${section.source}',
                          style: TextStyle(
                            color: AppColors.buttonColors,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (section.categories != null) ...[
                          const SizedBox(height: 4),
                          const Text(
                            'Categories:',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            section.categories!,
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                        if (section.reference != null) ...[
                          const SizedBox(height: 4),
                          const Text(
                            'Reference:',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            section.reference!,
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ],
                    ),
                  )),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            foregroundColor: Colors.white70,
          ),
          child: const Text('Close'),
        ),
        if (citation.link != null)
          TextButton(
            onPressed: () => _launchURL(citation.link!),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.buttonColors,
            ),
            child: const Text(
              'Learn More',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
      ],
      actionsPadding: const EdgeInsets.all(16),
    );
  }
}

class CitationData {
  final String title;
  final String description;
  final String source;
  final String? link;
  final String? categories;
  final String? reference;
  final List<MetricSection>? sections;

  const CitationData({
    required this.title,
    required this.description,
    required this.source,
    this.link,
    this.categories,
    this.reference,
    this.sections,
  });
}

class MetricSection {
  final String title;
  final String description;
  final String source;
  final String? categories;
  final String? reference;

  const MetricSection({
    required this.title,
    required this.description,
    required this.source,
    this.categories,
    this.reference,
  });
}

//   Widget _buildSection(MetricSection section) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.black45,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: Colors.grey[850]!,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             section.title,
//             style: TextStyle(
//               color: AppColors.buttonColors,
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             section.description,
//             style: const TextStyle(
//               color: Colors.white70,
//               fontSize: 14,
//             ),
//           ),
//           if (section.categories != null) ...[
//             const SizedBox(height: 12),
//             Text(
//               'Categories:',
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 14,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               section.categories!,
//               style: const TextStyle(
//                 color: Colors.white70,
//                 fontSize: 14,
//               ),
//             ),
//           ],
//           const SizedBox(height: 8),
//           Text(
//             'Source: ${section.source}',
//             style: TextStyle(
//               color: Colors.grey[400],
//               fontSize: 12,
//               fontStyle: FontStyle.italic,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCategories(String categories) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Categories:',
//           style: TextStyle(
//             color: AppColors.buttonColors,
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           categories,
//           style: const TextStyle(
//             color: Colors.white70,
//             fontSize: 16,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildSourceSection(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.black45,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: Colors.grey[850]!,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Source: ${citation.source}',
//             style: const TextStyle(
//               color: Colors.white70,
//               fontSize: 14,
//             ),
//           ),
//           const SizedBox(height: 4),
//           GestureDetector(
//             onTap: () async {
//               try {
//                 await _launchURL(citation.link??"");
//               } catch (e) {
//                 if (context.mounted) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text('Could not open the link'),
//                       backgroundColor: Colors.red,
//                     ),
//                   );
//                 }
//               }
//             },
//             child: Text(
//               'Learn more →',
//               style: TextStyle(
//                 color: AppColors.buttonColors,
//                 fontSize: 14,
//                 decoration: TextDecoration.underline,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCloseButton(BuildContext context) {
//     return ElevatedButton(
//       onPressed: () => Navigator.pop(context),
//       style: ElevatedButton.styleFrom(
//         backgroundColor: AppColors.buttonColors,
//         minimumSize: const Size(double.infinity, 45),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(22),
//         ),
//       ),
//       child: const Text(
//         'Close',
//         style: TextStyle(
//           color: Colors.black,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }
// }

// // InfoButton widget for use in your screens
// class InfoButton extends StatelessWidget {
//   final String metricType;
//   final double size;
//   final Color? color;
//   final String? label;
//   final bool compact;

//   const InfoButton({
//     super.key,
//     required this.metricType,
//     this.size = 20,
//     this.color,
//     this.label,
//     this.compact = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     if (compact) {
//       return IconButton(
//         icon: Icon(
//           Icons.info_outline,
//           color: color ?? AppColors.buttonColors.withOpacity(0.7),
//           size: size,
//         ),
//         onPressed: () => CitationDialog.show(context, metricType),
//         tooltip: 'View source information',
//         padding: EdgeInsets.zero,
//         constraints: BoxConstraints(
//           minWidth: size + 4,
//           minHeight: size + 4,
//         ),
//       );
//     }

//     return ElevatedButton.icon(
//       onPressed: () => CitationDialog.show(context, metricType),
//       icon: Icon(Icons.info_outline, size: size),
//       label: Text(label ?? 'Health Metrics Info'),
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.black45,
//         foregroundColor: color ?? AppColors.buttonColors,
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//           side: BorderSide(
//             color: (color ?? AppColors.buttonColors).withOpacity(0.4),
//           ),
//         ),
//       ),
//     );
//   }
// }
