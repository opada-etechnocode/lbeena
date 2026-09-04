import 'dart:io';

import 'package:syrians_in_uae/ui/screens/profile/cubit/status.dart';
import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/results/result.dart';
import '../../../../data/sources/auth/auth_remote_data_source.dart';
import '../../../../data/sources/community/community_data_source.dart';
import '../../../../data/sources/following/following_remote_data_source.dart';
import '../../../../data/sources/home_page/home_page_data_source.dart';
import '../../../../data/sources/profile/profile_page_data_source.dart';
import '../../../../widgets/file_compress.dart';

class ProfileCubit extends Cubit<ProfileStates> {
  ProfileCubit() : super(InitialProfileState());

  static ProfileCubit get(context) => BlocProvider.of(context);

  /// Following
  // i follow this user ?
  Future<void> isFollowThisUser({
    required int userId,
  }) async {
    FollowingRemoteDataSourceImpl followingDataSourceImpl =
    const FollowingRemoteDataSourceImpl();
    try {
      emit(LoadingIsFollowingUserState());

      var followingData = await followingDataSourceImpl.isFollowUser(userId: userId);

      if (followingData.data != null) {
        emit(SuccessIsFollowingUserState(followingData.data!));
      } else {
        emit(ErrorIsFollowingUserState(followingData.error.toString()));
      }
    } catch (e) {
      print("Error : $e");
      emit(ErrorIsFollowingUserState(e.toString()));
    }
  }

  // follow user
  Future<void> followThisUser({
    required int userId,
  }) async {
    FollowingRemoteDataSourceImpl followingDataSourceImpl =
    const FollowingRemoteDataSourceImpl();
    try {
      emit(LoadingFollowingUserState());

      var followingData = await followingDataSourceImpl.followUser(userId: userId);

      if (followingData.data!.status =='success') {
        emit(SuccessFollowingUserState(followingData.data!));
      } else {
        emit(ErrorFollowingUserState(followingData.error.toString()));
      }
    } catch (e) {
      print("Error : $e");
      emit(ErrorFollowingUserState(e.toString()));
    }
  }

  // un follow user
  Future<void> unFollowThisUser({
    required int userId,
  }) async {
    FollowingRemoteDataSourceImpl followingDataSourceImpl =
    const FollowingRemoteDataSourceImpl();
    try {
      emit(LoadingUnFollowingUserState());

      var followingData = await followingDataSourceImpl.unFollowUser(userId: userId);

      if (followingData.data!.status =='success') {
        emit(SuccessUnFollowingUserState(followingData.data!));
      } else {
        emit(ErrorUnFollowingUserState(followingData.error.toString()));
      }
    } catch (e) {
      print("Error : $e");
      emit(ErrorUnFollowingUserState(e.toString()));
    }
  }


  /// المتابعون من قبل هذا المستخدم : الإشخاص الذين يتابعهم
  Future<void> followingsForUser({
    required int userId,
    required int page,
    bool isLoading =true
  }) async {
    FollowingRemoteDataSourceImpl followingDataSourceImpl =
    const FollowingRemoteDataSourceImpl();
    try {
      if(isLoading){
        emit(LoadingFollowingUserState());
      }
      var followingData = await followingDataSourceImpl.followingsForUser(userId: userId,page: page);

      if (followingData.data != null) {
        emit(SuccessFollowingUserState(followingData.data!));
      } else {
        emit(ErrorFollowingUserState(followingData.error.toString()));
      }
    } catch (e) {
      print("Error : $e");
      emit(ErrorFollowingUserState(e.toString()));
    }
  }

  /// الأشخاص الذين يتابعون هذا المستخدم
  Future<void> followersForUser({
    required int userId,
    required int page,
    bool isLoading =true
  }) async {
    FollowingRemoteDataSourceImpl followingDataSourceImpl =
    const FollowingRemoteDataSourceImpl();
    try {
      if(isLoading){
        emit(LoadingFollowingUserState());
      }


      var followingData = await followingDataSourceImpl.followersForUser(userId: userId,page: page);

      if (followingData.data != null) {
        emit(SuccessFollowingUserState(followingData.data!));
      } else {
        emit(ErrorFollowingUserState(followingData.error.toString()));
      }
    } catch (e) {
      print("Error : $e");
      emit(ErrorFollowingUserState(e.toString()));
    }
  }

