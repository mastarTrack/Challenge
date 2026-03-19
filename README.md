# Challenge

Apple Music 스타일의 인터페이스를 참고하여  
음악과 팟캐스트를 탐색할 수 있도록 구현한 iOS 앱입니다.

iTunes Search API를 활용해 데이터를 불러오고,  
RxSwift 기반의 MVVM 구조로 메인 화면과 검색 결과 화면을 구성했습니다.


---

## 프로젝트 소개

이 프로젝트는 Apple Music 형태의 탐색 경험을 iOS 앱으로 구현하는 것을 목표로 했습니다.

메인 화면에서는 계절 키워드(봄, 여름, 가을, 겨울)를 기준으로 음악 데이터를 구분해 보여주고,  
검색 화면에서는 사용자의 입력값에 따라 음악과 팟캐스트 결과를 함께 제공합니다.

단순히 데이터를 보여주는 것에 그치지 않고,  
각 섹션에 맞는 레이아웃과 셀 타입을 분리하여 화면 구조를 설계했습니다.

---

## 개발 목표

- UIKit 기반 화면 설계 연습
- MVVM 패턴과 RxSwift Input / Output 구조 적용
- CollectionView Compositional Layout 활용
- DiffableDataSource를 이용한 동적 UI 업데이트
- 외부 API 연동 및 비동기 데이터 처리 경험

---

## 사용 기술

- **MVVM**
- **UIKit**
- **RxSwift**
- **RxCocoa**
- **SnapKit**
- **Then**
- **Kingfisher**

---

## 주요 기능

### 1. 메인 화면 구성
- Apple Music 스타일의 메인 화면 구현
- 봄 / 여름 / 가을 / 겨울 키워드 기준으로 음악 데이터를 분류
- 섹션별 헤더 제공
- 카드형 셀과 리스트형 셀을 혼합해 레이아웃 구성

### 2. 검색 기능
- UISearchController 기반 검색 인터페이스 구현
- 검색어 입력 시 검색 결과 화면으로 실시간 반영
- 음악과 팟캐스트 데이터를 동시에 조회
- 결과를 섹션별로 분리하여 표시

### 3. 반응형 데이터 바인딩
- ViewController → ViewModel로 Input 전달
- ViewModel → ViewController로 Output 방출
- RxSwift를 활용한 비동기 데이터 흐름 처리

---

## 화면 구성

### 메인 화면
- 계절 키워드별 음악 추천 섹션
- CardCell / ListCell 혼합 구성
- DiffableDataSource 기반 스냅샷 적용

### 검색 결과 화면
- Music 섹션
- Podcast 섹션
- 검색 결과에 따라 동적으로 섹션 구성

---

## 내가 구현한 내용

- MVVM 구조 설계
- RxSwift Input / Output 패턴 적용
- 메인 화면 UI 설계 및 구현
- CardCell / ListCell / SearchCardCell 구현
- SectionHeaderView 구현
- APIService 생성
- Music / Podcast 모델 설계
- 검색 결과 화면 설계 및 구현
- 음악 / 팟캐스트 통합 검색 로직 구현

---

## 구현 포인트

### 1. 계절별 데이터를 하나의 화면에 구성
메인 화면에서는 계절 키워드를 기준으로 각각 API를 호출한 뒤,  
응답 결과를 하나의 딕셔너리 형태로 누적하여 섹션별 데이터로 관리했습니다.

이를 통해 동일한 구조의 비동기 작업을 반복하면서도  
화면에서는 일관된 형태로 데이터를 렌더링할 수 있었습니다.

### 2. DiffableDataSource를 활용한 UI 갱신
CollectionView 데이터 갱신 시 reload 방식 대신 snapshot 기반으로 처리하여  
섹션 및 아이템 변경을 더 안전하게 반영했습니다.

### 3. 검색 결과의 다중 데이터 처리
검색 기능에서는 음악과 팟캐스트를 각각 조회한 뒤  
두 결과를 하나의 스트림으로 합쳐서 화면에 표시했습니다.

이 과정을 통해 서로 다른 타입의 데이터를  
하나의 검색 흐름 안에서 함께 보여주는 구조를 구현할 수 있었습니다.

---

## 폴더 구조

```bash
Challenge
├── Model
│   ├── MusicModel.swift
│   └── PodcastModel.swift
├── Service
│   └── APIService.swift
├── View
│   ├── View
│   │   ├── CardCell.swift
│   │   ├── ListCell.swift
│   │   ├── SearchCardCell.swift
│   │   └── SectionHeaderView.swift
│   └── ViewController
│       ├── MainViewController.swift
│       └── SearchResultViewController.swift
└── ViewModel
    ├── MainViewModel.swift
    └── SearchResultViewModel.swift
```

--- 

# 트러블 슈팅 
## RxSwift transform 구조 이해
초기에는 ViewModel의 transform 내부에서 입력을 어떻게 처리하고 어떤 Output을 반환해야 하는지 흐름을 잡는 것이 어려웠습니다.
하지만 Input은 “이벤트의 시작점”, Output은 “화면이 구독할 결과 스트림”이라는 관점으로 정리한 뒤 각 화면의 데이터 흐름을 더 명확하게 설계할 수 있었습니다.

## 여러 API 결과를 하나의 화면 상태로 합치기
계절별 음악 데이터나 검색 시 음악/팟캐스트 데이터를 각각 불러온 뒤 이를 어떤 형태로 묶어 화면에 전달할지 고민했습니다.
이 과정에서 merge, scan, combineLatest 같은 연산자를 활용해 여러 비동기 결과를 하나의 상태로 정리하는 방법을 익힐 수 있었습니다.\

---

# 추가 개선 사항
- 상세 화면 설계 및 구현
- 음악 듣기 기능 추가
- 로딩 / 빈 결과 / 에러 상태 UI 추가
- 테스트 가능한 ViewModel 구조로 개선

---

# 스크린샷

|메인화면|검색화면|
|:-:|:-:|
|<img width="300" height="906" alt="스크린샷 2026-03-19 오전 9 53 03" src="https://github.com/user-attachments/assets/93d55703-f0c8-4a36-9a4e-d11154fd6200" />|<img width="300" height="908" alt="스크린샷 2026-03-19 오전 9 51 48" src="https://github.com/user-attachments/assets/74f9299c-c4f3-4ddf-a265-5191042ab2b5" />|

---
