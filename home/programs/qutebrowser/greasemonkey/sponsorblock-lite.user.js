// ==UserScript==
// @name         SponsorBlock Lite
// @name:en      SponsorBlock Lite - Auto-skip sponsor segments on YouTube and Bilibili
// @name:zh-CN   SponsorBlock Lite - 自动跳过 YouTube/Bilibili 赞助内容
// @name:zh-TW   SponsorBlock Lite - 自動跳過 YouTube/Bilibili 贊助內容
// @name:ja      SponsorBlock Lite - YouTube/Bilibili スポンサー自動スキップ
// @name:ko      SponsorBlock Lite - YouTube/Bilibili 스폰서 자동 건너뛰기
// @name:de      SponsorBlock Lite - YouTube/Bilibili Sponsoren überspringen
// @name:fr      SponsorBlock Lite - Ignorer les sponsors YouTube/Bilibili
// @name:es      SponsorBlock Lite - Saltar patrocinadores YouTube/Bilibili
// @name:it      SponsorBlock Lite - Salta sponsor YouTube/Bilibili
// @namespace    https://github.com/hxueh
// @version      1.1.1
// @description  Auto-skip sponsor segments on YouTube and Bilibili using SponsorBlock API
// @description:en Auto-skip sponsor segments on YouTube and Bilibili using SponsorBlock API
// @description:zh-CN 基于 SponsorBlock API 自动跳过 YouTube 和 Bilibili 视频中的赞助片段
// @description:zh-TW 基於 SponsorBlock API 自動跳過 YouTube 和 Bilibili 影片中的贊助片段
// @description:ja    SponsorBlock API を使用して YouTube と Bilibili 動画のスポンサーセグメントを自動的にスキップします
// @description:ko    SponsorBlock API를 사용하여 YouTube 및 Bilibili 동영상의 스폰서 구간을 자동으로 건너뜁니다
// @description:de    Überspringen Sie Sponsorensegmente in YouTube- und Bilibili-Videos automatisch mit der SponsorBlock-API
// @description:fr    Ignorez automatiquement les segments sponsorisés dans les vidéos YouTube et Bilibili via l'API SponsorBlock
// @description:es    Salte automáticamente los segmentos de patrocinadores en videos de YouTube y Bilibili usando la API de SponsorBlock
// @description:it    Salta automaticamente i segmenti degli sponsor nei video di YouTube e Bilibili utilizzando l'API SponsorBlock
// @author       hxueh
// @match        https://www.youtube.com/*
// @match        https://music.youtube.com/*
// @match        https://m.youtube.com/*
// @match        https://*.bilibili.com/video/*
// @icon         https://sponsor.ajay.app/LogoSponsorBlock256px.png
// @grant        GM_xmlhttpRequest
// @grant        GM_addStyle
// @connect      sponsor.ajay.app
// @connect      bsbsb.top
// @run-at       document-idle
// @license      LGPL-3.0-or-later
// @downloadURL https://update.greasyfork.org/scripts/560869/SponsorBlock%20Lite.user.js
// @updateURL https://update.greasyfork.org/scripts/560869/SponsorBlock%20Lite.meta.js
// ==/UserScript==