  Future<void> editProfileInformation({
    String? userName,
    String? mobileNumber,
    String? desc_user,
    File? imageProfile,
  }) async {
    ProfilePageDataSourceImpl profileDataSourceImpl =
        const ProfilePageDataSourceImpl();
    try {
      emit(LoadingEditProfileState());

      var profileData = await profileDataSourceImpl.getEditProfileData(
        userName: userName,
        imageProfile: imageProfile,
        desc_user: desc_user,
        mobileNumber: mobileNumber,
      );

      if (profileData.data != null) {
        emit(SuccessEditProfileState(profileData.data!));
      } else {
        emit(ErrorEditProfileState(profileData.error.toString()));
      }
    } catch (e) {
      print("Error : $e");
      emit(ErrorEditProfileState(e.toString()));
    }
  }

  Future<void> editSocialMediaCompanyList({
  required List<String> socialMediaCompanyList
  }) async {
    ProfilePageDataSourceImpl profileDataSourceImpl =
    const ProfilePageDataSourceImpl();
    try {
      emit(LoadingEditSocialMediaCompanyListState());

      var profileData = await profileDataSourceImpl.socialMediaCompanyList(socialMediaCompanyList: socialMediaCompanyList);

      if (profileData.data != null) {
        emit(SuccessEditSocialMediaCompanyListState(profileData.data!));
      } else {
        emit(ErrorEditSocialMediaCompanyListState(profileData.error.toString()));
      }
    } catch (e) {
      print("Error : $e");
      emit(ErrorEditSocialMediaCompanyListState(e.toString()));
    }
  }

/// get Post User
  Future<void> getPostUser() async {
    CommunityDataSourceImpl addCommentDataImpl =
    const CommunityDataSourceImpl();
    try {
      emit(LoadingGetPostUserState());

      var getPostUserData =
      await addCommentDataImpl.getUserOrCompanyCommunityPost();

      if (getPostUserData.data != null) {
        emit(SuccessGetPostUserState(getPostUserData.data!));
      } else {
        emit(ErrorGetPostUserState(getPostUserData.error!.message!));
      }
    } catch (e, stack) {
      print("Error In GetPostUser is : $e in $stack");
      emit(ErrorGetPostUserState("Error is $e"));
    }
  }
  /// get Status User
  Future<void> getStatusUser() async {
    HomePageDataSourceImpl getStatusUserDataSourceImpl =
    const HomePageDataSourceImpl();
    try {
      if(!isClosed) {
        emit(LoadingGetStatusUserState());
      }
      var getStatusUserData =
      await getStatusUserDataSourceImpl.getStatusUser();

      if (getStatusUserData.data != null) {
        if(!isClosed) {
          emit(SuccessGetStatusUserState(getStatusUserData.data!));
        }  } else {
        if(!isClosed) {
          emit(ErrorGetStatusUserState(getStatusUserData.error!.message!));
        }   }
    } catch (e, stack) {
      print("Error In GetStatusUser is : $e in $stack");
      if(!isClosed) {
        emit(ErrorGetStatusUserState("Error is $e"));
      } }
  }
  Future<void> evaluateCompany({
    required int companyId,
    required double value,
  }) async {
    ProfilePageDataSourceImpl evaluateCompanyDataSourceImpl =
    const ProfilePageDataSourceImpl();
    try {
      emit(LoadingEvaluateCompanyState());

      var evaluateAdsData =
      await evaluateCompanyDataSourceImpl.evaluateCompany(companyId: companyId, value: value);

      if (evaluateAdsData.data != null) {
        emit(SuccessEvaluateCompanyState(evaluateAdsData.data!));
      } else {
        emit(ErrorEvaluateCompanyState(evaluateAdsData.error!.message!));
      }
    } catch (e, stack) {
      print("Error In EvaluateAds is : $e in $stack");
      emit(ErrorEvaluateCompanyState("Error is $e"));
    }
  }

  Future<void> sendOtp(String mobile) async {
    AuthRemoteDataSourceImpl authRemoteDataSourceImpl =
        const AuthRemoteDataSourceImpl();
    try {
      emit(LoadingSendOTPState());

      Result otp = await authRemoteDataSourceImpl.sendVerificationCode(mobile);

      if (otp.data != null) {
        emit(SuccessSendOTPState(otp.data));
        print(otp.data);
      } else {
        emit(ErrorSendOTPState(otp.error!.message!));
      }
    } catch (e, stack) {
      print("Error In SendOtp is : $e in $stack");
      emit(ErrorSendOTPState("Error is $e"));
    }
  }

