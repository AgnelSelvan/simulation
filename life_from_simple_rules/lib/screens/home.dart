import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:life_from_simple_rules/extension/list.dart';
import 'package:life_from_simple_rules/extension/offset.dart';
import 'package:life_from_simple_rules/models/atom.dart';
import 'package:life_from_simple_rules/widgets/painter.dart';
import 'package:life_from_simple_rules/widgets/slider.dart';

class ParticleScreen extends StatefulWidget {
  const ParticleScreen({
    super.key,
  });

  @override
  State<ParticleScreen> createState() => _ParticleScreenState();
}

class _ParticleScreenState extends State<ParticleScreen> {
//   late AnimationController controller;
//   late Animation<int> frame;
  List<Atom> atoms = [];
  Timer? timer;

  double maxWidth = 300;
  double maxHeight = 300;
  double lifeControlsWidth = 300;

  double redAtomCount = 100;
  double redAtomRadius = 2.5;
  double redAtomspeed = 0.5;
  double redXRed = -0.2;
  double redXGreen = -0.1;
  double redXYellow = -.1;

  double yellowAtomCount = 100;
  double yellowAtomRadius = 2.5;
  double yellowAtomspeed = 0.5;
  double yellowXYellow = 0.01;
  double yellowXGreen = .2;
  double yellowXRed = -.1;

  double greenAtomCount = 100;
  double greenAtomRadius = 2.5;
  double greenAtomspeed = 0.5;
  double greenXGreen = 0.01;
  double greenXRed = -.01;
  double greenXYellow = -.1;

  double minG = -2;
  double maxG = 2;
  double minSpeed = 0;
  double maxSpeed = 1;

  double minScreenWidthToShowControl = 600;
  bool canShowControl = false;
  int calcutionPerSec = 0;

  late Random random;
  int get count =>
      redAtomCount.toInt() + yellowAtomCount.toInt() + greenAtomCount.toInt();

  void generateAtom(Color color, int count, double radius,
      {required double speed}) {
    atoms.removeWhere((element) => element.color == color);
    for (var i = 0; i < count; i++) {
      final double dx = random.nextInt(maxWidth.toInt()).toDouble();
      final double dy = random.nextInt(maxHeight.toInt()).toDouble();
      atoms.add(
        Atom(
          position: Offset(dx, dy),
          color: color,
          id: random.nextInt(999999),
          radius: radius,
          speed: speed,
        ),
      );
    }
  }

  void updateRadius(Color color, double radius) {
    final atomsDup = atoms.where((element) => element.color == color);

    for (var atom in atomsDup) {
      final index = atoms.indexOf(atom);
      atoms[index] = atoms[index].copyWith(radius: radius);
    }
  }

  void updateSpeed(Color color, double speed) {
    final atomsDup = atoms.where((element) => element.color == color);

    for (var atom in atomsDup) {
      final index = atoms.indexOf(atom);
      atoms[index] = atoms[index].copyWith(speed: speed);
    }
  }

  bool get isMobileView =>
      MediaQuery.of(context).size.width < minScreenWidthToShowControl;

