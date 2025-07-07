// ignore_for_file: non_constant_identifier_names

import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:inspired_blog_panel/advertisement/model/advertisement.dart';
import 'package:inspired_blog_panel/api/configs/api_routes.dart';
import 'package:inspired_blog_panel/api/http_service.dart';
import 'package:inspired_blog_panel/auth/controller/auth_controller.dart';
import 'package:inspired_blog_panel/auth/model/user.dart';
import 'package:inspired_blog_panel/entertainment/model/entertainment.dart';

import 'package:inspired_blog_panel/header_image/model/header_image.dart';
import 'package:inspired_blog_panel/magazine/model/magazine.dart';
import 'package:inspired_blog_panel/meta_data/model/meta_data.dart';
import 'package:inspired_blog_panel/utils/functions.dart';

class NounAPI {
  // register user
  static Future<User?> register(User userModel, String password) async {
    dd('[API Service] Creating account');
    final response = await HTTP.post(
      endPoint: NounAPIRoutes.REGISTER,
      body: {...userModel.toJson(), "password": password},
    );

    if (response != null) {
      final data = response.data;
      dd('$data', emphasized: false, response: true);

      if (response.statusCode == 201) {
        return User.fromJson(data);
      }
    }

    return null;
  }

  // log in
  static Future<User?> logIn(String email, String password) async {
    dd('[API Service] Logging In');
    final response = await HTTP.post(
      endPoint: NounAPIRoutes.LOGIN,
      body: {"email": email, "password": password},
    );

    if (response != null) {
      final data = response.data;
      dd('$data', emphasized: false, response: true);

      if (response.statusCode == 200) {
        return User.fromJson(data);
      }
    }

    return null;
  }

  // log out
  static Future<bool> logOut(int userId) async {
    dd('[API Service] Logging Out');
    final response = await HTTP.get(
      endPoint: '${NounAPIRoutes.LOGOUT}/$userId',
    );

    if (response != null) {
      final data = response.data;
      dd('$data', emphasized: false, response: true);

      if (response.statusCode == 200) {
        return true;
      }
    }

    return false;
  }

  // update user
  static Future<bool> updateUser(User user) async {
    dd('[API Service] Logging Out');
    final response = await HTTP.put(
      endPoint: '${NounAPIRoutes.USER}/${user.userId}',
      headers: {HttpHeaders.authorizationHeader: "Bearer ${user.token}"},
      body: {
        "name": user.name,
      },
    );

    if (response != null) {
      final data = response.data;
      dd('$data', emphasized: false, response: true);

      if (response.statusCode == 200) {
        return true;
      }
    }

    return false;
  }

