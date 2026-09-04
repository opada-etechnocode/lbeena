
import 'dart:io';

import 'package:syrians_in_uae/ui/screens/auth/register/cubit/status.dart';
import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../../core/results/result.dart';
import '../../../../../data/models/auth/register/register_company_from_data.dartregister_from_data.dart';
import '../../../../../data/models/auth/register/register_from_data.dart';
import '../../../../../data/models/company/activity_company_model.dart';
import '../../../../../data/sources/auth/auth_remote_data_source.dart';
import '../../../../../data/sources/profile/profile_page_data_source.dart';
import '../../../../../widgets/components.dart';
import '../../../../../widgets/file_compress.dart';
import '../../login/cubit/cubit.dart';


class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(InitialOTPState());
  static RegisterCubit get(context) => BlocProvider.of(context);

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



  Future<void> getActivityCompany() async {
    AuthRemoteDataSourceImpl authRemoteDataSourceImpl =
    const AuthRemoteDataSourceImpl();
    try {
      emit(LoadingActivityCompanyState());

      Result<ActivityCompanyModel> data = await authRemoteDataSourceImpl.getActivityCompany();

      if (data.data != null) {
          setDataCompany(data.data!);
        emit(SuccessActivityCompanyState(data.data!));
        print(data.data);
      } else {
        emit(ErrorActivityCompanyState(data.error!.message!));
      }
    } catch (e, stack) {
      print("Error In SendOtp is : $e in $stack");
      emit(ErrorActivityCompanyState("Error is $e"));
    }
  }



  Future<void> validateMobileNumber(String otpCode , String mobile ) async{
    AuthRemoteDataSourceImpl authRemoteDataSourceImpl = const AuthRemoteDataSourceImpl();
    try{
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

    }catch(e,stack){
      print("Error In validateMobileNumber is : $e in $stack");
      emit(ErrorValidateMobileNumberState("Error is $e"));
    }
  }

  Future<void> login(String phone, String password) async {
    AuthRemoteDataSourceImpl authRemoteDataSourceImpl =
    const AuthRemoteDataSourceImpl();
    try {
      emit(LoadingLoginState());

      var authentication =
      await authRemoteDataSourceImpl.login(phone, password);



      if (authentication.data!.data != null) {
        unSubscribeToTopic();

        emit(SuccessLoginState(authentication.data!));
      } else {
        emit(ErrorLoginState(authentication.data!.message!));
      }
    } catch (e, stack) {
      print("Error In Login is : $e in $stack");
      emit(ErrorLoginState("Error is $e"));
    }
  }

  Future<void> resetPassword(String mobile, String password,String confirmPassword) async{
    AuthRemoteDataSourceImpl authRemoteDataSourceImpl = const AuthRemoteDataSourceImpl();
    try{
      emit(LoadingResetPasswordState());
      Result resetPassword =
      await authRemoteDataSourceImpl.resetPassword(mobile, password,confirmPassword);
      // if(resetPassword.data)

      if (resetPassword.data != null) {
        emit(SuccessResetPasswordState(resetPassword.data));
      } else {
        print(resetPassword.error!.message!);
        emit(ErrorResetPasswordState(resetPassword.error!.message!));
      }

    }catch(e,stack){
      print("Error In ResetPassword is : $e in $stack");
      emit(ErrorResetPasswordState("Error is $e"));
    }
  }

  Future<void> registerUser (
  {required RegisterFromData registerFromData}
      ) async{
    AuthRemoteDataSourceImpl authRemoteDataSourceImpl = const AuthRemoteDataSourceImpl();
    try{
      emit(LoadingRegisterUserState());
      Result registerUser =
      await authRemoteDataSourceImpl.registerUser(registerFromData: registerFromData);
      // if(registerUser.data)

      if (registerUser.data != null) {
        emit(SuccessRegisterUserState(registerUser.data));
      } else {
        print(registerUser.error!.message!);
        emit(ErrorRegisterUserState(registerUser.error!.message!));
      }

    }catch(e,stack){
      print("Error In RegisterUser is : $e in $stack");
      emit(ErrorRegisterUserState("Error is $e"));
    }
  }


  Future<void> registerCompany (
      {required RegisterFromDataCompany registerFromDataCompany}
      ) async{
    AuthRemoteDataSourceImpl authRemoteDataSourceImpl = const AuthRemoteDataSourceImpl();
    try{
      emit(LoadingRegisterCompanyState());
      Result registerCompany =
      await authRemoteDataSourceImpl.registerCompany(registerFromDataCompany: registerFromDataCompany);
      // if(registerUser.data)

      if (registerCompany.data != null) {
        emit(SuccessRegisterCompanyState(registerCompany.data));
      } else {
        print(registerCompany.error!.message!);
        emit(ErrorRegisterCompanyState(registerCompany.error!.message!));
      }

    }catch(e,stack){
      print("Error In RegisterUser is : $e in $stack");
      emit(ErrorRegisterCompanyState("Error is $e"));
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
  Future<void> transferUserToCompany (
      {required RegisterFromDataCompany transferUserToCompanyFromDataCompany}
      ) async{
    AuthRemoteDataSourceImpl authRemoteDataSourceImpl = const AuthRemoteDataSourceImpl();
    try{
      emit(LoadingRegisterCompanyState());
      Result transferUserToCompanyCompany =
      await authRemoteDataSourceImpl.transferUserToCompany(registerFromDataCompany: transferUserToCompanyFromDataCompany);
      // if(registerUser.data)

      if (transferUserToCompanyCompany.data != null) {
        emit(SuccessTransferUserToCompanyState(transferUserToCompanyCompany.data));
      } else {
        print(transferUserToCompanyCompany.error!.message!);
        emit(ErrorRegisterCompanyState(transferUserToCompanyCompany.error!.message!));
      }

    }catch(e,stack){
      print("Error In transferUserToCompanyUser is : $e in $stack");
      emit(ErrorRegisterCompanyState("Error is $e"));
    }
  }

  XFile? fileLicense;


  Future<void> openCamera() async {

    try {
      emit(LoadingLoadFileState());
      final picker = ImagePicker();
      XFile? result = await picker.pickImage(source: ImageSource.camera,
        imageQuality: 50,
      );

      if (result != null) {
        // // حجم الصورة بالبايت
        // int fileSizeInBytes = File(result.path).lengthSync();
        // // تحويل الحجم إلى ميغابايت
        // double fileSizeInMb = fileSizeInBytes / (1024 * 1024);
        // print(fileSizeInMb);
        // if (fileSizeInMb > 1) {
        //   print('خطأ: حجم الصورة أكبر من 1 ميغابايت');
        //
        //   // return;
        //   fileLicense =null;
        //   emit(UpToOneMegaLoadFileState());
        //   // setState(() {
        //   //
        //   // });
        //   // SnackBarHelper.mySnackBarError('خطأ: حجم الصورة أكبر من 1 ميغابايت', context);
        // } else {
        //
        //   fileLicense = result;
        //   // fileLicense = File(result!.path);
        //   print(fileLicense);
        //   // setState(() {});
        //   // await uploadFile(filePath);
        //   emit(SuccessLoadFileState(fileLicense));
        // }

        final File file = File(result.path);
        final compressedFile = await FileManager.compressFile(file,false);
        if (compressedFile != null) {
          Directory tempDir = await getTemporaryDirectory();
          String tempPath = '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
          await compressedFile.copy(tempPath);
          fileLicense = XFile(tempPath);
          emit(SuccessLoadFileState(fileLicense));}

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
      XFile? result = await picker.pickImage(source: ImageSource.gallery
        // imageQuality: 50,
      );

      if (result != null) {

        // int fileSizeInBytes = File(result.path).lengthSync();
        //
        // double fileSizeInMb = fileSizeInBytes / (1024 * 1024);
        // print(fileSizeInMb);
        //
        // if (fileSizeInMb > 1) {
        //
        //   fileLicense = result;
        //   emit(SuccessLoadFileState(fileLicense));
        //   // emit(UpToOneMegaLoadFileState());
        //   // print('خطأ: حجم الصورة أكبر من 1 ميغابايت');
        //   return;
        // } else {
        //
        //   fileLicense = result;
        //   emit(SuccessLoadFileState(fileLicense));
        //   print(fileLicense);
        //
        // }

        final File file = File(result.path);
        final compressedFile = await FileManager.compressFile(file,false);
        if (compressedFile != null) {
          Directory tempDir = await getTemporaryDirectory();
          String tempPath = '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
          await compressedFile.copy(tempPath);
          fileLicense = XFile(tempPath);
          emit(SuccessLoadFileState(fileLicense));
        }
      }

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
        if(fileSizeInMb > 3 ){
          emit(UpToOneMegaLoadFileState());
          print('خطأ: حجم الملف أكبر من 3 ميغابايت');
          return;
        }else {
          fileLicense = XFile(result.files.single.path!);
          emit(SuccessLoadFileState(fileLicense));
          print(fileLicense);

          print(fileLicense!.path); 
        }
        

      } else {

      }
    } catch (e) {
      emit(ErrorLoadFileState());
      print('Error picking PDF: $e');
    }
  }
}
