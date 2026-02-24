import 'dart:io';
import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_editor/image_editor.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../common/base_scaffold.dart';

class CropPage extends StatelessWidget {
  final File image;
  final bool ifFixedSize;

  final controller = Get.put(CropPageController());

  CropPage({required this.image, this.ifFixedSize = false});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
        title: "Edit photo".tr,
        backgroundColor: Colors.black,
        actions: [
          GestureDetector(
            onTap: () => controller.crop((image) => Get.back(result: image)),
            child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
                color: Colors.transparent,
                child: Text(
                  "Done".tr,
                  style: TextStyle(fontSize: 16, color: Colors.white),
                )),
          ),
        ],
        body: Container(
          color: Colors.black,
          child: ExtendedImage.file(
            image,
            fit: BoxFit.contain,
            mode: ExtendedImageMode.editor,
            extendedImageEditorKey: controller.editorKey,
            initEditorConfigHandler: (state) {
              return EditorConfig(
                maxScale: 8.0,
                cropRectPadding: EdgeInsets.all(20.0),
                hitTestSize: 20.0,
                editorMaskColorHandler: (context, down) {
                  return Colors.black.withOpacity(down ? 0.4 : 0.8);
                },
                cropAspectRatio: ifFixedSize
                    ? CropAspectRatios.ratio16_9
                    : CropAspectRatios.custom,
              );
            },
          ),
        ));
  }
}

class CropPageController extends GetxController {
  final GlobalKey<ExtendedImageEditorState> editorKey =
      GlobalKey<ExtendedImageEditorState>();
  File? cropImage;
  bool _cropping = false;
  double progress = 0;

  void crop(Function(File? file) onDone) async {
    if (_cropping) return;
    var msg = "";
    try {
      _cropping = true;
      Uint8List? fileData =
          await cropImageDataWithNativeLibrary(state: editorKey.currentState!);
      cropImage = await compressAndGetFile(fileData!);
      onDone(cropImage);
    } catch (e) {
      _cropping = false;
      msg = "保存出错: $e\n";
    }
  }

  Future<File> writeToFile(List<int> image, String filePath) async {
    File file = File(filePath);
    return file.writeAsBytes(image, flush: true, mode: FileMode.write);
  }

  Future<File> compressAndGetFile(Uint8List file) async {
    Directory tempDir = await getTemporaryDirectory();
    int index = DateTime.now().millisecondsSinceEpoch;
    String tempPath = tempDir.path;
    String name = "header_$index.jpg";
    tempPath = tempPath + "/" + name;
    var result = await FlutterImageCompress.compressWithList(
      file,
      quality: 60,
      minWidth: 400,
      minHeight: 400,
    );
    return await writeToFile(result, tempPath);
  }

  Future<Uint8List?> cropImageDataWithNativeLibrary(
      {required ExtendedImageEditorState state}) async {
    final cropRect = state.getCropRect() ?? Rect.zero;
    final action = state.editAction ?? EditActionDetails();
    final rotateAngle = action.rotateAngle.toInt();
    final flipHorizontal = action.flipY;
    final flipVertical = action.flipX;
    final img = state.rawImageData;
    ImageEditorOption option = ImageEditorOption();
    if (action.needCrop) {
      option.addOption(ClipOption.fromRect(cropRect));
    }
    if (action.needFlip) {
      option.addOption(
          FlipOption(horizontal: flipHorizontal, vertical: flipVertical));
    }
    if (action.hasRotateAngle) {
      option.addOption(RotateOption(rotateAngle));
    }

    final start = DateTime.now();
    final result = await ImageEditor.editImage(
      image: img,
      imageEditorOption: option,
    );
    return result;
  }
}
