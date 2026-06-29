<#import "template.ftl" as layout>
<@layout.registrationLayout displayInfo=false displayMessage=false; section>
    <#if section = "header">
        ${msg("emailForgotTitle")}
    <#elseif section = "form">
        <div class="sandori-auth-container sandori-centered">
            <div class="sandori-logo-container sandori-logo-small">
                <img src="${url.resourcesPath}/img/logo1.png" alt="${realm.displayName!realm.name} 로고">
            </div>
            <header class="sandori-header">
                <h1 class="sandori-action-title">비밀번호 찾기</h1>
                <p class="sandori-action-subtitle">가입한 아이디 또는 이메일을 입력하면 재설정 안내를 보내드려요.</p>
            </header>
            <#if message?has_content>
                <div class="sandori-message sandori-message-${message.type}" role="alert">
                    <span>${kcSanitize(message.summary)?no_esc}</span>
                </div>
            </#if>
            <form id="kc-reset-password-form" class="sandori-form" action="${url.loginAction}" method="post">
                <div class="sandori-input-group">
                    <label for="username">아이디 또는 이메일</label>
                    <input tabindex="1" id="username" class="sandori-input" name="username" value="${(auth.attemptedUsername!'')}" type="text" autofocus autocomplete="username" aria-invalid="<#if messagesPerField.existsError('username')>true</#if>">
                    <#if messagesPerField.existsError('username')>
                        <span class="sandori-field-error" role="alert">${kcSanitize(messagesPerField.get('username'))?no_esc}</span>
                    <#else>
                        <span class="sandori-input-message">계정 확인 후 등록된 이메일로 안내가 발송됩니다.</span>
                    </#if>
                </div>
                <button tabindex="2" class="sandori-btn sandori-btn-login" type="submit">재설정 메일 받기</button>
            </form>
            <footer>
                <div class="sandori-footer-link-block">
                    <a href="${url.loginUrl}">로그인으로 돌아가기</a>
                </div>
            </footer>
        </div>
    </#if>
</@layout.registrationLayout>