  Future<void> validateMobileNumber(String otpCode, String mobile) async {
    AuthRemoteDataSourceImpl authRemoteDataSourceImpl =
        const AuthRemoteDataSourceImpl();
    try {
      emit(LoadingValidateMobileNumberState());
      Result validation =
          await authRemoteDataSourceImpl.validateMobileNumber(otpCode, mobile);
      // if(validation.data)

      if (validation.data != null) {
        emit(SuccessValidateMobileNumberState(validation.data));
      } else {
        print(validation.error!.message!);
        emit(ErrorValidateMobileNumberState(validation.error!.message!));
      }
    } catch (e, stack) {
      print("Error In validateMobileNumber is : $e in $stack");
      emit(ErrorValidateMobileNumberState("Error is $e"));
    }
  }

  Future<void> checkMobileExists({
    String? mobileNumber,
  }) async {
    ProfilePageDataSourceImpl profileDataSourceImpl =
        const ProfilePageDataSourceImpl();
    try {
      emit(LoadingCheckMobileExistsState());

      var profileData = await profileDataSourceImpl.checkMobileExists(
        mobileNumber: mobileNumber,
      );

      if (profileData.data != null) {
        emit(SuccessCheckMobileExistsState(profileData.data!));
      } else {
        emit(ErrorCheckMobileExistsState(profileData.error.toString()));
      }
    } catch (e) {
      print("Error : $e");
      emit(ErrorCheckMobileExistsState(e.toString()));
    }
  }

  Future<void> getInformationCompany() async {
    ProfilePageDataSourceImpl profileDataSourceImpl =
        const ProfilePageDataSourceImpl();
    try {
      emit(LoadingCompanyInformationState());

      var profileData = await profileDataSourceImpl.companyInformation();

      if (profileData.data != null) {
        emit(SuccessCompanyInformationState(profileData.data!));
      } else {
        emit(ErrorCompanyInformationState(profileData.error.toString()));
      }
    } catch (e) {
      print("Error : $e");
      emit(ErrorCompanyInformationState(e.toString()));
    }
  }

  Future<void> getPackageCompany() async {
    ProfilePageDataSourceImpl profileDataSourceImpl =
        const ProfilePageDataSourceImpl();
    try {
      emit(LoadingPackageCompanyState());

      var packageData = await profileDataSourceImpl.getPackageCompany();

      if (packageData.data != null) {
        emit(SuccessPackageCompanyState(packageData.data!));
      } else {
        emit(ErrorPackageCompanyState(packageData.error.toString()));
      }
    } catch (e) {
      print("Error : $e");
      emit(ErrorPackageCompanyState(e.toString()));
    }
  }
  Future<void> getAllPackageCompany() async {
    ProfilePageDataSourceImpl profileDataSourceImpl =
    const ProfilePageDataSourceImpl();
    try {
      emit(LoadingPackageCompanyState());

      var packageData = await profileDataSourceImpl.getAllPackageCompany();

      if (packageData.data != null) {
        emit(SuccessPackageCompanyState(packageData.data!));
      } else {
        emit(ErrorPackageCompanyState(packageData.error.toString()));
      }
    } catch (e) {
      print("Error : $e");
      emit(ErrorPackageCompanyState(e.toString()));
    }
  }

  Future<void> editImageProfile({
    required File? image,
  }) async {
    ProfilePageDataSourceImpl profileDataSourceImpl =
        const ProfilePageDataSourceImpl();
    try {
      emit(LoadingEditImageProfileState());

      var editImageProfile = await profileDataSourceImpl.editImageProfile(
        image: image,
      );

      if (editImageProfile.data != null) {
        emit(SuccessEditImageProfileState(editImageProfile.data!));
      } else {
        emit(ErrorEditImageProfileState(editImageProfile.error.toString()));
      }
    } catch (e) {
      print("Error : $e");
      emit(ErrorEditImageProfileState(e.toString()));
    }
  }

  Future<void> getInfoMyCompany({
    required int idCompany,
    bool isLoading = true,
  }) async {
    ProfilePageDataSourceImpl profileDataSourceImpl =
        const ProfilePageDataSourceImpl();
    try {
      if(isLoading){
        emit(LoadingCompanyInformationState());

      }
      var profileData = await profileDataSourceImpl
          .getInfoMyCompany(idCompany: idCompany);

      if (profileData.data != null) {
        emit(SuccessCompanyInformationState(profileData.data!));
      } else {
        emit(ErrorCompanyInformationState(profileData.error.toString()));
      }
    } catch (e,stack) {
      print("Error : $e");
      print("stack : $stack");
      emit(ErrorCompanyInformationState(e.toString()));
    }
  }

