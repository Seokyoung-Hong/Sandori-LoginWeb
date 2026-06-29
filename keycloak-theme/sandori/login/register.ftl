<#import "template.ftl" as layout>
<@layout.registrationLayout displayInfo=false displayMessage=false; section>
    <#if section = "header">
        ${msg("registerTitle")}
    <#elseif section = "form">
        <div class="sandori-auth-container">
            <header class="sandori-header">
                <h1 class="sandori-register-title">회원가입</h1>
                <p class="sandori-register-subtitle">산돌이 식단 서비스를 이용하기 위한 정보를 입력해 주세요</p>
            </header>

            <#if message?has_content>
                <div class="sandori-message sandori-message-${message.type}" role="alert">
                    <span>${kcSanitize(message.summary)?no_esc}</span>
                </div>
            </#if>

            <main>
                <form id="kc-register-form" class="sandori-form sandori-register-form" action="${url.registrationAction}" method="post">
                    <input type="hidden" id="locale" name="locale" value="${(locale.currentLanguageTag!'ko')}">

                    <div class="sandori-input-group">
                        <label for="username">아이디 <span class="sandori-required" aria-hidden="true">*</span></label>
                        <div class="sandori-input-wrapper">
                            <input tabindex="1" id="username" class="sandori-input" name="username" value="${(register.formData.username!'')}" type="text" autocomplete="username" required aria-invalid="<#if messagesPerField.existsError('username')>true</#if>">
                            <button type="button" class="sandori-btn sandori-btn-check" aria-label="Keycloak 저장 시 중복 확인">중복확인</button>
                        </div>
                        <#if messagesPerField.existsError('username')>
                            <span class="sandori-field-error" role="alert">${kcSanitize(messagesPerField.get('username'))?no_esc}</span>
                        </#if>
                    </div>

                    <#if passwordRequired??>
                        <div class="sandori-input-group">
                            <label for="password">비밀번호 <span class="sandori-required" aria-hidden="true">*</span></label>
                            <input tabindex="2" id="password" class="sandori-input" name="password" type="password" autocomplete="new-password" required aria-invalid="<#if messagesPerField.existsError('password','password-confirm')>true</#if>">
                            <#if messagesPerField.existsError('password')>
                                <span class="sandori-field-error" role="alert">${kcSanitize(messagesPerField.get('password'))?no_esc}</span>
                            <#else>
                                <span class="sandori-input-message">비밀번호 정책에 맞게 입력해 주세요</span>
                            </#if>
                        </div>

                        <div class="sandori-input-group">
                            <label for="password-confirm">비밀번호 확인 <span class="sandori-required" aria-hidden="true">*</span></label>
                            <input tabindex="3" id="password-confirm" class="sandori-input" name="password-confirm" type="password" autocomplete="new-password" required aria-invalid="<#if messagesPerField.existsError('password-confirm')>true</#if>">
                            <#if messagesPerField.existsError('password-confirm')>
                                <span class="sandori-field-error" role="alert">${kcSanitize(messagesPerField.get('password-confirm'))?no_esc}</span>
                            <#else>
                                <span class="sandori-input-message">동일한 비밀번호를 한 번 더 입력해 주세요</span>
                            </#if>
                        </div>
                    </#if>

                    <div class="sandori-input-group">
                        <label for="email">이메일 <span class="sandori-required" aria-hidden="true">*</span></label>
                        <input tabindex="4" id="email" class="sandori-input" name="email" value="${(register.formData.email!'')}" type="email" autocomplete="email" required aria-invalid="<#if messagesPerField.existsError('email')>true</#if>">
                        <#if messagesPerField.existsError('email')>
                            <span class="sandori-field-error" role="alert">${kcSanitize(messagesPerField.get('email'))?no_esc}</span>
                        </#if>
                    </div>

                    <div class="sandori-input-group">
                        <label for="fullname">성명 <span class="sandori-required" aria-hidden="true">*</span></label>
                        <input tabindex="5" id="fullname" class="sandori-input" name="fullname" value="${(register.formData.fullname!'')}" type="text" autocomplete="name" required aria-invalid="<#if messagesPerField.existsError('fullname')>true</#if>">
                        <#if messagesPerField.existsError('fullname')>
                            <span class="sandori-field-error" role="alert">${kcSanitize(messagesPerField.get('fullname'))?no_esc}</span>
                        </#if>
                    </div>

                    <div class="sandori-input-group">
                        <label for="nickname">닉네임 <span class="sandori-optional">선택</span></label>
                        <input tabindex="6" id="nickname" class="sandori-input" name="nickname" value="${(register.formData.nickname!'')}" type="text" autocomplete="nickname" aria-invalid="<#if messagesPerField.existsError('nickname')>true</#if>">
                        <#if messagesPerField.existsError('nickname')>
                            <span class="sandori-field-error" role="alert">${kcSanitize(messagesPerField.get('nickname'))?no_esc}</span>
                        </#if>
                    </div>

                    <div class="sandori-input-group">
                        <label for="birthdate">생년월일 <span class="sandori-optional">선택</span></label>
                        <input tabindex="7" id="birthdate" class="sandori-input" name="birthdate" value="${(register.formData.birthdate!'')}" type="date" aria-invalid="<#if messagesPerField.existsError('birthdate')>true</#if>">
                        <#if messagesPerField.existsError('birthdate')>
                            <span class="sandori-field-error" role="alert">${kcSanitize(messagesPerField.get('birthdate'))?no_esc}</span>
                        </#if>
                    </div>

                    <div class="sandori-input-group">
                        <label for="gender">성별 <span class="sandori-optional">선택</span></label>
                        <select tabindex="8" id="gender" class="sandori-input sandori-select" name="gender" aria-invalid="<#if messagesPerField.existsError('gender')>true</#if>">
                            <option value="" <#if !(register.formData.gender??) || register.formData.gender == "">selected</#if>>선택하지 않음</option>
                            <option value="남성" <#if (register.formData.gender!'') == "남성">selected</#if>>남성</option>
                            <option value="여성" <#if (register.formData.gender!'') == "여성">selected</#if>>여성</option>
                        </select>
                        <#if messagesPerField.existsError('gender')>
                            <span class="sandori-field-error" role="alert">${kcSanitize(messagesPerField.get('gender'))?no_esc}</span>
                        </#if>
                    </div>

                    <#if recaptchaRequired??>
                        <div class="form-group">
                            <div class="${properties.kcInputWrapperClass!}">
                                <div class="g-recaptcha" data-size="compact" data-sitekey="${recaptchaSiteKey}"></div>
                            </div>
                        </div>
                    </#if>

                    <section class="sandori-terms-section">
                        <h2>이용약관</h2>
                        <div id="kc-registration-terms-text" class="sandori-terms-text">
                            서비스에 가입하려면 <a href="https://quanect.kr/policies/terms-of-service" rel="nofollow">서비스 이용약관</a> 및 <a href="https://quanect.kr/policies/privacy-policy" rel="nofollow">개인정보 처리방침</a>에 동의해 주세요.<br><br>
                            [필수] 수집 항목: 사용자 이름(ID), 이메일, 이름<br>
                            [필수] 수집 목적: 회원 식별, 계정 관리 및 서비스 제공<br>
                            [필수] 보유 기간: 회원 탈퇴 시까지<br><br>
                            [선택] 수집 항목: 닉네임, 생년월일, 성별<br>
                            [선택] 수집 목적: 맞춤형 서비스 제공 및 이용자 통계 분석<br>
                            [선택] 보유 기간: 회원 탈퇴 시까지<br>
                            선택 항목은 입력하지 않는 방식으로 제공을 거부할 수 있으며, 입력하지 않은 경우 해당 정보는 제공되지 않습니다.<br><br>
                            위 사항에 동의하지 않을 권리가 있으나, 필수 항목에 동의하지 않을 경우 회원가입 및 서비스 이용이 제한될 수 있습니다.
                        </div>
                        <div class="sandori-checkbox-group">
                            <div class="sandori-checkbox-item">
                                <input tabindex="9" id="termsAccepted" name="termsAccepted" value="true" type="checkbox" required aria-invalid="<#if messagesPerField.existsError('termsAccepted')>true</#if>">
                                <label for="termsAccepted">이용 약관에 동의합니다 <span class="sandori-required" aria-hidden="true">*</span></label>
                            </div>
                            <#if messagesPerField.existsError('termsAccepted')>
                                <span class="sandori-field-error" role="alert">${kcSanitize(messagesPerField.get('termsAccepted'))?no_esc}</span>
                            </#if>
                        </div>
                    </section>

                    <button tabindex="10" class="sandori-btn sandori-btn-signup" type="submit">등록</button>
                </form>
            </main>

            <footer>
                <div class="sandori-footer-link-block">
                    <span>이미 계정이 있으시다면</span>
                    <a href="${url.loginUrl}">로그인으로 돌아가기</a>
                </div>
            </footer>
        </div>
    </#if>
</@layout.registrationLayout>
