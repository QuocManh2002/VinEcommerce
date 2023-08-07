import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ImageRepository{
  Future<String> uploadImageToFireBase(XFile? myImage) async {
  String imageUrl = '';

  String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

  //Step 2: Upload image to firebase storage
  Reference referenceRoot = FirebaseStorage.instance.ref();
  Reference referenceDirImages = referenceRoot.child('images');

  Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

  //Handle error/success
  try {
    //Store the file
    await referenceImageToUpload.putFile(File(myImage!.path));
    //Success
    imageUrl = await referenceImageToUpload.getDownloadURL();
    print('imageUrl: ' + imageUrl);
  } catch (error) {
    //Error occur
  }

  return imageUrl;
}
    pickImage(ImageSource source) async{
      final ImagePicker _imagePicker = ImagePicker();
      XFile? _file = await _imagePicker.pickImage(source: source);
      
      if(_file != null){
        return await _file;
      }
      print("no image selected");
    }
}