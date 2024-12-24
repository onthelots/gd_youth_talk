# Youth(가제) 
> 서울시 강동구 청년센터에서 펼쳐지는 다양한 프로그램, 행사 등 유용한 정보를 앱에서 쉽고 빠르게

#### <a href="https://www.notion.so/onthelots/32eb5fa184c14426a4f32b654f76ec0e?v=96817719164f49e398abae2bc4c8565c&pvs=4"><img src="https://img.shields.io/badge/Notion-000000?style=flat&logo=Notion&logoColor=white"/></a> <a href="https://apps.apple.com/kr/app/scoop/id6466811453"><img src="https://img.shields.io/badge/AppStore-000000?style=flat&logo=AppStore&logoColor=white"/></a>


<br> 

# 목차

[1-프로젝트 소개](#1-프로젝트-소개)

- [1-1 개요](#1-1-개요)
- [1-2 주요목표](#1-2-주요목표)
- [1-3 개발환경](#1-3-개발환경)
- [1-4 구동방법](#1-4-구동방법)

[2-앱-디자인](#2-앱-디자인)
- [2-1 Screen Flow](#2-1-Screen-Flow)
- [2-2 Architecture](#2-2-Architecture)

[3-프로젝트 특징](#3-프로젝트-특징)

[4-프로젝트 세부과정](#4-프로젝트-세부과정)

[5-업데이트 및 리팩토링 사항](#5-업데이트-및-리팩토링-사항)


--- 

## 1-프로젝트 소개

### 1-1 개요

<br>

## 2-앱 디자인

### 2-1 Screen Flow
`메인(홈), 검색, 캘린더, 더보기 Tab 구성`
- 주요 프로그램 및 키워드 리스트를 통해 빠르게 정보를 전달
- 카테고리 분류를 통해 사용자들이 희망하는 프로그램을 분류하여 제공
- 타이틀, 서브타이틀을 기반으로 쿼리, 검색기능을 도입
- 월/일별 프로그램 현황을 한눈에 살펴볼 수 있도록 Table Calender를 제공
- 더보기 메뉴를 통해 관련 링크(InWeb) 및 테마설정 기능을 활용

<img width="4102" alt="app_flow" src="https://github.com/user-attachments/assets/b59cb130-1bfb-4e83-b74a-85961ff25b23" />


### 2-2 Architecture
`지속 가능한 유지보수와 기능 추가를 위한 Clean Architecture 적용`
- Application Layout, Domain Layout, Data Layout 분리
- 프로그램 데이터 파싱 이외, 추후 계정관리 기능 도입에 앞서 유지보수가 용이한 Clean Architecture 설계

`상태관리를 위한 Bloc 활용`
- Firebase Stream을 통해 할당되는 'Program' 리스트 데이터를 기반으로, UseCase 내 화면별 로직 구성
- 앱 전역에서 데이터를 공유하도록 중앙 집중화를 위해 GetIt Pakcage DI를 Main.dart 내 적용 (MultiProvider)
- 각각의 Screen, UI에 따라 Bloc을 Listen, Builder 함으로서 실시간 업데이트 사항을 즉각 반영

<img width="4183" alt="app_architecture" src="https://github.com/user-attachments/assets/064022b8-e97b-4df5-9034-7d179b0f5605" />



<br>


<br>

