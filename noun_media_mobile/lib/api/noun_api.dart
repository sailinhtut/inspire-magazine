import 'package:inspired_blog/advertisement/model/advertisement.dart';
import 'package:inspired_blog/api/configs/api_routes.dart';
import 'package:inspired_blog/api/http_service.dart';
import 'package:inspired_blog/app/model/header_image.dart';
import 'package:inspired_blog/app/model/meta_data.dart';
import 'package:inspired_blog/entertainment/model/entertainment.dart';

import 'package:inspired_blog/magazine/model/magazine.dart';
import 'package:inspired_blog/utils/functions.dart';

class NounAPI {
  // get magazines
  static Future<dynamic> getMagazines(int page) async {
    dd('[API Service] Getting magazines');

    final response = await HTTP.get(
      endPoint: NounAPIRoutes.PUBLIC_MAGAZINES,
      parameters: {"page": page},
    );

    if (response != null) {
      final data = response.data;
      dd('$data', emphasized: false, response: true);

      if (response.statusCode == 200) {
        return data;
      }
    }

    return {};
  }

  // get single magazine
  static Future<Magazine?> getMagazine(int magazineId) async {
    dd('[API Service] Getting magazine #$magazineId');

    final response = await HTTP.get(
      endPoint: "${NounAPIRoutes.MAGAZINES}/$magazineId",
    );

    if (response != null) {
      final data = response.data;
      dd('$data', emphasized: false, response: true);

      if (response.statusCode == 200) {
        return Magazine.fromJson(data);
      }
    }

    return null;
  }

  // search blogs
  static Future<List<Magazine>> searchMagazines(String needle) async {
    dd('[API Service] Searching journal');

    final response = await HTTP.get(
      endPoint: NounAPIRoutes.MAGAZINES,
      parameters: {"search": needle},
    );

    if (response != null) {
      final data = response.data;
      dd('$data', emphasized: false, response: true);

      if (response.statusCode == 200) {
        final magaines =
            List<dynamic>.from(data).map((e) => Magazine.fromJson(e)).toList();
        return magaines;
      }
    }

    return [];
  }

  // get entertainments
  static Future<dynamic> getEntertainments(int page) async {
    dd('[API Service] Getting entertainments ');

    final response = await HTTP.get(
      endPoint: NounAPIRoutes.PUBLIC_ENTERTAINMENTS,
      parameters: {"page": page},
    );

    if (response != null) {
      final data = response.data;
      dd('$data', emphasized: false, response: true);

      if (response.statusCode == 200) {
        return data;
      }
    }

    return {};
  }

  // get single entertainment
  static Future<Entertainment?> getEntertainment(int entertainmentId) async {
    dd('[API Service] Getting entertainment #$entertainmentId ');

    final response = await HTTP.get(
      endPoint: "${NounAPIRoutes.ENTERTAINMENTS}/$entertainmentId",
    );

    if (response != null) {
      final data = response.data;
      dd('$data', emphasized: false, response: true);

      if (response.statusCode == 200) {
        return Entertainment.fromJson(data);
      }
    }

    return null;
  }

  // search entertainment
  static Future<List<Entertainment>> searchEntertainments(String needle) async {
    dd('[API Service] Searching entertainment');

    final response = await HTTP.get(
      endPoint: NounAPIRoutes.ENTERTAINMENTS,
      parameters: {"search": needle},
    );

    if (response != null) {
      final data = response.data;
      dd('$data', emphasized: false, response: true);

      if (response.statusCode == 200) {
        final entertainment = List<dynamic>.from(data)
            .map((e) => Entertainment.fromJson(e))
            .toList();
        return entertainment;
      }
    }

    return [];
  }

  // header images
  static Future<List<HeaderImage>> getHeaderImages() async {
    dd('[API Service] Getting header images');

    final response = await HTTP.get(
      endPoint: NounAPIRoutes.HEADER_IMAGES,
    );

    if (response != null) {
      final data = response.data;
      dd('$data', emphasized: false, response: true);

      if (response.statusCode == 200) {
        final images = List<dynamic>.from(data)
            .map((e) => HeaderImage.fromJson(e))
            .toList();
        return images;
      }
    }

    return [];
  }

  // advertisements
  static Future<List<Advertisement>> getAdvertisements() async {
    dd('[API Service] Getting advertisements');

    final response = await HTTP.get(
      endPoint: NounAPIRoutes.ADVERTISEMENT,
    );

    if (response != null) {
      final data = response.data;
      dd('$data', emphasized: false, response: true);

      if (response.statusCode == 200) {
        final advertisements = List<dynamic>.from(data)
            .map((e) => Advertisement.fromJson(e))
            .toList();
        return advertisements;
      }
    }

    return [];
  }

  // meta data
  static Future<NounMetaData?> getMetaData(String name) async {
    dd('[API Service] Getting meta data');

    final response = await HTTP.get(
      endPoint: "${NounAPIRoutes.META_DATA}/$name",
    );

    if (response != null) {
      final data = response.data;
      dd('$data', emphasized: false, response: true);

      if (response.statusCode == 200) {
        final metaData = NounMetaData.fromJson(data);
        return metaData;
      }
    }

    return null;
  }
}