(function () {
    "use strict";

    // ==================== CONSTANTS ====================

    // Platform detection (must be first for other constants to use)
    const IS_BILIBILI = window.location.hostname.includes("bilibili.com");

    const API_BASE_YOUTUBE = "https://sponsor.ajay.app";
    const API_BASE_BILIBILI = "https://bsbsb.top";
    const API_BASE = IS_BILIBILI ? API_BASE_BILIBILI : API_BASE_YOUTUBE;
    const CATEGORIES = [
        "sponsor",
        "selfpromo",
        "exclusive_access",
        "interaction",
        "outro",
        "music_offtopic",
    ];
    const ACTION_TYPES = ["skip", "full"];
    const SKIP_BUFFER = 0.003;

    // Colors for all categories (used in preview bar and category pill)
    const CATEGORY_COLORS = {
        sponsor: "#00d400",
        selfpromo: "#ffff00",
        exclusive_access: "#008a5c",
        interaction: "#cc00ff",
        outro: "#0202ed",
        music_offtopic: "#ff9900",
    };

    const CATEGORY_LABELS = {
        exclusive_access: "Exclusive Access",
        music_offtopic: "Music: Non-Music",
    };

    // ==================== STATE ====================

    let currentVideoID = null;
    let segments = [];
    let skippableSegments = [];
    let skipScheduleTimer = null;
    let video = null;
    let lastSkippedUUID = null;
    let currentSegmentIndex = 0;
    let videoChangeDebounce = null;
    let previewBarContainer = null;
    let videoDuration = 0;
    let lastUrl = location.href;
    let urlPollInterval = null;
    let videoObserver = null;
    let rafSkipId = null; // For requestAnimationFrame-based skipping
    let lastVideoSrc = null; // Track video element replacement

    // Platform detection
    const IS_MUSIC_YOUTUBE = window.location.hostname === "music.youtube.com";
    const IS_MOBILE_YOUTUBE = window.location.hostname === "m.youtube.com";

    // Vinegar detection - now a function that's called when needed
    let IS_VINEGAR = false;

    function updateVinegarDetection() {
        const hasVideo = document.querySelector("video") !== null;
        const hasYouTubePlayer = document.querySelector("#movie_player, ytm-player, #player") !== null;
        const hasYouTubeProgressBar = document.querySelector(".ytp-progress-bar, .progress-bar-line") !== null;
        // Vinegar: video exists but no YouTube player components
        const detected = hasVideo && !hasYouTubePlayer && !hasYouTubeProgressBar;

        if (detected && !IS_VINEGAR) {
            IS_VINEGAR = true;
            log("Vinegar/native video mode detected");
        }

        return IS_VINEGAR;
    }

    // ==================== CSS INJECTION ====================

    function injectStyles() {
        const css = `
            /* Desktop YouTube styles */
            #sb-lite-previewbar {
                position: absolute;
                width: 100%;
                height: 100%;
                padding: 0;
                margin: 0;
                overflow: visible;
                pointer-events: none;
                z-index: 42;
                list-style: none;
                transform: scaleY(0.6);
                transition: transform 0.1s cubic-bezier(0, 0, 0.2, 1);
            }

            /* Expand on hover (desktop) */
            .ytp-progress-bar:hover #sb-lite-previewbar {
                transform: scaleY(1);
            }

            /* Fullscreen mode (desktop) */
            .ytp-big-mode #sb-lite-previewbar {
                transform: scaleY(0.625);
            }

            .ytp-big-mode .ytp-progress-bar:hover #sb-lite-previewbar {
                transform: scaleY(1);
            }

            /* Mobile YouTube styles */
            .advancement-bar-line #sb-lite-previewbar,
            .advancement-bar #sb-lite-previewbar,
            .progress-bar-line #sb-lite-previewbar {
                position: absolute;
                width: 100%;
                height: 100%;
                top: 0;
                left: 0;
                padding: 0;
                margin: 0;
                overflow: visible;
                pointer-events: none;
                z-index: 42;
                list-style: none;
                transform: none;
            }

            .sb-lite-segment {
                position: absolute;
                height: 100%;
                min-width: 1px;
                display: inline-block;
                opacity: 0.7;
            }

            .sb-lite-segment:hover {
                opacity: 1;
            }

            #sb-lite-category-pill {
                display: none;
                align-items: center;
                padding: 4px 12px;
                border-radius: 4px;
                font-size: 12px;
                font-weight: 500;
                margin-left: 8px;
                color: white;
                font-family: Roboto, Arial, sans-serif;
                white-space: nowrap;
                cursor: default;
                user-select: none;
            }

            /* Mobile category pill adjustments */
            .ytm-slim-owner-container #sb-lite-category-pill,
            ytm-slim-owner-renderer #sb-lite-category-pill {
                font-size: 10px;
                padding: 2px 8px;
                margin-left: 4px;
            }

            /* Bilibili styles */
            .bpx-player-progress-wrap #sb-lite-previewbar,
            .bpx-player-progress #sb-lite-previewbar,
            .bilibili-player-video-progress #sb-lite-previewbar,
            .squirtle-progress-wrap #sb-lite-previewbar {
                position: absolute;
                width: 100%;
                height: 100%;
                top: 0;
                left: 0;
                padding: 0;
                margin: 0;
                overflow: visible;
                pointer-events: none;
                z-index: 42;
                list-style: none;
                transform: none;
            }

            /* Bilibili category pill adjustments */
            .video-title #sb-lite-category-pill,
            .video-info-title #sb-lite-category-pill {
                font-size: 12px;
                padding: 2px 8px;
                margin-left: 8px;
            }
        `;

        if (typeof GM_addStyle !== "undefined") {
            GM_addStyle(css);
        } else {
            const style = document.createElement("style");
            style.textContent = css;
            document.head.appendChild(style);
        }
    }

    // ==================== UTILITY FUNCTIONS ====================

    async function sha256(message) {
        const msgBuffer = new TextEncoder().encode(message);
        const hashBuffer = await crypto.subtle.digest("SHA-256", msgBuffer);
        const hashArray = Array.from(new Uint8Array(hashBuffer));
        return hashArray.map((b) => b.toString(16).padStart(2, "0")).join("");
    }

    async function getHashPrefix(videoID) {
        const hash = await sha256(videoID);
        return hash.slice(0, 4);
    }

    function getBilibiliVideoID() {
        const url = window.location.href;
        const patterns = [
            /\/video\/([^/?#]+)/,
            /\/BV([^/?#]+)/,
            /bvid=([^&]+)/,
        ];
        for (const pattern of patterns) {
            const match = url.match(pattern);
            if (match) {
                let videoId = match[1];
                if (!videoId.startsWith("BV")) {
                    videoId = "BV" + videoId;
                }
                return videoId;
            }
        }
        return null;
    }

    function getVideoID() {
        if (IS_BILIBILI) {
            return getBilibiliVideoID();
        }

        const url = new URL(window.location.href);

        const vParam = url.searchParams.get("v");
        if (vParam && /^[a-zA-Z0-9_-]{11}$/.test(vParam)) {
            return vParam;
        }

        const shortsMatch = url.pathname.match(/\/shorts\/([a-zA-Z0-9_-]{11})/);
        if (shortsMatch) return shortsMatch[1];

        const embedMatch = url.pathname.match(/\/embed\/([a-zA-Z0-9_-]{11})/);
        if (embedMatch) return embedMatch[1];

        const liveMatch = url.pathname.match(/\/live\/([a-zA-Z0-9_-]{11})/);
        if (liveMatch) return liveMatch[1];

        // Mobile watch URL pattern
        const watchMatch = url.pathname.match(/\/watch\/([a-zA-Z0-9_-]{11})/);
        if (watchMatch) return watchMatch[1];

        return null;
    }

    function getVideoDuration() {
        return video?.duration || 0;
    }

    function log(message, ...args) {
        console.log(
            `[SB Lite${IS_BILIBILI ? " Bilibili" : IS_VINEGAR ? " Vinegar" : IS_MOBILE_YOUTUBE ? " Mobile" : ""}]`,
            message,
            ...args,
        );
    }

    function logError(message, ...args) {
        console.error(
            `[SB Lite${IS_BILIBILI ? " Bilibili" : IS_VINEGAR ? " Vinegar" : IS_MOBILE_YOUTUBE ? " Mobile" : ""}]`,
            message,
            ...args,
        );
    }

    // ==================== API FUNCTIONS ====================

    function fetchSegments(videoID) {
        return new Promise(async (resolve) => {
            try {
                const hashPrefix = await getHashPrefix(videoID);
                const params = new URLSearchParams({
                    categories: JSON.stringify(CATEGORIES),
                    actionTypes: JSON.stringify(ACTION_TYPES),
                });

                GM_xmlhttpRequest({
                    method: "GET",
                    url: `${API_BASE}/api/skipSegments/${hashPrefix}?${params}`,
                    headers: { Accept: "application/json" },
                    onload(response) {
                        if (response.status === 200) {
                            try {
                                const data = JSON.parse(response.responseText);
                                const videoData = data.find((v) => v.videoID === videoID);
                                const segs = videoData?.segments || [];
                                segs.sort((a, b) => a.segment[0] - b.segment[0]);
                                resolve(segs);
                            } catch {
                                resolve([]);
                            }
                        } else {
                            resolve([]);
                        }
                    },
                    onerror() {
                        resolve([]);
                    },
                });
            } catch {
                resolve([]);
            }
        });
    }

    // ==================== SKIP LOGIC ====================

    function computeSkippableSegments() {
        skippableSegments = segments.filter((s) => {
            if (s.actionType === "full") return false;
            if (s.category === "music_offtopic" && !IS_MUSIC_YOUTUBE) return false;
            return true;
        });
        currentSegmentIndex = 0;
    }

    function skipToTime(targetTime, retryCount = 0) {
        if (!video || targetTime === undefined) return false;

        const maxRetries = 3;
        const previousTime = video.currentTime;

        try {
            video.currentTime = targetTime;

            // On iOS/Vinegar, verify the skip worked after a short delay
            if (IS_VINEGAR && retryCount < maxRetries) {
                setTimeout(() => {
                    // Check if we're still in a segment that should be skipped
                    // (meaning the skip might have failed)
                    const currentTime = video.currentTime;
                    const timeDiff = Math.abs(currentTime - targetTime);

                    // If we're more than 0.5s away from target and still before target,
                    // the skip likely failed
                    if (timeDiff > 0.5 && currentTime < targetTime - 0.5) {
                        log(`Skip verification failed (attempt ${retryCount + 1}), retrying...`);
                        skipToTime(targetTime, retryCount + 1);
                    }
                }, 100);
            }

            return true;
        } catch (e) {
            logError("Skip failed:", e);
            return false;
        }
    }

    function findNextSegment(currentTime) {
        if (
            currentSegmentIndex > 0 &&
            skippableSegments[currentSegmentIndex - 1] &&
            currentTime < skippableSegments[currentSegmentIndex - 1].segment[0]
        ) {
            currentSegmentIndex = 0;
        }

        while (currentSegmentIndex < skippableSegments.length) {
            const seg = skippableSegments[currentSegmentIndex];
            if (currentTime < seg.segment[1] - SKIP_BUFFER) {
                return { segment: seg, index: currentSegmentIndex };
            }
            currentSegmentIndex++;
        }
        return null;
    }

    // RAF-based skip loop for Vinegar (more responsive than timeupdate)
    function startRAFSkipLoop() {
        if (rafSkipId) {
            cancelAnimationFrame(rafSkipId);
        }

        function checkAndSkip() {
            if (!video || !skippableSegments.length) {
                rafSkipId = null;
                return;
            }

            // Check for video element replacement
            if (IS_VINEGAR) {
                const currentVideo = document.querySelector("video");
                if (currentVideo && currentVideo !== video) {
                    log("Video element replaced, re-attaching...");
                    video = currentVideo;
                    setupVideoListeners();
                }
            }

            if (!video.paused) {
                const currentTime = video.currentTime;

                for (const seg of skippableSegments) {
                    const [startTime, endTime] = seg.segment;
                    if (
                        currentTime >= startTime - SKIP_BUFFER &&
                        currentTime < endTime - SKIP_BUFFER &&
                        lastSkippedUUID !== seg.UUID
                    ) {
                        lastSkippedUUID = seg.UUID;
                        log(`Skipping ${seg.category} segment at ${currentTime.toFixed(2)}s -> ${endTime.toFixed(2)}s`);
                        skipToTime(endTime);
                        break;
                    }
                }
            }

            rafSkipId = requestAnimationFrame(checkAndSkip);
        }

        rafSkipId = requestAnimationFrame(checkAndSkip);
    }

    function stopRAFSkipLoop() {
        if (rafSkipId) {
            cancelAnimationFrame(rafSkipId);
            rafSkipId = null;
        }
    }

    function scheduleSkips() {
        // For Vinegar/iOS, use RAF-based skipping for better responsiveness
        if (IS_VINEGAR || IS_MOBILE_YOUTUBE) {
            if (!video?.paused && skippableSegments.length > 0) {
                startRAFSkipLoop();
            }
            return;
        }

        // Desktop: use timer-based approach
        if (skipScheduleTimer) {
            clearTimeout(skipScheduleTimer);
            skipScheduleTimer = null;
        }

        if (!video || video.paused || !skippableSegments.length) return;

        const currentTime = video.currentTime;
        const result = findNextSegment(currentTime);

        if (!result) return;

        const { segment: nextSegment } = result;
        const [startTime, endTime] = nextSegment.segment;

        if (currentTime >= startTime - SKIP_BUFFER) {
            if (lastSkippedUUID !== nextSegment.UUID) {
                lastSkippedUUID = nextSegment.UUID;
                log(`Skipping ${nextSegment.category} segment`);
                skipToTime(endTime);
                currentSegmentIndex++;
            }
            setTimeout(scheduleSkips, 50);
            return;
        }

        const timeUntilStart = (startTime - currentTime) / video.playbackRate;
        const delayMs = Math.max(0, timeUntilStart * 1000 - 50);

        skipScheduleTimer = setTimeout(() => {
            if (!video || video.paused) return;

            const nowTime = video.currentTime;
            if (
                nowTime >= startTime - SKIP_BUFFER &&
                nowTime < endTime - SKIP_BUFFER
            ) {
                if (lastSkippedUUID !== nextSegment.UUID) {
                    lastSkippedUUID = nextSegment.UUID;
                    log(`Skipping ${nextSegment.category} segment`);
                    skipToTime(endTime);
                    currentSegmentIndex++;
                }
            }
            scheduleSkips();
        }, delayMs);
    }

    // ==================== PREVIEW BAR ====================

    function createPreviewBar() {
        const container = document.createElement("ul");
        container.id = "sb-lite-previewbar";
        return container;
    }

    function createSegmentBar(segment, duration) {
        const bar = document.createElement("li");
        bar.className = "sb-lite-segment";

        const startTime = segment.segment[0];
        const endTime = Math.min(segment.segment[1], duration);

        const startPercent = (startTime / duration) * 100;
        const endPercent = (endTime / duration) * 100;

        bar.style.left = `${startPercent}%`;
        bar.style.right = `${100 - endPercent}%`;
        bar.style.backgroundColor = CATEGORY_COLORS[segment.category] || "#888";

        // Add title tooltip
        bar.title = segment.category.replace(/_/g, " ");

        return bar;
    }

    function getProgressBar() {
        // Bilibili
        if (IS_BILIBILI) {
            return (
                document.querySelector(".bpx-player-progress-wrap") ||
                document.querySelector(".bilibili-player-video-progress") ||
                document.querySelector(".squirtle-progress-wrap") ||
                document.querySelector(".bpx-player-progress")
            );
        }

        // Desktop YouTube
        let progressBar = document.querySelector(".ytp-progress-bar");

        // YouTube Music
        if (!progressBar && IS_MUSIC_YOUTUBE) {
            progressBar = document.querySelector("#progress-bar");
        }

        // Mobile YouTube - try multiple selectors
        if (!progressBar && IS_MOBILE_YOUTUBE) {
            progressBar =
                document.querySelector(".progress-bar-line") ||
                document.querySelector(".advancement-bar-line") ||
                document.querySelector(".advancement-bar") ||
                document.querySelector("ytm-player .progress-bar") ||
                document.querySelector(".player-controls-content .progress-bar-line") ||
                document.querySelector("[class*='progress-bar']");
        }

        return progressBar;
    }

    function clearPreviewBar() {
        if (previewBarContainer) {
            previewBarContainer.innerHTML = "";
        }
    }

    function removePreviewBar() {
        if (previewBarContainer) {
            previewBarContainer.remove();
            previewBarContainer = null;
        }
    }

    function updatePreviewBar() {
        const duration = getVideoDuration();
        if (!duration || duration <= 0) return;

        videoDuration = duration;

        // Get or create container
        if (!previewBarContainer) {
            previewBarContainer = createPreviewBar();
        }

        // Attach to progress bar if not already attached
        const progressBar = getProgressBar();
        if (progressBar && !progressBar.contains(previewBarContainer)) {
            // Ensure progress bar has relative positioning for absolute children
            const computedStyle = window.getComputedStyle(progressBar);
            if (computedStyle.position === "static") {
                progressBar.style.position = "relative";
            }
            progressBar.appendChild(previewBarContainer);
        }

        if (!progressBar) {
            // For Vinegar, this is expected since native controls can't be modified
            if (IS_VINEGAR) {
                log("Preview bar not available (Vinegar/native controls)");
            } else {
                log("Progress bar not found, will retry...");
            }
            return;
        }

        // Clear existing bars
        clearPreviewBar();

        // Filter segments for preview bar (exclude ActionType.Full)
        const previewSegments = segments.filter((s) => s.actionType !== "full");

        // Sort by duration (longer first) to render properly
        const sortedSegments = [...previewSegments].sort(
            (a, b) => b.segment[1] - b.segment[0] - (a.segment[1] - a.segment[0]),
        );

        // Create segment bars
        for (const segment of sortedSegments) {
            // Skip music_offtopic on non-music YouTube
            if (segment.category === "music_offtopic" && !IS_MUSIC_YOUTUBE) {
                continue;
            }

            const bar = createSegmentBar(segment, duration);
            previewBarContainer.appendChild(bar);
        }
    }

    // ==================== CATEGORY PILL ====================

    function createCategoryPill() {
        const pill = document.createElement("span");
        pill.id = "sb-lite-category-pill";
        return pill;
    }

    function attachCategoryPill() {
        let pill = document.getElementById("sb-lite-category-pill");
        if (!pill) {
            pill = createCategoryPill();
        }

        let titleContainer = null;

        if (IS_BILIBILI) {
            // Bilibili title selectors
            titleContainer =
                document.querySelector(".video-title") ||
                document.querySelector(".title-text") ||
                document.querySelector("h1.video-title") ||
                document.querySelector(".video-info-title");
        } else if (IS_MUSIC_YOUTUBE) {
            titleContainer = document.querySelector("ytmusic-player-bar .title");
        } else if (IS_MOBILE_YOUTUBE) {
            // Mobile YouTube title selectors
            titleContainer =
                document.querySelector(
                    ".slim-video-metadata-header .slim-owner-icon-and-title",
                ) ||
                document.querySelector("ytm-slim-owner-renderer") ||
                document.querySelector(".slim-video-information-title") ||
                document.querySelector(".slim-video-metadata-title") ||
                document.querySelector("[class*='video-title']") ||
                document.querySelector("h2.slim-video-information-title");
        } else {
            // Desktop YouTube
            titleContainer =
                document.querySelector("#above-the-fold #title h1") ||
                document.querySelector("ytd-watch-metadata #title h1") ||
                document.querySelector("#info-contents h1") ||
                document.querySelector("h1.ytd-video-primary-info-renderer");
        }

        if (titleContainer && !titleContainer.contains(pill)) {
            titleContainer.style.display = "flex";
            titleContainer.style.alignItems = "center";
            titleContainer.style.flexWrap = "wrap";
            titleContainer.appendChild(pill);
        }

        return pill;
    }

    function showCategoryPill(segment) {
        const pill = attachCategoryPill();
        if (!pill) return;

        const label = CATEGORY_LABELS[segment.category] || segment.category;
        const color = CATEGORY_COLORS[segment.category] || "#008a5c";

        pill.textContent = label;
        pill.style.backgroundColor = color;
        pill.style.display = "inline-flex";
    }

    function hideCategoryPill() {
        const pill = document.getElementById("sb-lite-category-pill");
        if (pill) {
            pill.style.display = "none";
        }
    }

    function updateCategoryPill() {
        const fullVideoSegment = segments.find((s) => s.actionType === "full");
        if (fullVideoSegment) {
            showCategoryPill(fullVideoSegment);
        } else {
            hideCategoryPill();
        }
    }

    // ==================== VIDEO LISTENERS ====================

    function setupVideoListeners() {
        if (!video) return;

        // Re-check Vinegar detection now that we have a video
        updateVinegarDetection();

        const videoId = video.getAttribute("data-sb-lite-initialized");
        const currentSrc = video.currentSrc || video.src;

        // Check if this is a new video or if the source changed
        if (videoId === currentVideoID && lastVideoSrc === currentSrc) return;

        video.setAttribute("data-sb-lite-initialized", currentVideoID);
        lastVideoSrc = currentSrc;

        log("Setting up video listeners" + (IS_VINEGAR ? " (Vinegar mode)" : ""));

        // Remove any existing listeners by cloning (for Vinegar video replacement scenario)
        // We'll use named functions and track them instead

        const onPlay = () => {
            log("Video play event");
            scheduleSkips();
        };

        const onPlaying = () => {
            log("Video playing event");
            scheduleSkips();
        };

        const onSeeked = () => {
            log("Video seeked event");
            lastSkippedUUID = null;
            currentSegmentIndex = 0;
            if (!video.paused) {
                scheduleSkips();
            }
        };

        const onRateChange = () => {
            scheduleSkips();
        };

        const onPause = () => {
            log("Video pause event");
            if (skipScheduleTimer) {
                clearTimeout(skipScheduleTimer);
                skipScheduleTimer = null;
            }
            stopRAFSkipLoop();
        };

        const onDurationChange = () => {
            if (segments.length > 0) {
                updatePreviewBar();
            }
        };

        const onLoadedMetadata = () => {
            log("Video loadedmetadata event");
            if (segments.length > 0) {
                updatePreviewBar();
            }
        };

        video.addEventListener("play", onPlay);
        video.addEventListener("playing", onPlaying);
        video.addEventListener("seeked", onSeeked);
        video.addEventListener("ratechange", onRateChange);
        video.addEventListener("pause", onPause);
        video.addEventListener("durationchange", onDurationChange);
        video.addEventListener("loadedmetadata", onLoadedMetadata);

        // For Vinegar/iOS: also listen to timeupdate as backup
        // (RAF loop is primary, but timeupdate helps when app is backgrounded)
        if (IS_VINEGAR || IS_MOBILE_YOUTUBE) {
            const onTimeUpdate = () => {
                if (!video.paused && skippableSegments.length > 0) {
                    const currentTime = video.currentTime;
                    for (const seg of skippableSegments) {
                        const [startTime, endTime] = seg.segment;
                        if (
                            currentTime >= startTime &&
                            currentTime < endTime - SKIP_BUFFER &&
                            lastSkippedUUID !== seg.UUID
                        ) {
                            lastSkippedUUID = seg.UUID;
                            log(`Skipping ${seg.category} segment (timeupdate backup)`);
                            skipToTime(endTime);
                            break;
                        }
                    }
                }
            };
            video.addEventListener("timeupdate", onTimeUpdate);
        }

        // For Vinegar: Monitor for video element replacement
        if (IS_VINEGAR) {
            // Also start skip loop immediately if video is already playing
            if (!video.paused && skippableSegments.length > 0) {
                startRAFSkipLoop();
            }
        }
    }

    function findVideoElement() {
        // Bilibili selectors
        if (IS_BILIBILI) {
            video =
                document.querySelector(".bpx-player-video-area video") ||
                document.querySelector(".bilibili-player video") ||
                document.querySelector("video");
            return video;
        }

        // For Vinegar (or when YouTube player is replaced), just find any video element
        const anyVideo = document.querySelector("video");
        if (anyVideo) {
            // Check if this looks like a Vinegar setup (no YouTube player elements)
            const hasYouTubePlayer = document.querySelector("#movie_player, ytm-player") !== null;
            if (!hasYouTubePlayer) {
                if (!IS_VINEGAR) {
                    IS_VINEGAR = true;
                    log("Vinegar/native video detected");
                }
                video = anyVideo;
                return video;
            }
        }

        // Desktop selectors
        video =
            document.querySelector("video.html5-main-video") ||
            document.querySelector("video.video-stream") ||
            document.querySelector("#movie_player video");

        // Mobile selectors
        if (!video && IS_MOBILE_YOUTUBE) {
            video =
                document.querySelector("ytm-player video") ||
                document.querySelector(".player-container video") ||
                document.querySelector(".html5-video-container video") ||
                document.querySelector(".video-stream") ||
                document.querySelector("video[playsinline]") ||
                document.querySelector("video");
        }

        // Fallback
        if (!video) {
            video = document.querySelector("video");
        }

        return video;
    }

    // ==================== MUTATION OBSERVER FOR VIDEO ====================

    function setupVideoObserver() {
        if (videoObserver) {
            videoObserver.disconnect();
        }

        videoObserver = new MutationObserver((mutations) => {
            // Check if video element was added or replaced
            const currentVideo = document.querySelector("video");

            if (currentVideo && currentVideo !== video) {
                log("Video element change detected via observer");
                video = currentVideo;

                // Re-check Vinegar status
                updateVinegarDetection();

                if (currentVideoID) {
                    setupVideoListeners();
                    if (segments.length > 0 && !video.paused) {
                        scheduleSkips();
                    }
                }
            } else if (!currentVideo && video) {
                log("Video element removed");
                video = null;
                stopRAFSkipLoop();
            }
        });

        videoObserver.observe(document.body, {
            childList: true,
            subtree: true,
        });
    }

    // ==================== NAVIGATION & INITIALIZATION ====================

    function resetState() {
        currentVideoID = null;
        segments = [];
        skippableSegments = [];
        lastSkippedUUID = null;
        currentSegmentIndex = 0;
        videoDuration = 0;
        lastVideoSrc = null;

        if (skipScheduleTimer) {
            clearTimeout(skipScheduleTimer);
            skipScheduleTimer = null;
        }

        stopRAFSkipLoop();

        hideCategoryPill();
        removePreviewBar();
    }

    async function loadSegmentsAndSetup() {
        if (!currentVideoID) return;

        try {
            segments = await fetchSegments(currentVideoID);

            if (segments.length > 0) {
                log(`Found ${segments.length} segments for video ${currentVideoID}`);
            }

            computeSkippableSegments();
            updateCategoryPill();
            updatePreviewBar();
            setupVideoListeners();

            if (video && !video.paused) {
                scheduleSkips();
            }

            // Retry preview bar attachment after a delay (for slow-loading UI)
            if ((IS_MOBILE_YOUTUBE || IS_VINEGAR) && segments.length > 0) {
                setTimeout(updatePreviewBar, 1000);
                setTimeout(updatePreviewBar, 2000);
                setTimeout(updateCategoryPill, 1000);
            }
        } catch (error) {
            logError("Failed to load segments:", error);
        }
    }

    function handleVideoChangeImpl() {
        const newVideoID = getVideoID();

        if (!newVideoID || newVideoID === currentVideoID) {
            return;
        }

        log(`Video changed to: ${newVideoID}`);
        resetState();
        currentVideoID = newVideoID;

        let attempts = 0;
        const maxAttempts = 50;

        const checkVideo = setInterval(() => {
            attempts++;

            // Re-check Vinegar detection on each attempt
            updateVinegarDetection();

            if (findVideoElement()) {
                clearInterval(checkVideo);
                log("Video element found after", attempts, "attempts");
                loadSegmentsAndSetup();
            } else if (attempts >= maxAttempts) {
                clearInterval(checkVideo);
                logError("Failed to find video element after max attempts");
            }
        }, 100);
    }

    function handleVideoChange() {
        if (videoChangeDebounce) {
            clearTimeout(videoChangeDebounce);
        }
        videoChangeDebounce = setTimeout(handleVideoChangeImpl, 50);
    }

    function setupNavigationListener() {
        // Standard YouTube navigation events (may not fire on mobile)
        document.addEventListener("yt-navigate-finish", () => {
            log("yt-navigate-finish event");
            handleVideoChange();
        });

        document.addEventListener("yt-navigate-start", () => {
            hideCategoryPill();
            removePreviewBar();
            stopRAFSkipLoop();
        });

        // Mobile-specific events
        if (IS_MOBILE_YOUTUBE) {
            document.addEventListener("state-navigateend", () => {
                log("state-navigateend event");
                handleVideoChange();
            });

            document.addEventListener("yt-page-data-updated", () => {
                log("yt-page-data-updated event");
                handleVideoChange();
            });
        }

        // History API interception
        const originalPushState = history.pushState;
        history.pushState = function (...args) {
            originalPushState.apply(this, args);
            log("pushState detected");
            handleVideoChange();
        };

        const originalReplaceState = history.replaceState;
        history.replaceState = function (...args) {
            originalReplaceState.apply(this, args);
            log("replaceState detected");
            handleVideoChange();
        };

        window.addEventListener("popstate", () => {
            log("popstate event");
            handleVideoChange();
        });

        // URL polling fallback (essential for mobile and Vinegar)
        urlPollInterval = setInterval(() => {
            if (location.href !== lastUrl) {
                log("URL change detected via polling:", location.href);
                lastUrl = location.href;
                handleVideoChange();
            }

            // For Vinegar: periodically check if video element was replaced
            if (IS_VINEGAR && currentVideoID) {
                const currentVideo = document.querySelector("video");
                if (currentVideo && currentVideo !== video) {
                    log("Video element replacement detected via polling");
                    video = currentVideo;
                    setupVideoListeners();
                    if (skippableSegments.length > 0 && !video.paused) {
                        scheduleSkips();
                    }
                }
            }
        }, 500);
    }

    function init() {
        log("Initializing SponsorBlock Lite");

        // Initial Vinegar detection (may update later when video loads)
        updateVinegarDetection();

        log(
            "Platform:",
            IS_BILIBILI ? "Bilibili" : IS_VINEGAR ? "Vinegar" : IS_MOBILE_YOUTUBE ? "Mobile" : IS_MUSIC_YOUTUBE ? "Music" : "Desktop",
        );

        injectStyles();
        setupNavigationListener();
        setupVideoObserver();
        handleVideoChange();

        // Multiple retry attempts for initial load
        setTimeout(handleVideoChange, 500);
        setTimeout(handleVideoChange, 1000);
        setTimeout(handleVideoChange, 2000);

        // Additional retries for mobile/Vinegar
        if (IS_MOBILE_YOUTUBE || IS_VINEGAR) {
            setTimeout(handleVideoChange, 3000);
            setTimeout(handleVideoChange, 5000);
        }

        // For Vinegar: also retry after longer delays since the player loads differently
        setTimeout(() => {
            updateVinegarDetection();
            if (IS_VINEGAR) {
                log("Late Vinegar detection check");
                handleVideoChange();
            }
        }, 4000);
    }

    // ==================== START ====================

    if (document.readyState === "loading") {
        document.addEventListener("DOMContentLoaded", init);
    } else {
        init();
    }
})();
