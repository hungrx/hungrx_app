import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/data/Models/profile_screen/get_profile_details_model.dart';
import 'package:hungrx_app/presentation/blocs/get_profile_details/get_profile_details_bloc.dart';
import 'package:hungrx_app/presentation/blocs/get_profile_details/get_profile_details_event.dart';
import 'package:hungrx_app/presentation/blocs/get_profile_details/get_profile_details_state.dart';
import 'package:hungrx_app/routes/route_names.dart';
import 'package:share_plus/share_plus.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  // late GetProfileDetailsBloc _bloc;
  GetProfileDetailsModel? _cachedProfileDetails;
  String? userId;

  @override
  void initState() {
    super.initState();

    _fetchProfileDetails();
  }

  void _fetchProfileDetails() {
    context.read<GetProfileDetailsBloc>().add(FetchProfileDetails());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => _fetchProfileDetails(),
          child: BlocConsumer<GetProfileDetailsBloc, GetProfileDetailsState>(
            listener: (context, state) {
              if (state is GetProfileDetailsFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    action: SnackBarAction(
                      label: 'Retry',
                      onPressed: _fetchProfileDetails,
                    ),
                  ),
                );
              } else if (state is GetProfileDetailsSuccess) {
                _cachedProfileDetails = state.profileDetails;
              }
            },
            builder: (context, state) {
              return SingleChildScrollView(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        _buildHeader(context, _cachedProfileDetails),
                        _buildUserStats(_cachedProfileDetails),
                        _buildPersonalDetails(context, userId),
                        _buildAppSettings(),
                        _buildInviteSection(),
                      ],
                    ),
                    // Show loading overlay only when fetching new data
                    if (state is GetProfileDetailsLoading &&
                        _cachedProfileDetails == null)
                      // _buildLoadingOverlay(),
                      // Show error overlay only on initial load failure
                      if (state is GetProfileDetailsFailure &&
                          _cachedProfileDetails == null)
                        _buildErrorOverlay(),
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

  Widget _buildErrorOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.8),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Failed to load profile',
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchProfileDetails,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
      BuildContext context, GetProfileDetailsModel? profileData) {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0, bottom: 20),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage:
                AssetImage(profileData?.profilephoto ?? 'assets/images/dp.png')
                    as ImageProvider,
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
    if (profileData?.tdee != null) {
      try {
        double value = double.parse(profileData!.tdee);
        tdee = value.round().toString();
      } catch (e) {
        tdee = "0";
      }
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('TDEE', '$tdee cal'),
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
        _buildDetailItem(Icons.flag_outlined, 'Primary Goal', 'Gain weight...',
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
            'Change mail, log out, delete account', () {
          context.pushNamed(RouteNames.accountSettings, extra: {
            'userId': userId,
          });
        }),
        _buildDetailItem(Icons.info_outline, 'About',
            'About us, Privacy Policy, app version', () {
          context.pushNamed(RouteNames.policiesScreen);
        }),
        _buildDetailItem(Icons.help_outline, 'Help & Support',
            'Help, feedbacks, social media', () {
          context.pushNamed(RouteNames.helpSupportScreen);
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
