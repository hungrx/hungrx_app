import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/data/Models/profile_screen/get_profile_details_model.dart';
import 'package:hungrx_app/presentation/blocs/get_profile_details/get_profile_details_bloc.dart';
import 'package:hungrx_app/presentation/blocs/get_profile_details/get_profile_details_event.dart';
import 'package:hungrx_app/presentation/blocs/get_profile_details/get_profile_details_state.dart';
import 'package:hungrx_app/presentation/blocs/referral/referral_bloc.dart';
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
        _cachedProfileDetails =
            GetProfileDetailsModel.fromJson(json.decode(cachedData));
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
                if (_cachedProfileDetails?.toJson() !=
                    state.profileDetails.toJson()) {
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

  Widget _buildHeader(
      BuildContext context, GetProfileDetailsModel? profileData) {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0, bottom: 20),
      child: Column(
        children: [
          profileData == null
              ? CircleAvatar(
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
          context.pushNamed(RouteNames.subscriptionScreen, extra: true);
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
    String getInviteLink() {
      if (Platform.isAndroid) {
        return "https://play.google.com/store/apps/details?id=com.hungrx.hungrx_app";
      } else if (Platform.isIOS) {
        return "https://apps.apple.com/us/app/hungrx/id6741845887";
      }
      return "https://www.hungrx.com/";
    }

    void showReferralDialog(String referralCode) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey[900],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Your Referral Code',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          referralCode,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.5,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy,
                              color: AppColors.buttonColors),
                          onPressed: () {
                            Clipboard.setData(
                                ClipboardData(text: referralCode));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Referral code copied!'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.share, color: Colors.black),
                    label: const Text(
                      'Invite Friends',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonColors,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    onPressed: () async {
                      String baseText =
                          "Share HungrX and help your friends discover smarter eating with personalized meal recommendations and nearby restaurant insights!";
                      String link = getInviteLink();
                      String inviteText =
                          "$baseText Use my referral code: $referralCode Join me now: $link";

                      try {
                        await Share.share(
                          inviteText,
                          subject: 'Join hungrX App!',
                        );
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Failed to share. Please try again.')),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    Future<void> handleReferral() async {
      try {
        if (!mounted) return;
        BuildContext dialogContext = context;

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            dialogContext = context;
            return const Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppColors.buttonColors),
              ),
            );
          },
        );

        final completer = Completer<void>();
        late StreamSubscription<ReferralState> subscription;

        subscription = context.read<ReferralBloc>().stream.listen(
          (state) async {
            if (state is ReferralSuccess) {
              if (mounted && dialogContext.mounted) {
                Navigator.of(dialogContext).pop(); // Close loading dialog
                showReferralDialog(
                    state.referralCode); // Show new referral dialog
              }
              completer.complete();
            } else if (state is ReferralFailure) {
              if (mounted && dialogContext.mounted) {
                Navigator.of(dialogContext).pop();
              }
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error)),
                );
              }
              completer.complete();
            }
          },
          onError: (error) {
            if (mounted && dialogContext.mounted) {
              Navigator.of(dialogContext).pop();
            }
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('An error occurred. Please try again.')),
              );
            }
            completer.complete();
          },
        );

        if (mounted) {
          context.read<ReferralBloc>().add(GenerateReferralCode());
        }

        await completer.future;
        await subscription.cancel();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    'Failed to generate referral code. Please try again.')),
          );
        }
        debugPrint('Error handling referral: $e');
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
            onPressed: handleReferral,
          ),
        ),
      ],
    );
  }
}
