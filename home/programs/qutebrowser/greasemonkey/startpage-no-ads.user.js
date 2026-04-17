// ==UserScript==
// @name        Startpage - Hide Ads
// @match       https://www.startpage.com/*
// @run-at      document-start
// ==/UserScript==

new MutationObserver(function(mutations) {
  mutations.forEach((mutation) => {
    if (mutation.type === 'childList') {
      mutation.addedNodes.forEach((node) => {
        if (node.nodeType === 1 && node.nodeName === 'DIV' && node.id === 'gcsa-top') {
          node.remove();
          this.disconnect();
        }
      });
    }
  });
}).observe(document, { childList: true, subtree: true });
