class Comic {
  // Required parameters
  String _title = ''; // Name
  String _sortTitle = ''; // SortName
  String _imageId = '';
  String _imagePath = '';
  String _path = '';
  String _id = '';
  int _index = -1;
  String _type = '';
  String _overview = '';
  bool _started = false;

  // Optional parameters
  double _rating = 0.0;
  String _releaseYear = '';
  double _progress = 0.0;
  List<String> _tags = [];

  String _url = '';

  Comic({
    required String title,
    required String sortTitle,
    required String imageId,
    required String imagePath,
    required String path,
    required String id,
    required int index,
    required String type,
    required String overview,
    required bool started,
    required double rating,
    required String releaseYear,
    required double progress,
    required List<String> tags,
    required String url,
  }) {
    title = _title;
    sortTitle = _sortTitle;
    imageId = _imageId;
    imagePath = _imagePath;
    path = _path;
    id = _id;
    index = _index;
    type = _type;
    overview = _overview;
    started = _started;
    rating = _rating;
    releaseYear = _releaseYear;
    progress = _progress;
    tags = _tags;
    url = _url;
  }

  factory Comic.fromJson(Map<String, dynamic> json) {
    String url = '';
    return Comic(
      index: json['Index'],
      title: json['Name'],
      id: json['Id'],
      sortTitle: json['SortName'],
      path: json['Path'],
      overview: json['Overview'],
      rating: json['CommunityRating'],
      releaseYear: json['PremiereDate'],
      imageId: json['ImageTags']['Primary'],
      imagePath: url +
          "/Items/" +
          json['Id'] +
          "/Images/Primary?MaxWidth=500&Tag=" +
          json['ImageTags']['Primary'] +
          "&quality=90",
      tags: json['Tags'],
      type: json['MediaType'],
      url: url,
      started: false,
      progress: 0,
      // started: item['UserData']['Played'],
      // progress: item['UserData']['PlayedPercentage'],
    );
  }

  void clear() {
    _title = '';
    _sortTitle = '';
    _imageId = '';
    _imagePath = 'assets/images/placeholder.png';
    _path = '';
    _id = '';
    _index = -1;
    _type = '';
    _overview = '';
    _started = false;
    _rating = -1;
    _releaseYear = '';
    _progress = -1;
    _tags = [];
    // _genres = [];
  }

  // initialize the comic
  String get title => _title;
  set title(String title) => _title = title;

  String get sortTitle => _sortTitle;
  set sortTitle(String sortTitle) => _sortTitle = sortTitle;

  String get imageId => _imageId;
  set imageId(String imageId) => _imageId = imageId;

  String get imagePath => _imagePath;
  set imagePath(String imagePath) => _imagePath = imagePath;

  String get path => _path;
  set path(String path) => _path = path;

  String get id => _id;
  set id(String id) => _id = id;

  int get index => _index;
  set index(int index) => _index = index;

  String get type => _type;
  set type(String type) => _type = type;

  String get overview => _overview;
  set overview(String overview) => _overview = overview;

  bool get started => _started;
  set started(bool started) => _started = started;

  double get rating => _rating;
  set rating(double rating) => _rating = rating;

  String get releaseYear => _releaseYear;
  set releaseYear(String releaseYear) => _releaseYear = releaseYear;

  double get progress => _progress;
  set progress(double progress) => _progress = progress;

  List<String> get tags => _tags;
  set tags(List<String> tags) => _tags = tags;
}