  Future<void> getInformationCompanyForAdvertisersAdmin() async {
    ProfilePageDataSourceImpl profileDataSourceImpl =
    const ProfilePageDataSourceImpl();
    try {
      emit(LoadingCompanyInformationState());

      var profileData = await profileDataSourceImpl
          .companyInformationForAdvertisersAdmin();

      if (profileData.data != null) {
        emit(SuccessCompanyInformationState(profileData.data!));
      } else {
        emit(ErrorCompanyInformationState(profileData.error.toString()));
      }
    } catch (e,stack) {
      print("Error : $e");
      print("stack : $stack");
      emit(ErrorCompanyInformationState(e.toString()));
    }
  }



  Future<void> getFormatDate({
    required String createdAt,
    required String joinedAt,
  }) async {
    print(createdAt);
    print(joinedAt);
    try {
      emit(LoadingDataFormatState());

      DateTime createdAtDateTime = DateTime.parse(createdAt);
      DateTime joinedAtDateTime = DateTime.parse(joinedAt);

      String createdAtTime = DateFormat('yyyy-MM-dd').format(createdAtDateTime);
      String joinedAtTime = DateFormat('yyyy-MM-dd').format(joinedAtDateTime);

      print(createdAtTime);
      print(joinedAtTime);
      emit(SuccessDataFormatState(
          createAt: createdAtTime, joinAt: joinedAtTime));
    } catch (e) {
      print("Error : $e");
      emit(ErrorDataFormatState(e.toString()));
    }
  }

  Future<void> getInformationCompanyAbout() async {
    ProfilePageDataSourceImpl profileDataSourceImpl =
        const ProfilePageDataSourceImpl();
    try {
      emit(LoadingCompanyInformationAboutState());

      var profileData =
          await profileDataSourceImpl.getProfileInformationCompany();

      if (profileData.data != null) {
        emit(SuccessCompanyInformationAboutState(profileData.data!));
      } else {
        emit(ErrorCompanyInformationAboutState(profileData.error.toString()));
      }
    } catch (e) {
      print("Error : $e");
      emit(ErrorCompanyInformationAboutState(e.toString()));
    }
  }

  Future<void> getDescriptionCompany({
    required int? idCompany,
  }) async {
    ProfilePageDataSourceImpl profileDataSourceImpl =
        const ProfilePageDataSourceImpl();
    try {
      emit(LoadingCompanyDescriptionState());

      var profileData = await profileDataSourceImpl.getDescriptionCompany(
          idCompany: idCompany);

      if (profileData.data != null) {
        emit(SuccessCompanyDescriptionState(profileData.data!));
      } else {
        emit(ErrorCompanyDescriptionState(profileData.error.toString()));
      }
    } catch (e,stack) {
      print("Error : $e");
      print("stack : $stack");
      emit(ErrorCompanyDescriptionState(e.toString()));
    }
  }


  Future<void> getProfileUser() async {
    ProfilePageDataSourceImpl profileDataSourceImpl =
    const ProfilePageDataSourceImpl();
    try {
      emit(LoadingProfileUserState());

      var profileData = await profileDataSourceImpl.getProfileUser();

      if (profileData.data != null) {
        emit(SuccessProfileUserState(profileData.data!));
      } else {
        emit(ErrorProfileUserState(profileData.error.toString()));
      }
    } catch (e) {
      print("Error : $e");
      emit(ErrorProfileUserState(e.toString()));
    }
  }


  Future<void> changeAdsFromExpired() async {
    ProfilePageDataSourceImpl profileDataSourceImpl =
    const ProfilePageDataSourceImpl();
    try {
      emit(LoadingChangeAdsFromExpiredState());

      var profileData = await profileDataSourceImpl.changeAdsFromExpired();

      if (profileData.data != null) {
        emit(SuccessChangeAdsFromExpiredState(profileData.data!));
      } else {
        emit(ErrorChangeAdsFromExpiredState(profileData.error.toString()));
      }
    } catch (e) {
      print("Error : $e");
      emit(ErrorChangeAdsFromExpiredState(e.toString()));
    }
  }
  Future<void> editInformationCompany({
    String? companyName,
    String? personName,
    String? licenseName,
    int? subcategory_id,
    String? country,
    int? companyActivity,
    String? expiryDate,
    File? commercialLicense,
    String? companyDescription,
  }) async {
    ProfilePageDataSourceImpl profileDataSourceImpl =
        const ProfilePageDataSourceImpl();
    try {
      emit(LoadingEditInformationCompanyState());

      var profileData = await profileDataSourceImpl.editInformationCompany(
        personName: personName,
        expiryDate: expiryDate,
        country: country,
        subcategory_id: subcategory_id,
        companyName: companyName,
        companyActivity: companyActivity,
        commercialLicense: commercialLicense,
        licenseName: licenseName,
        companyDescription: companyDescription,
      );

      if (profileData.data != null) {
        emit(SuccessEditInformationCompanyState(profileData.data!));
      } else {
        emit(ErrorEditInformationCompanyState(profileData.error.toString()));
      }
    } catch (e,stack) {
      print("Error : $e");
      print("Error : $stack");
      emit(ErrorEditInformationCompanyState(e.toString()));
    }
  }

