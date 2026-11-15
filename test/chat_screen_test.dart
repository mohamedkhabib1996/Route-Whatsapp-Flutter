import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:whatsapp_app/main.dart';
import 'package:whatsapp_app/models/chat_message.dart';
import 'package:whatsapp_app/widgets/chat_bubble.dart';

const _recordDemo = bool.fromEnvironment('RECORD_DEMO');
const _frameDirectory = String.fromEnvironment(
  'DEMO_FRAMES',
  defaultValue: 'build/demo_frames',
);

Future<void> _loadFonts() async {
  final roboto = FontLoader('Roboto');
  for (final weight in ['Regular', 'Medium', 'Bold']) {
    roboto.addFont(rootBundle.load('assets/fonts/Roboto-$weight.ttf'));
  }
  await roboto.load();
  final icons = FontLoader('MaterialIcons')
    ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
  await icons.load();
}

class _DemoFrames {
  _DemoFrames(this.tester, this.boundaryKey);

  final WidgetTester tester;
  final GlobalKey boundaryKey;
  int _frame = 0;

  Future<void> hold(int frames) async {
    if (!_recordDemo) {
      await tester.pump(Duration(microseconds: frames * 83333));
      return;
    }
    for (var index = 0; index < frames; index++) {
      await tester.pump(const Duration(microseconds: 83333));
      final boundary =
          boundaryKey.currentContext!.findRenderObject()!
              as RenderRepaintBoundary;
      await tester.runAsync(() async {
        final image = await boundary.toImage(pixelRatio: 2);
        try {
          final data = await image.toByteData(format: ui.ImageByteFormat.png);
          final path =
              '$_frameDirectory/frame_${_frame.toString().padLeft(4, '0')}.png';
          await File(path).writeAsBytes(data!.buffer.asUint8List());
        } finally {
          image.dispose();
        }
      });
      _frame++;
    }
  }

  Future<void> type(String text) async {
    if (!_recordDemo) {
      await tester.enterText(find.byType(TextField), text);
      await tester.pump();
      return;
    }
    for (var length = 1; length <= text.length; length++) {
      await tester.enterText(find.byType(TextField), text.substring(0, length));
      await hold(1);
    }
  }
}

void main() {
  testWidgets(
    'chat opens and sends trimmed local messages without blank bubbles',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.runAsync(_loadFonts);
      if (_recordDemo) {
        await tester.runAsync(
          () => Directory(_frameDirectory).create(recursive: true),
        );
      }
      final boundaryKey = GlobalKey();
      await tester.pumpWidget(
        RepaintBoundary(key: boundaryKey, child: const Assignment6App()),
      );
      await tester.pumpAndSettle();
      await tester.runAsync(() async {
        final context = tester.element(find.byType(Scaffold));
        await Future.wait([
          for (final asset in [
            'assets/images/chat_wallpaper.png',
            'assets/images/john_avatar.png',
            'assets/images/route_logo.png',
          ])
            precacheImage(AssetImage(asset), context),
        ]);
      });
      await tester.pumpAndSettle();
      final frames = _DemoFrames(tester, boundaryKey);

      expect(find.text('John Safwat'), findsOneWidget);
      expect(
        find.text('What a Great Course! To learn Flutter'),
        findsOneWidget,
      );
      expect(find.byTooltip('Send message'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await frames.hold(24);

      await tester.tap(find.byType(TextField));
      await frames.type('  Hello from my Flutter app!  ');
      await frames.hold(12);
      await tester.tap(find.byTooltip('Send message'));
      await frames.hold(24);
      expect(find.text('Hello from my Flutter app!'), findsOneWidget);
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        '',
      );
      expect(tester.takeException(), isNull);

      await frames.type('   ');
      await tester.tap(find.byTooltip('Send message'));
      await frames.hold(12);
      final emptyBubbles = tester
          .widgetList<ChatBubble>(find.byType(ChatBubble))
          .where(
            (bubble) =>
                bubble.message.kind == MessageKind.text &&
                (bubble.message.text?.trim().isEmpty ?? true),
          );
      expect(emptyBubbles, isEmpty);

      await frames.type('Message sent successfully.');
      await frames.hold(8);
      await tester.tap(find.byTooltip('Send message'));
      await frames.hold(30);
      expect(find.text('Message sent successfully.'), findsOneWidget);
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        '',
      );
      expect(tester.takeException(), isNull);
      FocusManager.instance.primaryFocus?.unfocus();
      await frames.hold(18);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
    },
  );
}
