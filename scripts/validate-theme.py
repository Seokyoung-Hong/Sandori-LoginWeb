#!/usr/bin/env python3
"""Lightweight structural validation for the Sandori Keycloak themes.

This does not replace a live Keycloak render test, but it catches packaging,
asset, CSS reference, and common FreeMarker balance mistakes in CI/local use.
"""
from __future__ import annotations

from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[1]
THEME_ROOT = ROOT / "keycloak-theme" / "sandori"
LOGIN = THEME_ROOT / "login"
EMAIL = THEME_ROOT / "email"

REQUIRED_FILES = [
    LOGIN / "theme.properties",
    LOGIN / "login.ftl",
    LOGIN / "register.ftl",
    LOGIN / "login-reset-password.ftl",
    LOGIN / "login-update-password.ftl",
    LOGIN / "login-verify-email.ftl",
    LOGIN / "error.ftl",
    LOGIN / "info.ftl",
    LOGIN / "login-page-expired.ftl",
    LOGIN / "resources" / "css" / "sandori-login.css",
    LOGIN / "resources" / "img" / "logo1.png",
    LOGIN / "resources" / "img" / "check.png",
    LOGIN / "messages" / "messages_ko.properties",
    LOGIN / "messages" / "messages_en.properties",
    EMAIL / "theme.properties",
    EMAIL / "html" / "email-verification.ftl",
    EMAIL / "html" / "password-reset.ftl",
    EMAIL / "html" / "executeActions.ftl",
    EMAIL / "text" / "email-verification.ftl",
    EMAIL / "text" / "password-reset.ftl",
    EMAIL / "text" / "executeActions.ftl",
    EMAIL / "messages" / "messages_ko.properties",
    EMAIL / "messages" / "messages_en.properties",
]

SNIPPETS = {
    LOGIN / "login.ftl": [
        'action="${url.loginAction}"',
        'name="username"',
        'name="password"',
        '${url.registrationUrl}',
        '${url.loginResetCredentialsUrl}',
        '${url.resourcesPath}/img/logo1.png',
    ],
    LOGIN / "register.ftl": [
        'action="${url.registrationAction}"',
        'name="locale"',
        'name="username"',
        'name="password"',
        'name="password-confirm"',
        'name="email"',
        'name="fullname"',
        'name="nickname"',
        'name="birthdate"',
        'name="gender"',
        'name="termsAccepted"',
        '${url.loginUrl}',
    ],
    LOGIN / "login-reset-password.ftl": [
        'action="${url.loginAction}"',
        'name="username"',
        '${url.loginUrl}',
    ],
    LOGIN / "login-update-password.ftl": [
        'action="${url.loginAction}"',
        'name="password-new"',
        'name="password-confirm"',
    ],
    LOGIN / "login-verify-email.ftl": [
        '${msg("emailVerifyInstruction1", user.email)}',
        'action="${url.loginAction}"',
        '${url.loginUrl}',
    ],
    LOGIN / "error.ftl": [
        '${url.loginUrl}',
        '요청을 처리하지 못했어요',
    ],
    LOGIN / "info.ftl": [
        'pageRedirectUri',
        '계속하기',
    ],
    LOGIN / "login-page-expired.ftl": [
        '${url.loginRestartFlowUrl}',
        '${url.loginUrl}',
    ],
    EMAIL / "html" / "email-verification.ftl": ['${link}', '이메일 인증하기'],
    EMAIL / "html" / "password-reset.ftl": ['${link}', '비밀번호 재설정하기'],
    EMAIL / "html" / "executeActions.ftl": ['${link}', '계정 작업 진행하기'],
}


def fail(message: str) -> None:
    print(f"FAIL: {message}", file=sys.stderr)
    raise SystemExit(1)


def assert_exists() -> None:
    missing = [str(p.relative_to(ROOT)) for p in REQUIRED_FILES if not p.exists()]
    if missing:
        fail("missing required theme files: " + ", ".join(missing))


def assert_theme_properties() -> None:
    login_props = (LOGIN / "theme.properties").read_text(encoding="utf-8")
    for expected in ["parent=base", "styles=css/sandori-login.css", "locales=ko,en"]:
        if expected not in login_props:
            fail(f"login/theme.properties missing {expected!r}")
    email_props = (EMAIL / "theme.properties").read_text(encoding="utf-8")
    for expected in ["parent=base", "locales=ko,en"]:
        if expected not in email_props:
            fail(f"email/theme.properties missing {expected!r}")


def assert_snippets() -> None:
    for path, snippets in SNIPPETS.items():
        text = path.read_text(encoding="utf-8")
        for snippet in snippets:
            if snippet not in text:
                fail(f"{path.relative_to(ROOT)} missing snippet {snippet!r}")


def assert_freemarker_balance(path: Path) -> None:
    text = path.read_text(encoding="utf-8")
    for tag in ["if", "list"]:
        opens = len(re.findall(rf"<#\s*{tag}(?:\s|>)", text))
        closes = len(re.findall(rf"</#\s*{tag}\s*>", text))
        if opens != closes:
            fail(f"{path.relative_to(ROOT)} has unbalanced <#{tag}> tags: {opens} open, {closes} close")
    if text.count("<@layout.registrationLayout") != text.count("</@layout.registrationLayout>"):
        fail(f"{path.relative_to(ROOT)} has unbalanced registrationLayout macro")


def assert_css_assets() -> None:
    css = (LOGIN / "resources" / "css" / "sandori-login.css").read_text(encoding="utf-8")
    if '../img/check.png' not in css:
        fail("CSS does not reference ../img/check.png for custom checkboxes")
    for klass in [
        "sandori-auth-container",
        "sandori-btn-kakao",
        "sandori-btn-google",
        "sandori-btn-apple",
        "sandori-status-icon",
        "sandori-action-title",
    ]:
        if klass not in css:
            fail(f"CSS missing .{klass}")


def main() -> None:
    assert_exists()
    assert_theme_properties()
    assert_snippets()
    for path in LOGIN.glob("*.ftl"):
        assert_freemarker_balance(path)
    assert_css_assets()
    print("OK: Sandori Keycloak theme structure validated")
    print(f"login theme: {LOGIN.relative_to(ROOT)}")
    print(f"email theme: {EMAIL.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
