import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/consts.dart';
import 'package:weather_app/screens/colors.dart';

class WeatherHome extends StatefulWidget {
  const WeatherHome({super.key});

  @override
  State<WeatherHome> createState() => _WeatherHomeState();
}

class _WeatherHomeState extends State<WeatherHome> {
  final WeatherFactory _wf = WeatherFactory(weather_api_key);
  Weather? _weather;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchWeather('karachi');
  }

  Future<void> _fetchWeather(String city) async {
    try {
      Weather? weather = await _wf.currentWeatherByCityName(city);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      setState(() {
        _weather = null; // Reset weather to null if an error occurs
      });
    }
  }

  void _onSearch() {
    String city = _controller.text.trim();
    if (city.isNotEmpty) {
      _fetchWeather(city);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.only(
            top: 30,
            left: 20,
            right: 20,
          ),
          child: Column(
            children: [
              _buildSearchBar(),
              SizedBox(
                height: 60,
              ),
              Expanded(child: _Buildui()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: '  Search any Location',
              hintStyle: const TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              suffixIcon: IconButton(
                icon: const Icon(Iconsax.search_normal_copy),
                onPressed: _onSearch,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _Buildui() {
    if (_weather == null) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.grey,
        ),
      );
    }
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _LocationHeader(),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            _DateTimeinfo(),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            _weathericon(),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            _weathertemp(),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            _extrainfo(),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            _extramore(),
          ],
        ),
      ),
    );
  }

  Widget _LocationHeader() {
    return Text(
      _weather?.areaName ?? '',
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
    );
  }

  Widget _DateTimeinfo() {
    DateTime now = _weather!.date!;
    return Column(
      children: [
        Text(
          DateFormat('h:mm a').format(now),
          style: const TextStyle(fontSize: 19),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat('EEEE :').format(now),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 10),
            Text(
              '${DateFormat('d.MM.yyyy').format(now)}',
              style: const TextStyle(fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ],
    );
  }

  Widget _weathericon() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.25,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  'http://openweathermap.org/img/wn/${_weather?.weatherIcon}@4x.png'),
            ),
          ),
        ),
        Text(
          _weather?.weatherDescription ?? '',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  Widget _weathertemp() {
    return Text(
      "${_weather?.temperature?.celsius?.toStringAsFixed(0)}°C",
      style: const TextStyle(fontSize: 35, fontWeight: FontWeight.w500),
    );
  }

  Widget _extrainfo() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              height: 60,
              width: 60,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: cardcolor),
              child: Image.asset('assets/images/windspeed.png'),
            ),
            Container(
              height: 60,
              width: 60,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: cardcolor),
              child: Image.asset('assets/images/clouds.png'),
            ),
            Container(
              height: 60,
              width: 60,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: cardcolor),
              child: Image.asset('assets/images/humidity.png'),
            ),
          ],
        ),
        SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: 20,
              width: 60,
              child: Text(
                '${_weather?.windSpeed?.toStringAsFixed(0)}km/h',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 20,
              width: 60,
              child: Text(
                '${_weather?.cloudiness?.toStringAsFixed(1)}%',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 20,
              width: 60,
              child: Text(
                '${_weather?.humidity?.toStringAsFixed(0)}%',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _extramore() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              height: 60,
              width: 60,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: cardcolor),
              child: Image.asset(
                'assets/images/max.png',
              ),
            ),
            Container(
              height: 60,
              width: 60,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: cardcolor),
              child: Image.asset('assets/images/snow.png'),
            ),
            Container(
              height: 60,
              width: 60,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: cardcolor),
              child: Image.asset('assets/images/barish.png'),
            ),
          ],
        ),
        SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: 20,
              width: 60,
              child: Text(
                '${_weather?.tempMax?.celsius?.toStringAsFixed(0)}°C',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 20,
              width: 60,
              child: Text(
                '${_weather?.snowLast3Hours?.toStringAsFixed(2) ?? '0'}mm',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 20,
              width: 60,
              child: Text(
                '${_weather?.rainLast3Hours?.toStringAsFixed(2) ?? '0'}mm',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