  XFile? fileLicense;

  Future<void> openCamera() async {
    try {
      emit(LoadingLoadFileState());
      final picker = ImagePicker();
      XFile? result = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
      );

      if (result != null) {
        // حجم الصورة بالبايت
        int fileSizeInBytes = File(result.path).lengthSync();
        // تحويل الحجم إلى ميغابايت
        double fileSizeInMb = fileSizeInBytes / (1024 * 1024);
        print(fileSizeInMb);
        if (fileSizeInMb > 1) {
          print('خطأ: حجم الصورة أكبر من 1 ميغابايت');

          // return;
          fileLicense = null;
          emit(UpToOneMegaLoadFileProfileState());
          // setState(() {
          //
          // });
          // SnackBarHelper.mySnackBarError('خطأ: حجم الصورة أكبر من 1 ميغابايت', context);
        } else {
          fileLicense = result;
          // fileLicense = File(result!.path);
          print(fileLicense);
          // setState(() {});
          // await uploadFile(filePath);
          emit(SuccessLoadFileProfileState(fileLicense));
        }
      }
    } catch (e) {
      emit(ErrorLoadFileState());
      print('Error picking image camera: $e');
    }
  }

  Future<void> loadImages() async {
    try {
      emit(LoadingLoadFileState());
      final picker = ImagePicker();
      XFile? result = await picker.pickImage(source: ImageSource.gallery,
          imageQuality: 50,
          );

      final File file = File(result!.path);
      // File rotatedFile = await FlutterExifRotation.rotateAndSaveImage(path: file.path);
      int fileSizeInBytes = File(result.path).lengthSync();
      double fileSizeInMb = fileSizeInBytes / (1024 * 1024);
      print('fileSizeInMb : $fileSizeInMb');
      final compressedFile = await FileManager.compressFile(file,false,
      isProfile: true);
      if (compressedFile != null) {
        Directory tempDir = await getTemporaryDirectory();
        String tempPath = '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
        await compressedFile.copy(tempPath);

        fileLicense = XFile(tempPath);
        int fileSizeInBytes2 = File(fileLicense!.path).lengthSync();
        double fileSizeInMb = fileSizeInBytes2 / (1024 * 1024);
        print('fileSizeInBytes2 : $fileSizeInMb');
        emit(SuccessLoadFileProfileState(fileLicense));
      }
      // if (result != null) {
      //   // حجم الصورة بالبايت
      //   final File file = File(result.path);
      //   final compressedFile = await FileManager.compressFile(file,false);
      //   if (compressedFile != null) {
      //     Directory tempDir = await getTemporaryDirectory();
      //     String tempPath = '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      //     await compressedFile.copy(tempPath);
      //     fileLicense = XFile(tempPath);
      //     emit(SuccessLoadFileState(fileLicense));
      //   }
      // }
    } catch (e) {
      print('Error picking load image: $e');
      emit(ErrorLoadFileState());
    }
  }

  Future<void> pickPDFAndUpload() async {
    try {
      emit(LoadingLoadFileState());
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        int fileSizeInBytes = result.files.first.size;
        double fileSizeInMb = fileSizeInBytes / (1024 * 1024);
        if (fileSizeInMb > 1) {
          emit(UpToOneMegaLoadFileProfileState());
          print('خطأ: حجم الصورة أكبر من 1 ميغابايت');
          return;
        } else {
          fileLicense = XFile(result.files.single.path!);
          emit(SuccessLoadFileProfileState(fileLicense));
          print(fileLicense);

          print(fileLicense!.path);
        }
      } else {}
    } catch (e) {
      emit(ErrorLoadFileState());
      print('Error picking PDF: $e');
    }
  }
}
