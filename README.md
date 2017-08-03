# 장보지마 우리가 해줄게

우아한테크캠프 3조 (팀 오삼굉땡)의 프로젝트인 **장보지마 우리가 해줄게** 리포지토리입니다.

기존의 온라인 장보기와는 다르게 재료로 장을 보지 않고 레시피로 장을 볼 수 있도록 도와줍니다. 현재는 레시피 공유 사이트인 [만개의 레시피](http://www.10000recipe.com/)의 URL을 입력하면 레시피 정보로 바로 주문할 수 있어요!

 

## Branch

그라운드룰과 코딩 컨벤션 등의 개발 문서들을 정리해둔 **master** branch이 있으며, 개발 타겟 플랫폼인 **web**, **ios**, **backend** branch로 각각 나누어 관리합니다.

* Web : https://github.com/woowahan-techcamp/3team_osgd/tree/web
* iOS : https://github.com/woowahan-techcamp/3team_osgd/tree/ios
* Backend : https://github.com/woowahan-techcamp/3team_osgd/tree/backend


 

## Documents

* [Service Proposal](https://slack-files.com/T6F62L0DP-F6GST664B-6f92e7275d)
* [Backlog](https://docs.google.com/spreadsheets/d/1dyxzR9sf1DLQt7YwmyywFFr-AN6VCsFfpu50yRHVUy0/edit#gid=0)
* [Database Model](https://slack-files.com/T6F62L0DP-F6H30CHAR-98efbbbacd)

 


## Ground rule

### Communication

프로젝트 진행 중 **커뮤니케이션**이나 **회의**는 **슬랙의 osgd 채널**을 통해 진행하고, **GitHub**의 **Issue**와 **Project** (Kanban Board)를 이용해 프로젝트를 관리합니다.

 

### Rules

프로젝트 진행 중 지켜야 할 규율입니다!

- 맡은 일이 버거우면 미리미리 말하기
- 잠은 6시간 이상 꼭 자기
- 팀원이 힘들어 하면 강제로 휴식하게 만들기
- 최대한 35시간 내에 해결하기


 


### 팀장

팀장은 팀원이 한주씩 돌아가면서 맡습니다.

* 순서 : 박진수(#1) -> 김수완(#2) -> 황예린(#3) -> 서동욱(#4)

#### 팀장의 역할

팀장은 **굳은 일을 맡으며**, **팀원의 건강을 챙기고**, **최종 결정 권한**을 갖습니다. 또 **즐거운 팀 분위기**를 만들기 위해 **야근을 지양**하고 **팀워크를 복돋는데** 힘쓰고 중재하는 역할을 맡습니다

 

### Meeting

회의록 작성은 **osgd 슬랙**의 **회의**채널에 작성합니다

#### 모닝 스크럼

9시에 출근하면 짧게 20분동안 회의를 합니다

#### 티 타임 미팅

- 오후 4시에서 5시 사이에 진행하는 회의입니다
- 12시 전에 주제를 정해 짧게 진행합니다
- 주제가 정해지지 않았따면 회의를 하지 않습니다
- 커피나 차 등 반드시 마실것을 가져올 것



#### 저녁 회고

하루동안 한 일을 리뷰하고 기술적/시간적으로 어려웠던 점들을 돌아보는 시간입니다. 깃허브 이슈와 프로젝트(칸반 보드)를 통해 테스크를 정리합니다.

- 월~목
  - 오후 5시 30분부터 ~
  - 프로젝트의 진행 상황 보고와 함께 어려웠던 점에 대해 이야기를 나눕니다.
- 금요일
  - 오후 5시부터 ~
  - 데모에 대한 피드백을 나누고 다음주에 할 일을 정합니다



#### 한 주 계획 세우기

- 월요일 1시 ~ 1시 20분 사이 진행
  - 이번 한 주에 할 계획이나 테스크를 정하는 시간을 갖습니다



#### To-do List 정하기

할 일과 테스크는 **GitHub**의 **Issue**에 적고, 진행 상황을 팀원 누구나가 쉽게 알 수 있도록 **Project**의 **칸반 보드**에 올립니다

#### 팀원간 결정에 어려움이 있다면

다수결을 원칙으로 정하되, 상황에 따라 팀장이 최종 결정을 하도록 합니다



## Coding Convention

### 공통

* *객체지향의 사실과 오해* 서적 참고하기 

### Web

* HTML/CSS Markup — *레진 마크업 가이드* 참고
  * https://github.com/lezhin/markup-guide
* Javascript — *Airbnb 스타일 가이드* 참고
  * https://github.com/airbnb/javascript

### iOS
* Swift — *LinkedIn 스타일 가이드* 참고

  * https://github.com/linkedin/swift-style-guide
  * 새로운 객체를 만들기보단 extension을 적극적으로 활용
  * 강제 형변환 제로, 객체는 기능별로, 점진적으로 구분하기
* 개발은 TDD로 진행


 
