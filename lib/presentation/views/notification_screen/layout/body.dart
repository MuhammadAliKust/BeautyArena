import 'package:beauty_arena_app/presentation/elements/select_type_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../application/app_state.dart';
import '../../../../application/user_provider.dart';
import '../../../../configurations/enums.dart';
import '../../../../infrastructure/models/notification.dart';
import '../../../../infrastructure/services/categories.dart';
import '../../../../infrastructure/services/notification.dart';
import '../../../elements/processing_widget.dart';
import 'widgets/notification_widget.dart';

class NotificationViewBody extends StatefulWidget {
  const NotificationViewBody({Key? key}) : super(key: key);

  @override
  _NotificationViewBodyState createState() => _NotificationViewBodyState();
}

class _NotificationViewBodyState extends State<NotificationViewBody> {
  @override
  Widget build(BuildContext context) {
    var state = Provider.of<AppState>(context, listen: false);
    var user = Provider.of<UserProvider>(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          color: Colors.white),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Image.asset('assets/icons/notification _icon.png',
                    width: 23.09, height: 26.52),
                const SizedBox(width: 10),
                const Text(
                  'Notifications',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          FutureProvider.value(
            value: NotificationServices().getAllNotifications(
                context, state, user.getUserDetails()!.data!.token.toString()),
            initialData: NotificationModel(),
            builder: (context, child) {
              var model = context.watch<NotificationModel>();
              if (state.getStateStatus() == AppCurrentState.IsBusy) {
                return const Center(child: ProcessingWidget());
              } else if (state.getStateStatus() == AppCurrentState.IsError) {
                return const Text('No Internet');
              } else {
                return Expanded(
                  child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: model.data!.length,
                      itemBuilder: (BuildContext context, int i) {
                        return NotificationWidget(
                            onTap: () {},
                            subHeading:  model.data![i].content.toString(),
                            backgroundcolor: const Color(0xffFBFBFB),
                            image:
                                'assets/icons/order_successfully_notification_icon.png',
                            heading: model.data![i].title.toString(),
                            time: model.data![i].date.toString());
                      }),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
