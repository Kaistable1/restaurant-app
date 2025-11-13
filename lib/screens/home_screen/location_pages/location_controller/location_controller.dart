import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationController extends GetxController {
  var locationItem = <LocationItem>[].obs;
  List top = [
    'most reviewed',
    'Discount',
    'minimum',
    'maximum',
  ];
  RxString selectedTop = 'most reviewed'.obs;
  var selectedDiscount = '10%'.obs;

  @override
  void onInit() {
    super.onInit();
    loadLocation();
  }

  /// Urls... to links social media...
  final Uri facebookUrl = Uri.parse('https://www.facebook.com');
  final Uri twitterUrl = Uri.parse('https://twitter.com');
  final Uri instagramUrl = Uri.parse('https://www.instagram.com');
  final Uri likedInUrl = Uri.parse('https://www.linkedin.com');

  Future<void> launchFaceBookUrl() async {
    if (!await launchUrl(facebookUrl)) {
      throw Exception('Could not launch $facebookUrl');
    }
  }

  Future<void> launchTwitterUrl() async {
    if (!await launchUrl(twitterUrl)) {
      throw Exception('Could not launch $twitterUrl');
    }
  }

  Future<void> launchInstagramUrl() async {
    if (!await launchUrl(instagramUrl)) {
      throw Exception('Could not launch $instagramUrl');
    }
  }

  Future<void> launchLinkedinUrl() async {
    if (!await launchUrl(likedInUrl)) {
      throw Exception('Could not launch $likedInUrl');
    }
  }

  void loadLocation() {
    // Dummy data. Replace with your actual data source.
    locationItem.addAll([
      LocationItem(
          title: 'Pizza',
          description:
              'Duis aute irure dolor in reprehend voluptate velit esse cillum',
          imagePath: 'assets/images/a1.png',
          timetext: '09:00',
          endTimeText: '08:00',
          percentText: '50%'),
      LocationItem(
          title: 'Buffet',
          description:
              'Duis aute irure dolor in reprehend voluptate velit esse cillum',
          imagePath: 'assets/images/a2.png',
          timetext: '06:00',
          endTimeText: '08:00',
          percentText: '80%'),
      LocationItem(
          title: 'Pizza',
          description:
              'Duis aute irure dolor in reprehend voluptate velit esse cillum',
          imagePath: 'assets/images/a3.png',
          timetext: '12:00',
          endTimeText: '08:00',
          percentText: '60%'),
      LocationItem(
          title: 'Salad',
          description:
              'Duis aute irure dolor in reprehend voluptate velit esse cillum',
          imagePath: 'assets/images/a2.png',
          timetext: '01:00',
          endTimeText: '08:00',
          percentText: '40%'),
      LocationItem(
          title: 'Buffet',
          description:
              'Duis aute irure dolor in reprehend voluptate velit esse cillum',
          imagePath: 'assets/images/a1.png',
          timetext: '18:00',
          endTimeText: '08:00',
          percentText: '20%'),
      LocationItem(
          title: 'Pasta',
          description:
              'Duis aute irure dolor in reprehend voluptate velit esse cillum',
          imagePath: 'assets/images/a3.png',
          timetext: '16:00',
          endTimeText: '08:00',
          percentText: '50%'),
      LocationItem(
          title: 'Pizza',
          description:
              'Duis aute irure dolor in reprehend voluptate velit esse cillum',
          imagePath: 'assets/images/a1.png',
          timetext: '03:00',
          endTimeText: '08:00',
          percentText: '56%'),
      LocationItem(
        title: 'Salad',
        description:
            'Duis aute irure dolor in reprehend voluptate velit esse cillum',
        imagePath: 'assets/images/a2.png',
        timetext: '06:00',
        endTimeText: '08:00',
        percentText: '07%',
      ),
    ]);
  }
}

class LocationItem {
  String title;
  String description;
  String imagePath;
  String timetext;
  String endTimeText;
  String percentText;

  LocationItem(
      {required this.title,
      required this.description,
      required this.imagePath,
      required this.timetext,
      required this.endTimeText,
      required this.percentText});
}
