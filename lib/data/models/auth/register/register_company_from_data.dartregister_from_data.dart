import 'dart:io';

class RegisterFromDataCompany {

  RegisterFromDataCompany({
    this.companyName,
    this.mobile,
    this.password,
    this.personName,
    this.commercialLicense,
    this.licenseNumber,
    this.country,
    // this.companyActivity,
    this.companyDescription,
    this.business_activity_id,
    this.subActivityCompanyId,
    this.expiryDate,
    this.accountType,
});
  String? companyName ;
  String? personName ;
  int? business_activity_id ;
  int? subActivityCompanyId ;
  String? companyDescription ;
  File? commercialLicense ;
  String? licenseNumber ;
  String? country ;
  // String? companyActivity ;
  String? expiryDate ;
  String? mobile ;
  String? accountType ;
  String? password ;

}