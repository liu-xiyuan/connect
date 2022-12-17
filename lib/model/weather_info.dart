import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WeatherInfo {
  /// 天气标识图标组
  static Map<String, Map> weatherMap = {
    'sun': {
      'id': [1, 2, 3, 33, 34],
      'icon': FontAwesomeIcons.solidSun,
    },
    'moon': {
      'id': [],
      'icon': FontAwesomeIcons.solidMoon,
    },
    'cloud': {
      'id': [4, 5, 6, 7, 8, 35, 36, 38],
      'icon': FontAwesomeIcons.cloud,
    },
    'smog': {
      'id': [11],
      'icon': FontAwesomeIcons.smog,
    },
    'cloud-showers-heavy': {
      'id': [12, 13, 39, 40],
      'icon': FontAwesomeIcons.cloudShowersHeavy,
    },
    'cloud-sun-rain': {
      'id': [14, 17],
      'icon': FontAwesomeIcons.cloudSunRain,
    },
    'cloud-bolt': {
      'id': [15, 16, 41, 42],
      'icon': FontAwesomeIcons.cloudBolt,
    },
    'cloud-rain': {
      'id': [18, 20, 26],
      'icon': FontAwesomeIcons.cloudRain,
    },
    'snow': {
      'id': [19, 21, 22, 23, 25, 29, 43, 44],
      'icon': FontAwesomeIcons.solidSnowflake,
    },
    'ice': {
      'id': [24],
      'icon': FontAwesomeIcons.icicles,
    },
    'hot': {
      'id': [30],
      'icon': FontAwesomeIcons.temperatureHigh,
    },
    'cold': {
      'id': [31],
      'icon': FontAwesomeIcons.temperatureLow,
    },
    'wind': {
      'id': [32],
      'icon': FontAwesomeIcons.wind,
    },
    'cloud-moon': {
      'id': [37],
      'icon': FontAwesomeIcons.cloudMoon,
    },
  };

  static IconData getWeatherIcon(int weatherId, bool isDayNight) {
    IconData res = FontAwesomeIcons.cloud;

    weatherMap.forEach((key, value) {
      if (value['id'].contains(weatherId)) {
        if (key == 'sun' && !isDayNight) {
          res = weatherMap['moon']!['icon']; // 判断是否为晚上
        } else {
          res = value['icon'];
        }
      }
    });

    return res;
  }
}
