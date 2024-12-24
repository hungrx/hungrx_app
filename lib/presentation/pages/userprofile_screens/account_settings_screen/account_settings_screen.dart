import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hungrx_app/data/services/auth_service.dart';
import 'package:hungrx_app/presentation/blocs/delete_account/delete_account_bloc.dart';
import 'package:hungrx_app/presentation/blocs/delete_account/delete_account_event.dart';
import 'package:hungrx_app/presentation/blocs/delete_account/delete_account_state.dart';
import 'package:hungrx_app/presentation/blocs/report_bug/report_bug_bloc.dart';
import 'package:hungrx_app/presentation/blocs/report_bug/report_bug_event.dart';
import 'package:hungrx_app/presentation/blocs/report_bug/report_bug_state.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/custom_textfield.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key,});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  final TextEditingController reportController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  Future<void> _showDeleteConfirmationDialog() async {
    if (!mounted) return;

    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return BlocBuilder<DeleteAccountBloc, DeleteAccountState>(
          builder: (context, state) {
            return AlertDialog(
              backgroundColor: Colors.grey[900],
              title: const Text(
                'Confirm Account Deletion',
                style: TextStyle(color: Colors.white),
              ),
              content: state is DeleteAccountLoading
                  ? const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text(
                          'Deleting account...',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    )
                  : const Text(
                      'Are you sure you want to delete your account? This action cannot be undone.',
                      style: TextStyle(color: Colors.white),
                    ),
              actions: state is DeleteAccountLoading
                  ? null
                  : <Widget>[
                      TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(false),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(true),
                        child: const Text(
                          'Delete',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
            );
          },
        );
      },
    );

    if (shouldDelete == true && mounted) {
      // Get user ID from your auth service or state management
      // final userId = await _authService.getCurrentUserId();
      context.read<DeleteAccountBloc>().add(
            DeleteAccountRequested(),
          );
    }
  }

  Future<void> _handleLogout() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.logout();

      if (mounted) {
        // Navigate to login screen
        GoRouter.of(context).go('/login');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error logging out. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _showLogoutConfirmationDialog() async {
    if (!mounted) return;

    final bool? shouldLogout = await showDialog<bool>(
      context: context,
      barrierDismissible: !_isLoading,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text(
            'Confirm Logout',
            style: TextStyle(color: Colors.white),
          ),
          content: _isLoading
              ? const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Logging out...',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                )
              : const Text(
                  'Are you sure you want to log out?',
                  style: TextStyle(color: Colors.white),
                ),
          actions: _isLoading
              ? null
              : <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(false),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(true),
                    child: const Text(
                      'Log Out',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
        );
      },
    );

    if (shouldLogout == true && mounted) {
      await _handleLogout();
    }
  }

  Widget _buildExpansionTile(String title, List<Widget> children) {
    return ExpansionTile(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      backgroundColor: Colors.grey[900],
      collapsedBackgroundColor: Colors.grey[900],
      iconColor: Colors.white,
      collapsedIconColor: Colors.white,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<DeleteAccountBloc, DeleteAccountState>(
          listener: (context, state) {
            if (state is DeleteAccountSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
              Navigator.of(context).popUntil((route) => route.isFirst);
              // Navigate to login screen
              GoRouter.of(context).go('/login');
              // context.go('/login');
            } else if (state is DeleteAccountFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
        BlocListener<ReportBugBloc, ReportBugState>(
          listener: (context, state) {
            if (state is ReportBugSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            } else if (state is ReportBugFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: Colors.red,
                ),
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
            onPressed: () => context.go('/profile'),
          ),
          title: const Text(
            'Account Settings',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16.0),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                _buildExpansionTile(
                  'Report a bug',
                  [
                    BlocBuilder<ReportBugBloc, ReportBugState>(
                      builder: (context, state) {
                        return Column(
                          children: [
                            CustomTextFormField(
                              controller: reportController,
                              hintText: 'Describe the bug',
                              enabled: state is! ReportBugLoading,
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: state is ReportBugLoading
                                  ? null
                                  : () {
                                      if (reportController.text.isNotEmpty) {
                                        context.read<ReportBugBloc>().add(
                                              ReportBugSubmitted( // Get from auth service
                                                report: reportController.text,
                                              ),
                                            );
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                              ),
                              child: state is ReportBugLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    )
                                  : const Text(
                                      'Submit Report',
                                      style: TextStyle(color: Colors.white),
                                    ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
                _buildExpansionTile(
                  'Delete Account',
                  [
                    const Text(
                      'Are you sure you want to delete your account? This action cannot be undone.',
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    BlocBuilder<DeleteAccountBloc, DeleteAccountState>(
                      builder: (context, state) {
                        return ElevatedButton(
                          onPressed: state is DeleteAccountLoading
                              ? null
                              : _showDeleteConfirmationDialog,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: state is DeleteAccountLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Text('Delete Account',
                                  style: TextStyle(color: Colors.white)),
                        );
                      },
                    ),
                  ],
                ),
                _buildExpansionTile(
                  'Log out',
                  [
                    ElevatedButton(
                      onPressed:
                          _isLoading ? null : _showLogoutConfirmationDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text('Log Out',
                              style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
