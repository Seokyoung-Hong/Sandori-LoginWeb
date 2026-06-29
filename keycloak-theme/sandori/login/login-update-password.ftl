<#import "template.ftl" as layout>
<@layout.registrationLayout displayInfo=false displayMessage=false; section>
    <#if section = "header">
        ${msg("updatePasswordTitle")}
    <#elseif section = "form">
        <div class="sandori-auth-container sandori-centered">
            <div class="sandori-logo-container sandori-logo-small">
                <img src="${url.resourcesPath}/img/logo1.png" alt="${realm.displayName!realm.name} 로고">
            </div>
            <header class="sandori-header">
                <h1 class="sandori-action-title">새 비밀번호 설정</h1>
                <p class="sandori-action-subtitle">계정을 안전하게 보호할 새 비밀번호를 입력해 주세요.</p>
            </header>
            <#if message?has_content>
                <div class="sandori-message sandori-message-${message.type}" role="alert">
                    <span>${kcSanitize(message.summary)?no_esc}</span>
                </div>
            </#if>
            <form id="kc-passwd-update-form" class="sandori-form" action="${url.loginAction}" method="post">
                <div class="sandori-input-group">
                    <label for="password-new">새 비밀번호</label>
                    <input tabindex="1" id="password-new" class="sandori-input" name="password-new" type="password" autocomplete="new-password" autofocus aria-invalid="<#if messagesPerField.existsError('password','password-confirm')>true</#if>">
                    <#if messagesPerField.existsError('password')>
                        <span class="sandori-field-error" role="alert">${kcSanitize(messagesPerField.get('password'))?no_esc}</span>
                    <#else>
                        <span class="sandori-input-message">비밀번호 정책에 맞게 입력해 주세요.</span>
                    </#if>
                </div>
                <div class="sandori-input-group">
                    <label for="password-confirm">새 비밀번호 확인</label>
                    <input tabindex="2" id="password-confirm" class="sandori-input" name="password-confirm" type="password" autocomplete="new-password" aria-invalid="<#if messagesPerField.existsError('password-confirm')>true</#if>">
                    <#if messagesPerField.existsError('password-confirm')>
                        <span class="sandori-field-error" role="alert">${kcSanitize(messagesPerField.get('password-confirm'))?no_esc}</span>
                    <#else>
                        <span class="sandori-input-message">동일한 비밀번호를 한 번 더 입력해 주세요.</span>
                    </#if>
                </div>
                <#if isAppInitiatedAction??>
                    <div class="sandori-checkbox-item">
                        <input tabindex="3" id="logout-sessions" name="logout-sessions" type="checkbox" checked>
                        <label for="logout-sessions">다른 기기에서 로그아웃</label>
                    </div>
                </#if>
                <button tabindex="4" class="sandori-btn sandori-btn-login" type="submit">비밀번호 변경</button>
                <#if isAppInitiatedAction??>
                    <button tabindex="5" class="sandori-btn sandori-btn-secondary" type="submit" name="cancel-aia" value="true">나중에 하기</button>
                </#if>
            </form>
        </div>
    </#if>
</@layout.registrationLayout>
