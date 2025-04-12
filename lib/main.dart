import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:provider/provider.dart';
import 'models/session_model.dart';
import 'widgets/session_editor.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => SessionModel(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Portal(
      child: MaterialApp(
        title: 'WorkoutPro',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.indigo,
          colorScheme: const ColorScheme.dark(
            primary: Colors.indigo,
            secondary: Colors.tealAccent,
            tertiary: Colors.amber,
            surface: Color(0xFF1E1E1E),
          ),
          useMaterial3: true,
          fontFamily: 'Inter',
        ),
        home: const SessionEditorScreen(),
      ),
    );
  }
}

class SessionEditorScreen extends StatelessWidget {
  const SessionEditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Session Builder'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Session saved')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => _showHelpDialog(context),
          ),
        ],
      ),
      body: const SessionEditor(),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quick Guide'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('• Type / to see available block types'),
              Text('• Use /type.sport.parameters format'),
              Text('  Example: /interval.cycling.5x.2min.1min'),
              Text('• Press Enter to create a block'),
              Text('• Press Shift+Enter for text notes'),
              Text('• Click a block and press Backspace to edit'),
              Text('• Drag handles to reorder blocks'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}
