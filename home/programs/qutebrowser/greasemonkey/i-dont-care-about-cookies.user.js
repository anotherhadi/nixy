// ==UserScript==
// @name     I don't care about cookies
// @name:vi Tôi không quan tâm về cookie
// @name:zh-CN 我不关心cookie
// @name:zh-TW 我不關心cookie
// @name:ja クッキーについては気にしない
// @name:ru Я не забочусь о куки
// @namespace    http://tampermonkey.net/
// @version      2025.01.03.2
// @description  Remove cookie warnings from almost all websites! Auto accept cookies and remove annoying cookie popups
// @description:vi Loại bỏ cảnh báo cookie từ hầu hết các trang web! Tự động chấp nhận cookie và xóa các popup cookie phiền phức
// @description:zh-CN 自动接受cookie并移除烦人的cookie弹窗
// @description:zh-TW 自動接受cookie並移除煩人的cookie彈窗
// @description:ru Автоматическое принятие cookie и удаление надоедливых всплывающих окон
// @description:ja 自動承認cookieと迷惑なポップアップを削除
// @author       Yuusei
// @match        *://*/*
// @grant        none
// @icon https://lh3.googleusercontent.com/sCLTYpGX0VcVootQ_XaFQ9saRIhVWu79ngSzY5eTZ5evRpJ_Q27OdvxA4RrOoZXP7Q4enFh-u6VhxObcJLfARw1g=s60
// @compatible   chrome
// @compatible   edge
// @compatible   firefox
// @compatible   safari
// @run-at       document-start
// @license      gpl-3.0-only
// @downloadURL https://update.greasyfork.org/scripts/522645/I%20don%27t%20care%20about%20cookies.user.js
// @updateURL https://update.greasyfork.org/scripts/522645/I%20don%27t%20care%20about%20cookies.meta.js
// ==/UserScript==

