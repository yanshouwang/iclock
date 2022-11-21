import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:iclock/utilities.dart';
import 'package:iclock/view_models.dart';
import 'package:iclock/widgets.dart';

class StopwatchView extends StatefulWidget {
  const StopwatchView({super.key});

  @override
  State<StopwatchView> createState() => _StopwatchViewState();
}

class _StopwatchViewState extends State<StopwatchView> {
  late StopwatchViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = StopwatchViewModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40.0),
            Expanded(
              flex: 2,
              child: buildStopwatch(context),
            ),
            const SizedBox(height: 40.0),
            Expanded(
              flex: 1,
              child: buildCounters(context),
            ),
            const SizedBox(height: 40.0),
            SizedBox(
              height: 100.0,
              child: buildController(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStopwatch(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40.0),
      child: ValueListenableBuilder<Duration>(
        valueListenable: viewModel.elapsed,
        builder: (context, elapsed, child) {
          final counters = viewModel.counters.value;
          final counter = counters.isEmpty ? Duration.zero : counters.last;
          final duration = elapsed - counter;
          return MimeticStopwatch(
            elapsed: elapsed,
            duration: duration,
            primaryColor: Theme.of(context).colorScheme.primary,
          );
        },
      ),
    );
  }

  Widget buildCounters(BuildContext context) {
    return ValueListenableBuilder<List<Duration>>(
      valueListenable: viewModel.counters,
      builder: (context, counters, child) {
        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          itemCount: counters.length,
          itemBuilder: (context, index) {
            final ri = counters.length - 1 - index;
            final counter = counters[ri];
            final previous = ri == 0 ? Duration.zero : counters[ri - 1];
            final duration = counter - previous;
            final style = Theme.of(context).textTheme.titleMedium!;
            return Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    '${ri + 1}',
                    style: index == 0
                        ? style.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          )
                        : style,
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Text(
                    counter.stopwatchText,
                    style: style,
                  ),
                ),
                Text(
                  '+${duration.stopwatchText}',
                  style: style,
                ),
              ],
            );
          },
          separatorBuilder: (context, index) {
            return const SizedBox(height: 20.0);
          },
        );
      },
    );
  }

  Widget buildController(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20.0),
      child: ValueListenableBuilder<bool>(
        valueListenable: viewModel.running,
        builder: (context, running, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ValueListenableBuilder<Duration>(
                valueListenable: viewModel.elapsed,
                builder: (context, elapsed, child) {
                  return Visibility(
                    visible: elapsed != Duration.zero,
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    child: IconButton(
                      onPressed: running
                          ? null
                          : () {
                              viewModel.reset();
                            },
                      icon: const Icon(FluentIcons.arrow_clockwise_24_regular),
                    ),
                  );
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (running) {
                    viewModel.stop();
                  } else {
                    viewModel.start();
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                ),
                child: Icon(
                  running
                      ? FluentIcons.pause_12_filled
                      : FluentIcons.play_12_filled,
                ),
              ),
              ValueListenableBuilder<Duration>(
                valueListenable: viewModel.elapsed,
                builder: (context, elapsed, child) {
                  return Visibility(
                    visible: elapsed != Duration.zero,
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    child: IconButton(
                      onPressed: running
                          ? () {
                              viewModel.count();
                            }
                          : null,
                      icon: const Icon(FluentIcons.flag_24_regular),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
