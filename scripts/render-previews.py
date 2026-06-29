#!/usr/bin/env python3
"""Render static preview screenshots for Sandori Keycloak theme pages.

The previews are not live Keycloak renders; they are visual smoke previews that
reuse the checked-in CSS/assets so design regressions can be inspected quickly.
"""
from __future__ import annotations

from pathlib import Path
import shutil
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "screenshots"
PREVIEW = ROOT / "preview"
CSS = ROOT / "keycloak-theme" / "sandori" / "login" / "resources" / "css" / "sandori-login.css"
IMG = ROOT / "keycloak-theme" / "sandori" / "login" / "resources" / "img"
CHROMIUM = shutil.which("chromium") or shutil.which("chromium-browser") or shutil.which("google-chrome")

BASE_HEAD = """<!doctype html>
<html lang=\"ko\"><head><meta charset=\"utf-8\"><meta name=\"viewport\" content=\"width=device-width,initial-scale=1\">
<link rel=\"stylesheet\" href=\"assets/css/sandori-login.css\"><title>{title}</title></head><body>
"""
BASE_FOOT = "</body></html>\n"


def page(title: str, inner: str) -> str:
    return BASE_HEAD.format(title=title) + inner + BASE_FOOT


def logo() -> str:
    return '<div class="sandori-logo-container sandori-logo-small"><img src="assets/img/logo1.png" alt="SANDORI 로고"></div>'


def auth_card(title: str, subtitle: str, body: str, icon: str = "") -> str:
    return f'''<div class="sandori-auth-container sandori-centered">
{logo()}
{icon}
<header class="sandori-header"><h1 class="sandori-action-title">{title}</h1><p class="sandori-action-subtitle">{subtitle}</p></header>
{body}
</div>'''


def input_group(label: str, typ: str = "text", msg: str = "") -> str:
    extra = f'<span class="sandori-input-message">{msg}</span>' if msg else ""
    return f'<div class="sandori-input-group"><label>{label}</label><input class="sandori-input" type="{typ}">{extra}</div>'