(function () {
	'use strict';

	const CONSENT_TEXTS = {
		en: ['accept', 'accept all', 'agree', 'continue', 'got it', 'reject all', 'decline', 'necessary only', 'required only', 'manage', 'customize'],
		vi: ['chấp nhận', 'chấp nhận tất cả', 'đồng ý', 'tiếp tục', 'từ chối tất cả', 'từ chối', 'chỉ cần thiết', 'tùy chỉnh', 'quản lý', 'cho phép', 'đồng ý và tiếp tục', 'tôi đồng ý', 'xác nhận', 'tôi chấp nhận', 'đồng ý tất cả', 'chấp nhận và tiếp tục', 'cho phép tất cả'],
		zh: ['接受', '接受全部', '同意', '继续', '拒绝全部', '拒绝', '仅必要', '管理', '自定义'],
		ru: ['принять', 'принять все', 'согласен', 'продолжить', 'отклонить все', 'отклонить', 'только необходимые', 'настроить', 'управлять'],
		ja: ['承認', '同意', '続ける', 'すべて拒否', '拒否', '必要のみ', 'カスタマイズ', '管理'],
		de: ['akzeptieren', 'einverstanden', 'fortfahren', 'alle ablehnen', 'ablehnen', 'nur notwendige', 'anpassen', 'verwalten'],
		fr: ['accepter', 'accepter tout', 'accepte', 'continuer', 'tout refuser', 'refuser', 'uniquement nécessaire', 'personnaliser', 'gérer'],
		es: ['aceptar', 'acepto todo', 'acepto', 'continuar', 'rechazar todo', 'rechazar', 'solo necesario', 'personalizar', 'gestionar'],
		it: ['accetta', 'accetto tutto', 'accetto', 'continua', 'rifiuta tutto', 'rifiuta', 'solo necessari', 'personalizza', 'gestisci'],
		pl: ['akceptuj', 'akceptuj wszystko', 'zgadzam się', 'kontynuuj', 'odrzuć wszystko', 'odrzuć', 'tylko niezbędne', 'dostosuj', 'zarządzaj'],
		nl: ['accepteren', 'accepteren', 'doorgaan', 'alles weigeren', 'weigeren', 'alleen noodzakelijk', 'aanpassen', 'beheren'],
		ko: ['동의', '모두 동의', '계속하기', '모두 거부', '거부', '필수만', '설정', '관리'],
		th: ['ยอมรับ', 'ยอมรับทั้งหมด', 'ตกลง', 'ปฏิเสธทั้งหมด', 'ปฏิเสธ', 'จำเป็นเท่านั้น', 'ตั้งค่า', 'จัดการ'],
		id: ['setuju', 'setuju semua', 'lanjutkan', 'tolak semua', 'tolak', 'wajib saja', 'pengaturan', 'kelola'],
		ms: ['terima', 'terima semua', 'teruskan', 'tolak semua', 'tolak', 'perlu sahaja', 'tetapan', 'urus'],
		pt: ['aceitar', 'aceitar tudo', 'continuar', 'rejeitar tudo', 'rejeitar', 'necessário', 'configurar', 'gerir'],
		sv: ['godkänn', 'godkänn alla', 'fortsätt', 'neka alla', 'neka', 'nödvändiga', 'inställningar', 'hantera'],
		da: ['accepter', 'accepter alle', 'fortsæt', 'afvis alle', 'afvis', 'nødvendige', 'indstillinger', 'administrer'],
		fi: ['hyväksy', 'hyväksy kaikki', 'jatka', 'hylkää kaikki', 'hylkää', 'välttämätön', 'asetukset', 'hallitse'],
		'zh-CN': ['接受', '接受全部', '同意', '继续', '我同意', '确定', '确认', '知道了', '好的', '拒绝全部', '拒绝', '仅必要', '设置', '自定义', '管理', '保存设置', '允许', '允许全部', '接受并继续', '同意并继续', '保存并继续'],
		'zh-TW': ['接受', '接受全部', '同意', '繼續', '我同意', '確定', '確認', '知道了', '好的', '拒絕全部', '拒絕', '僅必要', '設置', '自定義', '管理', '保存設置', '允許', '允許全部', '接受並繼續', '同意並繼續', '保存並繼續'],
		ko: ['동의', '모두 동의', '수락', '계속하기', '확인', '거부', '거부하기', '필수만', '설정', '관리', '저장', '허용', '모두 허용'],
		th: ['ยอมรับ', 'ยอมรับทั้งหมด', 'ตกลง', 'ดำเนินการต่อ', 'ปฏิเสธ', 'ปฏิเสธทั้งหมด', 'จำเป็นเท่านั้น', 'ตั้งค่า', 'จัดการ', 'บันทึก', 'อนุญาต', 'อนุญาตทั้งหมด'],
		id: ['terima', 'terima semua', 'setuju', 'lanjutkan', 'tolak', 'tolak semua', 'wajib saja', 'pengaturan', 'kelola', 'simpan', 'izinkan', 'izinkan semua'],
		ms: ['terima', 'terima semua', 'setuju', 'teruskan', 'tolak', 'tolak semua', 'perlu sahaja', 'tetapan', 'urus', 'simpan', 'benarkan', 'benarkan semua'],
	};

	function matchesConsentText(element) {
		const text = element.textContent.toLowerCase();
		const lang = document.documentElement.lang || 'en';
		const texts = CONSENT_TEXTS[lang.split('-')[0]] || CONSENT_TEXTS['en'];
		return texts.some(t => text.includes(t));
	}

	// Utility functions
	function _sl(selector, container) {
		return (container || document).querySelector(selector);
	}

	function _id(id) {
		return document.getElementById(id);
	}

	function _ev(selector, container, full) {
		return document.evaluate((typeof full == 'undefined' ? '//' : '') + selector, container || document, null, XPathResult.ANY_TYPE, null).iterateNext();
	}

	function _if(condition, ...selectors) {
		return _sl(condition) ? _chain(...selectors) : false;
	}

	function _if_else(condition, if_selectors, else_selectors) {
		if (_sl(condition)) return _chain(...if_selectors);

		return _chain(...else_selectors);
	}

	function _chain(...selectors) {
		let elements,
			l = selectors.length;
		let flagUnique = false,
			flagOptional = false,
			flagAllMatches = false;

		for (let i = currentChainElement; i < l; i++) {
			if (/^FLAG\:/.test(selectors[i])) {
				selectors[i]
					.split(':')[1]
					.split(',')
					.forEach(function (flag) {
						if (flag == 'UNIQUE') flagUnique = true;
						else if (flag == 'OPTIONAL') flagOptional = true;
						else if (flag == 'REQUIRED') flagOptional = false;
						else if (flag == 'ALL-MATCHES') flagAllMatches = true;
						else if (flag == 'SINGLE-MATCH') flagAllMatches = false;
					});

				continue;
			}

			if (flagUnique) selectors[i] += selectors[i].startsWith('//') ? '[not(contains(@class, "' + classname + '"))]' : ':not(.' + classname + ')';

			if (i == l - 1) return selectors[i];

			elements = _sl(selectors[i], false, flagAllMatches);

			if (!flagAllMatches) elements = elements ? [elements] : [];

			if (!elements.length) {
				if (flagOptional) {
					currentChainElement++;
					continue;
				}

				return false;
			}

			currentChainElement++;

			elements.forEach(function (element) {
				if (flagUnique) element.classList.add(classname);

				if (element.nodeName == 'OPTION') element.selected = true;
				else element.click();
			});
		}

		return false;
	}

	function getItem(hostname) {
		switch (hostname) {
			case 'youtube.com':
			case 'www.youtube.com':
				return { strict: true, key: 'CONSENT', value: 'PENDING+999' };

			case 'google.com':
			case 'www.google.com':
				return { strict: true, key: 'CONSENT', value: 'YES+' };

			case 'twitter.com':
			case 'www.twitter.com':
				return { strict: false, key: 'twtr_cookie_consent', value: '1' };

			case 'pepephone.com':
			case 'lyricsbox.com':
				return { strict: true, key: 'cookieconsent', value: '1111' };

			case 'kontaktbazar.at':
			case 'hoernews.de':
				return { strict: false, key: 'cookieconsent_status', value: 'dismiss' };

			case 'vodafoneziggo.nl':
				return { strict: false, key: 'cookies-accepted', value: 'true' };
			case 'frankfurt.de':
				return { strict: false, key: 'cookieAccepted', value: 'needed---piwik' };
			case 'hackerrank.com':
				return { strict: false, key: 'show_cookie_banner', value: 'false' };

			case 'facebook.com':
			case 'www.facebook.com':
				return { strict: true, key: 'datr', value: 'accepted' };

			case 'instagram.com':
			case 'www.instagram.com':
				return { strict: true, key: 'ig_did', value: 'accepted' };

			case 'linkedin.com':
			case 'www.linkedin.com':
				return { strict: false, key: 'lidc', value: 'accepted' };

			case 'reddit.com':
			case 'www.reddit.com':
				return { strict: false, key: 'eu_cookie', value: '{"opted":true}' };

			case 'tiktok.com':
			case 'www.tiktok.com':
				return { strict: true, key: 'tt_webid', value: 'accepted' };

			case 'netflix.com':
			case 'www.netflix.com':
				return { strict: false, key: 'netflix-cookie-consent', value: 'accepted' };

			case 'spotify.com':
			case 'www.spotify.com':
				return { strict: false, key: 'sp_dc', value: 'accepted' };

			case 'amazon.com':
			case 'www.amazon.com':
				return { strict: false, key: 'amazon-cookie-consent', value: 'accepted' };

			case 'pinterest.com':
			case 'www.pinterest.com':
				return { strict: false, key: '_pinterest_sess', value: 'accepted' };

			case 'twitch.tv':
			case 'www.twitch.tv':
				return { strict: false, key: 'twitch_cookie_consent', value: 'accepted' };

			case 'github.com':
			case 'www.github.com':
				return { strict: false, key: '_gh_sess', value: 'accepted' };

			case 'medium.com':
			case 'www.medium.com':
				return { strict: false, key: 'medium_cookie_consent', value: 'accepted' };

			case 'quora.com':
			case 'www.quora.com':
				return { strict: false, key: 'm-b', value: 'accepted' };

			case 'stackoverflow.com':
			case 'www.stackoverflow.com':
				return { strict: false, key: 'acct', value: 'accepted' };

			case 'microsoft.com':
			case 'www.microsoft.com':
				return { strict: false, key: 'MUID', value: 'accepted' };

			case 'apple.com':
			case 'www.apple.com':
				return { strict: false, key: 'geo', value: 'accepted' };

			case 'dropbox.com':
			case 'www.dropbox.com':
				return { strict: false, key: 'dbx-consent', value: 'accepted' };

			case 'booking.com':
			case 'www.booking.com':
				return { strict: false, key: 'bkng_consent', value: 'accepted' };

			case 'vnexpress.net':
			case 'www.vnexpress.net':
				return { strict: false, key: 'vnexpress_cookie_consent', value: 'accepted' };

			case 'thanhnien.vn':
			case 'www.thanhnien.vn':
				return { strict: false, key: 'thanhnien_cookie', value: 'accepted' };

			case 'tuoitre.vn':
			case 'www.tuoitre.vn':
				return { strict: false, key: 'tuoitre_cookie', value: 'accepted' };

			case 'tiki.vn':
			case 'www.tiki.vn':
				return { strict: false, key: 'tiki_cookie', value: 'accepted' };

			case 'shopee.vn':
			case 'www.shopee.vn':
				return { strict: false, key: 'shopee_cookie', value: 'accepted' };

			case 'lazada.vn':
			case 'www.lazada.vn':
				return { strict: false, key: 'lzd_cookie', value: 'accepted' };

			case 'sendo.vn':
			case 'www.sendo.vn':
				return { strict: false, key: 'sendo_cookie', value: 'accepted' };

			case 'thegioididong.com':
			case 'www.thegioididong.com':
				return { strict: false, key: 'tgdd_cookie', value: 'accepted' };

			case 'fptshop.com.vn':
			case 'www.fptshop.com.vn':
				return { strict: false, key: 'fpt_cookie', value: 'accepted' };

			case 'cellphones.com.vn':
			case 'www.cellphones.com.vn':
				return { strict: false, key: 'cps_cookie', value: 'accepted' };

			case 'aliexpress.com':
			case 'www.aliexpress.com':
				return { strict: false, key: 'aep_usuc_f', value: 'accepted' };

			case 'ebay.com':
			case 'www.ebay.com':
				return { strict: false, key: 'ebay_cookie_consent', value: 'accepted' };

			case 'coursera.org':
			case 'www.coursera.org':
				return { strict: false, key: 'coursera_cookie', value: 'accepted' };

			case 'udemy.com':
			case 'www.udemy.com':
				return { strict: false, key: 'ud_cookie', value: 'accepted' };

			case 'bachhoaxanh.com':
			case 'www.bachhoaxanh.com':
				return { strict: false, key: 'bhx_cookie', value: 'accepted' };

			case 'dienmayxanh.com':
			case 'www.dienmayxanh.com':
				return { strict: false, key: 'dmx_cookie', value: 'accepted' };

			case 'nguyenkim.com':
			case 'www.nguyenkim.com':
				return { strict: false, key: 'nk_cookie', value: 'accepted' };

			case 'dantri.com.vn':
			case 'www.dantri.com.vn':
				return { strict: false, key: 'dantri_cookie', value: 'accepted' };

			case 'vietnamnet.vn':
			case 'www.vietnamnet.vn':
				return { strict: false, key: 'vietnamnet_cookie', value: 'accepted' };

			case '24h.com.vn':
			case 'www.24h.com.vn':
				return { strict: false, key: '24h_cookie', value: 'accepted' };

			case 'vietcombank.com.vn':
			case 'www.vietcombank.com.vn':
				return { strict: false, key: 'vcb_cookie', value: 'accepted' };

			case 'techcombank.com.vn':
			case 'www.techcombank.com.vn':
				return { strict: false, key: 'tcb_cookie', value: 'accepted' };

			case 'mbbank.com.vn':
			case 'www.mbbank.com.vn':
				return { strict: false, key: 'mb_cookie', value: 'accepted' };

			case 'amazon.co.jp':
			case 'www.amazon.co.jp':
				return { strict: false, key: 'amazon_jp_cookie', value: 'accepted' };

			case 'rakuten.co.jp':
			case 'www.rakuten.co.jp':
				return { strict: false, key: 'rakuten_jp_cookie', value: 'accepted' };

			case 'taobao.com':
			case 'www.taobao.com':
				return { strict: false, key: 'taobao_cookie', value: 'accepted' };

			case 'line.me':
			case 'www.line.me':
				return { strict: false, key: 'line_cookie', value: 'accepted' };

			case 'weibo.com':
			case 'www.weibo.com':
				return { strict: false, key: 'weibo_cookie', value: 'accepted' };

			case 'kakao.com':
			case 'www.kakao.com':
				return { strict: false, key: 'kakao_cookie', value: 'accepted' };

			case 'yahoo.co.jp':
			case 'www.yahoo.co.jp':
				return { strict: false, key: 'yahoo_jp_cookie', value: 'accepted' };

			case 'naver.com':
			case 'www.naver.com':
				return { strict: false, key: 'naver_cookie', value: 'accepted' };

			case 'baidu.com':
			case 'www.baidu.com':
				return { strict: false, key: 'baidu_cookie', value: 'accepted' };

			case 'zalando.com':
			case 'www.zalando.com':
				return { strict: false, key: 'zalando_cookie', value: 'accepted' };

			case 'asos.com':
			case 'www.asos.com':
				return { strict: false, key: 'asos_cookie', value: 'accepted' };

			case 'zara.com':
			case 'www.zara.com':
				return { strict: false, key: 'zara_cookie', value: 'accepted' };

			case 'tmall.com':
			case 'www.tmall.com':
				return { strict: false, key: 'tmall_cookie', value: 'accepted' };

			case 'jd.com':
			case 'www.jd.com':
				return { strict: false, key: 'jd_cookie', value: 'accepted' };

			case 'sina.com.cn':
			case 'www.sina.com.cn':
				return { strict: false, key: 'sina_cookie', value: 'accepted' };

			case 'qq.com':
			case 'www.qq.com':
				return { strict: false, key: 'qq_cookie', value: 'accepted' };

			case '163.com':
			case 'www.163.com':
				return { strict: false, key: 'netease_cookie', value: 'accepted' };

			case 'sohu.com':
			case 'www.sohu.com':
				return { strict: false, key: 'sohu_cookie', value: 'accepted' };

			case 'bilibili.com':
			case 'www.bilibili.com':
				return { strict: false, key: 'bilibili_cookie', value: 'accepted' };
		}

		const parts = hostname.split('.');
		if (parts.length > 2) {
			parts.shift();
			return getItem(parts.join('.'));
		}
		return false;
	}

	function _parent(element) {
		if (element && element.parentNode) return element.parentNode;
		return false;
	}

	function _iframe(iframe_selector, selector) {
		var e = _sl(iframe_selector);
		return e ? _sl(selector, e.contentDocument || e.contentWindow.contentDocument) : e;
	}

	// Cookie consent handling logic
	let searchPairs = {
		'.vn-cookie-banner': ['.vn-cookie-banner__reject', '.vn-cookie-banner__customize'],
		'.vn-cookie-notice': ['.vn-cookie-notice__reject', '.vn-cookie-notice__settings'],
		'.vn-cookie-consent': ['.vn-cookie-consent__reject', '.vn-cookie-consent__customize'],
		'.vn-cookie-popup': ['.vn-cookie-popup__reject', '.vn-cookie-popup__settings'],

		'.shopee-cookie-banner': ['.shopee-cookie-banner__reject', '.shopee-cookie-banner__settings'],
		'.lazada-cookie-notice': ['.lazada-cookie-notice__reject', '.lazada-cookie-notice__settings'],
		'.tiki-cookie-popup': ['.tiki-cookie-popup__reject', '.tiki-cookie-popup__settings'],
		'.sendo-cookie-consent': ['.sendo-cookie-consent__reject', '.sendo-cookie-consent__settings'],

		'.vnexpress-cookie': ['.vnexpress-cookie__reject', '.vnexpress-cookie__settings'],
		'.tuoitre-cookie': ['.tuoitre-cookie__reject', '.tuoitre-cookie__settings'],
		'.thanhnien-cookie': ['.thanhnien-cookie__reject', '.thanhnien-cookie__settings'],
		'.dantri-cookie': ['.dantri-cookie__reject', '.dantri-cookie__settings'],

		'.tgdd-cookie-notice': ['.tgdd-cookie-notice__reject', '.tgdd-cookie-notice__settings'],
		'.fpt-cookie-popup': ['.fpt-cookie-popup__reject', '.fpt-cookie-popup__settings'],
		'.cps-cookie-consent': ['.cps-cookie-consent__reject', '.cps-cookie-consent__settings'],

		'.vcb-cookie-notice': ['.vcb-cookie-notice__reject', '.vcb-cookie-notice__settings'],
		'.tcb-cookie-popup': ['.tcb-cookie-popup__reject', '.tcb-cookie-popup__settings'],
		'.mb-cookie-consent': ['.mb-cookie-consent__reject', '.mb-cookie-consent__settings'],

		'div[class*="consent"]': ['button[class*="reject"]', 'button[class*="decline"]', 'button[class*="settings"]'],
		'div[class*="notice"]': ['button[class*="reject"]', 'button[class*="decline"]', 'button[class*="settings"]'],
		'div[class*="popup"]': ['button[class*="reject"]', 'button[class*="decline"]', 'button[class*="settings"]'],
		'div[class*="banner"]': ['button[class*="reject"]', 'button[class*="decline"]', 'button[class*="settings"]'],
	};

	let searchGroups = [
		'.qc-cmp2-summary-buttons button[mode="secondary"],\
		.qc-cmp2-buttons-desktop > button:first-child,\
		#didomi-popup .didomi-button-highlight:not([class*="paywall"]):not([class*="disagree"]),\
		#rgpd_video .rgpd-mask a[data-rgpd-consent],\
		.cli-barmodal-open #wt-cli-privacy-save-btn,\
		.js--modal[style*="block"] .cookie-permission--accept-button,\
		.gdpr-modal-rider .btn-cookieaccept,\
		.js-cookiewall #sel-test-accept-cookies-button,\
		#mpo[style*="block"] .submit.modal-privacy__btn[onclick*="privacyframe.accept"],\
		.lightbox--cookie-consent .btn-cta,\
		.lightbox.cookie-consent .cookie-consent-button-decline,\
		.js-modal-gdpr.is-active .btn[data-level="2"],\
		#CybotCookiebotDialogBodyLevelButtonLevelOptinAllowallSelection,\
		#cookieNotificationModal.in .btn.accept-cookie,\
		.has-ccwindow .cc-compliance .cc-dismiss,\
		.ds2-cookie-disclaimer--slidedown .ds2-cookie-disclaimer-js--submit,\
		#mdlCookieCompliance.in .cookieClose,\
		#cookieModal.in .js-acceptDefaultCookie,\
		.c-cookiebutton .c-cookiebutton__close,\
		#normativa_cookies.in .btn,\
		#cookiewall.in .btn-primary,\
		.outerCookieBar .EuCookieBar__cookieButton,\
		#TOS-POPUP .rhododendron-popup__button--agree,\
		#cookie-wall #accept-cookies,\
		#popup-wrapper .button[href*="/cookies.consent.php"],\
		.reveal.cookies[style*="block"] button[click*="aceptaCookies"],\
		.mnd-cookie-modal[style*="block"] .btn.is--primary,\
		.cookieHandler.cookieHandler--modalOpen #acceptAllCookies,\
		.gdpr-modal--active .btn--primary,\
		#dpi-banner:not(.hidden) #btn-agree-cookie,\
		.gh-banner.gh-banner-active #gh-cookiebanner-close,\
		#mrktpref.notification-bar .btn-success,\
		#PopinGDPRCookie[style*="block"] .jsbd-popin-ok,\
		#modal-rodo.in .btn-primary,\
		.cookie-compliance-modal.in .btn-primary,\
		.cookieconsent.show .btn[data-dm*="accept"],\
		.cookie-wall-modal.in .btn.ja,\
		#modal-consent.in .modal-consent-accept,\
		.rodo #cookies.in .btn-primary,\
		.js-cookie-alert.in .js-cookie-alert-accept,\
		#modal_gdpr_intro_popup.in #gdpr-modal-btn-ok-agree,\
		#consentButtonContainer > button[onclick*="sendAndRedirect"],\
		#eu-consent[style*="block"] .btn.yes,\
		.modal--gdpr.is-open .js-gdpr-consent,\
		#cookiePopupModal.in .cookiepopup-agreed,\
		.polityka-cookie-rodo[style*="block"] .button-zgoda,\
		.ui-dialog.consent-modal[style*="block"] .js-btn-agree,\
		#up-cookie.active .button[onclick*="setCookiePreference"],\
		.RodoModal.in .close,\
		.consent-popup form[action*="cookie-consent"] .consent-popup__button,\
		#consent form[action*="cookie-consent"] .one-btn,\
		#cookiewall-wrapper .button[href*="accept"],\
		#cookieChoiceButtonAccept,\
		.mod-cookie-consent[style*="block"] .btn-all-cookies,\
		.c-layer--consent .layer-button--accept,\
		.button.button-ok[onclick*="acceptAVG"],\
		#meredithGdprConsentFormButton,\
		#advanced-cookie-modal.in .cookie-accept,\
		.show-modal .cookie-settings-manager-container .initial-dialog .js-accept-button,\
		.cookie-settings-manager-container .initial-dialog[style*="block"] .js-accept-button,\
		.gdprLightbox[data-module="gdprLightbox"] ._type_gdpr_agree,\
		.cookie.showa #Row1_Column1_Cell1_CookieSettings_AdvancedSaveAccept,\
		#core-cookie-container[style*="block"] .btn--agree,\
		.cookie-consent-modal._show .action-primary,\
		#dsgvoModal.show #dsvgo-banner__button,\
		.basicLightbox--visible #accept-all-gdpr,\
		#gdpr-modal.in .gdpr-modal__btn--accept,\
		.cookiehint .btn.cookieagree,\
		#cookiealert .modal.in .btn[href*="accept"],\
		#lml-data-consent-accept,\
		#CBCookieMsg.in .btn[onclick*="approveCookies"],\
		#cookiewall-container .button[name="submit"],\
		#cookie_disclaimer.in .cookie_disclaimer_button,\
		.m-cookie.iziModal[style*="block"] .m-cookie__save2.button,\
		kamino-cookie-policy .mat-raised-button,\
		#surbma-gpga-modal[style*="block"] button,\
		#GDPR.overlayBox .menuButton,\
		#cookiebar .cookie-selection-button.accept,\
		.modal.in .btn.close-modal-cookie,\
		#consent-module[style*="block"] #consent-module-text-button,\
		.modal #consentButton,\
		#consent-modal[style*="block"] .lm_modal__modal__content__body__buttons__ok,\
		.cookiesOverlay3Box #cookiesConsentOK,\
		.bemCookieOverlay--activePopup .bemCookieOverlay__btn--save,\
		#root main ~ div [data-gi-selector="reject-all-cookies"] ~ div a,\
		.cookies-management .cookies-deny,\
		.offcanvas.is-open .js-offcanvas-cookie-submit,\
		.force--consent.show--consent #cs_save__btn,\
		.force--consent.show--consent #s-sv-bn,\
		#cookieNoticeModal.vrm-reveal[style*="block"] .vrm-reveal__icon--close',
		'.cookie-banner .cookie-banner__buttons .cookie-banner__button--reject,\
		.cookie-consent-banner .cookie-consent-banner__reject,\
		.cookie-notification .cookie-notification__buttons .cookie-notification__reject,\
		.cookie-policy-banner .cookie-policy-banner__buttons .cookie-policy-banner__reject,\
		.cookie-warning .cookie-warning__buttons .cookie-warning__reject,\
		.cookie-notice .cookie-notice__buttons .cookie-notice__reject,\
		.cookie-alert .cookie-alert__buttons .cookie-alert__reject,\
		.cookie-popup .cookie-popup__buttons .cookie-popup__reject,\
		.cookie-modal .cookie-modal__buttons .cookie-modal__reject,\
		.cookie-dialog .cookie-dialog__buttons .cookie-dialog__reject,\
		.gdpr-banner .gdpr-banner__buttons .gdpr-banner__reject,\
		.gdpr-modal .gdpr-modal__buttons .gdpr-modal__reject,\
		.gdpr-notice .gdpr-notice__buttons .gdpr-notice__reject,\
		.gdpr-popup .gdpr-popup__buttons .gdpr-popup__reject,\
		.gdpr-dialog .gdpr-dialog__buttons .gdpr-dialog__reject,\
		.privacy-banner .privacy-banner__buttons .privacy-banner__reject,\
		.privacy-modal .privacy-modal__buttons .privacy-modal__reject,\
		.privacy-notice .privacy-notice__buttons .privacy-notice__reject,\
		.privacy-popup .privacy-popup__buttons .privacy-popup__reject,\
		.privacy-dialog .privacy-dialog__buttons .privacy-dialog__reject',

		'.consent-banner .consent-banner__buttons .consent-banner__reject,\
		.consent-modal .consent-modal__buttons .consent-modal__reject,\
		.consent-notice .consent-notice__buttons .consent-notice__reject,\
		.consent-popup .consent-popup__buttons .consent-popup__reject,\
		.consent-dialog .consent-dialog__buttons .consent-dialog__reject,\
		.tracking-banner .tracking-banner__buttons .tracking-banner__reject,\
		.tracking-modal .tracking-modal__buttons .tracking-modal__reject,\
		.tracking-notice .tracking-notice__buttons .tracking-notice__reject,\
		.tracking-popup .tracking-popup__buttons .tracking-popup__reject,\
		.tracking-dialog .tracking-dialog__buttons .tracking-dialog__reject',

		'.cookie-settings-modal .cookie-settings__reject,\
		.cookie-settings-modal .cookie-settings__customize,\
		.cookie-preferences-modal .cookie-preferences__reject,\
		.cookie-preferences-modal .cookie-preferences__customize,\
		.cookie-manager-modal .cookie-manager__reject,\
		.cookie-manager-modal .cookie-manager__customize,\
		.cookie-control-modal .cookie-control__reject,\
		.cookie-control-modal .cookie-control__customize,\
		.cookie-options-modal .cookie-options__reject,\
		.cookie-options-modal .cookie-options__customize',

		'.data-privacy-modal .data-privacy__reject,\
		.data-privacy-modal .data-privacy__customize,\
		.data-protection-modal .data-protection__reject,\
		.data-protection-modal .data-protection__customize,\
		.data-consent-modal .data-consent__reject,\
		.data-consent-modal .data-consent__customize,\
		.data-settings-modal .data-settings__reject,\
		.data-settings-modal .data-settings__customize,\
		.data-preferences-modal .data-preferences__reject,\
		.data-preferences-modal .data-preferences__customize',

		'.privacy-manager-modal .privacy-manager__reject,\
		.privacy-manager-modal .privacy-manager__customize,\
		.privacy-settings-modal .privacy-settings__reject,\
		.privacy-settings-modal .privacy-settings__customize,\
		.privacy-options-modal .privacy-options__reject,\
		.privacy-options-modal .privacy-options__customize,\
		.privacy-control-modal .privacy-control__reject,\
		.privacy-control-modal .privacy-control__customize,\
		.privacy-preferences-modal .privacy-preferences__reject,\
		.privacy-preferences-modal .privacy-preferences__customize',

		'.consent-manager-modal .consent-manager__reject,\
		.consent-manager-modal .consent-manager__customize,\
		.consent-settings-modal .consent-settings__reject,\
		.consent-settings-modal .consent-settings__customize,\
		.consent-options-modal .consent-options__reject,\
		.consent-options-modal .consent-options__customize,\
		.consent-control-modal .consent-control__reject,\
		.consent-control-modal .consent-control__customize,\
		.consent-preferences-modal .consent-preferences__reject,\
		.consent-preferences-modal .consent-preferences__customize',

		'.tracking-manager-modal .tracking-manager__reject,\
		.tracking-manager-modal .tracking-manager__customize,\
		.tracking-settings-modal .tracking-settings__reject,\
		.tracking-settings-modal .tracking-settings__customize,\
		.tracking-options-modal .tracking-options__reject,\
		.tracking-options-modal .tracking-options__customize,\
		.tracking-control-modal .tracking-control__reject,\
		.tracking-control-modal .tracking-control__customize,\
		.tracking-preferences-modal .tracking-preferences__reject,\
		.tracking-preferences-modal .tracking-preferences__customize',

		'.gdpr-manager-modal .gdpr-manager__reject,\
		.gdpr-manager-modal .gdpr-manager__customize,\
		.gdpr-settings-modal .gdpr-settings__reject,\
		.gdpr-settings-modal .gdpr-settings__customize,\
		.gdpr-options-modal .gdpr-options__reject,\
		.gdpr-options-modal .gdpr-options__customize,\
		.gdpr-control-modal .gdpr-control__reject,\
		.gdpr-control-modal .gdpr-control__customize,\
		.gdpr-preferences-modal .gdpr-preferences__reject,\
		.gdpr-preferences-modal .gdpr-preferences__customize',

		'div[class*="cookie-banner"] button[class*="reject"],\
		 div[class*="cookie-banner"] button[class*="decline"],\
		 div[class*="cookie-banner"] button[class*="settings"],\
		 div[id*="cookie-banner"] button[class*="reject"],\
		 div[id*="cookie-banner"] button[class*="decline"],\
		 div[id*="cookie-banner"] button[class*="settings"]',

		'div[class*="cookie-consent"] button[class*="reject"],\
		 div[class*="cookie-consent"] button[class*="decline"],\
		 div[class*="cookie-consent"] button[class*="settings"],\
		 div[id*="cookie-consent"] button[class*="reject"],\
		 div[id*="cookie-consent"] button[class*="decline"],\
		 div[id*="cookie-consent"] button[class*="settings"]',

		'div[class*="cookie-notice"] button[class*="reject"],\
		 div[class*="cookie-notice"] button[class*="decline"],\
		 div[class*="cookie-notice"] button[class*="settings"],\
		 div[id*="cookie-notice"] button[class*="reject"],\
		 div[id*="cookie-notice"] button[class*="decline"],\
		 div[id*="cookie-notice"] button[class*="settings"]',

		'[data-*="cookie"] button[data-*="reject"],\
		[data-*="cookie"] button[data-*="decline"],\
		[data-*="cookie"] button[data-*="settings"],\
		[data-*="gdpr"] button[data-*="reject"],\
		[data-*="gdpr"] button[data-*="decline"],\
		[data-*="gdpr"] button[data-*="settings"]',

		'div[class*="cookie-layer"] button[class*="reject"],\
		 div[class*="cookie-layer"] button[class*="decline"],\
		 div[class*="cookie-layer"] button[class*="settings"],\
		 div[id*="cookie-layer"] button[class*="reject"],\
		 div[id*="cookie-layer"] button[class*="decline"],\
		 div[id*="cookie-layer"] button[class*="settings"]',

		'div[class*="cookie-section"] button[class*="reject"],\
		 div[class*="cookie-section"] button[class*="decline"],\
		 div[class*="cookie-section"] button[class*="settings"],\
		 div[id*="cookie-section"] button[class*="reject"],\
		 div[id*="cookie-section"] button[class*="decline"],\
		 div[id*="cookie-section"] button[class*="settings"]',

		'div[class*="cookie-container"] button[class*="reject"],\
		 div[class*="cookie-container"] button[class*="decline"],\
		 div[class*="cookie-container"] button[class*="settings"],\
		 div[id*="cookie-container"] button[class*="reject"],\
		 div[id*="cookie-container"] button[class*="decline"],\
		 div[id*="cookie-container"] button[class*="settings"]',

		'[data-purpose*="cookie"] button[data-purpose*="reject"],\
		 [data-purpose*="cookie"] button[data-purpose*="decline"],\
		 [data-purpose*="cookie"] button[data-purpose*="settings"],\
		 [data-ref*="cookie"] button[data-ref*="reject"],\
		 [data-ref*="cookie"] button[data-ref*="decline"],\
		 [data-ref*="cookie"] button[data-ref*="settings"]',

		'[id*="cookie-manager"] button[id*="reject"],\
		 [id*="cookie-manager"] button[id*="decline"],\
		 [id*="cookie-manager"] button[id*="settings"],\
		 [id*="cookie-control"] button[id*="reject"],\
		 [id*="cookie-control"] button[id*="decline"],\
		 [id*="cookie-control"] button[id*="settings"]',

		'div[class*="vn-cookie"] button[class*="reject"],\
		 div[class*="vn-cookie"] button[class*="decline"],\
		 div[class*="vn-cookie"] button[class*="settings"],\
		 div[id*="vn-cookie"] button[class*="reject"],\
		 div[id*="vn-cookie"] button[class*="decline"],\
		 div[id*="vn-cookie"] button[class*="settings"]',

		'div[class*="ecommerce"] button[class*="cookie-reject"],\
		 div[class*="ecommerce"] button[class*="cookie-decline"],\
		 div[class*="ecommerce"] button[class*="cookie-settings"],\
		 div[id*="ecommerce"] button[class*="cookie-reject"],\
		 div[id*="ecommerce"] button[class*="cookie-decline"],\
		 div[id*="ecommerce"] button[class*="cookie-settings"]',

		'div[class*="news"] button[class*="cookie-reject"],\
		 div[class*="news"] button[class*="cookie-decline"],\
		 div[class*="news"] button[class*="cookie-settings"],\
		 div[id*="news"] button[class*="cookie-reject"],\
		 div[id*="news"] button[class*="cookie-decline"],\
		 div[id*="news"] button[class*="cookie-settings"]',

		'div[class*="retail"] button[class*="cookie-reject"],\
		 div[class*="retail"] button[class*="cookie-decline"],\
		 div[class*="retail"] button[class*="cookie-settings"],\
		 div[id*="retail"] button[class*="cookie-reject"],\
		 div[id*="retail"] button[class*="cookie-decline"],\
		 div[id*="retail"] button[class*="cookie-settings"]',

		'div[class*="gdpr"] button[class*="reject"],\
		 div[class*="gdpr"] button[class*="decline"],\
		 div[class*="gdpr"] button[class*="settings"],\
		 div[id*="gdpr"] button[class*="reject"],\
		 div[id*="gdpr"] button[class*="decline"],\
		 div[id*="gdpr"] button[class*="settings"]',

		'div[class*="privacy"] button[class*="reject"],\
		 div[class*="privacy"] button[class*="decline"],\
		 div[class*="privacy"] button[class*="settings"],\
		 div[id*="privacy"] button[class*="reject"],\
		 div[id*="privacy"] button[class*="decline"],\
		 div[id*="privacy"] button[class*="settings"]',

		'div[class*="bank"] button[class*="cookie-reject"],\
		 div[class*="bank"] button[class*="cookie-decline"],\
		 div[class*="bank"] button[class*="cookie-settings"],\
		 div[id*="bank"] button[class*="cookie-reject"],\
		 div[id*="bank"] button[class*="cookie-decline"],\
		 div[id*="bank"] button[class*="cookie-settings"]',

		'div[class*="consent"] button[class*="reject"],\
		 div[class*="consent"] button[class*="decline"],\
		 div[class*="consent"] button[class*="settings"],\
		 div[id*="consent"] button[class*="reject"],\
		 div[id*="consent"] button[class*="decline"],\
		 div[id*="consent"] button[class*="settings"]',

		'div[class*="notice"] button[class*="reject"],\
		 div[class*="notice"] button[class*="decline"],\
		 div[class*="notice"] button[class*="settings"],\
		 div[id*="notice"] button[class*="reject"],\
		 div[id*="notice"] button[class*="decline"],\
		 div[id*="notice"] button[class*="settings"]',

		'div[class*="popup"] button[class*="reject"],\
		 div[class*="popup"] button[class*="decline"],\
		 div[class*="popup"] button[class*="settings"],\
		 div[id*="popup"] button[class*="reject"],\
		 div[id*="popup"] button[class*="decline"],\
		 div[id*="popup"] button[class*="settings"]',

		'div[class*="eu-cookie-banner"] button[class*="reject"],\
		 div[class*="eu-cookie-banner"] button[class*="settings"]',

		'div[class*="gdpr-notice"] button[class*="reject"],\
		 div[class*="gdpr-notice"] button[class*="settings"]',

		'div[class*="privacy-consent"] button[class*="reject"],\
		 div[class*="privacy-consent"] button[class*="settings"]',

		'div[class*="asia"] button[class*="cookie-reject"],\
		 div[class*="asia"] button[class*="cookie-decline"],\
		 div[class*="asia"] button[class*="cookie-settings"]',

		'div[class*="europe"] button[class*="cookie-reject"],\
		 div[class*="europe"] button[class*="cookie-decline"],\
		 div[class*="europe"] button[class*="cookie-settings"]',

		'div[class*="global"] button[class*="cookie-reject"],\
		 div[class*="global"] button[class*="cookie-decline"],\
		 div[class*="global"] button[class*="cookie-settings"]',

		'div[class*="america"] button[class*="cookie-reject"],\
		 div[class*="america"] button[class*="cookie-decline"],\
		 div[class*="america"] button[class*="cookie-settings"]',

		'div[class*="oceania"] button[class*="cookie-reject"],\
		 div[class*="oceania"] button[class*="cookie-decline"],\
		 div[class*="oceania"] button[class*="cookie-settings"]',
	];

	let currentChainElement = 0;
	const classname = Math.random()
		.toString(36)
		.replace(/[^a-z]+/g, '');

	// Search loop function
	let searchGroupsLength = searchGroups.length,
		searchPairsKeys = Object.keys(searchPairs),
		searchPairsJoinedKeys = searchPairsKeys.join(','),
		timeoutDuration = 300;

	function querySelectorAllShadowRoot(selector, root = document) {
		const elements = [];
		const findElements = node => {
			if (node.shadowRoot) {
				node.shadowRoot.querySelectorAll(selector).forEach(el => elements.push(el));
				node.shadowRoot.querySelectorAll('*').forEach(findElements);
			}
		};
		root.querySelectorAll('*').forEach(findElements);
		return elements;
	}

	function searchLoop(counter) {
		if (document.cookie.indexOf('cookie_consent') !== -1) {
			return;
		}

		const dynamicTimeout = Math.min(timeoutDuration * (counter + 1), 2000);

		setTimeout(function () {
			document.querySelectorAll(searchPairsJoinedKeys).forEach(function (box) {
				searchPairsKeys.forEach(function (selector) {
					if (box.matches(selector)) {
						const shadowElements = querySelectorAllShadowRoot(searchPairs[selector].join(','), box);
						shadowElements.forEach(button => {
							if (button.click && !button.classList.contains(classname)) {
								button.classList.add(classname);

								if (typeof chrome == 'object' && chrome.runtime) chrome.runtime.sendMessage({ command: 'cookie_warning_dismissed', url: document.location.href });

								button.click();

								if (selector != '.message-container' && button.getAttribute('href') != '#cookieman-settings')
									setTimeout(function () {
										if (button) button.click();
									}, 500);

								timeoutDuration += 500;
							}
						});
					}
				});
			});

			document.querySelectorAll(searchGroups[counter % searchGroupsLength]).forEach(function (element) {
				if (element.click && !element.classList.contains(classname)) {
					element.classList.add(classname);

					if (typeof chrome == 'object' && chrome.runtime) chrome.runtime.sendMessage({ command: 'cookie_warning_dismissed', url: document.location.href });

					element.click();

					if (element.getAttribute('aria-pressed') != 'true')
						setTimeout(function () {
							if (element) element.click();
						}, 500);

					timeoutDuration += 500;
				}
			});

			if (counter < 100 * searchGroupsLength) {
				searchLoop(counter + 1);
			}
		}, dynamicTimeout);
	}

	// Embeds handling
	function handleEmbeds() {
		var l = document.location,
			is_audioboom = false,
			is_dailymotion = false,
			is_dailybuzz = false,
			is_playerclipslaliga = false;

		switch (l.hostname) {
			case 'embeds.audioboom.com':
				is_audioboom = true;
				break;

			case 'dailymotion.com':
			case 'www.dailymotion.com':
				is_dailymotion = l.pathname.indexOf('/embed') === 0;
				break;

			case 'geo.dailymotion.com':
				is_dailymotion = l.pathname.indexOf('/player') === 0;
				break;

			case 'dailybuzz.nl':
				is_dailybuzz = l.pathname.indexOf('/buzz/embed') === 0;
				break;

			case 'playerclipslaliga.tv':
				is_playerclipslaliga = true;
				break;
		}

		function searchEmbeds() {
			setTimeout(function () {
				if (is_audioboom) {
					document.querySelectorAll('div[id^="cookie-modal"] .modal[style*="block"] .btn.mrs:not(.' + classname + ')').forEach(function (button) {
						button.className += ' ' + classname;
						button.click();
					});
				} else if (is_dailymotion) {
					document.querySelectorAll('.np_DialogConsent-accept:not(.' + classname + '), .consent_screen-accept:not(.' + classname + ')').forEach(function (button) {
						button.className += ' ' + classname;
						button.click();
					});
				} else if (is_dailybuzz) {
					document.querySelectorAll('#ask-consent #accept:not(.' + classname + ')').forEach(function (button) {
						button.className += ' ' + classname;
						button.click();
					});
				} else if (is_playerclipslaliga) {
					document.querySelectorAll('#cookies button[onclick*="saveCookiesSelection"]:not(.' + classname + ')').forEach(function (button) {
						button.className += ' ' + classname;
						button.click();
					});
				} else {
					return;
				}

				searchEmbeds();
			}, 1000);
		}

		searchEmbeds();
	}

	// Initialize
	var start = setInterval(function () {
		var html = document.querySelector('html');

		if (!html || /idc0_350/.test(html.className)) return;

		clearInterval(start);

		html.className += ' idc0_350';
		searchLoop(0);
		handleEmbeds();
	}, 500);

	var hostname = document.location.hostname.replace(/^w{2,3}\d*\./i, ''),
		items = getItem(hostname);

	if (items) {
		(items instanceof Array ? items : [items]).forEach(function (item) {
			let value = localStorage.getItem(item.key);
			if (value == null || (item.strict && value != item.value)) {
				localStorage.setItem(item.key, item.value);
				counter++;
			}
		});

		if (counter > 0) document.location.reload();
	}
})();
