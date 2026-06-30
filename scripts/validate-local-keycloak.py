#!/usr/bin/env python3
from __future__ import annotations

from pathlib import Path
import json
import sys
from typing import NoReturn


ROOT = Path(__file__).resolve().parents[1]
COMPOSE = ROOT / "docker-compose.yml"
REALM = ROOT / "keycloak" / "import" / "Sandori-realm.json"
DOC = ROOT / "docs" / "local-keycloak.md"


def fail(message: str) -> NoReturn:
    print(f"FAIL: {message}", file=sys.stderr)
    raise SystemExit(1)


def expect_dict(value: object, context: str) -> dict[str, object]:
    if not isinstance(value, dict):
        fail(f"{context} must be an object")
    normalized: dict[str, object] = {}
    for key, item in value.items():
        if not isinstance(key, str):
            fail(f"{context} contains a non-string key")
        normalized[key] = item
    return normalized


def expect_list(value: object, context: str) -> list[object]:
    if not isinstance(value, list):
        fail(f"{context} must be a list")
    return value


def expect_string_list(value: object, context: str) -> list[str]:
    items = expect_list(value, context)
    strings: list[str] = []
    for item in items:
        if not isinstance(item, str):
            fail(f"{context} must contain only strings")
        strings.append(item)
    return strings


def assert_exists() -> None:
    for path in [COMPOSE, REALM, DOC]:
        if not path.exists():
            fail(f"missing required file: {path.relative_to(ROOT)}")


def assert_compose() -> None:
    text = COMPOSE.read_text(encoding="utf-8")
    expected_snippets = [
        "quay.io/keycloak/keycloak:26.6.4",
        "start-dev",
        "--import-realm",
        "--spi-theme-static-max-age=-1",
        "--spi-theme-cache-themes=false",
        "--spi-theme-cache-templates=false",
        "./keycloak-theme/sandori:/opt/keycloak/themes/sandori:ro",
        "./keycloak/import:/opt/keycloak/data/import:ro",
        "KC_BOOTSTRAP_ADMIN_USERNAME: admin",
        "KC_BOOTSTRAP_ADMIN_PASSWORD: admin",
        "axllent/mailpit:v1.27",
        '"8080:8080"',
        '"8025:8025"',
        '"1025:1025"',
    ]
    for snippet in expected_snippets:
        if snippet not in text:
            fail(f"docker-compose.yml missing snippet {snippet!r}")


def assert_realm() -> None:
    data = expect_dict(json.loads(REALM.read_text(encoding="utf-8")), "realm import")
    if data.get("realm") != "Sandori":
        fail("realm import must target 'Sandori'")
    if data.get("loginTheme") != "sandori":
        fail("realm import must set loginTheme to 'sandori'")
    if data.get("emailTheme") != "sandori":
        fail("realm import must set emailTheme to 'sandori'")
    if data.get("registrationAllowed") is not True:
        fail("realm import must enable registrationAllowed")
    if data.get("rememberMe") is not True:
        fail("realm import must enable rememberMe")
    if data.get("resetPasswordAllowed") is not True:
        fail("realm import must enable resetPasswordAllowed")
    if data.get("internationalizationEnabled") is not True:
        fail("realm import must enable internationalization")
    supported_locales = expect_string_list(data.get("supportedLocales") or [], "realm import supportedLocales")
    for locale in ["ko", "en"]:
        if locale not in supported_locales:
            fail(f"realm import must support locale {locale!r}")

    clients = [expect_dict(client, "realm import client") for client in expect_list(data.get("clients") or [], "realm import clients")]
    clients_by_id = {client.get("clientId"): client for client in clients}
    client_ids = set(clients_by_id)
    for client_id in ["auth-relay", "sandol-meal-service", "account", "account-console"]:
        if client_id not in client_ids:
            fail(f"realm import missing client {client_id!r}")

    auth_relay = expect_dict(clients_by_id["auth-relay"], "auth-relay client")
    if auth_relay.get("baseUrl") != "/realms/Sandori/account/":
        fail("auth-relay baseUrl must point to the Account personal info page")
    redirect_uris = expect_string_list(auth_relay.get("redirectUris") or [], "auth-relay redirectUris")
    for redirect_uri in ["/realms/Sandori/account/*", "http://localhost:8080/realms/Sandori/account/*"]:
        if redirect_uri not in redirect_uris:
            fail(f"auth-relay redirectUris missing {redirect_uri!r}")


def assert_docs() -> None:
    text = DOC.read_text(encoding="utf-8")
    expected_snippets = [
        "docker compose up",
        "http://localhost:8080/admin",
        "Sandori-realm.json",
        "Realm: `Sandori`",
        "auth-relay",
        "sandol-meal-service",
        "/realms/Sandori/account",
    ]
    for snippet in expected_snippets:
        if snippet not in text:
            fail(f"docs/local-keycloak.md missing snippet {snippet!r}")


def main() -> None:
    assert_exists()
    assert_compose()
    assert_realm()
    assert_docs()
    print("OK: local Keycloak test environment validated")
    print(f"compose: {COMPOSE.relative_to(ROOT)}")
    print(f"realm import: {REALM.relative_to(ROOT)}")
    print(f"docs: {DOC.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
