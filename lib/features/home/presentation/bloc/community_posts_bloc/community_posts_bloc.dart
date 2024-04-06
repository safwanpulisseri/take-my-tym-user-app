import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:take_my_tym/core/model/app_post_model.dart';
import 'package:take_my_tym/features/home/domain/usecases/get_community_posts_usecase.dart';

part 'community_posts_event.dart';
part 'community_posts_state.dart';

class CommunityPostsBloc
    extends Bloc<CommunityPostsEvent, CommunityPostsState> {
  CommunityPostsBloc() : super(CommunityPostsLoadingState()) {
    CommunityPostsUseCase communityPostsUseCase =
        GetIt.instance<CommunityPostsUseCase>();
    on<BuyTymCommunityPostsEvent>((event, emit) async {
      emit(CommunityPostsLoadingState());
      try {
        await communityPostsUseCase.buyTymPosts().then(
            (value) => emit(BuyTymCommunityPostsState(buyTymPosts: value)));
      } catch (e) {
        log(e.toString());
      }
    });
    on<SellTymCommunityPostsEvent>((event, emit) {
    });
  }
}
