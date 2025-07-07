// ignore_for_file: constant_identifier_names, prefer_interpolation_to_compose_strings

class NounAPIRoutes {
  // static const HOST = 'http://127.0.0.1:8000';
  static const HOST = 'https://beta.artmediamm.com';
  static const API = '/api';
  static const BASE_API_PATH = HOST + API;

  // magazines
  static const MAGAZINES = BASE_API_PATH + '/magazines';
  static const PUBLIC_MAGAZINES = BASE_API_PATH + '/public/magazines';
  static const TOPICS = BASE_API_PATH + '/topics';

  // entertainments
  static const ENTERTAINMENTS = BASE_API_PATH + '/entertainments';
  static const PUBLIC_ENTERTAINMENTS = BASE_API_PATH + '/public/entertainments';
  static const SERIES = BASE_API_PATH + '/series';
  static const EPISODES = BASE_API_PATH + '/episodes';

  // header images
  static const HEADER_IMAGES = BASE_API_PATH + '/header-images';

  // advertisements
  static const ADVERTISEMENT = BASE_API_PATH + '/advertisements';

  // meta data
  static const META_DATA = BASE_API_PATH + '/meta-data';
}