  // get magazines
  static Future<dynamic> getMagazines(int page) async {
    dd('[API Service] Getting magazines');

    final response = await HTTP.get(
      endPoint: NounAPIRoutes.MAGAZINES,
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

  static Future<Magazine?> createMagazine({
    required String name,
    required String? description,
    required int? order,
    required PlatformFile coverPhoto,
    Function(int, int)? onSendProgress,
    Function(int, int)? onReceiveProgress,
  }) async {
    dd('[API Service] Creating magazine');

    final content = FormData.fromMap({
      "name": name,
      "description": description ?? '',
      "cover_photo": MultipartFile.fromBytes(coverPhoto.bytes!.toList(),
          filename: coverPhoto.name),
      if (order != null) "order": order,
    });

    final response = await HTTP.post(
        endPoint: NounAPIRoutes.MAGAZINES,
        headers: {
          HttpHeaders.authorizationHeader:
              "Bearer ${AuthController.instance.currentUser.token}",
          HttpHeaders.contentTypeHeader: "multipart/form-data",
        },
        body: content,
        onReceiveProgress: onReceiveProgress,
        onSendProgress: onSendProgress);
    dd('${response?.data}', emphasized: false, response: true);

    if (response != null && response.statusCode == 200) {
      final createdMagazine = Magazine.fromJson(response.data);
      return createdMagazine;
    }
    return null;
  }

  static Future<Magazine?> updateMagazine(
    int magazineId, {
    required String name,
    String? description,
    int? order,
    PlatformFile? coverPhoto,
    PlatformFile? advertisementPhoto,
    Function(int, int)? onSendProgress,
    Function(int, int)? onReceiveProgress,
  }) async {
    dd('[API Service] Updating magazine');

    final content = FormData.fromMap({
      "name": name,
      "description": description ?? '',
      if (coverPhoto != null)
        "cover_photo": MultipartFile.fromBytes(
          coverPhoto.bytes!.toList(),
          filename: coverPhoto.name,
        ),
      if (order != null) "order": order,
    });

    final response = await HTTP.post(
        endPoint: '${NounAPIRoutes.MAGAZINES}/$magazineId',
        headers: {
          HttpHeaders.authorizationHeader:
              "Bearer ${AuthController.instance.currentUser.token}",
          HttpHeaders.contentTypeHeader: "multipart/form-data",
        },
        body: content,
        onReceiveProgress: onReceiveProgress,
        onSendProgress: onSendProgress);
    dd('${response?.data}', emphasized: false, response: true);

    if (response != null && response.statusCode == 200) {
      final updatedMagazine = Magazine.fromJson(response.data);
      return updatedMagazine;
    }
    return null;
  }

  static Future<bool> deleteMagazine(int topicId) async {
    dd('[API Service] Deleting topic');

    final response = await HTTP.delete(
      endPoint: '${NounAPIRoutes.MAGAZINES}/$topicId',
      headers: {
        HttpHeaders.authorizationHeader:
            "Bearer ${AuthController.instance.currentUser.token}",
      },
    );
    dd('${response?.data}', emphasized: false, response: true);

    if (response != null && response.statusCode == 200) {
      return true;
    }
    return false;
  }

  static Future<Topic?> createTopic({
    required int magazineId,
    required String name,
    required String? description,
    required int? order,
    required PlatformFile coverPhoto,
    Function(int, int)? onSendProgress,
    Function(int, int)? onReceiveProgress,
  }) async {
    dd('[API Service] Creating topic');

    final content = FormData.fromMap({
      "magazine_id": magazineId,
      "title": name,
      "description": description ?? '',
      "cover_photo": MultipartFile.fromBytes(
        coverPhoto.bytes!,
        filename: coverPhoto.name,
      ),
      if (order != null) "order": order,
    });

    final response = await HTTP.post(
        endPoint: NounAPIRoutes.TOPICS,
        headers: {
          HttpHeaders.authorizationHeader:
              "Bearer ${AuthController.instance.currentUser.token}",
          HttpHeaders.contentTypeHeader: "multipart/form-data",
        },
        body: content,
        onReceiveProgress: onReceiveProgress,
        onSendProgress: onSendProgress);
    dd('${response?.data}', emphasized: false, response: true);

    if (response != null && response.statusCode == 200) {
      final createdTopic = Topic.fromJson(response.data);
      return createdTopic;
    }
    return null;
  }

  static Future<Topic?> updateTopic(
    int topicId, {
    int? magazineId,
    String? name,
    String? description,
    int? order,
    PlatformFile? coverPhoto,
    Function(int, int)? onSendProgress,
    Function(int, int)? onReceiveProgress,
  }) async {
    dd('[API Service] Updating topic');

    final content = FormData.fromMap({
      if (magazineId != null) "magazine_id": magazineId,
      if (name != null) "title": name,
      if (description != null) "description": description ?? '',
      if (coverPhoto != null)
        "cover_photo": MultipartFile.fromBytes(
          coverPhoto.bytes!,
          filename: coverPhoto.name,
        ),
      if (order != null) "order": order
    });

    final response = await HTTP.post(
        endPoint: '${NounAPIRoutes.TOPICS}/$topicId',
        headers: {
          HttpHeaders.authorizationHeader:
              "Bearer ${AuthController.instance.currentUser.token}",
          HttpHeaders.contentTypeHeader: "multipart/form-data",
        },
        body: content,
        onReceiveProgress: onReceiveProgress,
        onSendProgress: onSendProgress);
    dd('${response?.data}', emphasized: false, response: true);

    if (response != null && response.statusCode == 200) {
      final createdTopic = Topic.fromJson(response.data);
      return createdTopic;
    }
    return null;
  }

  static Future<bool> deleteTopic(int topicId) async {
    dd('[API Service] Deleting topic');

    final response = await HTTP.delete(
      endPoint: '${NounAPIRoutes.TOPICS}/$topicId',
      headers: {
        HttpHeaders.authorizationHeader:
            "Bearer ${AuthController.instance.currentUser.token}",
      },
    );
    dd('${response?.data}', emphasized: false, response: true);

    if (response != null && response.statusCode == 200) {
      return true;
    }
    return false;
  }

  static Future<List<String>> addContentPhotos(
    int topicId,
    List<PlatformFile> photos, {
    Function(int, int)? onSendProgress,
    Function(int, int)? onReceiveProgress,
  }) async {
    dd('[API Service] Adding content photos');

    final data = FormData.fromMap({});

    for (final photo in photos) {
      final size = photo.size;
      if (size > 2000000) {
        toast("Sorry ${photo.name} is bigger than 2 MB");
        return [];
      }
      data.files.add(MapEntry("content_photos[]",
          MultipartFile.fromBytes(photo.bytes!, filename: photo.name)));
    }

    final response = await HTTP.post(
      endPoint: '${NounAPIRoutes.TOPICS}/$topicId/add-content-photo',
      headers: {
        HttpHeaders.authorizationHeader:
            "Bearer ${AuthController.instance.currentUser.token}",
      },
      body: data,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
    dd('${response?.data}', emphasized: false, response: true);

    if (response != null && response.statusCode == 200) {
      final updatedTopic = Topic.fromJson(response.data);
      return updatedTopic.photos!;
    }

    return [];
  }

  static Future<bool> removeContentPhotos(
      int topicId, List<String> photos) async {
    dd('[API Service] Adding content photos');

    List<int> removePhotoIds = [];
    for (final photo in photos) {
      final name = photo.split('/').last.split('.').first;
      final id = int.tryParse(name);
      if (id != null) {
        removePhotoIds.add(id);
      }
    }
    removePhotoIds = removePhotoIds.toSet().toList();

    final response = await HTTP.post(
        endPoint: '${NounAPIRoutes.TOPICS}/$topicId/remove-content-photo',
        headers: {
          HttpHeaders.authorizationHeader:
              "Bearer ${AuthController.instance.currentUser.token}",
        },
        body: {
          'content_photo_ids': removePhotoIds
        });
    dd('${response?.data}', emphasized: false, response: true);

    if (response != null && response.statusCode == 200) {
      return true;
    }

    return false;
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
      endPoint: NounAPIRoutes.ENTERTAINMENTS,
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

  // create entertainments
  static Future<Entertainment?> createEntertainment({
    required String name,
    required String? description,
    required PlatformFile coverPhoto,
    required int? order,
    Function(int, int)? onSendProgress,
    Function(int, int)? onReceiveProgress,
  }) async {
    dd("[API Service] Creating Entertainment");

    final content = FormData.fromMap({
      "name": name,
      "description": description ?? "",
      "cover_photo":
          MultipartFile.fromBytes(coverPhoto.bytes!, filename: coverPhoto.name),
      if (order != null) "order": order,
    });

    final response = await HTTP.post(
      endPoint: NounAPIRoutes.ENTERTAINMENTS,
      headers: {
        HttpHeaders.authorizationHeader:
            "Bearer ${AuthController.instance.currentUser.token}",
      },
      body: content,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
    dd('${response?.data}', emphasized: false, response: true);

    if (response != null && response.statusCode == 200) {
      final entertainment = Entertainment.fromJson(response.data);
      return entertainment;
    }
    return null;
  }

  // update entertainments
  static Future<Entertainment?> updateEntertainment(
    int entertainmentId, {
    String? name,
    String? description,
    int? order,
    PlatformFile? coverPhoto,
    Function(int, int)? onSendProgress,
    Function(int, int)? onReceiveProgress,
  }) async {
    dd("[API Service] Creating Entertainment");

    final content = FormData.fromMap({
      if (name != null) "name": name,
      if (description != null) "description": description,
      if (coverPhoto != null)
        "cover_photo": MultipartFile.fromBytes(coverPhoto.bytes!,
            filename: coverPhoto.name),
      if (order != null) "order": order,
    });

    final response = await HTTP.post(
      endPoint: '${NounAPIRoutes.ENTERTAINMENTS}/$entertainmentId',
      headers: {
        HttpHeaders.authorizationHeader:
            "Bearer ${AuthController.instance.currentUser.token}",
      },
      body: content,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
    dd('${response?.data}', emphasized: false, response: true);

    if (response != null && response.statusCode == 200) {
      final entertainment = Entertainment.fromJson(response.data);
      return entertainment;
    }
    return null;
  }

  static Future<bool> deleteEntertainment(int entertainmentId) async {
    dd('[API Service] Deleting entertainment');

    final response = await HTTP.delete(
      endPoint: '${NounAPIRoutes.ENTERTAINMENTS}/$entertainmentId',
      headers: {
        HttpHeaders.authorizationHeader:
            "Bearer ${AuthController.instance.currentUser.token}",
      },
    );
    dd('${response?.data}', emphasized: false, response: true);

    if (response != null && response.statusCode == 200) {
      return true;
    }
    return false;
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

  static Future<Series?> createSeries({
    required String name,
    required String description,
    required PlatformFile coverPhoto,
    required int entertainmentId,
    required int? order,
    Function(int, int)? onSendProgress,
    Function(int, int)? onReceiveProgress,
  }) async {
    dd("[API Service] Creating series");

    final content = FormData.fromMap({
      "name": name,
      "description": description,
      "cover_photo": MultipartFile.fromBytes(
        coverPhoto.bytes!,
        filename: coverPhoto.name,
      ),
      "entertainment_id": entertainmentId,
      if (order != null) "order": order,
    });

    final response = await HTTP.post(
      endPoint: NounAPIRoutes.SERIES,
      headers: {
        HttpHeaders.authorizationHeader:
            "Bearer ${AuthController.instance.currentUser.token}",
      },
      body: content,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
    dd('${response?.data}', emphasized: false, response: true);

    if (response != null && response.statusCode == 200) {
      final series = Series.fromJson(response.data);
      return series;
    }
    return null;
  }

  static Future<Series?> updateSeries(
    int seriesId, {
    String? name,
    String? description,
    PlatformFile? coverPhoto,
    int? entertainmentId,
    int? order,
    Function(int, int)? onSendProgress,
    Function(int, int)? onReceiveProgress,
  }) async {
    dd("[API Service] Updating series");

    final content = FormData.fromMap({
      if (name != null) "name": name,
      if (description != null) "description": description,
      if (coverPhoto != null)
        "cover_photo": MultipartFile.fromBytes(
          coverPhoto.bytes!,
          filename: coverPhoto.name,
        ),
      // if (entertainmentId != null) "entertainment_id": entertainmentId,
      if (order != null) "order": order,
    });

    final response = await HTTP.post(
      endPoint: "${NounAPIRoutes.SERIES}/$seriesId",
      headers: {
        HttpHeaders.authorizationHeader:
            "Bearer ${AuthController.instance.currentUser.token}",
      },
      body: content,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
    dd('${response?.data}', emphasized: false, response: true);

    if (response != null && response.statusCode == 200) {
      final series = Series.fromJson(response.data);
      return series;
    }
    return null;
  }

  static Future<bool> deleteSeries(int seriesId) async {
    dd('[API Service] Deleting Series');

    final response = await HTTP.delete(
      endPoint: '${NounAPIRoutes.SERIES}/$seriesId',
      headers: {
        HttpHeaders.authorizationHeader:
            "Bearer ${AuthController.instance.currentUser.token}",
      },
    );
    dd('${response?.data}', emphasized: false, response: true);

    if (response != null && response.statusCode == 200) {
      return true;
    }
    return false;
  }

  static Future<Episode?> createEpisode({
    required String name,
    required String description,
    required PlatformFile videoThunbnail,
    required String videoUrl,
    required int seriesId,
    required int? order,
    Function(int, int)? onSendProgress,
    Function(int, int)? onReceiveProgress,
  }) async {
    dd("[API Service] Creating episode");

    final content = FormData.fromMap({
      "title": name,
      "description": description,
      "video_thumbnail": MultipartFile.fromBytes(
        videoThunbnail.bytes!,
        filename: videoThunbnail.name,
      ),
      "series_id": seriesId,
      "video_url": videoUrl,
      if (order != null) "order": order,
    });

    final response = await HTTP.post(
      endPoint: NounAPIRoutes.EPISODES,
      headers: {
        HttpHeaders.authorizationHeader:
            "Bearer ${AuthController.instance.currentUser.token}",
      },
      body: content,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
    dd('${response?.data}', emphasized: false, response: true);

    if (response != null && response.statusCode == 200) {
      final series = Episode.fromJson(response.data);
      return series;
    }
    return null;
  }

  static Future<Episode?> updateEpisode(
    int episodeID, {
    String? name,
    String? description,
    String? videoUrl,
    PlatformFile? videoThumbnail,
    int? seriesId,
    int? order,
    Function(int, int)? onSendProgress,
    Function(int, int)? onReceiveProgress,
  }) async {
    dd("[API Service] Updating episode");

    final content = FormData.fromMap({
      if (name != null) "title": name,
      if (description != null) "description": description,
      if (videoThumbnail != null)
        "video_thumbnail": MultipartFile.fromBytes(
          videoThumbnail.bytes!,
          filename: videoThumbnail.name,
        ),
      // if (seriesId != null) "series_id": seriesId,
      if (videoUrl != null) "video_url": videoUrl,
      if (order != null) "order": order,
    });

    final response = await HTTP.post(
      endPoint: "${NounAPIRoutes.EPISODES}/$episodeID",
      headers: {
        HttpHeaders.authorizationHeader:
            "Bearer ${AuthController.instance.currentUser.token}",
      },
      body: content,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
    dd('${response?.data}', emphasized: false, response: true);

    if (response != null && response.statusCode == 200) {
      final series = Episode.fromJson(response.data);
      return series;
    }
    return null;
  }

  static Future<bool> deleteEpisode(int episodeId) async {
    dd('[API Service] Deleting Episode');

    final response = await HTTP.delete(
      endPoint: '${NounAPIRoutes.EPISODES}/$episodeId',
      headers: {
        HttpHeaders.authorizationHeader:
            "Bearer ${AuthController.instance.currentUser.token}",
      },
    );
    dd('${response?.data}', emphasized: false, response: true);

    if (response != null && response.statusCode == 200) {
      return true;
    }
    return false;
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

  static Future<HeaderImage?> createHeaderImage({
    required String name,
    required String redirect,
    required PlatformFile image,
    int? order,
    Function(int, int)? onSendProgress,
    Function(int, int)? onReceiveProgress,
  }) async {
    dd("[API Service] Creating episode");

    final content = FormData.fromMap({
      "name": name,
      "redirect": redirect,
      "image": MultipartFile.fromBytes(
        image.bytes!,
        filename: image.name,
      ),
      if (order != null) "order": order,
    });

    final response = await HTTP.post(
      endPoint: NounAPIRoutes.HEADER_IMAGES,
      headers: {
        HttpHeaders.authorizationHeader:
            "Bearer ${AuthController.instance.currentUser.token}",
      },
      body: content,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
    dd('${response?.data}', emphasized: false, response: true);

    if (response != null && response.statusCode == 200) {
      final images = HeaderImage.fromJson(response.data);
      return images;
    }
    return null;
  }

  static Future<bool> deleteHeaderImage(int imageId) async {
    dd('[API Service] Deleting Episode');

    final response = await HTTP.delete(
      endPoint: '${NounAPIRoutes.HEADER_IMAGES}/$imageId',
      headers: {
        HttpHeaders.authorizationHeader:
            "Bearer ${AuthController.instance.currentUser.token}",
      },
    );
    dd('${response?.data}', emphasized: false, response: true);

    if (response != null && response.statusCode == 200) {
      return true;
    }
    return false;
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

  static Future<Advertisement?> createAdvertisement({
    required String name,
    required String description,
    required String redirect,
    required AdsTypes adsType,
    required PlatformFile image,
    Function(int, int)? onSendProgress,
    Function(int, int)? onReceiveProgress,
  }) async {
    dd("[API Service] Creating advertisement");

    final content = FormData.fromMap({
      "name": name,
      "description": description,
      "ads_type": adsType.name,
      "redirect": redirect,
      "image": MultipartFile.fromBytes(
        image.bytes!,
        filename: image.name,
      ),
    });

    final response = await HTTP.post(
      endPoint: NounAPIRoutes.ADVERTISEMENT,
      headers: {
        HttpHeaders.authorizationHeader:
            "Bearer ${AuthController.instance.currentUser.token}",
      },
      body: content,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
    dd('${response?.data}', emphasized: false, response: true);

    if (response != null && response.statusCode == 200) {
      final advertisement = Advertisement.fromJson(response.data);
      return advertisement;
    }
    return null;
  }

  static Future<Advertisement?> updateAdvertisement(
    int advertisementId, {
    required String name,
    required String description,
    required String redirect,
    required AdsTypes adsType,
    required PlatformFile? image,
    int? order,
    Function(int, int)? onSendProgress,
    Function(int, int)? onReceiveProgress,
  }) async {
    dd("[API Service] Creating episode");

    final content = FormData.fromMap({
      "name": name,
      "description": description,
      "redirect": redirect,
      "ads_type": adsType.name,
      if (image != null)
        "image": MultipartFile.fromBytes(
          image.bytes!,
          filename: image.name,
        ),
    });

    final response = await HTTP.post(
      endPoint: "${NounAPIRoutes.ADVERTISEMENT}/$advertisementId",
      headers: {
        HttpHeaders.authorizationHeader:
            "Bearer ${AuthController.instance.currentUser.token}",
      },
      body: content,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
    dd('${response?.data}', emphasized: false, response: true);

    if (response != null && response.statusCode == 200) {
      final advertisement = Advertisement.fromJson(response.data);
      return advertisement;
    }
    return null;
  }

  static Future<bool> deleteAdvertisement(int advertisementId) async {
    dd('[API Service] Deleting Advertisement');

    final response = await HTTP.delete(
      endPoint: '${NounAPIRoutes.ADVERTISEMENT}/$advertisementId',
      headers: {
        HttpHeaders.authorizationHeader:
            "Bearer ${AuthController.instance.currentUser.token}",
      },
    );
    dd('${response?.data}', emphasized: false, response: true);

    if (response != null && response.statusCode == 200) {
      return true;
    }
    return false;
  }

  // meta data
  static Future<List<NounMetaData>> getMetaData() async {
    dd('[API Service] Getting meta data');

    final response = await HTTP.get(
      endPoint: NounAPIRoutes.META_DATA,
    );

    if (response != null) {
      final data = response.data;
      dd('$data', emphasized: false, response: true);

      if (response.statusCode == 200) {
        final metaData = List<dynamic>.from(data)
            .map((e) => NounMetaData.fromJson(e))
            .toList();
        return metaData;
      }
    }

    return [];
  }

  static Future<NounMetaData?> createMetaData({
    required String name,
    required String metaContent,
    Function(int, int)? onSendProgress,
    Function(int, int)? onReceiveProgress,
  }) async {
    dd("[API Service] Creating meta data");

    final content = FormData.fromMap({
      "content": metaContent,
    });

    final response = await HTTP.post(
      endPoint: "${NounAPIRoutes.META_DATA}/$name",
      headers: {
        HttpHeaders.authorizationHeader:
            "Bearer ${AuthController.instance.currentUser.token}",
      },
      body: content,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
    dd('${response?.data}', emphasized: false, response: true);

    if (response != null && response.statusCode == 200) {
      final metaData = NounMetaData.fromJson(response.data);
      return metaData;
    }
    return null;
  }

  static Future<bool> deleteMetaData(String name) async {
    dd('[API Service] Deleting meta data');

    final response = await HTTP.delete(
      endPoint: '${NounAPIRoutes.META_DATA}/$name',
      headers: {
        HttpHeaders.authorizationHeader:
            "Bearer ${AuthController.instance.currentUser.token}",
      },
    );
    dd('${response?.data}', emphasized: false, response: true);

    if (response != null && response.statusCode == 200) {
      return true;
    }
    return false;
  }
}
