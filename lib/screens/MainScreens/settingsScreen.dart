// The purpose of this file is to allow the user to change the settings of the app

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:jellybook/providers/themeProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart' as p_info;
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:jellybook/providers/languageProvider.dart';
import 'package:jellybook/widgets/SimpleUserCard.dart';
import 'package:jellybook/widgets/SettingsItem.dart';
import 'package:jellybook/variables.dart';
import 'package:palette_generator/palette_generator.dart';

import 'package:openapi/openapi.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String userName = '';
  String serverUrl = '';
  Color textColor = Colors.black;
  SharedPreferences? prefs;

  @override
  void initState() {
    getPackageInfo();
    super.initState();
    // Settings.init();
    setSharedPrefs();
  }

  themeListener() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> setSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  String version = '';

  Future<void> getPackageInfo() async {
    p_info.PackageInfo packageInfo = await p_info.PackageInfo.fromPlatform();
    version = packageInfo.version;
  }

  @override
  Widget build(BuildContext context) {
    // ThemeManager themeManager = Provider.of<ThemeManager>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          (AppLocalizations.of(context)?.settings ?? 'Settings'),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            FutureBuilder(
              future: getProfilePic(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return FutureBuilder<Color>(
                    future: getComplementaryColor(snapshot.data),
                    builder: (BuildContext context,
                        AsyncSnapshot<Color> colorSnapshot) {
                      if (colorSnapshot.hasData) {
                        Color complementaryColor = colorSnapshot.data ??
                            Colors
                                .black; // if the color is null, set it to black
                        return SimpleUserCard(
                          cardColor: complementaryColor,
                          userProfilePic: snapshot.data,
                          userName: userName,
                          userNameColor: textColor,
                          onTap: () {},
                          backgroundMotifColor: complementaryColor,
                          subtitle: InkWell(
                            onTap: () async {
                              if (await canLaunchUrl(Uri.parse(serverUrl))) {
                                await launchUrl(
                                  Uri.parse(serverUrl),
                                  mode: LaunchMode.externalApplication,
                                );
                              } else {
                                throw 'Could not launch $serverUrl';
                              }
                            },
                            child: Text(
                              serverUrl,
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: textColor,
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  );
                } else {
                  return Container();
                }
              },
            ),
            // should be comprised of widgets
            /* themeSettings(context),
            const SizedBox(
              height: 20,
            ),
            */
            const SizedBox(
              height: 10,
            ),
            languageSettings(context),
            const SizedBox(
              height: 20,
            ),
            // pageTransitionSettings(),
            FutureBuilder(
              future: themeSettings(context),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data;
                } else {
                  return Container();
                }
              },
            ),
            const SizedBox(
              height: 20,
            ),
            FutureBuilder(
              future: readingDirectionSettings(context),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data;
                } else {
                  return Container();
                }
              },
            ),
            // readingDirectionSettings(context),
            const SizedBox(
              height: 20,
            ),
            // experimentalFeaturesSettings(),
            // button to show log file
            // logToFile(),
            // const SizedBox(
            //   height: 20,
            // ),
            // SizedBox(
            //   // depends on screen size
            //   height: MediaQuery.of(context).size.height * 0.38,
            // ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.25,
              child: ElevatedButton(
                onPressed: () {
                  showLicensePage(
                    context: context,
                    applicationName: 'Jellybook',
                    applicationVersion: version,
                    applicationIcon: Image.asset(
                      'assets/images/Logo.png',
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.width * 0.4,
                    ),
                    applicationLegalese:
                        'MIT License. Made with love by Kara Wilson',
                  );
                },
                child: Text(
                  AppLocalizations.of(context)?.licenses ?? 'Licenses',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            aboutSettings(),
          ],
        ),
      ),
    );
  }

  // theme settings (future builder to get the current theme and then change it)
  Future<Widget> themeSettings(BuildContext context) async {
    return SettingsItem(
      title: AppLocalizations.of(context)?.theme ?? 'theme',
      selected: prefs?.getString('theme') ?? 'system',
      backgroundColor: Theme.of(context).splashColor,
      icon: Icons.color_lens,
      values: <String, String>{
        'system': AppLocalizations.of(context)?.systemTheme ?? 'System',
        'light': AppLocalizations.of(context)?.lightTheme ?? 'Light',
        'dark': AppLocalizations.of(context)?.darkTheme ?? 'Dark',
        'amoled': AppLocalizations.of(context)?.amoledTheme ?? 'Amoled',
      },
      onChange: (value) async {
        debugPrint('Value: $value');
        SharedPreferences prefs = await SharedPreferences.getInstance();
        ThemeChangeNotifier themeChangeNotifier =
            Provider.of<ThemeChangeNotifier>(context, listen: false);
        prefs.setString('theme', value.toString().toLowerCase());
        themeChangeNotifier.setTheme = value.toString().toLowerCase();
        setState(() {});
      },
    );
  }

  Future<Color> getComplementaryColor(ImageProvider ip) async {
    PaletteGenerator pg = await PaletteGenerator.fromImageProvider(ip);
    Color color = pg.lightMutedColor?.color ?? Colors.white;
    double hue = HSVColor.fromColor(color).hue;
    double saturation = HSVColor.fromColor(color).saturation;
    double value = HSVColor.fromColor(color).value;

    double complementaryHue = (hue + 180) % 360;

    // convert back to RGB
    Color complementaryColor =
        HSVColor.fromAHSV(1.0, complementaryHue, saturation, value).toColor();
    int red = complementaryColor.red;
    int green = complementaryColor.green;
    int blue = complementaryColor.blue;
    textColor = Color.fromARGB(255, 255 - red, 255 - green, 255 - blue);
    return complementaryColor;

    //
    // logger.i('red: $red, green: $green, blue: $blue');
    // red = 255 - red;
    // green = 255 - green;
    // blue = 255 - blue;
    // return Color.fromARGB(255, red, green, blue);
  }

  Future<ImageProvider> getProfilePic() async {
    p_info.PackageInfo packageInfo = await p_info.PackageInfo.fromPlatform();
    final prefs = await SharedPreferences.getInstance();
    final server = prefs.getString('server') ?? '';
    final userId = prefs.getString('UserId') ?? '';
    final token = prefs.getString('accessToken') ?? '';
    final username = prefs.getString('username') ?? '';
    final version = packageInfo.version;
    const _client = "JellyBook";
    const _device = "Unknown Device";
    const _deviceId = "Unknown Device id";

    userName = username;
    serverUrl = server;

    final headers = {
      'Accept': 'application/json',
      'Accept-Language': 'en-US,en;q=0.5',
      'Accept-Encoding': 'gzip, deflate',
      'Content-Type': 'application/json',
      "X-Emby-Authorization":
          "MediaBrowser Client=\"$_client\", Device=\"$_device\", DeviceId=\"$_deviceId\", Version=\"$version\", Token=\"$token\"",
      'Connection': 'keep-alive',
      'Origin': server,
      'Host': server.substring(server.indexOf("//") + 2, server.length),
      'Content-Length': '0',
    };
    final api = Openapi(basePathOverride: server).getImageApi();
    Uint8List image = Uint8List(0);
    ImageProvider imageProvider = Image.asset('assets/images/Logo.png').image;
    try {
      var response = await api.getUserImage(
          userId: userId, imageType: ImageType.primary, headers: headers);
      logger.i(response.statusCode);
      if (response != null && response.statusCode == 200) {
        image = response.data!;
      }
    } catch (e) {
      logger.e(e.toString());
    }
    if (image.isNotEmpty) {
      imageProvider = MemoryImage(image);
    }
    // scale the image to 50% of the original size
    return imageProvider;
  }

  // Widget themeSettings(BuildContext context) => DropDownSettingsTile(
  //       settingKey: 'theme',
  //       title: AppLocalizations.of(context)?.theme ?? 'theme',
  //       selected: Settings.getValue<String>('theme') ?? 'System',
  //       leading: const Icon(Icons.color_lens),
  //       values: <String, String>{
  //         'System': AppLocalizations.of(context)?.systemTheme ?? 'System',
  //         'Light': AppLocalizations.of(context)?.lightTheme ?? 'Light',
  //         'Dark': AppLocalizations.of(context)?.darkTheme ?? 'Dark',
  //         'Amoled': AppLocalizations.of(context)?.amoledTheme ?? 'Amoled',
  //         // AppLocalizations.of(context)?.systemTheme ?? 'System': 'System',
  //         // AppLocalizations.of(context)?.lightTheme ?? 'Light': 'Light',
  //         // AppLocalizations.of(context)?.darkTheme ?? 'Dark': 'Dark',
  //         // AppLocalizations.of(context)?.amoledTheme ?? 'Amoled': 'Amoled',
  //       },
  //       // give the key and value of the selected theme
  //       onChange: (value) async {
  //         debugPrint('Settings theme: ${Settings.getValue<String>('theme')}');
  //         // debugPrint('Theme changed to $value');
  //         SharedPreferences prefs = await SharedPreferences.getInstance();
  //         ThemeChangeNotifier themeChangeNotifier =
  //             Provider.of<ThemeChangeNotifier>(context, listen: false);
  //         // set the theme to the english value of the selected theme
  //         Settings.setValue<String>('theme', value.toString());
  //         prefs.setString('theme', value.toString().toLowerCase());
  //         themeChangeNotifier.setTheme = value.toString().toLowerCase();
  //       },
  //     );

  // static String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  static final isoLangs = {
    "ab": {"name": "Abkhaz", "nativeName": "аҧсуа"},
    "aa": {"name": "Afar", "nativeName": "Afaraf"},
    "af": {"name": "Afrikaans", "nativeName": "Afrikaans"},
    "afh": {"name": "Afrihili", "nativeName": "Afrihili"},
    "ak": {"name": "Akan", "nativeName": "Akan"},
    "sq": {"name": "Albanian", "nativeName": "Shqip"},
    "am": {"name": "Amharic", "nativeName": "አማርኛ"},
    "ar": {"name": "Arabic", "nativeName": "العربية"},
    "an": {"name": "Aragonese", "nativeName": "Aragonés"},
    "hy": {"name": "Armenian", "nativeName": "Հայերեն"},
    "as": {"name": "Assamese", "nativeName": "অসমীয়া"},
    "av": {"name": "Avaric", "nativeName": "авар мацӀ, магӀарул мацӀ"},
    "ae": {"name": "Avestan", "nativeName": "avesta"},
    "ay": {"name": "Aymara", "nativeName": "aymar aru"},
    "az": {"name": "Azerbaijani", "nativeName": "azərbaycan dili"},
    "bm": {"name": "Bambara", "nativeName": "bamanankan"},
    "ba": {"name": "Bashkir", "nativeName": "башҡорт теле"},
    "eu": {"name": "Basque", "nativeName": "euskara, euskera"},
    "be": {"name": "Belarusian", "nativeName": "Беларуская"},
    "bn": {"name": "Bengali", "nativeName": "বাংলা"},
    "bh": {"name": "Bihari", "nativeName": "भोजपुरी"},
    "bi": {"name": "Bislama", "nativeName": "Bislama"},
    "bs": {"name": "Bosnian", "nativeName": "bosanski jezik"},
    "br": {"name": "Breton", "nativeName": "brezhoneg"},
    "bg": {"name": "Bulgarian", "nativeName": "български език"},
    "my": {"name": "Burmese", "nativeName": "ဗမာစာ"},
    "ca": {"name": "Catalan; Valencian", "nativeName": "Català"},
    "ch": {"name": "Chamorro", "nativeName": "Chamoru"},
    "ce": {"name": "Chechen", "nativeName": "нохчийн мотт"},
    "ny": {
      "name": "Chichewa; Chewa; Nyanja",
      "nativeName": "chiCheŵa, chinyanja"
    },
    "zh": {"name": "Chinese", "nativeName": "中文 (Zhōngwén), 汉语, 漢語"},
    "zh_CHT": {
      "name": "Chinese (Simplified CHT)",
      "nativeName": "中文 (Zhōngwén), 汉语, 漢語"
    },
    "zh_Hant": {
      "name": "Chinese (Simplified Hant)",
      "nativeName": "中文 (Zhōngwén), 汉语, 漢語"
    },
    "cv": {"name": "Chuvash", "nativeName": "чӑваш чӗлхи"},
    "kw": {"name": "Cornish", "nativeName": "Kernewek"},
    "co": {"name": "Corsican", "nativeName": "corsu, lingua corsa"},
    "cr": {"name": "Cree", "nativeName": "ᓀᐦᐃᔭᐍᐏᐣ"},
    "hr": {"name": "Croatian", "nativeName": "hrvatski"},
    "cs": {"name": "Czech", "nativeName": "česky, čeština"},
    "da": {"name": "Danish", "nativeName": "dansk"},
    "dv": {"name": "Divehi; Dhivehi; Maldivian;", "nativeName": "ދިވެހި"},
    "nl": {"name": "Dutch", "nativeName": "Nederlands, Vlaams"},
    "en": {"name": "English", "nativeName": "English"},
    "en_pirate": {"name": "English (Pirate)", "nativeName": "English (Pirate)"},
    "eo": {"name": "Esperanto", "nativeName": "Esperanto"},
    "et": {"name": "Estonian", "nativeName": "eesti, eesti keel"},
    "ee": {"name": "Ewe", "nativeName": "Eʋegbe"},
    "fo": {"name": "Faroese", "nativeName": "føroyskt"},
    "fj": {"name": "Fijian", "nativeName": "vosa Vakaviti"},
    "fi": {"name": "Finnish", "nativeName": "suomi, suomen kieli"},
    "fr": {"name": "French", "nativeName": "français, langue française"},
    "ff": {
      "name": "Fula; Fulah; Pulaar; Pular",
      "nativeName": "Fulfulde, Pulaar, Pular"
    },
    "gl": {"name": "Galician", "nativeName": "Galego"},
    "ka": {"name": "Georgian", "nativeName": "ქართული"},
    "de": {"name": "German", "nativeName": "Deutsch"},
    "el": {"name": "Greek, Modern", "nativeName": "Ελληνικά"},
    "gn": {"name": "Guaraní", "nativeName": "Avañeẽ"},
    "gu": {"name": "Gujarati", "nativeName": "ગુજરાતી"},
    "ht": {"name": "Haitian; Haitian Creole", "nativeName": "Kreyòl ayisyen"},
    "ha": {"name": "Hausa", "nativeName": "Hausa, هَوُسَ"},
    "he": {"name": "Hebrew (modern)", "nativeName": "עברית"},
    "hz": {"name": "Herero", "nativeName": "Otjiherero"},
    "hi": {"name": "Hindi", "nativeName": "हिन्दी, हिंदी"},
    "ho": {"name": "Hiri Motu", "nativeName": "Hiri Motu"},
    "hu": {"name": "Hungarian", "nativeName": "Magyar"},
    "ia": {"name": "Interlingua", "nativeName": "Interlingua"},
    "id": {"name": "Indonesian", "nativeName": "Bahasa Indonesia"},
    "ie": {
      "name": "Interlingue",
      "nativeName": "Originally called Occidental; then Interlingue after WWII"
    },
    "ga": {"name": "Irish", "nativeName": "Gaeilge"},
    "ig": {"name": "Igbo", "nativeName": "Asụsụ Igbo"},
    "ik": {"name": "Inupiaq", "nativeName": "Iñupiaq, Iñupiatun"},
    "io": {"name": "Ido", "nativeName": "Ido"},
    "is": {"name": "Icelandic", "nativeName": "Íslenska"},
    "it": {"name": "Italian", "nativeName": "Italiano"},
    "iu": {"name": "Inuktitut", "nativeName": "ᐃᓄᒃᑎᑐᑦ"},
    "ja": {"name": "Japanese", "nativeName": "日本語 (にほんご／にっぽんご)"},
    "jv": {"name": "Javanese", "nativeName": "basa Jawa"},
    "kl": {
      "name": "Kalaallisut, Greenlandic",
      "nativeName": "kalaallisut, kalaallit oqaasii"
    },
    "kn": {"name": "Kannada", "nativeName": "ಕನ್ನಡ"},
    "kr": {"name": "Kanuri", "nativeName": "Kanuri"},
    "ks": {"name": "Kashmiri", "nativeName": "कश्मीरी, كشميري‎"},
    "kk": {"name": "Kazakh", "nativeName": "Қазақ тілі"},
    "km": {"name": "Khmer", "nativeName": "ភាសាខ្មែរ"},
    "ki": {"name": "Kikuyu, Gikuyu", "nativeName": "Gĩkũyũ"},
    "rw": {"name": "Kinyarwanda", "nativeName": "Ikinyarwanda"},
    "ky": {"name": "Kirghiz, Kyrgyz", "nativeName": "кыргыз тили"},
    "kv": {"name": "Komi", "nativeName": "коми кыв"},
    "kg": {"name": "Kongo", "nativeName": "KiKongo"},
    "ko": {"name": "Korean", "nativeName": "한국어 (韓國語), 조선말 (朝鮮語)"},
    "ku": {"name": "Kurdish", "nativeName": "Kurdî, كوردی‎"},
    "kj": {"name": "Kwanyama, Kuanyama", "nativeName": "Kuanyama"},
    "la": {"name": "Latin", "nativeName": "latine, lingua latina"},
    "lb": {"name": "Letzeburgesch", "nativeName": "Lëtzebuergesch"},
    "lg": {"name": "Luganda", "nativeName": "Luganda"},
    "li": {
      "name": "Limburgish, Limburgan, Limburger",
      "nativeName": "Limburgs"
    },
    "ln": {"name": "Lingala", "nativeName": "Lingála"},
    "lo": {"name": "Lao", "nativeName": "ພາສາລາວ"},
    "lt": {"name": "Lithuanian", "nativeName": "lietuvių kalba"},
    "lu": {"name": "Luba-Katanga", "nativeName": ""},
    "lv": {"name": "Latvian", "nativeName": "latviešu valoda"},
    "gv": {"name": "Manx", "nativeName": "Gaelg, Gailck"},
    "mk": {"name": "Macedonian", "nativeName": "македонски јазик"},
    "mg": {"name": "Malagasy", "nativeName": "Malagasy fiteny"},
    "ms": {"name": "Malay", "nativeName": "bahasa Melayu, بهاس ملايو‎"},
    "ml": {"name": "Malayalam", "nativeName": "മലയാളം"},
    "mt": {"name": "Maltese", "nativeName": "Malti"},
    "mi": {"name": "Māori", "nativeName": "te reo Māori"},
    "mr": {"name": "Marathi (Marāṭhī)", "nativeName": "मराठी"},
    "mh": {"name": "Marshallese", "nativeName": "Kajin M̧ajeļ"},
    "mn": {"name": "Mongolian", "nativeName": "монгол"},
    "na": {"name": "Nauru", "nativeName": "Ekakairũ Naoero"},
    "nv": {"name": "Navajo, Navaho", "nativeName": "Diné bizaad, Dinékʼehǰí"},
    "nb": {"name": "Norwegian Bokmål", "nativeName": "Norsk bokmål"},
    "nd": {"name": "North Ndebele", "nativeName": "isiNdebele"},
    "ne": {"name": "Nepali", "nativeName": "नेपाली"},
    "ng": {"name": "Ndonga", "nativeName": "Owambo"},
    "nn": {"name": "Norwegian Nynorsk", "nativeName": "Norsk nynorsk"},
    "no": {"name": "Norwegian", "nativeName": "Norsk"},
    "ii": {"name": "Nuosu", "nativeName": "ꆈꌠ꒿ Nuosuhxop"},
    "nr": {"name": "South Ndebele", "nativeName": "isiNdebele"},
    "oc": {"name": "Occitan", "nativeName": "Occitan"},
    "oj": {"name": "Ojibwe, Ojibwa", "nativeName": "ᐊᓂᔑᓈᐯᒧᐎᓐ"},
    "cu": {
      "name":
          "Old Church Slavonic, Church Slavic, Church Slavonic, Old Bulgarian, Old Slavonic",
      "nativeName": "ѩзыкъ словѣньскъ"
    },
    "om": {"name": "Oromo", "nativeName": "Afaan Oromoo"},
    "or": {"name": "Oriya", "nativeName": "ଓଡ଼ିଆ"},
    "os": {"name": "Ossetian, Ossetic", "nativeName": "ирон æвзаг"},
    "pa": {"name": "Panjabi, Punjabi", "nativeName": "ਪੰਜਾਬੀ, پنجابی‎"},
    "pi": {"name": "Pāli", "nativeName": "पाऴि"},
    "fa": {"name": "Persian", "nativeName": "فارسی"},
    "pl": {"name": "Polish", "nativeName": "polski"},
    "ps": {"name": "Pashto, Pushto", "nativeName": "پښتو"},
    "pt": {"name": "Portuguese", "nativeName": "Português"},
    "qu": {"name": "Quechua", "nativeName": "Runa Simi, Kichwa"},
    "rm": {"name": "Romansh", "nativeName": "rumantsch grischun"},
    "rn": {"name": "Kirundi", "nativeName": "kiRundi"},
    "ro": {"name": "Romanian", "nativeName": "română"},
    "ru": {"name": "Russian", "nativeName": "русский язык"},
    "sa": {"name": "Sanskrit (Saṁskṛta)", "nativeName": "संस्कृतम्"},
    "sc": {"name": "Sardinian", "nativeName": "sardu"},
    "sd": {"name": "Sindhi", "nativeName": "सिन्धी, سنڌي، سندھی‎"},
    "se": {"name": "Northern Sami", "nativeName": "Davvisámegiella"},
    "sm": {"name": "Samoan", "nativeName": "gagana faa Samoa"},
    "sg": {"name": "Sango", "nativeName": "yângâ tî sängö"},
    "sr": {"name": "Serbian", "nativeName": "српски језик"},
    "gd": {"name": "Scottish Gaelic; Gaelic", "nativeName": "Gàidhlig"},
    "sn": {"name": "Shona", "nativeName": "chiShona"},
    "si": {"name": "Sinhala, Sinhalese", "nativeName": "සිංහල"},
    "sk": {"name": "Slovak", "nativeName": "slovenčina"},
    "sl": {"name": "Slovene", "nativeName": "slovenščina"},
    "so": {"name": "Somali", "nativeName": "Soomaaliga, af Soomaali"},
    "st": {"name": "Southern Sotho", "nativeName": "Sesotho"},
    "es": {"name": "Spanish; Castilian", "nativeName": "español, castellano"},
    "su": {"name": "Sundanese", "nativeName": "Basa Sunda"},
    "sw": {"name": "Swahili", "nativeName": "Kiswahili"},
    "ss": {"name": "Swati", "nativeName": "SiSwati"},
    "sv": {"name": "Swedish", "nativeName": "svenska"},
    "ta": {"name": "Tamil", "nativeName": "தமிழ்"},
    "te": {"name": "Telugu", "nativeName": "తెలుగు"},
    "tg": {"name": "Tajik", "nativeName": "тоҷикӣ, toğikī, تاجیکی‎"},
    "th": {"name": "Thai", "nativeName": "ไทย"},
    "ti": {"name": "Tigrinya", "nativeName": "ትግርኛ"},
    "bo": {
      "name": "Tibetan Standard, Tibetan, Central",
      "nativeName": "བོད་ཡིག"
    },
    "tk": {"name": "Turkmen", "nativeName": "Türkmen, Түркмен"},
    "tl": {"name": "Tagalog", "nativeName": "Wikang Tagalog, ᜏᜒᜃᜅ᜔ ᜆᜄᜎᜓᜄ᜔"},
    "tn": {"name": "Tswana", "nativeName": "Setswana"},
    "to": {"name": "Tonga (Tonga Islands)", "nativeName": "faka Tonga"},
    "tr": {"name": "Turkish", "nativeName": "Türkçe"},
    "ts": {"name": "Tsonga", "nativeName": "Xitsonga"},
    "tt": {"name": "Tatar", "nativeName": "татарча, tatarça, تاتارچا‎"},
    "tw": {"name": "Twi", "nativeName": "Twi"},
    "ty": {"name": "Tahitian", "nativeName": "Reo Tahiti"},
    "ug": {"name": "Uighur, Uyghur", "nativeName": "Uyƣurqə, ئۇيغۇرچە‎"},
    "uk": {"name": "Ukrainian", "nativeName": "українська"},
    "ur": {"name": "Urdu", "nativeName": "اردو"},
    "uz": {"name": "Uzbek", "nativeName": "zbek, Ўзбек, أۇزبېك‎"},
    "ve": {"name": "Venda", "nativeName": "Tshivenḓa"},
    "vi": {"name": "Vietnamese", "nativeName": "Tiếng Việt"},
    "vo": {"name": "Volapük", "nativeName": "Volapük"},
    "wa": {"name": "Walloon", "nativeName": "Walon"},
    "cy": {"name": "Welsh", "nativeName": "Cymraeg"},
    "wo": {"name": "Wolof", "nativeName": "Wollof"},
    "fy": {"name": "Western Frisian", "nativeName": "Frysk"},
    "xh": {"name": "Xhosa", "nativeName": "isiXhosa"},
    "yi": {"name": "Yiddish", "nativeName": "ייִדיש"},
    "yo": {"name": "Yoruba", "nativeName": "Yorùbá"},
    "za": {"name": "Zhuang, Chuang", "nativeName": "Saɯ cueŋƅ, Saw cuengh"}
  };
  // Locales
  Map<String, String> localesMap(BuildContext context, String? languageCode) {
    // map the AppLocalizations.supportedLocales with a Map of the Locale name and the Locale code
    Map<String, String> locales = {};
    // add the locales to the map
    for (var locale in AppLocalizations.supportedLocales) {
      locales.addAll({
        locale.toString():
            // get the language name (ex. English) from isoLangs map
            isoLangs[locale.toString()]!['name'].toString() == locale.toString()
                ? isoLangs[locale.toString()]!['nativeName'] ??
                    locale.toString()
                : isoLangs[locale.toString()]!['name'] ?? locale.toString()
      });
      // remove the entry that has en_pirate as the key
      if (locale.toString() == 'en_pirate' || locale.toString() == 'zh_CHT') {
        locales.remove(locale.toString());
      }
    }

    // add a default value

    logger.d(locales);
    return locales;
  }

  // language settings Widget
  Widget languageSettings(BuildContext context) => SettingsItem(
        // settingKey: 'language',
        title: AppLocalizations.of(context)?.language ?? 'Language',
        selected:
            AppLocalizations.of(context)?.localeName.toString() ?? 'System',
        backgroundColor: Theme.of(context).splashColor,
        icon: Icons.language,
        values:
            localesMap(context, prefs?.getString('localeString') ?? 'System'),
        onChange: (value) async {
          logger.d(value);
          // change the locale
          final localeProvider =
              Provider.of<LocaleChangeNotifier>(context, listen: false);
          localeProvider.setLocale = value.toString();
          prefs?.setString('localeString', value.toString());

          setState(() {});
        },
      );

  // page transition settings
  Widget pageTransitionSettings() => SettingsItem(
        // settingKey: 'pageTransition',
        title:
            AppLocalizations.of(context)?.pageTransition ?? 'Page Transition',
        selected: prefs?.getString('pageTransition') ?? 'Page Turn',
        backgroundColor: Theme.of(context).splashColor,
        icon: Icons.pageview,
        values: const <String, String>{
          'Page Turn': 'Page Turn',
          'Slide': 'Slide',
        },
        onChange: (value) async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('pageTransition', value.toString());
        },
      );

  // Reading Direction settings
  Future<Widget> readingDirectionSettings(BuildContext context) async =>
      SettingsItem(
        // settingKey: 'readingDirection',
        title: AppLocalizations.of(context)?.readingDirection ??
            'Reading Direction',
        selected: prefs?.getString('readingDirection') ?? 'LTR',
        backgroundColor: Theme.of(context).splashColor,
        icon: Icons.format_textdirection_l_to_r_rounded,
        values: <String, String>{
          'LTR': AppLocalizations.of(context)?.ltr ?? 'Left to Right',
          'RTL': AppLocalizations.of(context)?.rtl ?? 'Right to Left',
          'Vertical': AppLocalizations.of(context)?.vertical ?? "Vertical",
        },
        onChange: (value) async {
          debugPrint(value);
          prefs?.setString('readingDirection', value.toString());
          setState(() {});
        },
      );

  // about settings (should contain the version number and the link to the github repo, and author)
  Widget aboutSettings() => FutureBuilder(
        future: getPackageInfo(),
        builder: (context, snapshot) {
          return Column(
            children: [
              // version number (should be a future builder)
              Text(
                (AppLocalizations.of(context)?.version ?? 'Version: ') +
                    (version.isNotEmpty
                        ? version
                        : AppLocalizations.of(context)?.unknown ?? 'Unknown'),
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "${AppLocalizations.of(context)?.madeBy ?? 'Made by'} Kara Wilson",
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 10,
              ),
              // insert https://github.com/Kara-Zor-El/JellyBook
              InkWell(
                child: const Text(
                  "https://github.com/Kara-Zor-El/JellyBook",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.blue,
                  ),
                ),
                onTap: () async {
                  try {
                    if (await canLaunchUrl(
                      Uri.parse("https://github.com/Kara-Zor-El/JellyBook"),
                    )) {
                      await launchUrl(
                        Uri.parse("https://github.com/Kara-Zor-El/JellyBook"),
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  } catch (e) {
                    logger.e(e.toString());
                  }
                },
              ),
            ],
          );
        },
      );
}