def make_pages() -> dict[str, str]:
    reset = auth_card(
        "비밀번호 찾기",
        "가입한 아이디 또는 이메일을 입력하면 재설정 안내를 보내드려요.",
        f'''<form class="sandori-form">{input_group("아이디 또는 이메일", "text", "계정 확인 후 등록된 이메일로 안내가 발송됩니다.")}<button class="sandori-btn sandori-btn-login">재설정 메일 받기</button></form><footer><div class="sandori-footer-link-block"><a href="#">로그인으로 돌아가기</a></div></footer>''',
    )
    update_pw = auth_card(
        "새 비밀번호 설정",
        "계정을 안전하게 보호할 새 비밀번호를 입력해 주세요.",
        f'''<form class="sandori-form">{input_group("새 비밀번호", "password", "비밀번호 정책에 맞게 입력해 주세요.")}{input_group("새 비밀번호 확인", "password", "동일한 비밀번호를 한 번 더 입력해 주세요.")}<button class="sandori-btn sandori-btn-login">비밀번호 변경</button></form>''',
    )
    verify = auth_card(
        "이메일을 확인해 주세요",
        "user@example.com 주소로 인증 메일을 보냈습니다.",
        '''<div class="sandori-info-card">인증 메일의 링크를 눌러야 산돌이를 계속 이용할 수 있습니다. 메일이 보이지 않으면 스팸함도 확인해 주세요.</div><form class="sandori-form"><button class="sandori-btn sandori-btn-login">인증 메일 다시 보내기</button></form><footer><div class="sandori-footer-link-block"><a href="#">로그인으로 돌아가기</a></div></footer>''',
        '<div class="sandori-status-icon sandori-status-mail">✉</div>',
    )
    error = auth_card(
        "요청을 처리하지 못했어요",
        "쿠키를 찾을 수 없습니다. 브라우저에서 쿠키가 활성화되어 있는지 확인하세요.",
        '<div class="sandori-action-stack"><a class="sandori-btn sandori-btn-login" href="#">서비스로 돌아가기</a><a class="sandori-link" href="#">로그인 다시 시도</a></div>',
        '<div class="sandori-status-icon sandori-status-error">!</div>',
    )
    info = auth_card(
        "안내",
        "비밀번호 재설정 메일을 발송했습니다. 이메일을 확인해 주세요.",
        '<div class="sandori-action-stack"><a class="sandori-btn sandori-btn-login" href="#">계속하기</a></div>',
        '<div class="sandori-status-icon sandori-status-info">✓</div>',
    )
    expired = auth_card(
        "페이지가 만료되었어요",
        "보안을 위해 인증 페이지가 만료되었습니다. 아래 버튼으로 다시 시작해 주세요.",
        '<div class="sandori-action-stack"><a class="sandori-btn sandori-btn-login" href="#">로그인 다시 시작</a><a class="sandori-link" href="#">로그인 화면으로 이동</a></div>',
        '<div class="sandori-status-icon sandori-status-warning">⏱</div>',
    )
    email = '''<!doctype html><html lang="ko"><head><meta charset="utf-8"><title>Sandori Email</title></head>
<body style="margin:0;padding:0;background:#f0f2f5;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',sans-serif;color:#212226;">
<table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="background:#f0f2f5;padding:32px 12px;"><tr><td align="center">
<table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="max-width:520px;background:#ffffff;border-radius:28px;padding:36px 30px;box-shadow:0 4px 20px rgba(0,0,0,.08);">
<tr><td align="center" style="font-size:24px;font-weight:800;color:#4EA6AA;padding-bottom:20px;">SANDORI</td></tr>
<tr><td style="font-size:22px;font-weight:800;text-align:center;padding-bottom:10px;">이메일을 인증해 주세요</td></tr>
<tr><td style="font-size:14px;line-height:1.7;color:#4D4D4D;text-align:center;padding-bottom:24px;">산돌이를 계속 이용하려면 아래 버튼을 눌러 이메일 인증을 완료해 주세요.</td></tr>
<tr><td align="center"><a href="#" style="display:inline-block;background:#4EA6AA;color:#ffffff;text-decoration:none;font-size:15px;font-weight:700;padding:14px 28px;border-radius:12px;">이메일 인증하기</a></td></tr>
<tr><td style="font-size:12px;line-height:1.6;color:#949BA5;padding-top:24px;word-break:break-all;">버튼이 열리지 않으면 다음 주소를 브라우저에 붙여넣어 주세요.<br>https://sandori.kr/auth/example</td></tr>
<tr><td style="padding-top:26px;font-size:12px;line-height:1.6;color:#949BA5;text-align:center;">본 메일은 Sandori 계정 보안을 위해 발송되었습니다.<br>요청하지 않았다면 이 메일을 무시해 주세요.</td></tr>
</table></td></tr></table></body></html>'''
    return {
        "01-reset-password.html": page("비밀번호 찾기", reset),
        "02-update-password.html": page("비밀번호 변경", update_pw),
        "03-verify-email.html": page("이메일 인증", verify),
        "04-error.html": page("오류", error),
        "05-info.html": page("안내", info),
        "06-page-expired.html": page("페이지 만료", expired),
        "07-email-verification.html": email,
    }


def main() -> None:
    if not CHROMIUM:
        raise SystemExit("chromium/google-chrome executable not found")
    OUT.mkdir(exist_ok=True)
    (PREVIEW / "assets" / "css").mkdir(parents=True, exist_ok=True)
    (PREVIEW / "assets" / "img").mkdir(parents=True, exist_ok=True)
    shutil.copy2(CSS, PREVIEW / "assets" / "css" / "sandori-login.css")
    for image in IMG.iterdir():
        if image.is_file():
            shutil.copy2(image, PREVIEW / "assets" / "img" / image.name)
    pages = make_pages()
    rendered = []
    for name, html in pages.items():
        html_path = PREVIEW / name
        html_path.write_text(html, encoding="utf-8")
        png = OUT / name.replace(".html", ".png")
        size = "800,720" if name.startswith("07-") else "430,920"
        subprocess.run([
            CHROMIUM,
            "--headless=new",
            "--no-sandbox",
            "--disable-gpu",
            f"--window-size={size}",
            f"--screenshot={png}",
            html_path.as_uri(),
        ], check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        rendered.append(png)
    print("rendered screenshots:")
    for path in rendered:
        print(path)


if __name__ == "__main__":
    main()
