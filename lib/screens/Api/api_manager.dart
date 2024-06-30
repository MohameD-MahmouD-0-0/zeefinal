import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/screens/Add_Diseases/DiseaseRespnse.dart';
import 'package:flutter_application_1/screens/Add_Diseases/Diseases_Request.dart';
import 'package:flutter_application_1/screens/add_screen.dart';
import 'package:http/http.dart' as http;
import '../../Dialog.dart';
import '../Paitent/paitentRequest.dart';
import '../Register/Register_Request.dart';
import '../Register/Register_Response.dart';
import '../addPaitientInfo_screen.dart';
import 'api_constant.dart';
class Api_manager {
  static Future<RegisterResponse?>register(String name , String emaill,
      String Password,String RePassword ,String PhoneNumber,BuildContext context) async {
    Uri url = Uri.https(Api_constant.baseurl,Api_constant.register);
    DialogUtils.showLoading(context,"Loding");
    try {
      var requestbody = RegisterRequest(
          name: name,
          emaill: emaill,
          password: Password,
          rePassword: RePassword,
          phoneNumber: PhoneNumber);
      var response = await http.post(url,body: requestbody.toJson());
      if(response.statusCode==201)
        {
          DialogUtils.closeLoading(context);
          DialogUtils.showMessage(context,message: "Register Succuessfully",
              title: "Success",posActionName: 'Ok',
              posAction: (){Navigator.of(context).pushNamed(AddScreen.routeName);});
          return RegisterResponse.fromJson(jsonDecode(response.body));
        }
      if(response.statusCode==400)
        {
          DialogUtils.closeLoading(context);
          DialogUtils.showMessage(context,message: "register with this name already exists  ",title: "Fail",posActionName: 'Ok' );
        }
    }catch(e)
    {
      throw e;
    }
    return null;

  }

  static Future<DiseaseResponse?>registerDisease(String deasesname,
      String deasesDiscription, String commenSymptoms, BuildContext context) async {
    Uri url = Uri.https(Api_constant.baseurl, Api_constant.Diseases);
    DialogUtils.showLoading(context, "Loading");

    var headers = {
      'Content-Type': 'application/json'
    };
    try {
      var requestBody = DiseasesRequest(
        deasesname: deasesname,
        deasesDiscription: deasesDiscription,
        commenSymptoms: commenSymptoms,
      );
      var response = await http.post(headers: headers,url,body: jsonEncode(requestBody.toJson()));
      if (response.statusCode == 201) {
        DialogUtils.closeLoading(context);
        DialogUtils.showMessage(context, message: "Disease Added successfully", title: "Success", posActionName: 'Ok', posAction: () {
          Navigator.of(context).pushNamed(AddPatientInfo.routeName);
        });
        return DiseaseResponse.fromJson(jsonDecode(response.body));
      }
      if (response.statusCode == 400) {
        DialogUtils.closeLoading(context);
        DialogUtils.showMessage(context, message: "failed operation", title: "Fail", posActionName: 'Ok');
      }
    } catch (e) {
      throw e;
    }
    return null;
    }

  static Future<RegisterResponse?> registerPatient(
      String firstName,
      String lasttName,
      String email,
      String phoneNumber,
      String handel,
      // String profilePicture,
      bool male,
      bool female,
      BuildContext context) async {
    Uri url = Uri.https(Api_constant.baseurl, Api_constant.Patinet);
    DialogUtils.showLoading(context, "Loading");
    try {
      var requestBody = PaitentRequest(
        firstName: firstName,
        lasttName: lasttName,
        email: email,
        phoneNumber: phoneNumber,
        handel: handel,
        // profilePicture: profilePicture,
        male: male,
        female: female,
      );
      var response = await http.post(url, body: jsonEncode(requestBody.toJson()));
      if (response.statusCode == 201) {
        DialogUtils.closeLoading(context);
        DialogUtils.showMessage(
          context,
          message: "Paitent Added Successfully",
          title: "Success",
          posActionName: 'Ok',
          posAction: () {
            Navigator.of(context).pushNamed('/AddScreen');
          },
        );
        return RegisterResponse.fromJson(jsonDecode(response.body));
      }
      if (response.statusCode == 400) {
        DialogUtils.closeLoading(context);
        DialogUtils.showMessage(
          context,
          message: "Register with this name already exists",
          title: "Fail",
          posActionName: 'Ok',
        );
      }
    } catch (e) {
      DialogUtils.closeLoading(context);
      DialogUtils.showMessage(
        context,
        message: "An error occurred: $e",
        title: "Error",
        posActionName: 'Ok',
      );
    }
    return null;
  }
}