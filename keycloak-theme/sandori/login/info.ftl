<#import "template.ftl" as layout>
<@layout.registrationLayout displayInfo=false displayMessage=false; section>
    <#if section = "header">
        ${msg("infoTitle")}
    <#elseif section = "form">
        <div class="sandori-auth-container sandori-centered">
            <div class="sandori-logo-container sandori-logo-small">
                <img src="${url.resourcesPath}/img/logo1.png" alt="${realm.displayName!realm.name} 로고">
            </div>
            <div class="sandori-status-icon sandori-status-info">✓</div>
            <header class="sandori-header">
                <h1 class="sandori-action-title">안내</h1>
                <p class="sandori-action-subtitle"><#if message?has_content>${kcSanitize(message.summary)?no_esc}<#else>요청이 정상적으로 처리되었습니다.</#if></p>
            </header>
            <div class="sandori-action-stack">
                <#if pageRedirectUri??>
                    <a class="sandori-btn sandori-btn-login" href="${pageRedirectUri}">계속하기</a>
                <#elseif actionUri??>
                    <a class="sandori-btn sandori-btn-login" href="${actionUri}">계속하기</a>
                <#elseif client?? && client.baseUrl?has_content>
                    <a class="sandori-btn sandori-btn-login" href="${client.baseUrl}">서비스로 돌아가기</a>
                <#else>
                    <a class="sandori-btn sandori-btn-login" href="${url.loginUrl}">로그인으로 돌아가기</a>
                </#if>
            </div>
        </div>
    </#if>
</@layout.registrationLayout>
