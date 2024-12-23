import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gd_youth_talk/src/core/di/setup_locator.dart';
import 'package:gd_youth_talk/src/core/routes.dart';
import 'package:gd_youth_talk/src/core/utils.dart';
import 'package:gd_youth_talk/src/domain/usecases/program_usecase.dart';
import 'package:gd_youth_talk/src/presentation/detail/bloc/detail_bloc.dart';
import 'package:gd_youth_talk/src/presentation/detail/bloc/detail_event.dart';
import 'package:gd_youth_talk/src/presentation/detail/bloc/detail_state.dart';
import 'package:gd_youth_talk/src/presentation/detail/widgets/program_date.dart';
import 'package:gd_youth_talk/src/presentation/detail/widgets/program_location.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';

class DetailScreen extends StatefulWidget {
  final String docId;

  const DetailScreen({super.key, required this.docId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {

  @override
  void initState() {
    context.read<ProgramDetailBloc>().add(LoadProgramDetailEvent(widget.docId));
    super.initState();
  }

  @override
  void dispose() {
    print("상세화면 dispose");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProgramDetailBloc, ProgramDetailState>(
      builder: (context, state) {
        if (state is ProgramDetailLoading) {
          return CircularProgressIndicator();
        } else if (state is ProgramDetailError) {
          print('에러');
        } else if (state is ProgramDetailLoaded) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme
                  .of(context)
                  .scaffoldBackgroundColor,
              centerTitle: true,
              scrolledUnderElevation: 0,
              title: Text(
                '프로그램 상세보기',
                style: Theme
                    .of(context)
                    .textTheme
                    .bodyLarge,
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 13.0), // 우측 여백 조정
                  child: IconButton(
                    icon: Icon(Icons.share),
                    onPressed: () {
                      Share.share(state.program.blogUrl ?? "",
                          subject: state.program.title);
                    },
                  ),
                ),
              ],
            ),
            body: Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 20.0), // 하단 여백 추가
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// thumbnail
                    Container(
                      height: 300,
                      color: getColorFromHex(
                          state.program.primaryColor ?? '#FFFFFF'),
                      child: Center(
                          child: CachedNetworkImage(
                            imageUrl: state.program.thumbnail ?? "",
                            width: 250,
                            height: 250,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(
                                    width: 120,
                                    height: 120,
                                    color: Colors.grey[300],
                                  ),
                                ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error), // 에러 발생 시 표시
                          )),
                    ),

                    /// divider
                    const Divider(
                      height: 10,
                      thickness: 10,
                    ),

                    SizedBox(
                      height: 30,
                    ),

                    /// subtitle
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // subtitle
                          Text(
                            state.program.subtitle ?? "",
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyMedium,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1, // max line
                          ),

                          const SizedBox(
                            height: 5,
                          ),

                          // title
                          Text(
                            state.program.title ?? "",
                            style: Theme
                                .of(context)
                                .textTheme
                                .displayMedium,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2, // max
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          /// 신청 기간
                          ProgramLocationRow(
                            program: state.program,
                            icon: Icon(
                              Icons.location_on,
                              size: 20,
                              color: Theme
                                  .of(context)
                                  .primaryColor,
                            ),
                          ),

                          const SizedBox(
                            height: 10,
                          ),

                          /// 프로그램 기간
                          ProgramDateRow(
                            program: state.program,
                            icon: Icon(
                              Icons.access_time_filled,
                              size: 20,
                              color: Theme
                                  .of(context)
                                  .hintColor,
                            ),
                            title: '진행 기간(일시)',
                            isProgramDate: true,
                          ),

                          /// divider
                          const Divider(
                            height: 50,
                            thickness: 1,
                          ),

                          Text(
                            state.program.detail ?? '',
                            style:
                            Theme
                                .of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.only(left: 13, right: 13, bottom: 50),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    final blogUrl = state.program.blogUrl ?? '';
                    if (blogUrl.isNotEmpty) {

                      // 상세보기 클릭 시, Hit수 증가시키기
                      locator<ProgramUseCase>()
                          .incrementProgramHits(state.program); // 조회수 증가 (count + 1)

                      // webView 이동
                      Navigator.pushNamed(context, Routes.webView,
                          arguments: blogUrl);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('블로그 주소가 존재하지 않습니다.')),
                      );
                    }
                  },
                  label: const Text(
                    '상세보기 & 신청하기',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    backgroundColor: Theme
                        .of(context)
                        .primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}
