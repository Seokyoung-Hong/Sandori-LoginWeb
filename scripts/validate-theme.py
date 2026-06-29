#!/usr/bin/env python3
"""Lightweight structural validation for the Sandori Keycloak theme.

This does not replace a live Keycloak render test, but it catches packaging,
asset, CSS reference, and common FreeMarker balance mistakes in CI/local use.
"""
from __future__ import annotations

from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[1]
THEME = ROOT / "keycloak-theme" / "sandori" / "login"

REQUIRED_FILES = [
    THEME / "theme.properties",
    THEME / "login.ftl",
    THEME / "register.ftl",
    THEME / "resources" / "css" / "sandori-login.css",
    THEME / "resources" / "img" / "logo1.png",
    THEME / "resources" / "img" / "check.png",
    THEME / "messages" / "messages_ko.properties",
    THEME / "messages" / "messages_en.properties",
]

REQUIRED_LOGIN_SNIPPETS = [
    'action="${url.loginAction}"',
    'name="username"',
    'name="password"',
    '${url.registrationUrl}',
    '${url.loginResetCredentialsUrl}',
    '${url.resourcesPath}/img/logo1.png',
]

REQUIRED_REGISTER_SNIPPETS = [
    'action="${url.registrationAction}"',
    'name="email"',
    'name="firstName"',
    'name="lastName"',
    'name="password"',
    'name="password-confirm"',
    '${url.loginUrl}',
]


def fail(message: str) -> None:
    print(f"FAIL: {message}", file=sys.stderr)
    raise SystemExit(1)


def assert_exists() -> None:
    missing = [str(p.relative_to(ROOT)) for p in REQUIRED_FILES if not p.exists()]
    if missing:
        fail("missing required theme files: " + ", ".join(missing))


def assert_theme_properties() -> None:
    props = (THEME / "theme.properties").read_text(encoding="utf-8")
    for expected in ["parent=base", "styles=css/sandori-login.css", "locales=ko,en"]:
        if expected not in props:
            fail(f"theme.properties missing {expected!r}")


def assert_snippets(path: Path, snippets: list[str]) -> None:
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
    css = (THEME / "resources" / "css" / "sandori-login.css").read_text(encoding="utf-8")
    if '../img/check.png' not in css:
        fail("CSS does not reference ../img/check.png for custom checkboxes")
    for klass in ["sandori-auth-container", "sandori-btn-kakao", "sandori-btn-google", "sandori-btn-apple"]:
        if klass not in css:
            fail(f"CSS missing .{klass}")


def main() -> None:
    assert_exists()
    assert_theme_properties()
    assert_snippets(THEME / "login.ftl", REQUIRED_LOGIN_SNIPPETS)
    assert_snippets(THEME / "register.ftl", REQUIRED_REGISTER_SNIPPETS)
    assert_freemarker_balance(THEME / "login.ftl")
    assert_freemarker_balance(THEME / "register.ftl")
    assert_css_assets()
    print("OK: Sandori Keycloak theme structure validated")
    print(f"theme: {THEME.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
