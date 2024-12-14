import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medicine_reminder/core/theme/colors.dart';
import 'package:medicine_reminder/feature/profilepage/viewmodel/profile_viewmodel.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  late double screenHeight;
  late double screenWidth;

  @override
  void initState() {
    super.initState();
    final userId = FirebaseAuth.instance.currentUser?.uid;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (userId != null) {
        Provider.of<ProfileViewmodel>(context, listen: false)
            .fetchProfileModel(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    final viewModel = Provider.of<ProfileViewmodel>(context);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            iconSize: 35,
            color: AppColors.secondaryColor,
            onPressed: () {
              viewModel.signOut(context);
            },
          ),
        ],
      ),
      body: Consumer<ProfileViewmodel>(
        builder: (context, viewModel, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: screenHeight * 0.01,
              ),
              Image.asset(
                'assets/images/background.jpg',
                fit: BoxFit.fitHeight,
                height: screenHeight * 0.3,
              ),
              SizedBox(
                height: screenHeight * 0.18,
              ),
              const Text(
                'HOŞ GELDİN! ',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondaryColor,
                ),
              ),
              Text(
                viewModel.name != null
                    ? '${viewModel.name} ${viewModel.surname}'
                    : '-',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondaryColor,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
