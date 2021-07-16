import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobile/blocs/MoreLocationServicesBloc.dart';
import 'package:mobile/models/SignUpOnBoardSelectedAnswersModel.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/util/constant.dart';

class MoreLocationServicesScreen extends StatefulWidget {
  final Function(Stream, Function) showApiLoaderCallback;
  final Future<dynamic> Function(String, dynamic) openActionSheetCallback;

  const MoreLocationServicesScreen({Key key, this.showApiLoaderCallback, this.openActionSheetCallback}) : super(key: key);

  @override
  _MoreLocationServicesScreenState createState() =>
      _MoreLocationServicesScreenState();
}

class _MoreLocationServicesScreenState
    extends State<MoreLocationServicesScreen> {
  bool _locationServicesSwitchState;

  Position _position;

  MoreLocationServicesBloc _bloc;

  @override
  void initState() {
    super.initState();

    _locationServicesSwitchState = false;

    _bloc = MoreLocationServicesBloc();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      bool isLocationAllowed = await Utils.checkLocationPermission();

      if(isLocationAllowed ?? false) {
        setState(() {
          _locationServicesSwitchState = true;
        });
      }

      widget.showApiLoaderCallback(
        _bloc.stream, () {
          _bloc.enterDummyDataToStreamController();
          _bloc.fetchMyProfileData();
      });

      _bloc.fetchMyProfileData();
    });

    _getLocationPosition();

    _listenToStream();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        if(!_locationServicesSwitchState) {
          return true;
        } else {
          _openSaveAndExitActionSheet();
          return false;
        }
      },
      child: Container(
        decoration: Constant.backgroundBoxDecoration,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: SafeArea(
                child: Column(
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        if(!_locationServicesSwitchState) {
                          Navigator.pop(context);
                        } else {
                          _openSaveAndExitActionSheet();
                        }
                      },
                      child: Container(
                        padding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Constant.moreBackgroundColor,
                        ),
                        child: Row(
                          children: [
                            Image(
                              width: 20,
                              height: 20,
                              image: AssetImage(Constant.leftArrow),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              Constant.locationServices,
                              style: TextStyle(
                                  color: Constant.locationServiceGreen,
                                  fontSize: 16,
                                  fontFamily: Constant.jostMedium),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Constant.moreBackgroundColor,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15, top: 15, bottom: 15),
                            child: Text(
                              Constant.locationServices,
                              style: TextStyle(
                                  color: Constant.locationServiceGreen,
                                  fontSize: 16,
                                  fontFamily: Constant.jostMedium
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: CupertinoSwitch(
                              value: _locationServicesSwitchState,
                              onChanged: (bool state) {
                                if (state) {
                                  _checkLocationPermission();
                                } else {
                                  setState(() {
                                    _locationServicesSwitchState = state;
                                    //widget.removeSelectedAnswerCallback(widget.question.tag);
                                  });
                                }
                              },
                              activeColor: Constant.chatBubbleGreen.withOpacity(0.6),
                              trackColor: Constant.chatBubbleGreen.withOpacity(0.2),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        Constant.enablingLocationServices,
                        style: TextStyle(
                            color: Constant.locationServiceGreen,
                            fontSize: 14,
                            fontFamily: Constant.jostMedium
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /*Future<void> _checkLocationPermission() async {
    _isCheckingLocation = true;
    Position position = await Utils.determinePosition();

    setState(() {
      _locationServicesSwitchState = position != null;
      _isCheckingLocation = false;
    });
  }*/

  void _getLocationPosition() async {
    Position position = await Utils.determinePosition();
    print('Position????$position');
    _position = position;
  }

  Future<void> _checkLocationPermission() async {
    if(_position == null) {
      //Utils.showApiLoaderDialog(context);
      /*_position = await Utils.determinePosition();
      Navigator.pop(context);*/

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if(permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        //Navigator.pop(context);
        var result = await Utils.showConfirmationDialog(context, 'You haven\'t allowed Location permissions to BonTriage. If you want to access Location, please grant permission.','Permission Required!','Not now','Allow');
        if(result == 'Yes') {
          Geolocator.openAppSettings();
        }
      } else {
        setState(() {
          _locationServicesSwitchState = true;
        });
        _position = await Utils.determinePosition();
        //Navigator.pop(context);
      }
    }

    if(_position != null) {
      setState(() {
        _locationServicesSwitchState = true;
      });
      List<String> latLngList = [];
      latLngList.add(_position.latitude.toString());
      latLngList.add(_position.longitude.toString());
      //widget.selectedAnswerCallBack(widget.question.tag, jsonEncode(latLngList));
    }
  }

  Future<void> _openSaveAndExitActionSheet() async {
    if(_position == null) {
      Navigator.pop(context);
      return;
    }

    double lat = _position.latitude;
    double lng = _position.longitude;

    print('Lat???$lat????${_bloc.lat}');
    print('Lng???$lng????${_bloc.lng}');

    if(lat != _bloc.lat || lng != _bloc.lng) {
      var result = await widget.openActionSheetCallback(Constant.saveAndExitActionSheet, null);

      if(result != null && result is String) {
        if(result == Constant.saveAndExit) {
          SelectedAnswers locationSelectedAnswers = _bloc.profileSelectedAnswerList.firstWhere((element) => element.questionTag == Constant.profileLocationTag, orElse: () => null);
          List<String> latLngValues = [_position.latitude.toString(), _position.longitude.toString()];

          if(locationSelectedAnswers == null) {
            _bloc.profileSelectedAnswerList.add(SelectedAnswers(questionTag: Constant.profileLocationTag, answer: jsonEncode(latLngValues)));
          } else {
            locationSelectedAnswers.answer = jsonEncode(latLngValues);
          }

          widget.showApiLoaderCallback(_bloc.stream, () {
            _bloc.enterDummyDataToStreamController();
            _bloc.editMyProfileData();
          });
          _bloc.editMyProfileData();
        }
      } else {
        Navigator.pop(context);
      }
    }
  }

  void _listenToStream() {
    _bloc.myProfileStream.listen((event) {
      if(event is String && event == Constant.success) {
        Navigator.pop(context);
      }
    });
  }
}
