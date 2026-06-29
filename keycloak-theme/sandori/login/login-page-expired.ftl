<#import "template.ftl" as layout>
<@layout.registrationLayout displayInfo=false displayMessage=false; section>
    <#if section = "header">
        ${msg("pageExpiredTitle")}
    <#elseif section = "form">
        <div class="sandori-auth-container sandori-centered">
            <div class="sandori-logo-container sandori-logo-small">
                <img src="${url.resourcesPath}/img/logo1.png" alt="${realm.displayName!realm.name} 로고">
            </div>
            <div class="sandori-status-icon sandori-status-warning">⏱</div>
            <header class="sandori-header">
                <h1 class="sandori-action-title">페이지가 만료되었어요</h1>
                <p class="sandori-action-subtitle">보안을 위해 인증 페이지가 만료되었습니다. 아래 버튼으로 다시 시작해 주세요.</p>
            </header>
            <div class="sandori-action-stack">
                <a class="sandori-btn sandori-btn-login" href="${url.loginRestartFlowUrl}">로그인 다시 시작</a>
                <a class="sandori-link" href="${url.loginUrl}">로그인 화면으로 이동</a>
            </div>
        </div>
    </#if>
</@layout.registrationLayout>
