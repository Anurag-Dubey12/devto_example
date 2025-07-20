import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pointer Widget Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.block),
              label: const Text('AbsorbPointer Demo'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AbsorbPointerDemo()),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.pan_tool),
              label: const Text('IgnorePointer Demo'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const IgnorePointerDemo()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AbsorbPointerDemo extends StatefulWidget {
  const AbsorbPointerDemo({super.key});

  @override
  State<AbsorbPointerDemo> createState() => _AbsorbPointerDemoState();
}

class _AbsorbPointerDemoState extends State<AbsorbPointerDemo> {
  bool _absorbing = true;
  String _lastTapped = 'None';

  void _handleTap(String layer) {
    setState(() {
      _lastTapped = layer;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$layer tapped!'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AbsorbPointer Demo'),
        centerTitle: true,
        backgroundColor: Colors.grey[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              'Absorbing enabled: $_absorbing\n\nLast tapped: $_lastTapped',
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Bottom layer - Blue
                  GestureDetector(
                    onTap: () => _handleTap('Bottom Layer'),
                    child: Container(
                      width: 320,
                      height: 320,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade700.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'Bottom Layer',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // Middle layer - Red wrapped with AbsorbPointer
                  AbsorbPointer(
                    absorbing: _absorbing,
                    child: GestureDetector(
                      onTap: () => _handleTap('Middle Layer'),
                      child: Container(
                        width: 220,
                        height: 220,
                        decoration: BoxDecoration(
                          color: Colors.red.shade700.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'Middle Layer\n(AbsorbPointer)',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),

                  // Top layer - Green
                  GestureDetector(
                    onTap: () => _handleTap('Top Layer'),
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.green.shade600.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'Top Layer',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Absorbing: ', style: TextStyle(fontSize: 16)),
                Switch(
                  value: _absorbing,
                  onChanged: (value) {
                    setState(() {
                      _absorbing = value;
                      _lastTapped = 'None';
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'How AbsorbPointer works:\n'
              '- When absorbing is ON, taps on the middle (red) layer are absorbed.\n'
              '- These taps do NOT reach the middle layer or pass through to the bottom layer.\n'
              '- Taps on the top (green) and bottom (blue) layers work normally.\n'
              '- When OFF, the middle layer detects taps normally.',
              style: TextStyle(fontSize: 14, color: Colors.white70),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────── IGNORE POINTER DEMO ────────────────

class IgnorePointerDemo extends StatefulWidget {
  const IgnorePointerDemo({super.key});

  @override
  State<IgnorePointerDemo> createState() => _IgnorePointerDemoState();
}

class _IgnorePointerDemoState extends State<IgnorePointerDemo> {
  bool _ignoring = true;
  String _lastTapped = 'None';

  void _handleTap(String layer) {
    setState(() {
      _lastTapped = layer;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$layer tapped!'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IgnorePointer Demo'),
        centerTitle: true,
        backgroundColor: Colors.grey[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              'Ignoring enabled: $_ignoring\n\nLast tapped: $_lastTapped',
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Bottom layer - Blue (semi-transparent)
                  GestureDetector(
                    onTap: () => _handleTap('Bottom Layer'),
                    child: Container(
                      width: 320,
                      height: 320,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade700.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'Bottom Layer',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // Middle layer - Red (semi-transparent), wrapped with IgnorePointer
                  IgnorePointer(
                    ignoring: _ignoring,
                    child: GestureDetector(
                      onTap: () => _handleTap('Middle Layer'),
                      child: Container(
                        width: 220,
                        height: 220,
                        decoration: BoxDecoration(
                          color: Colors.red.shade700.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'Middle Layer\n(IgnorePointer)',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),

                  // Top layer - Green (semi-transparent)
                  GestureDetector(
                    onTap: () => _handleTap('Top Layer'),
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.green.shade600.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'Top Layer',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Ignoring: ', style: TextStyle(fontSize: 16)),
                Switch(
                  value: _ignoring,
                  onChanged: (value) {
                    setState(() {
                      _ignoring = value;
                      _lastTapped = 'None';
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'How IgnorePointer works:\n'
              '- When ignoring is ON, taps on the middle (red) layer are ignored.\n'
              '- These taps pass through to the bottom layer.\n'
              '- Taps on the top (green) layer work normally.\n'
              '- When OFF, the middle layer detects taps normally.',
              style: TextStyle(fontSize: 14, color: Colors.white70),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
