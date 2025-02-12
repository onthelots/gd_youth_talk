# 강동청년톡톡 & 관리자용
> 청년의 가능성을 [잇다]
- 서울청년센터 강동에서 진행하는 다양한 프로그램과 행사를 한눈에 확인하고 쉽게 참여할 수 있도록 돕는 플랫폼입니다.

#### <a href="https://momentous-wallet-0f7.notion.site/1681c3f0e003806c9b50dde42728413a"><img src="https://img.shields.io/badge/Notion-000000?style=flat&logo=Notion&logoColor=white"/></a> <a href="https://apps.apple.com/kr/app/%EA%B0%95%EB%8F%99%EC%B2%AD%EB%85%84%ED%86%A1%ED%86%A1/id6739631810"><img src="https://img.shields.io/badge/AppStore-000000?style=flat&logo=AppStore&logoColor=white"/></a>


<br>

![screenshot_all](https://github.com/user-attachments/assets/b380881c-617a-4d6f-a856-fa011ddf10da)

<br> 

# 목차

[1-프로젝트 소개](#1-프로젝트-소개)

- [1-1 개요](#1-1-개요)
- [1-2 개발환경](#1-2-개발환경)

[2-앱-디자인](#2-앱-디자인)
- [2-1 Screen Flow](#2-1-Screen-Flow)
- [2-2 Architecture](#2-2-Architecture)

[3-프로젝트 특징](#3-프로젝트-특징)

[4-프로젝트 세부과정](#4-프로젝트-세부과정)

[5-업데이트 및 리팩토링 사항](#5-업데이트-및-리팩토링-사항)


--- 

## 1-프로젝트 소개

### 1-1 개요
`청년들에게 필요한 정책 & 프로그램을 한눈에`
- **개발기간** : 2024.12.01 ~ 2024.12.31 (약 4주)
- **참여인원** : 1인 (개인 프로젝트)
- **주요내용**

  - 서울청년센터 강동에서 진행되는프로그램에 대한 자세한 정보를 제공받고, 캘린더를 통해 일정을 확인
  - 블로그, 인스타그램 등 센터에서 운영하는 주요 사이트와 장소대관, Q&A 등을 손쉽게 이용
  - 실제 센터 내 근무하는 관리자의 원활한 프로그램 등록&관리를 위해 별도의 '관리자 앱' 개발

<br>

### 1-2 개발환경
- **활용기술 외 키워드**
  - Flutter

    - 사용자 (iOS, Android)
    - 관리자 (Web)
   
  - 상태관리 : BloC, Provider
  - DI : get_it 
  - Server : Firebase (Storage, FireStore, Authentication, Hosting)
  - Network : dio
  - DB : Shared Preferences, flutter_secure_storage

- **주요 라이브러리**
   - flutter_bloc
   - get_it
   - flutter_inappwebview
   - dio, cached_network_image
   - table_calendar, palette_generator 

<br>

## 2-앱 디자인

### 2-1 Screen Flow
`메인(홈), 검색, 캘린더, 더보기 Tab 구성`
- 주요 프로그램 및 키워드 리스트를 통해 빠르게 정보를 전달
- 카테고리 분류를 통해 사용자들이 희망하는 프로그램을 분류하여 제공
- 타이틀, 서브타이틀을 기반으로 쿼리, 검색기능을 도입
- 월/일별 프로그램 현황을 한눈에 살펴볼 수 있도록 Table Calender를 제공
- 더보기 메뉴를 통해 관련 링크(InWeb) 및 테마설정 기능을 활용

<img width="4102" alt="app_flow" src="https://github.com/user-attachments/assets/b59cb130-1bfb-4e83-b74a-85961ff25b23" />

<br>

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

## 3-프로젝트 특징
### 3-1 센터 내 주요 프로그램을 시각화, 검색기능 추가 (Home, Search)
- 섹션별로 '최근등록', '좋아요 수', '마감임박' 조건에 따라 Home Screen을 구성
- Timer를 통해 상단의 섹션의 경우, 해당하는 프로그램 갯수만큼 PageView를 트리거
- 제목, 부 제목을 기반으로 쿼리검색을 통해 해당하는 프로그램으로의 접근

<table>
  <tr>
    <td align="center"><img src="https://github.com/user-attachments/assets/5c6bb6c4-5bd5-4a1f-9f76-c19bd2851f4b" width="250" height="541"/></td>
    <td align="center"><img src="https://github.com/user-attachments/assets/7de70315-21fa-4fc5-bde3-c0f7b6b81b4a" width="250" height="541"/></td>
    <td align="center"><img src="https://github.com/user-attachments/assets/039d415a-0d7a-44bf-92a8-a380d1926a11" width="250" height="541"/></td>
  </tr>
  <tr>
    <td align="center">home(light mode)</td>
    <td align="center">Home(dark mode)</td>
    <td align="center">search</td>
  </tr>
</table>

<br>

### 3-2 캘린더, 카테고리를 통해 쉽고 직관적으로 확인 (Calendar, Category)
- 캘린더 기능을 통해 월별, 날짜별 프로그램을 분리하여 프로그램 일정파악에 용이
- 총 4개의 프로그램 분류(카테고리)를 통해 사용자가 희망하는 프로그램 리스트를 한눈에 파악

<table>
  <tr>
    <td align="center"><img src="https://github.com/user-attachments/assets/356c2590-056e-4be5-aa6f-e4e839565fd2" width="250" height="541"/></td>
    <td align="center"><img src="https://github.com/user-attachments/assets/8e7bd66e-9b2d-4461-af57-799067bfb142" width="250" height="541"/></td>
  </tr>
  <tr>
    <td align="center">Calender</td>
    <td align="center">Category</td>
  </tr>
</table>

<br>

### 3-3 프로그램 별 상세보기 페이지 구성, Web 이동을 통해 더욱 자세한 내용을 파악
- 프로그램 정보를 기반으로 이미지, 주소, 일시 외 상세 내용을 확인 (+ 공유기능)
- In Web Link를 할당함으로서 센터에서 제공하는 Blog 페이지로 이동
- 내 정보관리 및 옵션 페이지 제공 (대관신청, 문의, 테마설정 외)

<table>
  <tr>
    <td align="center"><img src="https://github.com/user-attachments/assets/d19b1746-3e5c-4097-9ea0-63bf9adddf52" width="250" height="541"/></td>
    <td align="center"><img src="https://github.com/user-attachments/assets/ae6a6c79-dbb4-4f83-a3c3-ba1f3600b98a" width="250" height="541"/></td>
    <td align="center"><img src="https://github.com/user-attachments/assets/d6c87392-746d-4ba3-8cf7-f16de4b5bfda" width="250" height="541"/></td>
  </tr>
  <tr>
    <td align="center">Detail</td>
    <td align="center">WebView</td>
    <td align="center">More</td>
  </tr>
</table>

<br>

### 3-4 회원 등록 후, 관리자 앱/웹과 연동한 출석시스템 구축
- 유저 고유 doc.id를 기반으로 한 QR 화면 생성
- 관리자 앱 내, QR Scanner를 통해 해당 유저의 방문횟수를 증가시킴으로서 출석관리 실시

<table>
  <tr>
    <td align="center"><img src="https://github.com/user-attachments/assets/ad924689-77c1-4524-ad73-623c60edadd4" width="250" height="541"/></td>
    <td align="center"><img src="https://github.com/user-attachments/assets/77aeb7ee-2446-4659-9cc7-656d798f96dd" width="250" height="541"/></td>
  </tr>
  <tr>
    <td align="center">QRCode</td>
    <td align="center">Count System</td>
  </tr>
</table>

<br>

## 4-프로젝트 세부과정
### 4-1 Design, App Flow 구현 
[앱 화면 디자인(Figma)](https://www.figma.com/design/l1U0pjVDfbtZbdOPwT5TSH/%EA%B0%95%EB%8F%99%EC%B2%AD%EB%85%84%ED%86%A1%ED%86%A1_design?node-id=0-1&t=Udn6lQ1TeRTw3xgO-1)

> 핵심 기능 구상 및 디자인 실시
- 실제 코드 작업을 통해 앱을 구현하기에 앞서, App Flow를 기반으로 Prototype 형태의 디자인을 선행
- 반드시 할당되어야 하는 메인 화면을 우선 작업한 후, 개발-디자인 작업을 병행하여 실시
- 라이트, 다크모드(메인 색상, 백그라운드 외)에 대비하여 색상 팔레트를 구성

![Section 1](https://github.com/user-attachments/assets/0e6fa493-c16b-42a2-82f8-83f3df248224)

<br>

### 4-2 관리자 앱 개발 + Firebase 프로젝트 생성&적용
> 개발과정의 시행착오를 줄이기 위한 관리자 앱 개발 및 배포 선행
- 앱 디자인 과정에서 나타나는 화면과의 이질감을 줄이기 위해, 더미데이터가 아닌 실제 데이터 모델을 필요로 함
- 따라서, '서울청년센터 강동'에서 실제 진행 중인 프로그램에 대한 정보를 담당자(매니저)를 통해 추가, 수정할 수 있도록 함

> Firebase Hosting을 통한 관리자 앱 배포 (용도상 최대한 UI 간소화)
- 단순히 '관리'의 용도이므로, UI나 디자인 비중을 줄이고 빠른 개발을 진행
- 담당자와의 연계를 통해 테스트 실시 + 프로그램 데이터 할당
- Hosting을 통해 Web 배포 완료

> 공지사항, 프로그램, 유저관리 + QR 출석기능 구현
- 센터 내 주요 소식을 빠르게 전달하기 위한 [공지사항] 생성기능 추가
- 현장 내 방문하는 가입 유저 관리를 위하여 [QR Scanner] 기능 도입

![Frame 5052](https://github.com/user-attachments/assets/0085d567-deb7-4746-b266-40569ff16a1a)

<br>

### 4-3 기 설계한 아키텍쳐를 기반으로 앱 개발 실시
> 클린 아키텍쳐 구현을 위하여 3가지 Layer Mock-up
- Data Layer : 관리자 앱에서 저장된 Datasouce를 Stream 형식으로 구독한 후, Model, interface(repository)를 설계
- Domain Layer : 각각의 UI 화면에서 활용할 수 있는 로직을 Usecase 내 구현 (일괄된 프로그램에 대한 정보이므로, Entities는 생략)
- Presentation Layer : Locator(DI) 생성 및 Bloc 주입을 위한 각각의 Screen 파일 생성
- Core : 앱 테마 외 Constants, Routes 작업 실시

<br>

> Bloc를 통한 상태관리 구축
- '프로그램'이라는 하나의 DataSource를 다루는 동시에 앱 전역에서 사용하기 때문에 Main.dart 내 Bloc 주입을 설정
- 각각의 화면(Screen) UI 작업과 동시에, Bloc(event, state) 파일을 생성 (Usecase 활용)
- 화면에 따라 필요한 부분에서 Builder, Consumer(Listener)를 선택하여 적용

<br>

## 5-업데이트 및 리팩토링 사항
### 5-1 우선 순위별 개선항목
1) Issue
- [ ] empty

2) Develop
- [x] Table_calender UI 개선
- [x] 로그인, 회원가입 등 유저관리 로직, UI 추가 (진행중)
- [ ] Bottom NavigationBar UI 개선
- [ ] Placeholder package 선택 후 적용 (ex. shimmer)

<br>
