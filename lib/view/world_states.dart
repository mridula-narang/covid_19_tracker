import 'package:covid_19_tracker/models/world_stats_model.dart';
import 'package:covid_19_tracker/services/states_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';

class WorldStatsScreen extends StatefulWidget {
  const WorldStatsScreen({super.key});

  @override
  State<WorldStatsScreen> createState() => _WorldStatsScreenState();
}

class _WorldStatsScreenState extends State<WorldStatsScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(duration: const Duration(seconds: 3), vsync: this)
        ..repeat();
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  final colorList = <Color>[
    Color(0xff4285F4),
    Color(0xff1aa260),
    Color(0xffde5246),
  ];

  @override
  Widget build(BuildContext context) {
    StatesServices statesServices = StatesServices();
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            FutureBuilder(
                future: statesServices.fetchWorldStatesRecords(),
                builder: (context, AsyncSnapshot<WorldStatesModel> snapshot) {
                  if (!snapshot.hasData) {
                    return Expanded(
                      flex: 1,
                      child: SpinKitFadingCircle(
                        color: Colors.white,
                        size: 50,
                        controller: _controller,
                      ),
                    );
                  } else {
                    return Column(
                      children: [
                        PieChart(
                          dataMap: {
                            "Total": double.parse(snapshot.data!.cases!.toString()),
                            "Recovered": double.parse(snapshot.data!.recovered!.toString()),
                            "Deaths": double.parse(snapshot.data!.deaths!.toString()),
                            
                          },
                          chartRadius: MediaQuery.of(context).size.width / 2.5,
                          legendOptions: LegendOptions(legendPosition: LegendPosition.left),
                          animationDuration: Duration(milliseconds: 1200),
                          chartType: ChartType.ring,
                          colorList: colorList,
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Card(
                              child: Column(
                                children: [
                                  ReusableRow(title: 'Total', value: '200'),
                                  ReusableRow(title: 'Total', value: '200'),
                                  ReusableRow(title: 'Total', value: '200'),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  color: Color(0xff1aa260),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                child: Text('Track Countries'),
                              ),
                            ),
                      ],
                    );
                  }
                }),
          ],
        ),
      )),
    );
  }
}

class ReusableRow extends StatelessWidget {
  String title, value;
  ReusableRow({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              Text(value),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Divider(),
        ],
      ),
    );
  }
}
