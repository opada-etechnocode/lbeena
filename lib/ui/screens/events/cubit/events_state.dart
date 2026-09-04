
import '../../../../data/models/events/effectiveness.dart';
import '../../../../data/models/events/social_media_effectiveness.dart';

abstract class EventsState {}

 class EventsInitial extends EventsState {}
 class SocialMediaEffectivenessStateLoading extends EventsState {}
   class SocialMediaEffectivenessStateSuccess extends EventsState {
   SocialMediaEffectivenessModel? socialMediaEffectivenessModel;SocialMediaEffectivenessStateSuccess(this.socialMediaEffectivenessModel);
 }
 class SocialMediaEffectivenessStateError extends EventsState {
   String? error;SocialMediaEffectivenessStateError(this.error);
 }


class EffectivenessStateLoading extends EventsState {}
class EffectivenessStateSuccess extends EventsState {
  EffectivenessModel? effectivenessModel;EffectivenessStateSuccess(this.effectivenessModel);
}
class EffectivenessStateError extends EventsState {
  String? error;EffectivenessStateError(this.error);
}

