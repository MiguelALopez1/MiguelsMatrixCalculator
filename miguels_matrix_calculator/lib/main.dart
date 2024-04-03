import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Matrix Display and Input',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(title: '4x4 Matrix Display and Input'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Store the user input for the matrices
  Map<String, List<List<String>>> userMatrices = {
    'A': List.generate(4, (_) => List.filled(4, '')),
    'B': List.generate(4, (_) => List.filled(4, '')),
    'C': List.generate(4, (_) => List.filled(4, '')),
    'D': List.generate(4, (_) => List.filled(4, '')),
  };

  // Function to create text widgets for the predefined matrix rows
  Widget _buildPredefinedMatrixWidget(vector.Matrix4 matrix) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(4, (i) {
        vector.Vector4 row = matrix.getRow(i);
        return Text(
          '[ ${row.x.toInt()} ${row.y.toInt()} ${row.z.toInt()} ${row.w.toInt()} ]',
          style: Theme.of(context).textTheme.headlineMedium,
        );
      }),
    );
  }

  // Function to create the matrix input fields
  Widget _buildMatrixInput(String matrixName) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(matrixName, style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
        ),
        ...List.generate(4, (i) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(4, (j) {
              return Padding(
                padding: const EdgeInsets.all(2.0),
                child: SizedBox(
                  width: 48,
                  height: 48,
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        userMatrices[matrixName]![i][j] = value;
                      });
                    },
                  ),
                ),
              );
            }),
          );
        }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Define the four predefined matrices
    List<vector.Matrix4> matrices = [
      vector.Matrix4.identity(),
      vector.Matrix4.zero()..setEntry(0, 3, 1)..setEntry(1, 2, 1)..setEntry(2, 1, 1)..setEntry(3, 0, 1),
      vector.Matrix4.zero()..setRow(0, vector.Vector4(0, 0, 1, 0))..setRow(1, vector.Vector4(0, 1, 0, 0))..setRow(2, vector.Vector4(0, 0, 0, 1))..setRow(3, vector.Vector4(1, 0, 0, 0)),
      vector.Matrix4.zero()..setRow(0, vector.Vector4(0, 1, 0, 0))..setRow(1, vector.Vector4(0, 0, 0, 1))..setRow(2, vector.Vector4(1, 0, 0, 0))..setRow(3, vector.Vector4(0, 0, 1, 0)),
    ];

    // Generate widgets for the predefined matrices
    List<Widget> predefinedMatrixWidgets = matrices.map((matrix) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: _buildPredefinedMatrixWidget(matrix),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Display the predefined matrices horizontally
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: predefinedMatrixWidgets,
              ),
            ),
            const Divider(height: 20, thickness: 2),
            // Display the matrix input fields horizontally
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildMatrixInput('A'),
                  VerticalDivider(width: 20, thickness: 2),
                  _buildMatrixInput('B'),
                  VerticalDivider(width: 20, thickness: 2),
                  _buildMatrixInput('C'),
                  VerticalDivider(width: 20, thickness: 2),
                  _buildMatrixInput('D'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add your submission logic here
              },
              child: const Text('Submit Matrices'),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Expanded(
                    // Use Expanded to ensure the text field takes up the remaining space
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter an expression:',
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0), // Add some spacing between the text field and the button
                  ElevatedButton(
                    onPressed: () {
                      // Your button tap logic here
                    },
                    child: Text('Submit'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
