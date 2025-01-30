import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/data/Models/profile_screen/get_profile_details_model.dart';
import 'package:hungrx_app/presentation/blocs/get_profile_details/get_profile_details_bloc.dart';
import 'package:hungrx_app/presentation/blocs/get_profile_details/get_profile_details_event.dart';
import 'package:hungrx_app/presentation/blocs/get_profile_details/get_profile_details_state.dart';
import 'package:hungrx_app/presentation/pages/userprofile_screens/user_profile_screen/widget/user_details_dialog.dart';
import 'package:hungrx_app/routes/route_names.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  // late GetProfileDetailsBloc _bloc;
  GetProfileDetailsModel? _cachedProfileDetails;
  String? userId;
bool _isInitialLoad = true;

  @override
  void initState() {
    super.initState();
    _loadCachedData();
  }

  Future<void> _loadCachedData() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString('profile_cache');
    
    if (cachedData != null) {
      setState(() {
        _cachedProfileDetails = GetProfileDetailsModel.fromJson(json.decode(cachedData));
        _isInitialLoad = false;
      });
    }
    
    // Fetch fresh data in background
    _fetchProfileDetails();
  }

  Future<void> _cacheData(GetProfileDetailsModel profileData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_cache', json.encode(profileData.toJson()));
  }

  void _fetchProfileDetails() {
    context.read<GetProfileDetailsBloc>().add(FetchProfileDetails());
  }

  Future<void> _handleRefresh() async {
    _fetchProfileDetails();
    return Future.delayed(const Duration(seconds: 1));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: BlocConsumer<GetProfileDetailsBloc, GetProfileDetailsState>(
            listener: (context, state) {
              if (state is GetProfileDetailsFailure) {
                if (!_isInitialLoad) {
                  // Only show error if it's not initial load and we have no cached data
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.error),
                      action: SnackBarAction(
                        label: 'Retry',
                        onPressed: _fetchProfileDetails,
                      ),
                    ),
                  );
                }
              } else if (state is GetProfileDetailsSuccess) {
                if (_cachedProfileDetails?.toJson() != state.profileDetails.toJson()) {
                  setState(() {
                    _cachedProfileDetails = state.profileDetails;
                  });
                  _cacheData(state.profileDetails);
                }
              }
            },
            builder: (context, state) {
              // Use cached data immediately if available
              return SingleChildScrollView(
                child: Column(
                  children: [
                    _buildHeader(context, _cachedProfileDetails),
                    _buildUserStats(_cachedProfileDetails),
                    _buildPersonalDetails(context, userId),
                    _buildAppSettings(),
                    _buildInviteSection(),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
  //   Widget _buildLoadingOverlay() {
  //   return Container(
  //     color: Colors.black.withOpacity(0.5),
  //     child: const Center(
  //       child: CircularProgressIndicator(),
  //     ),
  //   );
  // }

  // Widget _buildErrorOverlay() {
  //   return Container(
  //     color: Colors.black.withOpacity(0.8),
  //     child: Center(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           const Text(
  //             'Failed to load profile',
  //             style: TextStyle(color: Colors.white),
  //           ),
  //           const SizedBox(height: 16),
  //           ElevatedButton(
  //             onPressed: _fetchProfileDetails,
  //             child: const Text('Retry'),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

 Widget _buildHeader(BuildContext context, GetProfileDetailsModel? profileData) {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0, bottom: 20),
      child: Column(
        children: [
          profileData == null
              ?  CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[900],
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.grey,
                  ),
                )
              : CircleAvatar(
                  radius: 50,
                  backgroundImage: profileData.profilephoto != null
                      ? NetworkImage(profileData.profilephoto!)
                      : AssetImage(
                          profileData.gender.toLowerCase() == 'female'
                              ? 'assets/images/dpw.jpg'
                              : 'assets/images/dp.png',
                        ) as ImageProvider,
                ),
          const SizedBox(height: 10),
          Text(
            profileData?.name ?? "User",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserStats(GetProfileDetailsModel? profileData) {
    String tdee = "0";
    if (profileData?.dailyCalorieGoal != null) {
      try {
        double value = double.parse(profileData!.dailyCalorieGoal);
        tdee = value.round().toString();
      } catch (e) {
        tdee = "0";
      }
    }

    return GestureDetector(
      onTap: () {
        if (profileData != null) {
          showDialog(
            context: context,
            builder: (context) => UserStatsDetailDialog(
              profileData: profileData,
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem('Target', '$tdee cal'),
            _buildStatItem(
              'Weight',
              '${profileData?.weight ?? "0"} ${profileData?.isMetric ?? true ? "Kg" : "lbs"}',
            ),
            _buildStatItem(
              'Goal',
              '${profileData?.targetWeight ?? "0"} ${profileData?.isMetric ?? true ? "Kg" : "lbs"}',
            ),
            _buildStatItem('BMI', profileData?.bmi ?? "0"),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildPersonalDetails(BuildContext context, String? userId) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text('Personal Details',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
        ),
        _buildDetailItem(
          Icons.info_outline,
          'Basic Information',
          'Height, weight, age, gender...',
          () {
            context.pushNamed(RouteNames.basicInformationScreen);
          },
        ),
        _buildDetailItem(
            Icons.flag_outlined, 'Primary Goal', 'Target weight,Goal pace...',
            () {
          context.pushNamed(RouteNames.goalSettingsScreen, extra: {
            'userId': userId,
          });
        }),
        _buildDetailItem(Icons.payment, 'Subscription', 'Monthly plans...', () {
          context.pushNamed(RouteNames.subscriptionScreen);
        }),
      ],
    );
  }

  Widget _buildAppSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text('App Settings',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
        ),
        _buildDetailItem(Icons.person_outline, 'Account',
            'Report bug, log out, delete account', () {
          context.pushNamed(RouteNames.accountSettings, extra: {
            'userId': userId,
          });
        }),
        _buildDetailItem(Icons.help_outline, 'Help & Support',
            'Contact Us, feedbacks, social media', () {
          context.pushNamed(RouteNames.helpSupportScreen);
        }),
        _buildDetailItem(Icons.info_outline, 'About',
            'About us, Privacy Policy, app version', () {
          context.pushNamed(RouteNames.policiesScreen);
        }),
      ],
    );
  }

  Widget _buildDetailItem(
      IconData icon, String title, String subtitle, void Function()? ontap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey)),
      trailing:
          const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
      onTap: ontap, // Implement navigation or action
    );
  }

  Widget _buildInviteSection() {
    // Text to share
    const String inviteText =
        "Block Shorts, Apps, & Notifications to Regain your Focus. Join me now: https://regainapp.ai/download";

    // Function to handle sharing
    void handleShare() async {
      try {
        await Share.share(
          inviteText,
          subject: 'Join Regain App!',
        );
      } catch (e) {
        debugPrint('Error sharing: $e');
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Invite your friends',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          height: 100,
          decoration: BoxDecoration(
            image: const DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage("assets/images/referrel.jpg"),
            ),
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.person_add, color: Colors.black),
            label:
                const Text('Refer Now', style: TextStyle(color: Colors.black)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.buttonColors,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            onPressed: handleShare,
          ),
        ),
      ],
    );
  }
}
