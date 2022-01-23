## 🛠 개발 목표 (공부 목표)
- kakao blog api 를 활용하여, rxswift와 mvvm 패턴 알아가보기

## 🛠 사용한 API
- [KAKAO 다음 블로그 검색 API](https://developers.kakao.com/docs/latest/ko/daum-search/dev-guide#search-blog)

## 🛠 Dependency Management
- Swift Package Manager
    - 애플의 공식지원

## 🛠 기술스택
- RxSwift (6.2.0)
- RxCocoa (6.2.0)
- Snapkit (5.0.1)
    - autolayout 을 코드로 구현하는데 사용
- Kingfisher (7.1.2)
    - 이미지 로드 할때 사용

## 🛠 디자인패턴
- MVVM

## 🤔 회고
- rx를 사용하니, 데이터가 갱신되었을때 UI 이벤트 처리가 간결하다

## ☄ 이슈와 해결
- [x] json 값을 받아왔을 때, html 태그가 같이 받아와져서, 불필요하게 태그도 같이 표현되는 이슈
  - 해결 : string extension 을 통해, html 태그를 제거해줌
