import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/data/Models/profile_screen/get_basic_info_response.dart';
import 'package:hungrx_app/data/Models/profile_screen/update_basic_info_request.dart';
import 'package:hungrx_app/data/services/auth_service.dart';
import 'package:hungrx_app/presentation/blocs/get_basic_info/get_basic_info_bloc.dart';
import 'package:hungrx_app/presentation/blocs/get_basic_info/get_basic_info_event.dart';
import 'package:hungrx_app/presentation/blocs/get_basic_info/get_basic_info_state.dart';
import 'package:hungrx_app/presentation/blocs/get_profile_details/get_profile_details_bloc.dart';
import 'package:hungrx_app/presentation/blocs/get_profile_details/get_profile_details_event.dart';
import 'package:hungrx_app/presentation/blocs/update_basic_info/update_basic_info_bloc.dart';
import 'package:hungrx_app/presentation/blocs/update_basic_info/update_basic_info_event.dart';
import 'package:hungrx_app/presentation/blocs/update_basic_info/update_basic_info_state.dart';
import 'package:hungrx_app/presentation/pages/userprofile_screens/basic_information_screen/widget/formvalidator.dart';

class BasicInformationScreen extends StatefulWidget {
  const BasicInformationScreen({super.key});

  @override
  BasicInformationScreenState createState() => BasicInformationScreenState();
}

class BasicInformationScreenState extends State<BasicInformationScreen> {
  String? userId = "";
  late bool isMetric = true;
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController ageController;
  late TextEditingController heightController;
  late TextEditingController heightInchController;
  late TextEditingController heightInFeetController;
  final _authService = AuthService();
  String gender = '';
  final _formKey = GlobalKey<FormState>();

  bool _validateFields() {
    if (!_formKey.currentState!.validate()) {
      return false;
    }
    return true;
  }

  // Store weight values from GetBasicInfoBloc
  String? weightValue;
  String? targetWeightValue;

  @override
  void initState() {
    super.initState();
    _initializeUserId();
    _initializeControllers();
    _fetchUserBasicInfo();
  }

  Future<void> _initializeUserId() async {
    userId = await _authService.getUserId() ?? "";
    setState(() {});
  }

  void _initializeControllers() {
    nameController = TextEditingController();
    phoneController = TextEditingController();
    emailController = TextEditingController();
    ageController = TextEditingController();
    heightController = TextEditingController();
    heightInchController = TextEditingController();
    heightInFeetController = TextEditingController();
  }

  void _fetchUserBasicInfo() {
    context.read<GetBasicInfoBloc>().add(GetBasicInfoRequested());
  }

  void _updateControllers(UserBasicInfo info) {
    setState(() {
      isMetric = info.isMetric;
      nameController.text = info.name;
      phoneController.text = info.phone ?? '';
      emailController.text = info.email;
      ageController.text = info.age.replaceAll(' years', '');
      heightController.text = info.heightInCm?.replaceAll(' cm', '') ?? "";
      heightInchController.text =
          info.heightInInches?.replaceAll(' in', '') ?? "";
      heightInFeetController.text =
          info.heightInFeet?.replaceAll(' feet', '') ?? "";
      gender = info.gender;

      // Store weight values
      weightValue = info.isMetric
          ? info.weightInKg?.replaceAll(' kg', '')
          : info.weightInLbs?.replaceAll(' lbs', '');
      targetWeightValue = info.targetWeight.replaceAll(' kg', '');
    });
  }

  void _handleUpdateBasicInfo() {
    if (!_validateFields()) return;
    if (userId == null) return;

    // Get the current state of GetBasicInfoBloc
    final basicInfoState = context.read<GetBasicInfoBloc>().state;

    if (basicInfoState is GetBasicInfoSuccess) {}

    final request = UpdateBasicInfoRequest(
      userId: userId ?? "",
      name: nameController.text,
      email: emailController.text,
      gender: gender.toLowerCase(),
      mobile: phoneController.text,
      age: ageController.text,
      heightInCm: isMetric ? heightController.text : null,
      heightInFeet: !isMetric ? heightInFeetController.text : null,
      heightInInches: !isMetric ? heightInchController.text : null,
      weightInKg: isMetric ? weightValue : null,
      weightInLbs: !isMetric ? weightValue : null,
      targetWeight: targetWeightValue,
      isMetric: isMetric,
    );

    context.read<UpdateBasicInfoBloc>().add(UpdateBasicInfoSubmitted(request));
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    ageController.dispose();
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
            if (state is UpdateBasicInfoSuccess) {
              context.read<GetProfileDetailsBloc>().add(FetchProfileDetails());
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
                print(userId);
                return TextButton(
                  onPressed: userId == null || state is UpdateBasicInfoLoading
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
        body: Form(
          key: _formKey,
          child: BlocBuilder<GetBasicInfoBloc, GetBasicInfoState>(
            builder: (context, state) {
              if (userId == null || state is GetBasicInfoLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildInputField(Icons.person, 'Name', nameController),
                    const SizedBox(height: 16),
                    _buildGenderSelector(),
                    // const SizedBox(height: 16),
                    // _buildInputField(
                    //     Icons.phone, 'Phone number', phoneController),
                    const SizedBox(height: 16),
                    _buildInputField(Icons.email, 'Email', emailController),
                    const SizedBox(height: 16),
                    _buildInputField(Icons.cake, 'Age', ageController),
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
            child: TextFormField(
              controller: controller,
              style: const TextStyle(color: Colors.white),
              keyboardType: _getKeyboardType(label),
              validator: (value) => _getValidator(label, value),
              onChanged: (value) {
                _handleOnChanged(label, value, controller);
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: label,
                labelStyle: const TextStyle(color: Colors.grey),
                suffixText: suffix,
                suffixStyle: const TextStyle(color: AppColors.buttonColors),
                errorStyle: const TextStyle(color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextInputType _getKeyboardType(String label) {
    switch (label.toLowerCase()) {
      case 'phone number':
        return TextInputType.phone;
      case 'email':
        return TextInputType.emailAddress;
      case 'age':
      case 'height':
      case 'height (feet)':
      case 'height (inches)':
        return TextInputType.number;
      default:
        return TextInputType.text;
    }
  }

  String? _getValidator(String label, String? value) {
    switch (label.toLowerCase()) {
      case 'name':
        return FormValidators.validateName(value);
      // case 'phone number':
      //   return FormValidators.validatePhone(value);
      case 'email':
        return FormValidators.validateEmail(value);
      case 'age':
        return FormValidators.validateAge(value);
      case 'height':
        return FormValidators.validateHeight(value, isMetric);
      case 'height (feet)':
        return FormValidators.validateHeight(value, false);
      case 'height (inches)':
        return FormValidators.validateHeightInches(value);
      default:
        return null;
    }
  }

  void _handleOnChanged(
      String label, String value, TextEditingController controller) {
    if (label.toLowerCase() == 'phone number' && value.length > 10) {
      controller.text = value.substring(0, 10);
      controller.selection = TextSelection.fromPosition(
        const TextPosition(offset: 10),
      );
    }
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
