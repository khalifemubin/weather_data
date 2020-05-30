import 'package:flutter/material.dart';
import '../config/config.dart' as config;
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Climate extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<Climate> {
  String _newCity;

  Future _goToNextScreen(BuildContext context) async {
    Map results = await Navigator.of(context)
        .push(new MaterialPageRoute<Map>(builder: (context) => ChangeCity()));

    if (results != null && results.containsKey("new_city")) {
      setState(() {
        _newCity = results["new_city"];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          "Weather Data",
          style: new TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        leading: new IconButton(
            // alignment: Alignment.topLeft,
            icon: new Icon(
              Icons.menu,
              color: Colors.white,
            ),
            onPressed: () => _goToNextScreen(context)
            // onPressed: showStuff
            ),
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
              child: new Image.asset(
            "images/umbrella.png",
            width: 490.0,
            fit: BoxFit.fill,
            height: 1200.0,
          )),
          new Container(
            alignment: Alignment.topRight,
            margin: const EdgeInsets.fromLTRB(0.0, 11.0, 21.0, 0.0),
            child: new Text(
              '${_newCity == null ? config.defaultCity : _newCity}',
              // '${_newCity == null ? config.defaultCity : _newCity}',
              style: cityStyle(),
            ),
          ),
          // new Container(
          //   alignment: Alignment.center,
          //   child: new Image.asset("images/light_rain.png"),
          // ),
          new Container(
            margin: const EdgeInsets.fromLTRB(25.0, 340.0, 0.0, 0.0),
            // child: new Text("68.7F",style: temperatureStyle(),),
            child: updateTempWidget(_newCity),
          )
        ],
      ),
    );
  }

  Future<Map> getWeatherData(String city) async {
    String apiURL =
        "http://api.openweathermap.org/data/2.5/weather?q=$city&units=metric&APPID=${config.appID}";
    http.Response response = await http.get(apiURL);
    return json.decode(response.body);
  }

  Widget updateTempWidget(String city) {
    return new FutureBuilder(
        future: getWeatherData(city == null ? config.defaultCity : city),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          if (snapshot.hasData) {
            Map content = snapshot.data;
            return new ListView(
              children: <Widget>[
                new ListTile(
                  title: new Text(
                    content["main"]["temp"].toString() + " \u{2103}",
                    style: temperatureStyle(),
                  ),
                  subtitle: new ListTile(
                      title: new Text(
                    "Humidity: ${content["main"]["humidity"].toString()}\n"
                    "Min: ${content["main"]["temp_min"].toString()} \u{2103} \n"
                    "Max: ${content["main"]["temp_max"].toString()} \u{2103}\n",
                    style: extraTempData(),
                  )),
                )
              ],
            );
          } else {
            return Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}

TextStyle cityStyle() {
  return new TextStyle(
      color: Colors.white, fontSize: 23.0, fontStyle: FontStyle.italic);
}

TextStyle temperatureStyle() {
  return new TextStyle(
      color: Colors.white,
      fontSize: 40.0,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500);
}

TextStyle extraTempData() {
  return new TextStyle(
      color: Colors.white, fontSize: 17.0, fontWeight: FontWeight.bold);
}

class ChangeCity extends StatelessWidget {
  final _cityFieldController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.red,
          centerTitle: true,
          title: new Text("Change City"),
        ),
        body: new Stack(
          children: <Widget>[
            new Center(
              child: new Image.asset(
                "images/white_snow.png",
                width: 490.0,
                height: 1200.0,
                fit: BoxFit.fill,
              ),
            ),
            new ListView(children: <Widget>[
              new ListTile(
                  title: new TextField(
                decoration: new InputDecoration(
                  hintText: "Enter City",
                ),
                controller: _cityFieldController,
                keyboardType: TextInputType.text,
              )),
              new ListTile(
                  title: new FlatButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        Navigator.pop(
                            context, {'new_city': _cityFieldController.text});
                      },
                      color: Colors.redAccent,
                      textColor: Colors.white70,
                      child: new Text("Get Weather")))
            ])
          ],
        ));
  }
}
