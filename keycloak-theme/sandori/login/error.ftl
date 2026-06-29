<#import "template.ftl" as layout>
<@layout.registrationLayout displayInfo=false displayMessage=false; section>
    <#if section = "header">
        ${msg("errorTitle")}
    <#elseif section = "form">
        <div class="sandori-auth-container sandori-centered">
            <div class="sandori-logo-container sandori-logo-small">
                <img src="${url.resourcesPath}/img/logo1.png" alt="${realm.displayName!realm.name} 로고">
            </div>
            <div class="sandori-status-icon sandori-status-error">!</div>
            <header class="sandori-header">
                <h1 class="sandori-action-title">요청을 처리하지 못했어요</h1>
                <p class="sandori-action-subtitle"><#if message?has_content>${kcSanitize(message.summary)?no_esc}<#else>일시적인 오류가 발생했습니다.</#if></p>
            </header>
            <div class="sandori-action-stack">
                <#if client?? && client.baseUrl?has_content>
                    <a class="sandori-btn sandori-btn-login" href="${client.baseUrl}">서비스로 돌아가기</a>
                </#if>
                <#if skipLink??>
                <#else>
                    <a class="sandori-link" href="${url.loginUrl}">로그인 다시 시도</a>
                </#if>
            </div>
        </div>
    </#if>
</@layout.registrationLayout>
