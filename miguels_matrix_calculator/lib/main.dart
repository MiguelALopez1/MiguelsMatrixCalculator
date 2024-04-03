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
      title: 'Miguels Matrix Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(title: 'Miguels Matrix Calculator'),
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
  final List<TextEditingController> _controllers = List.generate(4, (i) => TextEditingController());

  // Store the user input for the matrices
  Map<String, List<List<String>>> userMatrices = {
    'A': List.generate(4, (_) => List.filled(4, '')),
    'B': List.generate(4, (_) => List.filled(4, '')),
    'C': List.generate(4, (_) => List.filled(4, '')),
    'D': List.generate(4, (_) => List.filled(4, '')),
    'E': List.generate(4, (_) => List.filled(4, '')),
    'F': List.generate(4, (_) => List.filled(4, '')),
    'G': List.generate(4, (_) => List.filled(4, '')),
  };

  // Matrix to be displayed and updated dynamically
  List<List<int>> displayMatrix = List.generate(4, (_) => List.generate(4, (_) => 0));

  // Function to update the display matrix and refresh the UI
  void updateDisplayMatrix(List<List<int>> newMatrix) {
    setState(() {
      displayMatrix = newMatrix;
    });
  }

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
  
  List<vector.Matrix4> savedMatrices = List.filled(7, vector.Matrix4.zero());

void saveInputMatrices() {
  List<String> keys = ['A', 'B', 'C', 'D', 'E', 'F', 'G'];
  for (int i = 0; i < keys.length; i++) {
    String key = keys[i];
    var matrixStrings = userMatrices[key]!;
    var matrixNumbers = matrixStrings.map((row) =>
      row.map((value) => double.tryParse(value) ?? 0.0).toList()  // Ensures 0.0 for empty fields
    ).toList();

    vector.Matrix4 newMatrix = vector.Matrix4(
      matrixNumbers[0][0], matrixNumbers[1][0], matrixNumbers[2][0], matrixNumbers[3][0],
      matrixNumbers[0][1], matrixNumbers[1][1], matrixNumbers[2][1], matrixNumbers[3][1],
      matrixNumbers[0][2], matrixNumbers[1][2], matrixNumbers[2][2], matrixNumbers[3][2],
      matrixNumbers[0][3], matrixNumbers[1][3], matrixNumbers[2][3], matrixNumbers[3][3],
    );

    savedMatrices[i] = newMatrix;

    print('Matrix $key: ${newMatrix.toString()}');
  }
}

// vector.Matrix4 scalarMultiplyMatrix(double scalar, vector.Matrix4 matrix) {
//   return matrix.scaled(scalar);
// }


// Helper method to perform scalar multiplication
vector.Matrix4 scalarMultiplyMatrix(double scalar, vector.Matrix4 matrix) {
  // Apply scalar multiplication to each element of the matrix
  return vector.Matrix4(
    matrix.entry(0, 0) * scalar, matrix.entry(1, 0) * scalar, matrix.entry(2, 0) * scalar, matrix.entry(3, 0) * scalar,
    matrix.entry(0, 1) * scalar, matrix.entry(1, 1) * scalar, matrix.entry(2, 1) * scalar, matrix.entry(3, 1) * scalar,
    matrix.entry(0, 2) * scalar, matrix.entry(1, 2) * scalar, matrix.entry(2, 2) * scalar, matrix.entry(3, 2) * scalar,
    matrix.entry(0, 3) * scalar, matrix.entry(1, 3) * scalar, matrix.entry(2, 3) * scalar, matrix.entry(3, 3) * scalar
  );
}


// Helper method to identify and perform operations
vector.Matrix4 performOperation(vector.Matrix4 matrix1, vector.Matrix4 matrix2, String operation) {
  switch (operation) {
    case '+':
      return matrix1 + matrix2;
    case '-':
      return matrix1 - matrix2;
    default:
      return vector.Matrix4.zero(); // Default to zero matrix for unsupported operations
  }
}

List<List<double>> displayMatrix1 = List.generate(4, (_) => List.generate(4, (_) => 0.0));
List<List<double>> displayMatrix2 = List.generate(4, (_) => List.generate(4, (_) => 0.0));
List<List<double>> displayMatrix3 = List.generate(4, (_) => List.generate(4, (_) => 0.0));
List<List<double>> displayMatrix4 = List.generate(4, (_) => List.generate(4, (_) => 0.0));


