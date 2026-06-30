# Local Keycloak theme verification

이 문서는 `keycloak/import/Sandori-realm.json`으로 실제 Sandori realm을 import하고, 이 저장소의 `keycloak-theme/sandori` 로그인/이메일 테마를 로컬 Keycloak에 mount해서 확인하는 방법을 정리합니다.

## What this environment gives you

- `Sandori` realm import
- `sandori` 로그인 테마 live mount
- `sandori` 이메일 테마 적용
- 실제 export 기준 client/role/user 설정 복원
- Mailpit으로 로컬 SMTP 수신 확인

## Start

```bash
docker compose up
```

처음 뜨는 데 10~30초 정도 걸릴 수 있습니다.

## Admin access

- Admin Console: `http://localhost:8080/admin`
- admin username: `admin`
- admin password: `admin`

## Imported realm

- Realm: `Sandori`
- Import file: `keycloak/import/Sandori-realm.json`
- Included clients include `auth-relay`, `sandol-meal-service`, `sandol-kakao-bot`, `account`, and `account-console`.

현재 import JSON의 주요 인증 설정:

- 회원가입: enabled
- 로그인 상태 유지: enabled
- 이메일 인증: disabled
- 비밀번호 재설정: enabled
- 지원 언어: `ko`, `en`

## Theme-applied page URLs

### Account personal info callback target

로그인 후 사용자 정보 페이지로 보내려면 redirect target으로 Account Console의 personal info 페이지를 사용합니다.

`http://localhost:8080/realms/Sandori/account`

### Login with auth-relay client

`http://localhost:8080/realms/Sandori/protocol/openid-connect/auth?client_id=auth-relay&redirect_uri=http%3A%2F%2Flocalhost%3A8080%2Frealms%2FSandori%2Faccount%2F&response_type=code&scope=openid`

이 페이지에서 `login.ftl`이 적용됩니다.

### Login with sandol-meal-service client

`http://localhost:8080/realms/Sandori/protocol/openid-connect/auth?client_id=sandol-meal-service&redirect_uri=http%3A%2F%2Flocalhost%3A8080%2Frealms%2FSandori%2Faccount&response_type=code&scope=openid`

`sandol-meal-service`는 import JSON에서 `/*` redirect URI를 허용하므로 로컬 Account Console callback 확인에 사용할 수 있습니다.

## Mail capture

- Mailpit UI: `http://localhost:8025`
- SMTP host inside compose: `mailpit:1025`

## Resetting imported data

realm import 내용을 바꿨는데 반영되지 않으면 컨테이너를 내린 뒤 다시 올리세요.

```bash
docker compose down
docker compose up --force-recreate
```