  void changeScreenSize() {
    maxWidth = isMobileView
        ? MediaQuery.of(context).size.width
        : (MediaQuery.of(context).size.width - lifeControlsWidth);
    maxHeight = MediaQuery.of(context).size.height;
    setState(() {});
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    changeScreenSize();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      random = Random();
      changeScreenSize();
      setState(() {});

      generateAtom(
        Colors.red,
        redAtomCount.toInt(),
        redAtomRadius,
        speed: redAtomspeed,
      );

      generateAtom(
        Colors.green,
        greenAtomCount.toInt(),
        yellowAtomRadius,
        speed: yellowAtomspeed,
      );

      generateAtom(
        Colors.yellow,
        yellowAtomCount.toInt(),
        greenAtomRadius,
        speed: greenAtomspeed,
      );

      startTimer();
    });

    super.initState();
  }

  startTimer() {
    //   fps microseconds: ((1000 / 60) * 1000).toInt()
    if (timer == null) {
      timer ??= Timer.periodic(
          Duration(microseconds: ((1000 / 60) * 1000).toInt()), (Timer t) {
        int cal = 0;
        cal += rule(
          atoms.greenAtom,
          atoms.greenAtom,
          greenXGreen,
        );
        cal += rule(
          atoms.greenAtom,
          atoms.redAtom,
          greenXRed,
        );
        cal += rule(
          atoms.greenAtom,
          atoms.yellowAtom,
          greenXYellow,
        );
        cal += rule(
          atoms.redAtom,
          atoms.redAtom,
          redXRed,
        );
        cal += rule(
          atoms.redAtom,
          atoms.greenAtom,
          redXGreen,
        );
        cal += rule(
          atoms.redAtom,
          atoms.yellowAtom,
          redXYellow,
        );
        cal += rule(
          atoms.yellowAtom,
          atoms.yellowAtom,
          yellowXYellow,
        );
        cal += rule(
          atoms.yellowAtom,
          atoms.greenAtom,
          yellowXGreen,
        );
        cal += rule(
          atoms.yellowAtom,
          atoms.greenAtom,
          yellowXRed,
        );
        calcutionPerSec = cal;
        setState(() {});
      });
    } else {
      timer?.cancel();
      timer = null;
    }

    setState(() {});
  }

  int rule(
    List<Atom> particle1,
    List<Atom> particle2,
    double g,
  ) {
    int calcution = 0;
    try {
      for (var i = 0; i < particle1.length; i++) {
        double fx = 0;
        double fy = 0;

        final particle = particle1[i];
        Offset a = particle.position;
        final index = atoms.indexWhere((element) => element.id == particle.id);
        for (var j = 0; j < particle2.length; j++) {
          Offset b = particle2[j].position;

          double dx = a.dx - b.dx;
          double dy = a.dy - b.dy;

          final d = sqrt(dx * dx + dy * dy);

          if (d > 0 && d < 100) {
            final force = g * particle.radius / d;
            fx += (force * dx);
            fy += (force * dy);
          }
          calcution++;
        }
        Offset velocity = Offset((fx + particle.velocity.dx) * particle.speed,
            (fy + particle.velocity.dy) * particle.speed);
        Offset position = a;
        double min = 0;
        if (a.dx <= min || a.dx >= (maxWidth + min)) {
          // velocity.dx * -1
          velocity = velocity.copyWith(dx: 0);
          position = a.copyWith(
              dx: random.nextInt(50) + velocity.dx, dy: a.dy + velocity.dy);
        } else if (a.dy <= min || a.dy >= (maxHeight + min)) {
          velocity = velocity.copyWith(dy: 0);
          position = a.copyWith(
              dx: a.dx + velocity.dx, dy: random.nextInt(50) + velocity.dy);
        } else {
          position = a.copyWith(dx: a.dx + velocity.dx, dy: a.dy + velocity.dy);
        }
        atoms[index] = atoms[index].copyWith(
          position: position,
          velocity: velocity,
        );
      }
    } catch (e) {}
    return calcution;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.black,
        child: Stack(
          children: [
            if (isMobileView)
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: _particlePainter(),
                  ))
            else
              Positioned(
                top: 0,
                left: lifeControlsWidth,
                child: _particlePainter(),
              ),
            if (MediaQuery.of(context).size.width < minScreenWidthToShowControl)
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: IconButton(
                      onPressed: () {
                        canShowControl = !canShowControl;
                        setState(() {});
                      },
                      icon: const Icon(Icons.settings)),
                ),
              ),
            if (MediaQuery.of(context).size.width < minScreenWidthToShowControl)
              if (canShowControl)
                _particleController(context)
              else
                const SizedBox()
            else
              _particleController(context)
          ],
        ),
      ),
    );
  }

  CustomPaint _particlePainter() {
    return CustomPaint(
      painter: MyPainter(
        atoms: atoms,
      ),
    );
  }

  Align _particleController(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: lifeControlsWidth,
        height: maxHeight,
        color: Colors.grey.withOpacity(0.05),
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text('Total Count: $count'),
                Text('calcutionPerSec: $calcutionPerSec'),
                _redAtomData(),
                _yellowAtomData(),
                _greenAtomData(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container _greenAtomData() {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        children: [
          Text(
              'Green: ${atoms.greenAtom.length} ${greenAtomRadius.toStringAsFixed(2)}'),
          TitleSlider(
            sliderValue: greenAtomCount.round().toDouble(),
            title: "Count",
            slider: Slider(
              value: greenAtomCount,
              onChanged: (val) {
                timer?.cancel();
                timer = null;
                greenAtomCount = val;
                generateAtom(
                  Colors.green,
                  greenAtomCount.toInt(),
                  greenAtomRadius,
                  speed: greenAtomspeed,
                );

                startTimer();
                setState(() {});
              },
              max: 800,
              min: 0,
            ),
          ),
          TitleSlider(
            title: "Radius",
            sliderValue: greenAtomRadius,
            slider: Slider(
              value: greenAtomRadius,
              onChanged: (val) {
                greenAtomRadius = val;
                updateRadius(Colors.green, greenAtomRadius);
                setState(() {});
              },
              max: 5,
              min: 0,
            ),
          ),
          TitleSlider(
            title: "Speed",
            sliderValue: greenAtomspeed,
            slider: Slider(
              value: greenAtomspeed,
              onChanged: (val) {
                greenAtomspeed = val;
                updateSpeed(Colors.green, greenAtomspeed);
                setState(() {});
              },
              max: maxSpeed,
              min: minSpeed,
            ),
          ),
          TitleSlider(
            title: "Green X Green",
            sliderValue: greenXGreen,
            slider: Slider(
              value: greenXGreen,
              onChanged: (val) {
                greenXGreen = val;
                timer?.cancel();
                timer = null;
                startTimer();
              },
              max: maxG,
              min: minG,
            ),
          ),
          TitleSlider(
            sliderValue: greenXRed,
            title: "Green X Red",
            slider: Slider(
              value: greenXRed,
              onChanged: (val) {
                greenXRed = val;
                timer?.cancel();
                timer = null;
                startTimer();
              },
              max: maxG,
              min: minG,
            ),
          ),
          TitleSlider(
            sliderValue: greenXYellow,
            title: "Green X Yellow",
            slider: Slider(
              value: greenXYellow,
              onChanged: (val) {
                greenXYellow = val;
                timer?.cancel();
                timer = null;
                startTimer();
              },
              max: maxG,
              min: minG,
            ),
          ),
        ],
      ),
    );
  }

  Container _yellowAtomData() {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        children: [
          Text(
              'Yellow: ${atoms.yellowAtom.length} ${yellowAtomRadius.toStringAsFixed(2)}'),
          TitleSlider(
            sliderValue: yellowAtomCount.round().toDouble(),
            title: "Count",
            slider: Slider(
              value: yellowAtomCount,
              onChanged: (val) {
                timer?.cancel();
                timer = null;
                yellowAtomCount = val;
                generateAtom(
                  Colors.yellow,
                  yellowAtomCount.toInt(),
                  yellowAtomRadius,
                  speed: yellowAtomspeed,
                );

                startTimer();
                setState(() {});
              },
              max: 800,
              min: 0,
            ),
          ),
          TitleSlider(
            title: "Radius",
            sliderValue: yellowAtomRadius,
            slider: Slider(
              value: yellowAtomRadius,
              onChanged: (val) {
                yellowAtomRadius = val;
                updateRadius(Colors.yellow, yellowAtomRadius);
                setState(() {});
              },
              max: 5,
              min: 0,
            ),
          ),
          TitleSlider(
            title: "Speed",
            sliderValue: yellowAtomspeed,
            slider: Slider(
              value: yellowAtomspeed,
              onChanged: (val) {
                yellowAtomspeed = val;
                updateSpeed(Colors.yellow, yellowAtomspeed);
                setState(() {});
              },
              max: maxSpeed,
              min: minSpeed,
            ),
          ),
          TitleSlider(
            title: "Yellow X Yellow",
            sliderValue: yellowXYellow,
            slider: Slider(
              value: yellowXYellow,
              onChanged: (val) {
                yellowXYellow = val;
                timer?.cancel();
                timer = null;
                startTimer();
              },
              max: maxG,
              min: minG,
            ),
          ),
          TitleSlider(
            title: "Yellow X Green",
            sliderValue: yellowXGreen,
            slider: Slider(
              value: yellowXGreen,
              onChanged: (val) {
                yellowXGreen = val;
                timer?.cancel();
                timer = null;
                startTimer();
              },
              max: maxG,
              min: minG,
            ),
          ),
          TitleSlider(
            title: "Yellow X Red",
            sliderValue: yellowXRed,
            slider: Slider(
              value: yellowXRed,
              onChanged: (val) {
                yellowXRed = val;
                timer?.cancel();
                timer = null;
                startTimer();
              },
              max: maxG,
              min: minG,
            ),
          ),
        ],
      ),
    );
  }

  Container _redAtomData() {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Red: ${atoms.redAtom.length}'),
          TitleSlider(
            title: "Count",
            sliderValue: redAtomCount.roundToDouble(),
            slider: Slider(
              value: redAtomCount,
              onChanged: (val) {
                timer?.cancel();
                timer = null;
                redAtomCount = val;
                generateAtom(
                  Colors.red,
                  redAtomCount.toInt(),
                  redAtomRadius,
                  speed: redAtomspeed,
                );

                startTimer();
                setState(() {});
              },
              max: 800,
              min: 0,
            ),
          ),
          TitleSlider(
            title: "Radius",
            sliderValue: redAtomRadius,
            slider: Slider(
              value: redAtomRadius,
              onChanged: (val) {
                redAtomRadius = val;
                updateRadius(Colors.red, redAtomRadius);
                setState(() {});
              },
              max: 5,
              min: 0,
            ),
          ),
          TitleSlider(
            title: "Speed",
            sliderValue: redAtomspeed,
            slider: Slider(
              value: redAtomspeed,
              onChanged: (val) {
                redAtomspeed = val;
                updateSpeed(Colors.red, redAtomspeed);
                setState(() {});
              },
              max: maxSpeed,
              min: minSpeed,
            ),
          ),
          TitleSlider(
            title: "Red X Red",
            sliderValue: redXRed,
            slider: Slider(
              value: redXRed,
              onChanged: (val) {
                redXRed = val;
                timer?.cancel();
                timer = null;
                startTimer();
              },
              max: maxG,
              min: minG,
            ),
          ),
          TitleSlider(
            title: "Red X Green",
            sliderValue: redXGreen,
            slider: Slider(
              value: redXGreen,
              onChanged: (val) {
                redXGreen = val;
                timer?.cancel();
                timer = null;
                startTimer();
              },
              max: maxG,
              min: minG,
            ),
          ),
          TitleSlider(
            title: "Red X Yellow",
            sliderValue: redXYellow,
            slider: Slider(
              value: redXYellow,
              onChanged: (val) {
                redXYellow = val;
                timer?.cancel();
                timer = null;
                startTimer();
              },
              max: maxG,
              min: minG,
            ),
          ),
        ],
      ),
    );
  }
}
