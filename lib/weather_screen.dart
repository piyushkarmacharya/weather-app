import 'dart:convert';
import 'dart:ui';

import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/secret.dart';
import 'package:weather_app/weather_items.dart';
import 'package:weather_app/additional_info_items.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});
  @override
  State<WeatherScreen> createState() {
    return _WeatherScreenState();
  }
}

class _WeatherScreenState extends State<WeatherScreen> {
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String country = "Kathmandu";
      final res = await http.get(Uri.parse(
          "https://api.openweathermap.org/data/2.5/forecast?q=$country&APPID=$openWeatherAPIKey"));
      final data = jsonDecode(res.body);
      if (data['cod'] != '200') {
        throw 'error occured';
      }
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Weather App",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            InkWell(
              onTap: () {
                setState(() {});
              },
              child: const Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                child: Icon(Icons.refresh),
              ),
            )
          ],
        ),
        body: FutureBuilder(
          future: getCurrentWeather(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }

            final data = snapshot.data!;
            final currtemp = data['list'][0]['main']['temp'];
            final currSky = data['list'][0]['weather'][0]['main'];
            final currPressure = data['list'][0]['main']['pressure'];
            final currWindSpeed = data['list'][0]['wind']['speed'];
            final currHumidity = data['list'][0]['main']['humidity'];

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Card(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                        elevation: 10,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 10,
                              sigmaY: 10,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Text(
                                    "$currtemp K",
                                    style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Icon(
                                    currSky == 'Clouds' || currSky == 'Rain'
                                        ? Icons.cloud
                                        : Icons.sunny,
                                    size: 64,
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    "$currSky",
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Weather forecast",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    //  SingleChildScrollView(
                    //     scrollDirection: Axis.horizontal,
                    //     child:  Row(
                    //       children: [
                    //         for(int i=1;i<=20;i++)
                    //         HourlyForecastItem(
                    //           time: data['list'][i]['dt'].toString(),
                    //           icn: data['list'][i]['weather'][0]['main']=="Clouds"||data['list'][i]['weather'][0]['main']=="Rain"?Icons.cloud:Icons.sunny,
                    //           value: data['list'][i]['main']['temp'].toString()+" K",
                    //         ),

                    //       ],
                    //     ),
                    //   ),

                    SizedBox(
                      height: 150,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 20,
                          itemBuilder: ((context, index) {
                            final hourlyTime = DateTime.parse(
                                data['list'][index]['dt_txt'].toString());
                            final hourlyIcon = data['list'][index]['weather'][0]
                                            ['main'] ==
                                        "Clouds" ||
                                    data['list'][index]['weather'][0]['main'] ==
                                        "Rain"
                                ? Icons.cloud
                                : Icons.sunny;
                            final hourlyTemp =
                                data['list'][index]['main']['temp'].toString() +
                                    " K";

                            return HourlyForecastItem(
                                time: DateFormat('j').format(hourlyTime),
                                icn: hourlyIcon,
                                value: hourlyTemp);
                          })),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Additional Information",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        AdditionalInfoItems(
                          icn: Icons.water_drop,
                          label: "Humidity",
                          value: "$currHumidity",
                        ),
                        AdditionalInfoItems(
                          icn: Icons.air,
                          label: "Wind Speed",
                          value: "$currWindSpeed",
                        ),
                        AdditionalInfoItems(
                          icn: Icons.beach_access,
                          label: "Pressure",
                          value: "$currPressure",
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
