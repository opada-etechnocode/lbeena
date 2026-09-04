import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:syrians_in_uae/ui/screens/events/widgets/effectiveness_widget.dart';
import 'package:syrians_in_uae/ui/screens/events/widgets/social_media_widget.dart';
import 'package:syrians_in_uae/widgets/components.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/models/events/effectiveness.dart';
import '../../../data/models/events/social_media_effectiveness.dart';
import '../../../widgets/events_shimmer/effectiveness_shimmer.dart';
import '../../../widgets/events_shimmer/social_media_shimmer.dart';
import '../../../widgets/smart_refresh_widget.dart';
import 'cubit/events_cubit.dart';
import 'cubit/events_state.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  List<SocialMediaEffectiveness> dataSocialMedia = [];
  List<Effectiveness> dataEffectiveness = [];
  bool isLoadingDataSocialMedia = true;
  bool isLoadingEffectiveness = true;
int page =1;
  final RefreshController _refreshController =
  RefreshController(initialRefresh: false);
  onRefresh(context) async {
    page =1;
    dataEffectiveness.clear();
     EventsCubit.get(context).getSocialMediaEffectiveness();
    await EventsCubit.get(context).getEffectiveness(page: page);
    _refreshController.refreshCompleted();
  }
  onLoading(context) async {
    page ++;
    await EventsCubit.get(context).getEffectiveness(page: page,isLoading: false);
    _refreshController.loadComplete();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarNormalWithIcon(
          text: 'نشاطات وفعاليات', context: context, isShowBack: true),
      body: BlocProvider(
        create: (context) => EventsCubit()
          ..getEffectiveness(page: 1)
          ..getSocialMediaEffectiveness(),
        child: BlocConsumer<EventsCubit, EventsState>(
          listener: (context, state) {
            if (state is SocialMediaEffectivenessStateSuccess) {
              dataSocialMedia = state.socialMediaEffectivenessModel!.data;
              isLoadingDataSocialMedia = false;
            }
            if (state is SocialMediaEffectivenessStateLoading) {
              isLoadingDataSocialMedia = true;
            }
            if (state is SocialMediaEffectivenessStateError) {
              isLoadingDataSocialMedia = false;
            }

            if (state is EffectivenessStateSuccess) {
              isLoadingEffectiveness = false;
              dataEffectiveness.addAll(state.effectivenessModel!.data);
            }

            if (state is EffectivenessStateLoading) {
              isLoadingEffectiveness = true;
            }
            if (state is EffectivenessStateError) {
              isLoadingEffectiveness = false;
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                sizeHeightNormal(),
                isLoadingDataSocialMedia
                    ? SocialMediaShimmer()
                    : SizedBox(
                  height: 90.h,
                      child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: dataSocialMedia.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return SocialMediaWidget(
                                icon: dataSocialMedia[index].image!,
                                onTap: () {
                                  final Uri url = Uri.parse( dataSocialMedia[index].url.toString());
                                  launchUrl(url,mode: LaunchMode.externalApplication);
                                });
                          }),
                    ),
                sizeHeightNormal(),


            Expanded(
                  child: SmartRefreshWidget(
                    onRefresh: () {
                      onRefresh(context);
                    },
                    controller: _refreshController,
                    onLoading: () {
                      onLoading(context);
                    },
                    child:     isLoadingEffectiveness ?EffectivenessShimmer(): ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: dataEffectiveness.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return EffectivenessWidget(
                             effectivenessData: dataEffectiveness[index],
                              );
                        }),
                  ),
                ),
                SizedBox(height: 10.h,),
              ],
            );
          },
        ),
      ),
    );
  }
}
