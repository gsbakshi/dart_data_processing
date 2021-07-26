import 'dart:io';

void main(List<String> args) {
  if (args.isEmpty) {
    print('Usage: dart total.dart <inputFileName.csv>');
    exit(1);
  }

  final inputFile = args.first;
  final data = checkFile(inputFile);
  if (data.isEmpty) {
    print(
        'This file seems to be empty/doesn\'t exist. Please check your file name again.');
    exit(1);
  }
  final Map<String, double> totalDurationByTag = {};
  data.removeAt(0);
  var totalDuration = 0.0;
  for (var line in data) {
    final values = line.split(',');
    final durationStr = values[3].replaceAll('"', '');
    final duration = double.parse(durationStr);
    final tag = values[5].replaceAll('"', '');
    final previousDuration = totalDurationByTag[tag];
    if (previousDuration == null) {
      totalDurationByTag[tag] = duration;
    } else {
      totalDurationByTag[tag] = previousDuration + duration;
    }
    totalDuration += duration;
  }
  for (var entry in totalDurationByTag.entries) {
    final durationFormatted = entry.value.toStringAsFixed(1);
    final tag = entry.key == '' ? 'Unallocated' : entry.key;
    print('$tag: ${durationFormatted}h');
  }

  print('Total time overall: ${totalDuration.toStringAsFixed(1)}h');
}

List<String> checkFile(String fileName) {
  late final List<String> fileData;
  try {
    fileData = File(fileName).readAsLinesSync();
  } catch (error) {
    fileData = [];
    print('This file doesn\'t exist');
  }
  return fileData;
}
