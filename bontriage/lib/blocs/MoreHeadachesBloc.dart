import 'dart:async';

import 'package:mobile/models/DeleteHeadacheResponseModel.dart';
import 'package:mobile/networking/AppException.dart';
import 'package:mobile/networking/RequestMethod.dart';
import 'package:mobile/repository/MoreHeadacheRepository.dart';
import 'package:mobile/util/WebservicePost.dart';
import 'package:mobile/util/constant.dart';

class MoreHeadacheBloc {
  MoreHeadacheRepository _moreHeadacheRepository;
  StreamController<dynamic> _deleteHeadacheStreamController;

  Stream<dynamic> get deleteHeadacheStream => _deleteHeadacheStreamController.stream;
  StreamSink<dynamic> get deleteHeadacheSink => _deleteHeadacheStreamController.sink;

  StreamController<dynamic> _networkStreamController;

  Stream<dynamic> get networkStream => _networkStreamController.stream;
  StreamSink<dynamic> get networkSink => _networkStreamController.sink;

  MoreHeadacheBloc() {
    _moreHeadacheRepository = MoreHeadacheRepository();

    _deleteHeadacheStreamController = StreamController<dynamic>();
    _networkStreamController = StreamController<dynamic>();
  }

  Future<void> callDeleteHeadacheTypeService(String eventId) async {
    try {
      var response = await _moreHeadacheRepository.deleteHeadacheServiceCall(
        '${WebservicePost.qaServerUrl}event/$eventId',
        RequestMethod.DELETE
      );
      if (response is AppException) {
        networkSink.addError(response);
      } else {
        if(response != null && response is DeleteHeadacheResponseModel) {
          networkSink.add(Constant.success);
          if(response.messageType == 'Event Deleted')
            deleteHeadacheSink.add(response.messageType);
          else
            networkSink.addError(Exception(Constant.somethingWentWrong));
        } else {
          networkSink.addError(Exception(Constant.somethingWentWrong));
        }
      }
    } catch(e) {
      networkSink.addError(Exception(Constant.somethingWentWrong));
    }
  }

  void initNetworkStreamController() {
    _networkStreamController?.close();
    _networkStreamController = StreamController<dynamic>();
  }

  void dispose() {
    _deleteHeadacheStreamController?.close();
    _networkStreamController?.close();
  }
}