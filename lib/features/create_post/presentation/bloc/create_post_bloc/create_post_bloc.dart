import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:take_my_tym/core/model/app_user_model.dart';
import 'package:take_my_tym/core/utils/app_error_msg.dart';
import 'package:take_my_tym/core/utils/app_exception.dart';
import 'package:take_my_tym/core/model/app_post_model.dart';
import 'package:take_my_tym/features/create_post/domain/usecases/create_post_usecase.dart';

import '../../../domain/usecases/update_post_usecase.dart';

part 'create_post_event.dart';
part 'create_post_state.dart';

class CreatePostBloc extends Bloc<CreatePostEvent, CreatePostState> {
  CreatePostBloc() : super(CreatePostInitial()) {
    // First page data
    String? postId;
    String? uid;
    String? userName;
    bool? tymType;
    String? workType;
    String? title;
    String? content;
      Timestamp? postDate;
    // Second page data
    List<String>? skills;
    String? location;
    String? experience;
    double? remuneration;

    on<CreateFirstPageEvent>(
      (event, emit) {
        if (event.title.length <= 3) {
          final error = AppErrorMsg(
              title: 'Give proper title',
              content:
                  'Gave a proper title, Other wise its harder for other to understand it');
          emit(
            CreateFirstFailState(
              error: error,
            ),
          );
          return;
        } else if (event.content.length <= 10) {
          final error = AppErrorMsg(
              title: 'Give proper decription',
              content:
                  'Gave a proper decription, Other wise its harder for other to understand it');
          emit(
            CreateFirstFailState(error: error),
          );
          return;
        } else {
          uid = event.userModel.uid;
          userName = "${event.userModel.firstName} ${event.userModel.lastName}";
          tymType = event.tymType;
          workType = event.workType;
          title = event.title;
          content = event.content;
          emit(CreateFirstSuccessState());
        }
      },
    );

    on<CreateSecondPageEvent>(
      ((event, emit) async {
        emit(CreatPostLoadingState());
        if (event.experience.length <= 2) {
          emit(
            CreateSecondFailState(error: AppErrorMsg()),
          );
          return;
        } else {
          final error = AppErrorMsg(
              title: "Invalid Remuneration",
              content:
                  "Please enter a remuneration amount that falls within the acceptable range.");
          try {
            remuneration = double.parse(event.remuneration);
          } catch (e) {
            emit(
              CreateSecondFailState(
                error: error,
              ),
            );
            return;
          }
          if (remuneration! < 500 || remuneration! >= 100000) {
            log("on error");
            emit(
              CreateSecondFailState(
                error: error,
              ),
            );
            return;
          } else {
            log("data adding success");
            skills = event.skills;
            location = event.location;
            experience = event.experience;
          }
        }
        //Post Data
        if (uid != null &&
            userName != null &&
            tymType != null &&
            workType != null &&
            title != null &&
            content != null &&
            skills != null &&
            location != null &&
            experience != null &&
            remuneration != null) {
          CreatePostUseCase createPostUseCase =
              GetIt.instance<CreatePostUseCase>();

          if (tymType != null && tymType == true) {
            try {
              final Timestamp timestamp = Timestamp.now();
              final bool res = await createPostUseCase.buyTymPost(
                postModel: PostModel(
                  tymType: true,
                  uid: uid!,
                  workType: workType!,
                  title: title!,
                  content: content!,
                  userName: userName!,
                  postDate: timestamp,
                  skills: skills!,
                  location: location!,
                  skillLevel: experience!,
                  price: remuneration!,
                  latitude: event.latitude,
                  longitude: event.longitude,
                ),
              );
              if (res) {
                log("success buy");
                emit(CreatePostSuccessState(refreshType: true, uid: uid!));
              } else {
                emit(
                  RemoteDataAddFailState(
                    error: AppErrorMsg(),
                  ),
                );
              }
            } on AppException {
              emit(
                RemoteDataAddFailState(error: AppErrorMsg()),
              );
            } catch (e) {
              emit(
                RemoteDataAddFailState(error: AppErrorMsg()),
              );
            }
          } else if (tymType != null && tymType == false) {
            try {
              final Timestamp timestamp = Timestamp.now();
              final bool res = await createPostUseCase.sellTymPost(
                postModel: PostModel(
                  tymType: false,
                  uid: uid!,
                  workType: workType!,
                  title: title!,
                  content: content!,
                  userName: userName!,
                  postDate: timestamp,
                  location: location!,
                  skillLevel: experience!,
                  price: remuneration!,
                  skills: skills!,
                  latitude: event.latitude,
                  longitude: event.longitude,
                ),
              );
              if (res) {
                emit(CreatePostSuccessState(refreshType: false, uid: uid!));
              } else {
                emit(
                  RemoteDataAddFailState(error: AppErrorMsg()),
                );
              }
            } on AppException {
              emit(
                RemoteDataAddFailState(error: AppErrorMsg()),
              );
            } catch (e) {
              RemoteDataAddFailState(error: AppErrorMsg());
            }
          } else {
            log("something went wrong come to bloc line 163");
          }
        }
      }),
    );
  
     on<UpdateFirstPageEvent>(
      (event, emit) {
        log("update first bloc");
        emit(CreatPostLoadingState());
        title = event.title.trim();
        content = event.content.trim();
        if (title!.length <= 3) {
          final AppErrorMsg error = AppErrorMsg(
              title: 'Give proper title',
              content:
                  'Gave a proper title, Other wise its harder for other to understand it');
          emit(
            CreateFirstFailState(error: error),
          );
          return;
        } else if (content!.length <= 10) {
          final AppErrorMsg error = AppErrorMsg(
              title: 'Give proper decription',
              content:
                  'Gave a proper decription, Other wise its harder for other to understand it');
          emit(
            CreateFirstFailState(
              error: error,
            ),
          );
          return;
        } else {
          postId = event.postModel.postId!;
          uid = event.postModel.uid;
          userName = event.postModel.userName;
          postDate = event.postModel.postDate;
          tymType = event.postModel.tymType;
          workType = event.workType;
          log("update success");
          emit(CreateFirstSuccessState());
        }
      },
    );
  
    
    on<UpdateSecondPageEvent>(
      ((event, emit) async {
        log("update second bloc");
        emit(CreatPostLoadingState());
       
          try {
            remuneration = double.parse(event.remuneration);
          } catch (e) {
            log("3");
            emit(
              CreateSecondFailState(
                error: AppErrorMsg()
              ),
            );
            return;
          }
          if (remuneration! >= 1000000) {
            log("4");
            emit(CreateSecondFailState(error: AppErrorMsg()));
            return;
          } else {
            log("data adding success");
            skills = event.skills;
            location = event.location;
            experience = event.experience;
          }
        
        //Post Data
        if (postId != null &&
            uid != null &&
            userName != null &&
            tymType != null &&
            workType != null &&
            title != null &&
            content != null &&
            skills != null &&
            location != null &&
            experience != null &&
            remuneration != null) {
          UpdatePostUseCase updatePostUseCase =
              GetIt.instance<UpdatePostUseCase>();
          if (tymType != null && tymType == true) {
            try {
              await updatePostUseCase
                  .updateBuyTymPost(
                      postModel: PostModel(
                postId: postId,
                tymType: tymType!,
                uid: uid!,
                workType: workType!,
                title: title!,
                content: content!,
                userName: userName!,
                postDate: postDate!,
                location: location!,
                skillLevel: experience!,
                price: remuneration!,
                skills: skills!,
                latitude: event.latitude,
                longitude: event.longitude,
              ))
                  .then((value) {
                emit(UpdatePostSuccessState(refreshType: tymType!, uid: uid!));
              });
            } on AppException catch (e) {
              emit(
                RemoteDataAddFailState(
                  error: AppErrorMsg(),
                ),
              );
            } catch (e) {
              emit(
                RemoteDataAddFailState(
                  error: AppErrorMsg(),
                ),
              );
            }
          } else if (tymType != null && tymType == false) {
            try {
              await updatePostUseCase
                  .updateSellTymPost(
                postModel: PostModel(
                  postId: postId,
                  tymType: tymType!,
                  uid: uid!,
                  workType: workType!,
                  title: title!,
                  content: content!,
                  userName: userName!,
                  postDate: postDate!,
                  location: location!,
                  skillLevel: experience!,
                  price: remuneration!,
                  skills: skills!,
                  latitude: event.latitude,
                  longitude: event.longitude,
                ),
              )
                  .then((value) {
                emit(CreatePostSuccessState(refreshType: tymType!, uid: uid!));
              });
            } on AppException catch (e) {
              emit(CreateSecondFailState(error: AppErrorMsg()));
            } catch (e) {
              emit(
                CreateSecondFailState(
                  error: AppErrorMsg(),
                ),
              );
            }
          } else {
            log("something went wrong come to bloc line 177");
          }
        }
      }),
    );
  }
}