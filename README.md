# 메모장 만들기 과제

## 1 과제 의도

- Objective-C 언어 학습
- 다양한 framework 사용
- 2월 3일 ~ 2월 6일 교육 내용 활용
  - 코코아 터치 프레임워크 이해
  - UIKit 및 tableViewController, NavigationController
  - 스토리보드 사용
  - 애플 인증서, 프로비저닝

---



## 2 개발 기술 스펙



- 로그인
- 메모
- 프로필
- 

- AuthenticationServices framework - Sing In with Apple 기능을 이용한 로그인
- UITabBarController를 활용한 화면구성
- WKWebView 사용
- UITableViewController를 활용한 메모 리스트 구현
  - cell swipe 기능 구현 / 삭제, notification
  - UserNotification 사용
- 메모 CRUD 기능 구현
  - Core Data 사용
  - Activity view를 활용한 공유
  - airBnb Lottie sdk 사용
  - cocoa pod을 활용한 의존성관리
- 프로필 화면
  - 로그아웃 기능
  - imagePickerController 사용

---



## 3 시연

- 영상 대체

---



##  4 세부사항

### Sign in with apple 로그인 / 로그아웃

- keychain 활용 - 진행중



### UserNotification

- permission의 위치
  - 앱을 처음 사용할 때 알림
  - 알림이 어떤 기능을 사용할 때 필요한지 알리기 쉽게 적절한 위치에 퍼미션을 요청
  - ![image-20200225110255553](/Users/theodore/Library/Application Support/typora-user-images/image-20200225110255553.png)
  - 가이드에 맞춰 앱 실행 초반에 퍼미선 요청을 swipe로 사용하여 처음 notification을 보낼때 퍼미션을 요청하도록 변경
- 여백



### CocoaPod 설정 및 Lottie sdk

- CocoaPod을 활용하여 의존성 관리

  - ![image-20200225110445345](/Users/theodore/Library/Application Support/typora-user-images/image-20200225110445345.png)
  - Lottie 가이드 문서에서는 podfile에 `pod 'lottie-ios'` 를 작성하고 `pod install`을 실행 하라고 가이드
  - 가이드 처럼 작성하게 되면 최신의 마스터를 가져오는 문제가 있음
  - 3.0 버전부터는 swift로 대체 되었기 때문에 objectiv-c를 지원하는 2.x의 브랜치 필요
  - 위와 같이 podlist를 작성해 주어 objectiv-c에서 활용할 수 있도록 수정

  

### 사진저장기능

- 여백
  - 

---



## 5 회고

> 여백



