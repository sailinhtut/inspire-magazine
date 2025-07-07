// ignore_for_file: constant_identifier_names, prefer_interpolation_to_compose_strings

class NounAPIRoutes {
  // static const HOST = 'http://127.0.0.1:8000';
  static const HOST = 'https://beta.artmediamm.com';
  static const API = '/api';
  static const BASE_API_PATH = HOST + API;

  // authentication
  static const LOGIN = BASE_API_PATH + '/login';
  static const REGISTER = BASE_API_PATH + '/register';
  static const LOGOUT = BASE_API_PATH + '/logout';
  static const USER = BASE_API_PATH + '/users';

  // magazines
  static const MAGAZINES = BASE_API_PATH + '/magazines';
  static const TOPICS = BASE_API_PATH + '/topics';

  // entertainments
  static const ENTERTAINMENTS = BASE_API_PATH + '/entertainments';
  static const SERIES = BASE_API_PATH + '/series';
  static const EPISODES = BASE_API_PATH + '/episodes';

  // header images
  static const HEADER_IMAGES = BASE_API_PATH + '/header-images';

  // advertisements
  static const ADVERTISEMENT = BASE_API_PATH + '/advertisements';

  // meta data
  static const META_DATA = BASE_API_PATH + '/meta-data';
}
