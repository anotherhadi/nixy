// ==UserScript==
// @name         TrackingTokenStripper
// @version      1.4
// @description  Remove most of the annoying tracking token from URL parameters
// @license      MIT
// @homepage     https://blog.miniasp.com/
// @homepageURL  https://blog.miniasp.com/
// @website      https://www.facebook.com/will.fans
// @source       https://github.com/doggy8088/TrackingTokenStripper/raw/refs/heads/master/TrackingTokenStripper.user.js
// @namespace    https://github.com/doggy8088/TrackingTokenStripper
// @author       Will Huang
// @match        *://*/*
// @run-at       document-start
// ==/UserScript==

(function () {
    'use strict';

    const oldReplaceState = history.replaceState;
    history.replaceState = function replaceState() {
        let ret = oldReplaceState.apply(this, arguments);
        window.dispatchEvent(new Event('replacestate'));
        window.dispatchEvent(new Event('locationchange'));
        return ret;
    };

    window.addEventListener('popstate', () => {
        window.dispatchEvent(new Event('locationchange'));
    });

    window.addEventListener('locationchange', function () {
        executeActions();
    });

    executeActions();

    let id = setInterval(executeActions, 500);

    setTimeout(() => { clearInterval(id); }, 2000);

    function executeActions() {

        var s = TrackingTokenStripper(location.href)
            // facebook
            .remove('fbclid')
            .removeByDomain('www.facebook.com', 'privacy_mutation_token')
            .removeByDomain('www.facebook.com', 'acontext')
            .removeByDomain('www.facebook.com', '__xts__[0]')
            .removeByDomain('www.facebook.com', 'notif_t')
            .removeByDomain('www.facebook.com', 'notif_id')
            .removeByDomain('www.facebook.com', 'notif_ids[0]')
            .removeByDomain('www.facebook.com', 'notif_ids[1]')
            .removeByDomain('www.facebook.com', 'notif_ids[2]')
            .removeByDomain('www.facebook.com', 'notif_ids[3]')
            .removeByDomain('www.facebook.com', 'ref', 'notif')
            .removeByDomain('www.facebook.com', 'ref=watch_permalink')

            // Dropbox
            .removeByDomain('www.dropbox.com', '_ad')
            .removeByDomain('www.dropbox.com', '_camp')
            .removeByDomain('www.dropbox.com', '_tk')

            // YouTube
            // https://youtu.be/4f-Y9G5ENPc?si=SHSu2hEdSbXGy4_Q
            // https://www.youtube.com/embed/4f-Y9G5ENPc?si=GQFJV_nKMXxpiQb6
            .removeByDomain('youtu.be', 'si')
            .removeByDomain('www.youtube.com', 'si')

            // Google Analytics
            // https://support.google.com/analytics/answer/1033863?hl=en
            .remove('utm_id')
            .remove('utm_source')
            .remove('utm_medium')
            .remove('utm_campaign')
            .remove('utm_term')
            .remove('utm_content')
            .remove('_ga')

            // GA - others
            .remove('utm_campaignid')
            .remove('utm_cid')
            .remove('utm_reader')
            .remove('utm_referrer')
            .remove('utm_name')
            .remove('utm_social')
            .remove('utm_social-type')
            .remove('gclid')
            .remove('igshid')
            .remove('_hsenc')
            .remove('_hsmi')
            .remove('mc_cid')
            .remove('mc_eid')
            .remove('mkt_tok')
            .remove('yclid')
            .remove('_openstat')

            // devblogs.microsoft.com
            .removeByDomain('devblogs.microsoft.com', 'utm_issue')
            .removeByDomain('devblogs.microsoft.com', 'utm_position')
            .removeByDomain('devblogs.microsoft.com', 'utm_topic')
            .removeByDomain('devblogs.microsoft.com', 'utm_section')
            .removeByDomain('devblogs.microsoft.com', 'utm_cta')
            .removeByDomain('devblogs.microsoft.com', 'utm_description')
            .removeByDomain('devblogs.microsoft.com', 'ocid')

            // Microsoft
            .remove('wt.mc_id')
            .removeByDomain('learn.microsoft.com', 'ocid')
            .removeByDomain('learn.microsoft.com', 'redirectedfrom')

            .removeByDomain('azure.microsoft.com', 'OCID')
            .removeByDomain('azure.microsoft.com', 'ef_id')

            .removeByDomain('www.msn.com', 'ocid')
            .removeByDomain('www.msn.com', 'cvid')

            // bilibili
            .removeByDomain('www.bilibili.com', 'share_source')
            .removeByDomain('www.bilibili.com', 'share_medium')

            // Others
            .remove('__tn__')
            .remove('gclsrc')
            .remove('itm_source')
            .remove('itm_medium')
            .remove('itm_campaign')
            .remove('mc') // sendgrid.com
            .remove('mcd') // sendgrid.com
            .remove('cvosrc') // sendgrid.com
            .remove('cr_cc') // https://blogs.microsoft.com/

            .remove('sc_channel')
            .remove('sc_campaign')
            .remove('sc_geo')
            .remove('trk')
            .remove('sc_publisher')
            .remove('trkCampaign')
            .remove('sc_outcome')
            .remove('sc_country')

            .remove('__hstc')
            .remove('__hssc')
            .remove('__hsfp')
            .remove('_gl')

            // Yahoo News
            .remove('guce_referrer')
            .remove('guce_referrer_sig')

            .toString();

        if (s && location.href !== s) {
            // console.log('Changing URL', s);
            // location.href = s;
            oldReplaceState.apply(history, [{}, '', s]);
        }

        function TrackingTokenStripper(url) {
            const parsedUrl = new URL(url);
            return {
                remove(name, value) {
                    if (parsedUrl.searchParams.has(name)) {
                        if (value && value === parsedUrl.searchParams.get(name)) {
                            parsedUrl.searchParams.delete(name);
                        }
                        if (!value) {
                            parsedUrl.searchParams.delete(name);
                        }
                    }
                    return TrackingTokenStripper(parsedUrl.toString());
                },
                removeByDomain(domain, name) {
                    if (parsedUrl.hostname.toLocaleLowerCase() === domain.toLocaleLowerCase()) {
                        if (name.indexOf('=') >= 0) {
                            var [key, value] = name.split("=");
                            return this.remove(key, value);
                        } else {
                            return this.remove(name);
                        }
                    } else {
                        return this;
                    }
                },
                toString() {
                    return parsedUrl.toString();
                }
            }
        }
    }

})();
