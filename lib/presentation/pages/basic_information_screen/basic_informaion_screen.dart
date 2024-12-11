import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/data/Models/get_basic_info_response.dart';
import 'package:hungrx_app/data/Models/update_basic_info_request.dart';
import 'package:hungrx_app/presentation/blocs/get_basic_info/get_basic_info_bloc.dart';
import 'package:hungrx_app/presentation/blocs/get_basic_info/get_basic_info_event.dart';
import 'package:hungrx_app/presentation/blocs/get_basic_info/get_basic_info_state.dart';
import 'package:hungrx_app/presentation/blocs/update_basic_info/update_basic_info_bloc.dart';
import 'package:hungrx_app/presentation/blocs/update_basic_info/update_basic_info_event.dart';
import 'package:hungrx_app/presentation/blocs/update_basic_info/update_basic_info_state.dart';

class BasicInformationScreen extends StatefulWidget {
  const BasicInformationScreen({super.key});

  @override
  BasicInformationScreenState createState() => BasicInformationScreenState();
}

class BasicInformationScreenState extends State<BasicInformationScreen> {
  static const String userId = "6756c8fc83e88396971c6dde";
  late bool isMetric = true;
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController ageController;
  late TextEditingController weightController;
  late TextEditingController targetWeightController;
  late TextEditingController heightController;
  late TextEditingController heightInchController;
  late TextEditingController heightInFeetController;
  String gender = '';

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _fetchUserBasicInfo();
  }

  void _initializeControllers() {
    nameController = TextEditingController();
    phoneController = TextEditingController();
    emailController = TextEditingController();
    ageController = TextEditingController();
    weightController = TextEditingController();
    targetWeightController = TextEditingController();
    heightController = TextEditingController();
    heightInchController = TextEditingController();
    heightInFeetController = TextEditingController();
  }

  void _fetchUserBasicInfo() {
    context.read<GetBasicInfoBloc>().add(GetBasicInfoRequested(userId));
  }

  void _updateControllers(UserBasicInfo info) {
    setState(() {
      isMetric = info.isMetric;
      nameController.text = info.name;
      phoneController.text = info.phone ?? '';
      emailController.text = info.email;
      ageController.text = info.age.replaceAll(' years', '');
      weightController.text = info.isMetric
          ? info.weightInKg?.replaceAll(' kg', '') ?? ""
          : info.weightInLbs?.replaceAll(' lbs', '') ?? "";
      targetWeightController.text = info.targetWeight.replaceAll(' kg', '');
      heightController.text = info.heightInCm?.replaceAll(' cm', '') ?? "";
      heightInchController.text =
          info.heightInInches?.replaceAll(' in', '') ?? "";
      heightInFeetController.text =
          info.heightInFeet?.replaceAll(' feet', '') ?? "";
      gender = info.gender;
    });
  }

  void _handleUpdateBasicInfo() {
    final request = UpdateBasicInfoRequest(
      userId: userId,
      name: nameController.text,
      email: emailController.text,
      gender: gender.toLowerCase(),
      mobile: phoneController.text,
      age: ageController.text,
      heightInCm: isMetric ? heightController.text : null,
      heightInFeet: !isMetric ? heightInFeetController.text : null,
      heightInInches: !isMetric ? heightInchController.text : null,
      weightInKg: isMetric ? weightController.text : null,
      weightInLbs: !isMetric ? weightController.text : null,
      targetWeight: targetWeightController.text,
      isMetric: isMetric,
    );

    context.read<UpdateBasicInfoBloc>().add(UpdateBasicInfoSubmitted(request));
  }

  bool _validateFields() {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneController.text.isEmpty ||
        ageController.text.isEmpty ||
        weightController.text.isEmpty ||
        targetWeightController.text.isEmpty ||
        gender.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    ageController.dispose();
    weightController.dispose();
    targetWeightController.dispose();
    heightController.dispose();
    heightInchController.dispose();
    heightInFeetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<GetBasicInfoBloc, GetBasicInfoState>(
          listener: (context, state) {
            if (state is GetBasicInfoSuccess) {
              _updateControllers(state.userInfo);
            } else if (state is GetBasicInfoFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
        ),
        BlocListener<UpdateBasicInfoBloc, UpdateBasicInfoState>(
          listener: (context, state) {
            if (state is UpdateBasicInfoLoading) {
              // Show loading indicator if needed
            } else if (state is UpdateBasicInfoSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.response.message)),
              );
              Navigator.of(context).pop();
            } else if (state is UpdateBasicInfoFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            'Basic Information',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            BlocBuilder<UpdateBasicInfoBloc, UpdateBasicInfoState>(
              builder: (context, state) {
                return TextButton(
                  onPressed: state is UpdateBasicInfoLoading
                      ? null
                      : () {
                          if (_validateFields()) {
                            _handleUpdateBasicInfo();
                          }
                        },
                  child: state is UpdateBasicInfoLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Done',
                          style: TextStyle(color: AppColors.buttonColors),
                        ),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<GetBasicInfoBloc, GetBasicInfoState>(
          builder: (context, state) {
            if (state is GetBasicInfoLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildInputField(Icons.person, 'Name', nameController),
                  const SizedBox(height: 16),
                  _buildGenderSelector(),
                  const SizedBox(height: 16),
                  _buildInputField(
                      Icons.phone, 'Phone number', phoneController),
                  const SizedBox(height: 16),
                  _buildInputField(Icons.email, 'Email', emailController),
                  const SizedBox(height: 16),
                  _buildInputField(Icons.cake, 'Age', ageController),
                  const SizedBox(height: 16),
                  _buildInputField(
                    Icons.monitor_weight,
                    'Weight',
                    weightController,
                    suffix: isMetric ? "kg" : "lbs",
                  ),
                  const SizedBox(height: 16),
                  _buildInputField(
                    Icons.monitor_weight_outlined,
                    'Target Weight',
                    targetWeightController,
                    suffix: isMetric ? "kg" : "lbs",
                  ),
                  const SizedBox(height: 16),
                  if (isMetric)
                    _buildInputField(
                      Icons.height,
                      'Height',
                      heightController,
                      suffix: "cm",
                    ),
                  if (!isMetric) ...[
                    _buildInputField(
                      Icons.height,
                      'Height (feet)',
                      heightInFeetController,
                      suffix: "feet",
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      Icons.height,
                      'Height (inches)',
                      heightInchController,
                      suffix: "inch",
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInputField(
    IconData icon,
    String label,
    TextEditingController controller, {
    String? suffix,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.buttonColors),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: label,
                labelStyle: const TextStyle(color: Colors.grey),
                suffixText: suffix,
                suffixStyle: const TextStyle(color: AppColors.buttonColors),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.buttonColors),
      ),
      child: Row(
        children: [
          const Icon(Icons.wc, color: Colors.white),
          const SizedBox(width: 16),
          Expanded(
            child: Row(
              children: [
                _buildGenderButton('Male'),
                const SizedBox(width: 16),
                _buildGenderButton('Female'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderButton(String genderOption) {
    bool isSelected = gender.toLowerCase() == genderOption.toLowerCase();
    return Expanded(
      child: ElevatedButton(
        onPressed: () => setState(() => gender = genderOption),
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isSelected ? AppColors.buttonColors : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: AppColors.buttonColors),
          ),
          elevation: 0,
        ),
        child: Text(
          genderOption,
          style: TextStyle(
            color: isSelected ? Colors.black : AppColors.buttonColors,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
