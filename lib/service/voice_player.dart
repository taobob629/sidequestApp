import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:wy/utils/index.dart';

/**
    author:mac
    创建日期:2023/3/31
    描述:
 */

class PlayState {
  static const int idle = 0;
  static const int playing = 1;
  static const int loadding = 2;
}

class AudioManager {
  // AudioManager({this._audioPlayer});

  RxInt _playState = RxInt(PlayState.idle);

  int get playState => _playState.value;

  set playState(int value) {
    _playState.value = value;
  }

  AudioPlayer _audioPlayer = AudioPlayer();

  AudioPlayer get audioPlayer => _audioPlayer;

  set audioPlayer(AudioPlayer value) {
    _audioPlayer = value;
  }

  factory AudioManager() => _getInstance();

  static AudioManager get instance => _getInstance();

  static AudioManager? _instance;

  // 获取唯一对象
  static AudioManager _getInstance() {
    _instance ??= AudioManager._internal();
    return _instance!;
  }

  //初始化...
  AudioManager._internal() {
    initPlayer();
  }

  void initPlayer() {
    audioPlayer?.playerStateStream.listen((state) {
      flog('playerStateStream $state');
      if (state.playing) {
        playState = PlayState.playing;
      }
      switch (state.processingState) {
        case ProcessingState.idle:
          playState = PlayState.idle;
          break;
        case ProcessingState.loading:
          playState = PlayState.loadding;
          break;
        case ProcessingState.buffering:
          break;
        case ProcessingState.ready:
          break;
        case ProcessingState.completed:
          stop();
          break;
      }
    });
  }

  Future<void> play(var voice) async {
    flog('voice $voice');
    if (audioPlayer == null) {
      audioPlayer = AudioPlayer();
      initPlayer();
    }
    if (audioPlayer?.playing == true) {
      await audioPlayer?.stop();
      return;
    }
    if (voice.isEmpty) {
      EasyLoading.showError('No Voice'.tr);
      return;
    }
    EasyLoading.show();
    final duration = await audioPlayer?.setUrl(voice); // Schemes: (https: | file: | asset: )
    EasyLoading.dismiss();
    audioPlayer?.play();
  }

  stop() async {
    playState = PlayState.idle;
    if (audioPlayer?.playing == true) await audioPlayer?.stop();
  }

  dispose() {
    audioPlayer?.dispose();
  }
}
