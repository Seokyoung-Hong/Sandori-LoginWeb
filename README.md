# Sandori-LoginWeb

Keycloak 인증 서버의 로그인 및 회원가입 페이지를 위해 제작된 Sandori HTML/CSS UI와 Keycloak Login Theme입니다.

## 주요 기능

- 원본 정적 시안
  - `LoginWeb.html`: 로고, 소셜 로그인, 아이디/비밀번호 입력, 회원가입/계정찾기 링크
  - `signup.html`: 회원가입 입력 폼, 약관 동의 체크박스
- Keycloak Login Theme
  - 1차 인증 플로우: `login.ftl`, `register.ftl`, `login-reset-password.ftl`, `login-update-password.ftl`, `login-verify-email.ftl`
  - 2차 안내/오류 플로우: `error.ftl`, `info.ftl`, `login-page-expired.ftl`
  - `register.ftl`: 실제 Sandori Realm 회원가입 폼에서 확인한 필드 구조 반영
    - 필수: 아이디(`username`), 비밀번호(`password`), 비밀번호 확인(`password-confirm`), 이메일(`email`), 성명(`fullname`), 약관 동의(`termsAccepted`)
    - 선택: 닉네임(`nickname`), 생년월일(`birthdate`), 성별(`gender`: `남성`/`여성`)
  - `keycloak-theme/sandori/login/resources/css/sandori-login.css`: 로그인/회원가입/비밀번호/이메일 인증/오류 공통 디자인 토큰과 컴포넌트
  - `keycloak-theme/sandori/login/resources/img/`: Keycloak 정적 리소스로 복사된 로고/체크 이미지
- Keycloak Email Theme
  - 4차 이메일 플로우: `email-verification.ftl`, `password-reset.ftl`, `executeActions.ftl`의 HTML/Text 템플릿

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

이메일 템플릿까지 Sandori 디자인으로 맞추려면 같은 화면에서 Email theme도 `sandori`로 설정합니다.

1. Realm Settings → Themes
2. Email theme: `sandori`
3. Save

## 소셜 로그인 매핑

`login.ftl`은 Keycloak에 등록된 Identity Provider를 자동으로 읽습니다.

- alias가 `kakao`이면 `카카오톡으로 시작하기`
- alias가 `google`이면 `Google 로 시작하기`
- alias가 `apple`이면 `Apple 로 시작하기`
- 그 외 alias는 `${표시명}로 시작하기`

따라서 Keycloak Identity Provider alias를 `kakao`, `google`, `apple`로 맞추면 현재 디자인과 버튼 색상이 그대로 적용됩니다.

## 회원가입 템플릿 메모

`register.ftl`은 실제 Sandori Realm 회원가입 페이지에서 확인한 필드명을 따릅니다.
필수 필드는 `username`, `password`, `password-confirm`, `email`, `fullname`, `termsAccepted`이고, 선택 필드는 `nickname`, `birthdate`, `gender`입니다.
`termsAccepted`는 현재 Realm의 약관 동의 필드명과 맞췄습니다. 약관 본문은 실제 페이지의 서비스 이용약관/개인정보 처리방침 링크와 필수·선택 수집 항목 안내를 반영했습니다.

## 로컬 검증

이 저장소에는 Keycloak 런타임 없이 구조를 검증하는 가벼운 스크립트가 있습니다.

```bash
python3 scripts/validate-theme.py
```

성공 시 다음과 같이 출력됩니다.

```text
OK: Sandori Keycloak theme structure validated
login theme: keycloak-theme/sandori/login
email theme: keycloak-theme/sandori/email
```

실제 FreeMarker 렌더링은 Keycloak 서버에서 최종 확인해야 합니다. 이 저장소의 검증 스크립트는 파일 누락, 주요 Keycloak 액션/필드 연결, CSS/이미지 참조, 단순 FTL 태그 균형을 확인합니다.

## 로컬 Keycloak 테스트 환경

실제 Keycloak에서 `sandori` 테마를 바로 확인하려면 테스트용 compose 환경을 사용할 수 있습니다.

```bash
docker compose up
```

포함 내용:

- `keycloak-theme/sandori` live mount
- `sandori` realm 자동 import
- Login theme / Email theme 자동 설정
- 회원가입 활성화
- Mailpit(`http://localhost:8025`) 메일 캡처

### 로컬 접속 정보

- Admin Console: `http://localhost:8080/admin`
- Admin ID: `admin`
- Admin Password: `admin`
- Mailpit: `http://localhost:8025`

테마가 적용된 로그인/회원가입 화면은 아래 URL에서 바로 확인할 수 있습니다.

- 로그인: `http://localhost:8080/realms/Sandori/protocol/openid-connect/auth?client_id=auth-relay&redirect_uri=http%3A%2F%2Flocalhost%3A8080%2Frealms%2FSandori%2Faccount%2F&response_type=code&scope=openid`
- 회원가입: `http://localhost:8080/realms/Sandori/protocol/openid-connect/registrations?client_id=auth-relay&redirect_uri=http%3A%2F%2Flocalhost%3A8080%2Frealms%2FSandori%2Faccount%2F&response_type=code&scope=openid`
- 로그인 후 사용자 정보 페이지: `http://localhost:8080/realms/Sandori/account`

같은 네트워크의 다른 기기에서 PC의 로컬 IP로 접속할 때는 `localhost` 대신 PC의 IPv4 주소를 사용합니다. 예를 들어 PC IP가 `192.168.0.10`이면 다음 형식입니다.

- Admin Console: `http://192.168.0.10:8080/admin`
- Mailpit: `http://192.168.0.10:8025`
- 로그인: `http://192.168.0.10:8080/realms/Sandori/protocol/openid-connect/auth?client_id=sandol-meal-service&redirect_uri=http%3A%2F%2F192.168.0.10%3A8080%2Frealms%2FSandori%2Faccount&response_type=code&scope=openid`
- 회원가입: `http://192.168.0.10:8080/realms/Sandori/protocol/openid-connect/registrations?client_id=sandol-meal-service&redirect_uri=http%3A%2F%2F192.168.0.10%3A8080%2Frealms%2FSandori%2Faccount&response_type=code&scope=openid`

로컬 IP로 테스트할 때 `auth-relay` 클라이언트의 redirect URI가 맞지 않으면, import JSON에서 wildcard redirect를 허용하는 `sandol-meal-service` 클라이언트로 확인하면 됩니다.

상세 사용법과 실제 열어볼 URL은 `docs/local-keycloak.md`를 참고하세요.

로컬 환경 정의가 제대로 들어갔는지 확인하려면 다음도 실행할 수 있습니다.

```bash
python3 scripts/validate-local-keycloak.py
```
