# Challenge — iTunes Music & Podcast Search App
iTunes Search API를 활용한 음악/팟캐스트 검색 앱.
RxSwift + MVVM + DiffableDataSource + CompositionalLayout을 핵심 기술로 구성한 심화 과제 프로젝트.

---

## 프로젝트 폴더 구조 
```
challenge/
├── Protocol/
│   ├── ViewModel.swift         ← 제네릭 Input/Output 프로토콜
│   └── SectionHeader.swift     ← 섹션 헤더 프로토콜
├── Model/
│   ├── Music.swift             ← iTunes 음악 데이터 모델 (Codable, Hashable)
│   ├── Podcast.swift           ← 팟캐스트 데이터 모델
│   ├── SearchItem.swift        ← 음악/팟캐스트 union 타입 (enum)
│   ├── HomeSection.swift       ← 홈 섹션 enum (봄/여름/가을/겨울)
│   ├── SearchSection.swift     ← 검색 섹션 enum (Podcast/Music)
│   └── NetworkManager.swift    ← URLSession + RxSwift Single<T>
├── ViewModel/
│   ├── HomeViewModel.swift     ← Input(initialized) → Output(musicInfo)
│   └── SearchViewModel.swift   ← Input(searchText) → Output(searchResult, error)
└── View/
    ├── Home/
    │   ├── HomeViewController.swift
    │   └── HomeView.swift
    ├── Search/
    │   ├── SearchViewController.swift
    │   └── SearchView.swift
    └── Common/
        ├── CardCell.swift
        ├── ListCell.swift
        ├── PosterCell.swift
        └── SectionHeaderView.swift
```

---

## 주요 기능

### 홈 화면

- **계절별 4개 섹션**: 봄(spring), 여름(summer), 가을(autumn), 겨울(winter) 키워드로 iTunes API 검색
- **봄 섹션**: CardLayout — 수평 스크롤, 랜덤 배경색 카드 형태, 앨범 이미지 + 제목 + 아티스트
- **여름/가을/겨울 섹션**: ListLayout — 3개씩 그룹화, 수평 스크롤, 앨범 이미지 + 텍스트
- **섹션 헤더**: SectionHeaderView로 각 섹션의 제목/부제목 표시
- **병렬 API 호출**: 4개 섹션을 동시에 요청하여 성능 최적화
- **에러 처리**: 네트워크 오류 시 UIAlertController로 사용자에게 알림

### 검색 화면

- **UISearchController**: HomeViewController 네비게이션 바에 SearchController 탑재
- **실시간 검색**: 입력 즉시 iTunes에서 음악 + 팟캐스트 동시 검색
- **디바운싱 300ms**: 입력 중 불필요한 API 요청 방지
- **중복 요청 방지**: `distinctUntilChanged`로 동일 검색어 재요청 차단
- **팟캐스트 섹션**: PosterLayout — 큰 포스터 형태, 제목/아티스트 하단 오버레이
- **음악 섹션**: ListLayout — 앨범 이미지 + 제목/아티스트 리스트 형태
- **결과 없음 처리**: 검색 결과가 0건일 때 emptyLabel 표시

---

## 핵심 기능

- **1.Input/Output 패턴**
  - ViewController → ViewModel: **Input** (사용자 액션, 이벤트)
  - ViewModel → ViewController: **Output** (가공된 데이터)
  - View와 ViewModel의 경계를 명확히 정의
  - `transform()` 메서드 하나로 모든 데이터 변환 처리

- **2. RxSwift**
  - **Observable.zip**: 4개 Observable이 모두 완료될 떄까지 대기 후 합쳐서 반환
  - **debounce**: 마지막 이벤트 입력 후 시간 경과 이후에 반환
  - **Single<T>**: 1회성 성공/실패 Observable
  - **PublishSubject<NetworkError>**: 에러 이벤트 분리
  - **observe(on:)**: UI업데이트 메인 스레드 실행
  - **disposed()**: 구독 생명주기 자동 관리

- **3. DiffableDataSource**

- **4. CollectionViewCompositionalLayout**
  - `NSCollectionLayoutItem` → `NSCollectionLayoutGroup` → `NSCollectionLayoutSection` 계층 구조
  - 각 섹션이 완전히 다른 레이아웃을 가질 수 있음
  - `orthogonalScrollingBehavior`로 섹션 내 수평 스크롤 구현

---

## 기술 스택
| 기술                  | 용도                      |
| ------------------- | ----------------------- |
| UIKit               | UI 프레임워크                |
| SnapKit             | 코드 기반 Auto Layout       |
| RxSwift             | 반응형 프로그래밍, 비동기 처리       |
| Kingfisher          | 이미지 비동기 로드 및 캐싱         |
| URLSession          | 네트워킹                    |
| DiffableDataSource  | CollectionView 데이터 관리   |
| CompositionalLayout | 복잡한 CollectionView 레이아웃 |
| iTunes Search API   | 음악/팟캐스트 데이터             |
