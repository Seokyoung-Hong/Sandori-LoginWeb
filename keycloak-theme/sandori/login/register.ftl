<#import "template.ftl" as layout>
<@layout.registrationLayout displayInfo=false displayMessage=false; section>
    <#if section = "header">
        ${msg("registerTitle")}
    <#elseif section = "form">
        <div class="sandori-auth-container">
            <header class="sandori-header">
                <h1 class="sandori-register-title">회원가입</h1>
            </header>

            <#if message?has_content>
                <div class="sandori-message sandori-message-${message.type}" role="alert">
                    <span>${kcSanitize(message.summary)?no_esc}</span>
                </div>
            </#if>

            <main>
                <form id="kc-register-form" class="sandori-form sandori-register-form" action="${url.registrationAction}" method="post">
                    <#if !realm.registrationEmailAsUsername>
                        <div class="sandori-input-group">
                            <label for="username">아이디</label>
                            <div class="sandori-input-wrapper">
                                <input tabindex="1" id="username" class="sandori-input" name="username" value="${(register.formData.username!'')}" type="text" autocomplete="username" aria-invalid="<#if messagesPerField.existsError('username')>true</#if>">
                                <button type="button" class="sandori-btn sandori-btn-check" aria-label="Keycloak 저장 시 중복 확인">중복확인</button>
                            </div>
                            <#if messagesPerField.existsError('username')>
                                <span class="sandori-field-error" role="alert">${kcSanitize(messagesPerField.get('username'))?no_esc}</span>
                            </#if>
                        </div>
                    </#if>

                    <div class="sandori-input-group">
                        <label for="email">이메일</label>
                        <input tabindex="2" id="email" class="sandori-input" name="email" value="${(register.formData.email!'')}" type="email" autocomplete="email" aria-invalid="<#if messagesPerField.existsError('email')>true</#if>">
                        <#if messagesPerField.existsError('email')>
                            <span class="sandori-field-error" role="alert">${kcSanitize(messagesPerField.get('email'))?no_esc}</span>
                        </#if>
                    </div>

                    <div class="sandori-input-group">
                        <label for="firstName">이름</label>
                        <input tabindex="3" id="firstName" class="sandori-input" name="firstName" value="${(register.formData.firstName!'')}" type="text" autocomplete="given-name" aria-invalid="<#if messagesPerField.existsError('firstName')>true</#if>">
                        <#if messagesPerField.existsError('firstName')>
                            <span class="sandori-field-error" role="alert">${kcSanitize(messagesPerField.get('firstName'))?no_esc}</span>
                        </#if>
                    </div>

                    <div class="sandori-input-group">
                        <label for="lastName">성</label>
                        <input tabindex="4" id="lastName" class="sandori-input" name="lastName" value="${(register.formData.lastName!'')}" type="text" autocomplete="family-name" aria-invalid="<#if messagesPerField.existsError('lastName')>true</#if>">
                        <#if messagesPerField.existsError('lastName')>
                            <span class="sandori-field-error" role="alert">${kcSanitize(messagesPerField.get('lastName'))?no_esc}</span>
                        </#if>
                    </div>

                    <#if passwordRequired??>
                        <div class="sandori-input-group">
                            <label for="password">비밀번호</label>
                            <input tabindex="5" id="password" class="sandori-input" name="password" type="password" autocomplete="new-password" aria-invalid="<#if messagesPerField.existsError('password','password-confirm')>true</#if>">
                            <#if messagesPerField.existsError('password')>
                                <span class="sandori-field-error" role="alert">${kcSanitize(messagesPerField.get('password'))?no_esc}</span>
                            <#else>
                                <span class="sandori-input-message">비밀번호 정책에 맞게 입력해 주세요</span>
                            </#if>
                        </div>

                        <div class="sandori-input-group">
                            <label for="password-confirm">비밀번호 확인</label>
                            <input tabindex="6" id="password-confirm" class="sandori-input" name="password-confirm" type="password" autocomplete="new-password" aria-invalid="<#if messagesPerField.existsError('password-confirm')>true</#if>">
                            <#if messagesPerField.existsError('password-confirm')>
                                <span class="sandori-field-error" role="alert">${kcSanitize(messagesPerField.get('password-confirm'))?no_esc}</span>
                            <#else>
                                <span class="sandori-input-message">동일한 비밀번호를 한 번 더 입력해 주세요</span>
                            </#if>
                        </div>
                    </#if>

                    <#if recaptchaRequired??>
                        <div class="form-group">
                            <div class="${properties.kcInputWrapperClass!}">
                                <div class="g-recaptcha" data-size="compact" data-sitekey="${recaptchaSiteKey}"></div>
                            </div>
                        </div>
                    </#if>

                    <section class="sandori-terms-section">
                        <h2>이용약관</h2>
                        <div class="sandori-checkbox-group">
                            <div class="sandori-checkbox-item">
                                <input id="terms-required" name="termsRequired" value="true" type="checkbox" required>
                                <label for="terms-required">이용 약관 동의 (필수)</label>
                            </div>
                            <div class="sandori-checkbox-item">
                                <input id="privacy-required" name="privacyRequired" value="true" type="checkbox" required>
                                <label for="privacy-required">개인정보 수집 동의 (필수)</label>
                            </div>
                            <div class="sandori-checkbox-item">
                                <input id="privacy-optional" name="privacyOptional" value="true" type="checkbox">
                                <label for="privacy-optional">개인정보 수집 동의 (선택)</label>
                            </div>
                            <div class="sandori-checkbox-item">
                                <input id="marketing-optional" name="marketingOptional" value="true" type="checkbox">
                                <label for="marketing-optional">혜택/알림 정보 수신 동의 (선택)</label>
                            </div>
                        </div>
                    </section>

                    <button tabindex="7" class="sandori-btn sandori-btn-signup" type="submit">회원가입하기</button>
                </form>
            </main>

            <footer>
                <div class="sandori-footer-link-block">
                    <span>이미 계정이 있으시다면</span>
                    <a href="${url.loginUrl}">로그인하기</a>
                </div>
            </footer>
        </div>
    </#if>
</@layout.registrationLayout>
