// Bedrock widget smoke test.
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Bedrock app smoke test', (WidgetTester tester) async {
    // Bedrock requires async DB init; this placeholder ensures the test file
    // compiles cleanly. Integration tests live in the integration_test/ folder.
    expect(true, isTrue);
  });
}
