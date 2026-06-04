import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/vital_provider.dart';

class VitalTrendsScreen extends ConsumerStatefulWidget {
  const VitalTrendsScreen({super.key});

  @override
  ConsumerState<VitalTrendsScreen> createState() =>
      _VitalTrendsScreenState();
}

class _VitalTrendsScreenState
    extends ConsumerState<VitalTrendsScreen> {
  List vitals = [];

  bool loading = true;

  String selectedVital = "BLOOD_PRESSURE";

  @override
  void initState() {
    super.initState();
    fetchVitals();
  }

  Future<void> fetchVitals() async {
    try {
      final data =
          await ref.read(vitalServiceProvider).getVitals();

      setState(() {
        vitals = data;
        loading = false;
      });
    } catch (e) {
      print(e);

      setState(() {
        loading = false;
      });
    }
  }

  List<FlSpot> getChartData() {
    final filtered = vitals
        .where(
          (v) => v["vital_type"] == selectedVital,
        )
        .toList();

    filtered.sort(
      (a, b) => DateTime.parse(
        a["recorded_at"],
      ).compareTo(
        DateTime.parse(
          b["recorded_at"],
        ),
      ),
    );

    List<FlSpot> spots = [];

    for (int i = 0; i < filtered.length; i++) {
      final value =
          double.tryParse(
            filtered[i]["value"].toString(),
          ) ??
          0;

      spots.add(
        FlSpot(
          i.toDouble(),
          value,
        ),
      );
    }

    return spots;
  }

  String getLabel(String value) {
    switch (value) {
      case "BLOOD_PRESSURE":
        return "Blood Pressure";
      case "BLOOD_SUGAR":
        return "Blood Sugar";
      case "WEIGHT":
        return "Weight";
      default:
        return value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final chartData = getChartData();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Vital Trends"),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: selectedVital,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Select Vital",
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: "BLOOD_PRESSURE",
                        child: Text("Blood Pressure"),
                      ),
                      DropdownMenuItem(
                        value: "BLOOD_SUGAR",
                        child: Text("Blood Sugar"),
                      ),
                      DropdownMenuItem(
                        value: "WEIGHT",
                        child: Text("Weight"),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedVital = value!;
                      });
                    },
                  ),

                  const SizedBox(height: 30),

                  Text(
                    getLabel(selectedVital),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Expanded(
                    child: chartData.isEmpty
                        ? const Center(
                            child: Text(
                              "No data available",
                            ),
                          )
                        : LineChart(
                            LineChartData(
                              gridData: const FlGridData(
                                show: true,
                              ),

                              borderData:
                                  FlBorderData(
                                    show: true,
                                  ),

                              titlesData:
                                  const FlTitlesData(
                                    rightTitles:
                                        AxisTitles(
                                          sideTitles:
                                              SideTitles(
                                                showTitles:
                                                    false,
                                              ),
                                        ),
                                  ),

                              lineBarsData: [
                                LineChartBarData(
                                  spots: chartData,

                                  isCurved: true,

                                  dotData:
                                      const FlDotData(
                                        show: true,
                                      ),

                                  belowBarData:
                                      BarAreaData(
                                        show: true,
                                      ),
                                ),
                              ],
                            ),
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}