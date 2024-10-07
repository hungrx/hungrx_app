import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/custom_textfield.dart';

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () =>  context.go('/profile'),
        ),
        title: const Text('Account Settings', style: TextStyle(color: Colors.white)),
      ),
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Account',
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              _buildExpansionTile(
                'Change Email',
                [
                  const CustomTextFormField(hintText: 'Enter new email'),
                  const SizedBox(height: 10),
                  const CustomTextFormField(hintText: 'Confirm new email'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Implement email change logic
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text('Change Email'),
                  ),
                ],
              ),
              _buildExpansionTile(
                'Report a bug',
                [
                  const CustomTextFormField(
                    hintText: 'Describe the bug',
                  
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Implement bug report logic
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    child: const Text('Submit Report'),
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
                  ElevatedButton(
                    onPressed: () {
                      // Implement account deletion logic
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('Delete Account'),
                  ),
                ],
              ),
              _buildExpansionTile(
                'Log out',
                [
                  ElevatedButton(
                    onPressed: () => _showLogoutConfirmationDialog(context),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                    child: const Text('Log Out'),
                  ),
                ],
              ),
            ]),
          ),
        ],
      ),
    );
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

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text('Confirm Logout', style: TextStyle(color: Colors.white)),
          content: const Text('Are you sure you want to log out?', style: TextStyle(color: Colors.white)),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Log Out', style: TextStyle(color: Colors.red)),
              onPressed: () {
                 context.go('/login');
                // Navigate to login screen or perform other logout actions
              },
            ),
          ],
        );
      },
    );
  }
}