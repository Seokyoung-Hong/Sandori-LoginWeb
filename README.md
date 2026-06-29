# Sandori-LoginWeb

Keycloak 인증 서버의 로그인 및 회원가입 페이지를 위해 제작된 Sandori HTML/CSS UI와 Keycloak Login Theme입니다.

## 주요 기능

- 원본 정적 시안
  - `LoginWeb.html`: 로고, 소셜 로그인, 아이디/비밀번호 입력, 회원가입/계정찾기 링크
  - `signup.html`: 회원가입 입력 폼, 약관 동의 체크박스
- Keycloak 테마
  - `keycloak-theme/sandori/login/login.ftl`: Keycloak 로그인 액션/소셜 IdP/오류 메시지와 연결된 로그인 템플릿
  - `keycloak-theme/sandori/login/register.ftl`: 같은 카드형 디자인을 재사용하는 회원가입 템플릿
  - `keycloak-theme/sandori/login/resources/css/sandori-login.css`: 로그인/회원가입 공통 디자인 토큰과 컴포넌트
  - `keycloak-theme/sandori/login/resources/img/`: Keycloak 정적 리소스로 복사된 로고/체크 이미지

## Keycloak 서버 적용

Keycloak 서버의 `themes` 디렉터리에 `sandori` 폴더를 복사합니다.

```bash
cp -R keycloak-theme/sandori /path/to/keycloak/themes/
```

컨테이너로 운영 중이면 예시는 다음과 같습니다.

```bash
docker cp keycloak-theme/sandori <keycloak-container>:/opt/keycloak/themes/sandori
```

개발 중에는 테마 캐시를 끄고 Keycloak을 실행하면 수정 반영이 빠릅니다.

```bash
/opt/keycloak/bin/kc.sh start-dev \
  --spi-theme-static-max-age=-1 \
  --spi-theme-cache-themes=false \
  --spi-theme-cache-templates=false
```

관리자 콘솔에서 다음을 설정합니다.

1. Realm Settings → Themes
2. Login theme: `sandori`
3. Save

## 소셜 로그인 매핑

`login.ftl`은 Keycloak에 등록된 Identity Provider를 자동으로 읽습니다.

- alias가 `kakao`이면 `카카오톡으로 시작하기`
- alias가 `google`이면 `Google 로 시작하기`
- alias가 `apple`이면 `Apple 로 시작하기`
- 그 외 alias는 `${표시명}로 시작하기`

따라서 Keycloak Identity Provider alias를 `kakao`, `google`, `apple`로 맞추면 현재 디자인과 버튼 색상이 그대로 적용됩니다.

## 회원가입 템플릿 메모

`register.ftl`은 Keycloak 기본 회원가입 필드(`username`, `email`, `firstName`, `lastName`, `password`, `password-confirm`)를 사용합니다.
약관 체크박스는 HTML required 검증용 필드로 두었고, Keycloak 사용자 속성으로 강제 저장하지 않습니다. 서버에 약관 동의 내역을 저장해야 하면 Realm의 User Profile 또는 Required Action 정책에 맞춰 필드명을 연결해야 합니다.

## 로컬 검증

이 저장소에는 Keycloak 런타임 없이 구조를 검증하는 가벼운 스크립트가 있습니다.

```bash
python3 scripts/validate-theme.py
```

성공 시 다음과 같이 출력됩니다.

```text
OK: Sandori Keycloak theme structure validated
theme: keycloak-theme/sandori/login
```

실제 FreeMarker 렌더링은 Keycloak 서버에서 최종 확인해야 합니다. 이 저장소의 검증 스크립트는 파일 누락, 주요 Keycloak 액션/필드 연결, CSS/이미지 참조, 단순 FTL 태그 균형을 확인합니다.
