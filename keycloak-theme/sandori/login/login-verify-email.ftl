<#import "template.ftl" as layout>
<@layout.registrationLayout displayInfo=false displayMessage=false; section>
    <#if section = "header">
        ${msg("emailVerifyTitle")}
    <#elseif section = "form">
        <div class="sandori-auth-container sandori-centered">
            <div class="sandori-logo-container sandori-logo-small">
                <img src="${url.resourcesPath}/img/logo1.png" alt="${realm.displayName!realm.name} 로고">
            </div>
            <div class="sandori-status-icon sandori-status-mail">✉</div>
            <header class="sandori-header">
                <h1 class="sandori-action-title">이메일을 확인해 주세요</h1>
                <p class="sandori-action-subtitle">${msg("emailVerifyInstruction1", user.email)}</p>
            </header>
            <#if message?has_content>
                <div class="sandori-message sandori-message-${message.type}" role="alert">
                    <span>${kcSanitize(message.summary)?no_esc}</span>
                </div>
            </#if>
            <div class="sandori-info-card">
                인증 메일의 링크를 눌러야 Sandori 서비스를 계속 이용할 수 있습니다. 메일이 보이지 않으면 스팸함도 확인해 주세요.
            </div>
            <form id="kc-verify-email-form" class="sandori-form" action="${url.loginAction}" method="post">
                <button class="sandori-btn sandori-btn-login" type="submit">인증 메일 다시 보내기</button>
            </form>
            <footer>
                <div class="sandori-footer-link-block">
                    <a href="${url.loginUrl}">로그인으로 돌아가기</a>
                </div>
            </footer>
        </div>
    </#if>
</@layout.registrationLayout>