void processComplexExpression(String expression, int resultIndex) {
  print('Processing expression for result matrix ${resultIndex + 1}: $expression');

  List<String> parts = expression.split(' ');
  vector.Matrix4 result = vector.Matrix4.zero();
  String lastOperation = '+';

  for (String part in parts) {
    if (part == '+' || part == '-') {
      lastOperation = part;
    } else {
      double scalar = 1.0;
      String matrixKey = part;

      // Check and process scalar multiplication
      if (part.contains(RegExp(r'[0-9]'))) {
    // Debug print to see what's extracted
    print("Part: $part");

    // Extracting scalar using regex that captures the numeric part
    String? scalarPart = RegExp(r'\d+').stringMatch(part);
    if (scalarPart != null) {
        scalar = double.parse(scalarPart);
        print("Scalar: $scalar");
    } else {
        // Log error if scalar part is not found - fallback to 1
        print("Scalar not found, defaulting to 1");
        scalar = 1.0;
    }

    // Extracting matrix key using regex that captures the alphabetic part
    String? matrixPart = RegExp(r'[A-G]').stringMatch(part);
    if (matrixPart != null) {
        matrixKey = matrixPart;
        print("Matrix Key: $matrixKey");
    } else {
        // Log error if matrix key is not found
        print("Matrix key not found");
        return; // Exit the function or handle this case appropriately
    }

    vector.Matrix4 currentMatrix = savedMatrices[['A', 'B', 'C', 'D', 'E', 'F', 'G'].indexOf(matrixKey)];
    vector.Matrix4 scaledMatrix = scalarMultiplyMatrix(scalar, currentMatrix);

    // Debug print to verify the scaled matrix
    print("Scaled Matrix: $scaledMatrix");
} else {
    // Handle non-scalar multiplication cases
}


      // Print the identified matrix and operation
      print('Operation: $lastOperation, Matrix Key: $matrixKey, Scalar: $scalar');

      vector.Matrix4 currentMatrix = savedMatrices[['A', 'B', 'C', 'D', 'E', 'F', 'G'].indexOf(matrixKey)];
      vector.Matrix4 scaledMatrix = scalarMultiplyMatrix(scalar, currentMatrix);

      // Logging the operation and the matrices involved
      if (result != vector.Matrix4.zero()) {
        print('Performing $lastOperation between:');
        print('Matrix 1: ${result.toString()}');
        print('Matrix 2: ${scaledMatrix.toString()}');
      }

      result = result == vector.Matrix4.zero() ? scaledMatrix : performOperation(result, scaledMatrix, lastOperation);
    }
  }

  // Print the final result
  print('Final calculated matrix for display ${resultIndex + 1}:');
  print(result.toString());

  // Update the correct display matrix based on the result index
 setState(() {
  switch (resultIndex) {
    case 0:
      displayMatrix1 = convertMatrix4ToList(result);
      break;
    case 1:
      displayMatrix2 = convertMatrix4ToList(result);
      break;
    case 2:
      displayMatrix3 = convertMatrix4ToList(result);
      break;
    case 3:
      displayMatrix4 = convertMatrix4ToList(result);
      break;
  }
});
}

List<List<double>> convertMatrix4ToList(vector.Matrix4 matrix) {
  List<List<double>> result = List.generate(4, (_) => List.generate(4, (_) => 0.0));
  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 4; j++) {
      result[i][j] = matrix.entry(i, j);
    }
  }
  return result;
}



@override
  Widget build(BuildContext context) {
    List<vector.Matrix4> matrices = [
      vector.Matrix4.identity(),
      vector.Matrix4.zero()..setRow(0, vector.Vector4(0, 0, 0, 1))..setRow(1, vector.Vector4(1, 0, 0, 0))..setRow(2, vector.Vector4(0, 1, 0, 0))..setRow(3, vector.Vector4(0, 0, 1, 0)),
      vector.Matrix4.zero()..setRow(0, vector.Vector4(0, 0, 1, 0))..setRow(1, vector.Vector4(0, 0, 0, 1))..setRow(2, vector.Vector4(1, 0, 0, 0))..setRow(3, vector.Vector4(0, 1, 0, 0)),
      vector.Matrix4.zero()..setRow(0, vector.Vector4(0, 1, 0, 0))..setRow(1, vector.Vector4(0, 0, 1, 0))..setRow(2, vector.Vector4(0, 0, 0, 1))..setRow(3, vector.Vector4(1, 0, 0, 0)),
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
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
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
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _buildMatrixInput('E'),
                        VerticalDivider(width: 20, thickness: 2),
                        _buildMatrixInput('F'),
                        VerticalDivider(width: 20, thickness: 2),
                        _buildMatrixInput('G'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveInputMatrices, // This now calls the function to save matrices
              child: const Text('Submit Matrices'),
            ),

            // Example for one of the text field/button pairs
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controllers[0],  // Using the first controller for the first text field
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter an expression:',
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: () {
                      // Use the text from the corresponding text field's controller
                      processComplexExpression(_controllers[0].text, 0);
                    },
                    child: Text('Submit'),
                  ),
                ],
              ),
            ),

            // Assuming this is for displayMatrix1
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: displayMatrix1.map((row) => Row(  
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: row.map((item) => 
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(item.toString(), style: TextStyle(fontSize: 24)),
                    )).toList(),
                )).toList(),
              ),
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
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: displayMatrix.map((row) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: row.map((item) => 
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(item.toString(), style: TextStyle(fontSize: 24)),
                    )).toList(),
                )).toList(),
              ),
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
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: displayMatrix.map((row) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: row.map((item) => 
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(item.toString(), style: TextStyle(fontSize: 24)),
                    )).toList(),
                )).toList(),
              ),
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
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: displayMatrix.map((row) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: row.map((item) => 
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(item.toString(), style: TextStyle(fontSize: 24)),
                    )).toList(),
                )).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
