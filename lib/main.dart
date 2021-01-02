import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var temp;
  var location;
  var description = 'Clear';
  var humidity;
  var windSpeed;

  initState() {
    super.initState();
    getWeather('Mumbai');
  }

  Future getWeather(String input) async {
    http.Response response = await http.get(
        'http://api.openweathermap.org/data/2.5/weather?q=$input&units=metric&appid=f075bbace84614dba550bf717437c881');//appid=your api key
    var result = jsonDecode(response.body);

    setState(() {
      this.location = result["name"];
      this.description = result["weather"][0]["main"];
      this.temp = result["main"]["temp"].round();
      this.humidity = result["main"]["humidity"];
      this.windSpeed = result["wind"]["speed"];
    });
  }

  void onTextSubmitted(String input) async {
    await getWeather(input);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/$description.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Center(
                    child: Text(
                      temp != null ? temp.toString() + ' \u00B0C' : 'Loading',
                      style: TextStyle(color: Colors.white, fontSize: 60.0),
                    ),
                  ),
                  Center(
                    child: Text(
                      location != null ? location.toString() : 'Loading',
                      style: TextStyle(color: Colors.white, fontSize: 40.0),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  ListTile(
                    title: Text('Humidity',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontSize: 20.0,
                        )),
                    leading: FaIcon(
                      FontAwesomeIcons.water,
                      color: Colors.white,
                    ),
                    trailing: Text(
                      humidity != null ? humidity.toString() : 'Loading',
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text('Wind speed',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontSize: 20.0,
                        )),
                    leading: FaIcon(
                      FontAwesomeIcons.wind,
                      color: Colors.white,
                    ),
                    trailing: Text(
                      windSpeed != null ? windSpeed.toString() : 'Loading',
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'Weather',
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                    leading: FaIcon(
                      FontAwesomeIcons.cloudSunRain,
                      color: Colors.white,
                    ),
                    trailing: Text(
                      description != null ? description.toString() : 'Loading',
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Container(
                    width: 300,
                    child: TextField(
                      onSubmitted: (String input) {
                        onTextSubmitted(input);
                      },
                      style: TextStyle(color: Colors.white, fontSize: 25),
                      decoration: InputDecoration(
                        hintText: 'Search another Location...',
                        hintStyle: TextStyle(color: Colors.white, fontSize: 18),
                        prefixIcon: Icon(Icons.search, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
