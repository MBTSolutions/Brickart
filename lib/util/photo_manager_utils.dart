import 'package:photo_manager/photo_manager.dart';

class PhotoManagerUtils {
  static Future<List<AssetEntity>> getPhotos(
      {int page: 1, int pageSize = 30}) async {
    try{
      var assetPathList = await PhotoManager.getAssetPathList(
        onlyAll: true,
        type: RequestType.image,
      );
      return await assetPathList.first.getAssetListPaged(page, pageSize);
    }catch(e){
      print(e);
      return null;
    }
  }
}
