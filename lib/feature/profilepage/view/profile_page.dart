import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medicine_reminder/core/theme/colors.dart';
import 'package:medicine_reminder/feature/profilepage/view/pill_list.dart';
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
              Text(
                'Hoş Geldin 😇',
                style: TextStyle(fontSize: 30.sp, color: Colors.black54),
              ),
              Text(
                viewModel.name != null ? ' ${viewModel.name} ' : '-',
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 30.sp, color: Colors.black54),
              ),
              SizedBox(
                height: 25.h,
              ),
              const Divider(),
              Image.asset(
                'assets/images/background.jpg',
                fit: BoxFit.fitHeight,
                height: 200.h,
              ),
              const Divider(),
              SizedBox(
                height: 25.h,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PillList()),
                  );
                },
                style: ButtonStyle(
                  fixedSize: WidgetStateProperty.all(
                    Size(300.w, 100.h),
                  ),
                  backgroundColor:
                      WidgetStateProperty.all(AppColors.secondaryColor),
                  foregroundColor: WidgetStateProperty.all(
                    Colors.white,
                  ),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.h),
                    ),
                  ),
                ),
                child: Text(
                  'Kullandığın İlaçlar',
                  style: TextStyle(fontSize: 25.sp),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
