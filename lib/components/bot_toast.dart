import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:qlkcl/utils/app_theme.dart';
import 'package:qlkcl/networking/response.dart';

// TextToast
CancelFunc showTextToast(String text) {
  return BotToast.showText(
    text: text,
    textStyle: TextStyle(color: CustomColors.primaryText, fontSize: 14.0),
    contentPadding: const EdgeInsets.all(16),
    contentColor: CustomColors.background,
    wrapToastAnimation: (controller, cancel, Widget child) =>
        CustomAnimationWidget(
      controller: controller,
      child: child,
    ),
  );
}

class CustomAnimationWidget extends StatefulWidget {
  final AnimationController controller;
  final Widget child;

  const CustomAnimationWidget(
      {Key? key, required this.controller, required this.child})
      : super(key: key);

  @override
  _CustomAnimationWidgetState createState() => _CustomAnimationWidgetState();
}

class _CustomAnimationWidgetState extends State<CustomAnimationWidget> {
  static final Tween<Offset> tweenOffset = Tween<Offset>(
    begin: const Offset(0, 40),
    end: const Offset(0, 0),
  );

  static final Tween<double> tweenScale = Tween<double>(begin: 0.7, end: 1.0);
  late Animation<double> animation;

  @override
  void initState() {
    animation =
        CurvedAnimation(parent: widget.controller, curve: Curves.decelerate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      child: widget.child,
      animation: animation,
      builder: (BuildContext? context, Widget? child) {
        return Transform.translate(
          offset: tweenOffset.evaluate(animation),
          child: Transform.scale(
            scale: tweenScale.evaluate(animation),
            child: Opacity(
              child: child,
              opacity: animation.value,
            ),
          ),
        );
      },
    );
  }
}

// Loading
CancelFunc showLoading({String? textLoading}) {
  return BotToast.showCustomLoading(toastBuilder: (cancelFunc) {
    return _CustomLoadWidget(cancelFunc: cancelFunc, textLoading: textLoading);
  });
}

class _CustomLoadWidget extends StatefulWidget {
  final CancelFunc cancelFunc;
  final String? textLoading;

  const _CustomLoadWidget(
      {Key? key, required this.cancelFunc, this.textLoading})
      : super(key: key);

  @override
  __CustomLoadWidgetState createState() => __CustomLoadWidgetState();
}

class __CustomLoadWidgetState extends State<_CustomLoadWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    animationController.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        animationController.forward();
      }
    });
    animationController.forward();

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const CircularProgressIndicator(),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              widget.textLoading ?? "Loading",
            ),
          )
        ],
      ),
    );
  }
}

// Notification
CancelFunc showNotification(dynamic data,
    {Status status = Status.success, String? subTitle, int duration = 3}) {
  return BotToast.showCustomNotification(
    dismissDirections: [DismissDirection.horizontal, DismissDirection.vertical],
    align: const Alignment(1, -1),
    duration: Duration(seconds: duration),
    toastBuilder: (cancel) {
      return _CustomWidget(
        cancelFunc: cancel,
        title: (data.runtimeType == Response)
            ? ((data as Response).status == Status.success
                ? "Thành công"
                : "Lỗi")
            : (status == Status.success
                ? "Thành công"
                : (status == Status.warning ? "Cảnh báo" : "Lỗi")),
        subTitle:
            (data.runtimeType == Response) ? (data as Response).message : data,
        backgroundColor: (data.runtimeType == Response)
            ? ((data as Response).status == Status.success
                ? CustomColors.success
                : CustomColors.error)
            : (status == Status.success
                ? CustomColors.success
                : (status == Status.warning
                    ? CustomColors.warning
                    : CustomColors.error)),
      );
    },
    onlyOne: false,
  );
}

class _CustomWidget extends StatefulWidget {
  final CancelFunc cancelFunc;
  final String title;
  final String? subTitle;
  final TextStyle? titleStyle;
  final TextStyle? subTitleStyle;
  final Color? backgroundColor;
  final double? borderRadius;
  final Icon closeIcon;
  final Widget? leading;
  final bool hideCloseButton;

  const _CustomWidget(
      {Key? key,
      required this.cancelFunc,
      required this.title,
      this.subTitle,
      this.titleStyle = const TextStyle(
        color: Colors.white,
        fontSize: 16.0,
      ),
      this.subTitleStyle = const TextStyle(color: Colors.white),
      this.backgroundColor,
      this.borderRadius = 8.0,
      this.closeIcon = const Icon(Icons.close),
      this.hideCloseButton = true,
      this.leading})
      : super(key: key);

  @override
  _CustomWidgetState createState() => _CustomWidgetState();
}

class _CustomWidgetState extends State<_CustomWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width > 450
          ? 350
          : MediaQuery.of(context).size.width,
      child: Wrap(
        children: <Widget>[
          Card(
            color: widget.backgroundColor ?? CustomColors.success,
            shape: widget.borderRadius == null
                ? null
                : RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(widget.borderRadius!),
                  ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.leading != null) widget.leading!,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: widget.titleStyle,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        if (widget.subTitle != null)
                          Text(
                            widget.subTitle!,
                            style: widget.subTitleStyle,
                          ),
                      ],
                    ),
                  ),
                  if (!widget.hideCloseButton)
                    IconButton(
                      icon: widget.closeIcon,
                      onPressed: widget.cancelFunc,
                      color: Colors.white,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
