import 'package:flutter/foundation.dart';
class Show_emoji with ChangeNotifier{
  bool _show_emoji=false;
  bool get SHOW_EMOJI=>_show_emoji;
  void update_emoji(bool value){
    _show_emoji=value;
    notifyListeners();
  }
  bool _upload_image=false;
  bool get UPLOAD_IMAGE=>_upload_image;
  void UPLOAD_LOADER(bool value){
    _upload_image=value;
    notifyListeners();
  }
}