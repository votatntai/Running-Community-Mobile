import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:running_community_mobile/cubit/archivement/archivement_state.dart';
import 'package:running_community_mobile/cubit/user/user_cubit.dart';
import 'package:running_community_mobile/cubit/user/user_state.dart';
import 'package:running_community_mobile/screens/SplashScreen.dart';
import 'package:running_community_mobile/utils/app_assets.dart';
import 'package:running_community_mobile/utils/colors.dart';
import 'package:running_community_mobile/utils/gap.dart';
import 'package:running_community_mobile/widgets/AppBar.dart';

import '../cubit/archivement/archivement_cubit.dart';
import '../utils/constants.dart';

class ProfileFragment extends StatefulWidget {
  const ProfileFragment({super.key});

  @override
  State<ProfileFragment> createState() => _ProfileFragmentState();
}

class _ProfileFragmentState extends State<ProfileFragment>{
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {

    @override
    void initState() {
      super.initState();
    }

    @override
    void dispose() {
      super.dispose();
    }

    return Scaffold(
      appBar: const MyAppBar(
        title: 'Profile',
      ),
      body: BlocBuilder<UserCubit, UserState>(builder: (context, state) {
        if (state is UserProfileLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is UserProfileSuccessState) {
          var userProfile = state.user;
          return Column(
            children: [
              IntrinsicHeight(
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: FadeInImage.assetNetwork(
                        placeholder: AppAssets.placeholder,
                        image: state.user.avatarUrl!,
                        height: 60,
                        width: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Gap.k16.width,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(userProfile.name!, style: primaryTextStyle(weight: FontWeight.bold),),
                        Text(userProfile.status!, style: secondaryTextStyle(),),
                      ],
                    ),
                  ],
                ),
              ).paddingSymmetric(horizontal: 32),
              Gap.k16.height,
              SizedBox(
                height: 50,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      // top: 100,
                      child: Card(
                        elevation: _selectedIndex == 0 ? 0 : 10,
                        child: Container(
                          // width: context.width() * 0.2,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          child: SvgPicture.asset(AppAssets.info, width: 24, color: _selectedIndex == 0 ? primaryColor : textSecondaryColor,),
                        ),
                      ).onTap(() => setState(() => _selectedIndex = 0)),
                    ),
                    Positioned(
                      left: 90,
                      child: Card(
                        elevation: _selectedIndex == 1 ? 0 : 10,
                        child: Container(
                          // width: context.width() * 0.2,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          child: SvgPicture.asset(AppAssets.trophy, width: 24, color: _selectedIndex == 1 ? primaryColor : textSecondaryColor,),
                        ),
                      ).onTap(() => setState(() => _selectedIndex = 1),)
                    ),
                  ],
                ),
              ).paddingSymmetric(horizontal: 32),
              Container(
                color: white,
                width: context.width(),
                child: [
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Email: ${userProfile.address}', style: secondaryTextStyle(),),
                        Text('Phone: ${userProfile.phone}', style: secondaryTextStyle(),),
                      ],
                    ),
                  ),
                  BlocBuilder<ArchivementCubit, ArchivementState>(
                    builder: (context, state) {
                      if (state is ArchivementLoadingState) {
                        return const Center(child: CircularProgressIndicator());
                        
                      }
                      if (state is ArchivementSuccessState) {
                        var archivements = state.archivements.archivements!;
                        return Padding(padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemBuilder: (context, index){
                                return Container(
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: white,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 1,
                                        blurRadius: 7,
                                        offset: const Offset(0, 3), // changes position of shadow
                                      )],
                                  ),
                                  child: Row(
                                    children: [
                                      FractionallySizedBox(
                                        heightFactor: 1,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
                                          child: FadeInImage.assetNetwork(
                                            placeholder: AppAssets.placeholder,
                                            image: archivements[index].thumbnailUrl!,
                                            // height: 60,
                                            width: 80,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Gap.k16.width,
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(archivements[index].tournament!.title!, style: primaryTextStyle(),),
                                          Text(archivements[index].name!, style: secondaryTextStyle(),),
                                          Text('Rank: ${archivements[index].rank!}', style: secondaryTextStyle(),),
                                        ],
                                      ).paddingAll(8),
                                    ],
                                  ),
                                );
                              }, separatorBuilder: (context, index) => const Divider(), itemCount: archivements.length)
                            ],
                          ),
                        );
                        
                      }
                      return const SizedBox.shrink();
                    }
                  ),
                ].elementAt(_selectedIndex),
              ).expand(),  
              
              Center(
                child: TextButton(
                  onPressed: () async {
                    await setValue(AppConstant.TOKEN_KEY, '');
                    Navigator.pushReplacementNamed(context, SplashScreen.routeName);
                  },
                  child: const Text('Logout'),
                ),
              ),
            ],
          ).paddingSymmetric(vertical: 32);
        }
        return const SizedBox.shrink();
      }),
    );
  }
}
