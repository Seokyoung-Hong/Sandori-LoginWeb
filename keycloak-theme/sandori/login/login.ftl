<#import "template.ftl" as layout>
<@layout.registrationLayout displayInfo=false displayMessage=false; section>
    <#if section = "header">
        ${msg("doLogIn")}
    <#elseif section = "form">
        <div class="sandori-auth-container sandori-centered">
            <div class="sandori-logo-container">
                <img src="${url.resourcesPath}/img/logo1.png" alt="${realm.displayName!realm.name} 로고">
            </div>

            <header class="sandori-header">
                <h1 class="sandori-login-title">쉽게 로그인하고<br>다양한 서비스를 이용해봐요</h1>
            </header>

            <#if message?has_content>
                <div class="sandori-message sandori-message-${message.type}" role="alert">
                    <span>${kcSanitize(message.summary)?no_esc}</span>
                </div>
            </#if>

            <main>
                <#if realm.identityFederationEnabled && social.providers?? && social.providers?size gt 0>
                    <section class="sandori-social-login" aria-label="소셜 로그인">
                        <#list social.providers as p>
                            <#assign providerClass = p.alias?lower_case>
                            <a id="social-${p.alias}" class="sandori-btn sandori-btn-${providerClass}" href="${p.loginUrl}">
                                <#if p.alias?lower_case == "kakao">카카오톡으로 시작하기
                                <#elseif p.alias?lower_case == "google">Google 로 시작하기
                                <#elseif p.alias?lower_case == "apple">Apple 로 시작하기
                                <#else>${p.displayName!p.alias}로 시작하기</#if>
                            </a>
                        </#list>
                    </section>
                    <div class="sandori-divider">또는</div>
                </#if>

                <form id="kc-form-login" class="sandori-form" action="${url.loginAction}" method="post">
                    <#if !usernameHidden??>
                        <input
                            tabindex="1"
                            id="username"
                            class="sandori-input"
                            name="username"
                            value="${(login.username!'')}"
                            type="text"
                            autocomplete="username"
                            placeholder="<#if !realm.loginWithEmailAllowed>${msg('username')}<#elseif !realm.registrationEmailAsUsername>${msg('usernameOrEmail')}<#else>${msg('email')}</#if>"
                            aria-invalid="<#if messagesPerField.existsError('username','password')>true</#if>"
                        />
                    </#if>

                    <input
                        tabindex="2"
                        id="password"
                        class="sandori-input"
                        name="password"
                        type="password"
                        autocomplete="current-password"
                        placeholder="${msg('password')}"
                        aria-invalid="<#if messagesPerField.existsError('username','password')>true</#if>"
                    />

                    <#if messagesPerField.existsError('username','password')>
                        <span class="sandori-field-error" role="alert">
                            ${kcSanitize(messagesPerField.getFirstError('username','password'))?no_esc}
                        </span>
                    </#if>

                    <#if realm.rememberMe && !usernameHidden??>
                        <label class="sandori-checkbox-item" for="rememberMe">
                            <#if login.rememberMe??>
                                <input tabindex="3" id="rememberMe" name="rememberMe" type="checkbox" checked>
                            <#else>
                                <input tabindex="3" id="rememberMe" name="rememberMe" type="checkbox">
                            </#if>
                            <span>${msg("rememberMe")}</span>
                        </label>
                    </#if>

                    <button tabindex="4" class="sandori-btn sandori-btn-login" name="login" id="kc-login" type="submit">로그인하기</button>
                </form>
            </main>

            <footer>
                <#if realm.password && realm.registrationAllowed && !registrationDisabled??>
                    <div class="sandori-signup-section">
                        <span>계정이 없으시다면</span>
                        <a href="${url.registrationUrl}">회원가입하기</a>
                    </div>
                </#if>
                <#if realm.resetPasswordAllowed>
                    <div class="sandori-find-account-section">
                        <a href="${url.loginResetCredentialsUrl}">아이디 / 비밀번호 찾기</a>
                    </div>
                </#if>
            </footer>
        </div>
    </#if>
</@layout.registrationLayout>
