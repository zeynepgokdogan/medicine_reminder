import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medicine_reminder/core/theme/colors.dart';
import 'package:medicine_reminder/feature/medicine/view/pill_list.dart';
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
            iconSize: 30.sp,
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
                height: 15.h,
              ),
              Image.asset(
                'assets/images/background.jpg',
                fit: BoxFit.fitHeight,
                height: 200.h,
              ),
              SizedBox(
                height: 18.h,
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Hoş Geldin, ',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondaryColor,
                        ),
                      ),
                      Text(
                        viewModel.name != null ? '${viewModel.name}' : '-',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.red,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50.h,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PillList()),
                      );
                    },
                    style: ButtonStyle(
                      fixedSize: WidgetStateProperty.all(
                        Size(300.w, 120.h),
                      ),
                      backgroundColor:
                          WidgetStateProperty.all(AppColors.secondaryColor),
                      foregroundColor: WidgetStateProperty.all(
                        Colors.black,
                      ),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.h),
                        ),
                      ),
                    ),
                    child: Text(
                      'İlaç Listeniz',
                      style: TextStyle(fontSize: 25.sp),
                    ),
                  )
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
