//
//  ViewController.swift
//  Shared (App)
//
//  Created by Wilton Garcia on 15/06/26.
//

import WebKit

#if os(iOS)
import UIKit
typealias PlatformViewController = UIViewController
#elseif os(macOS)
import Cocoa
import SafariServices
typealias PlatformViewController = NSViewController
#endif

let extensionBundleIdentifier = "wgroup.WG-ShortsBlcok.Extension"

class ViewController: PlatformViewController, WKNavigationDelegate, WKScriptMessageHandler {

    @IBOutlet var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let shortsBlockerJS = """
        (function() {
          const HIDE_STYLE = `
            ytd-rich-section-renderer[section-identifier*="shorts"],
            ytd-reel-shelf-renderer,
            ytd-reel-shelf-renderer *,
            ytd-rich-item-renderer:has(a[href*="/shorts/"]),
            ytd-grid-video-renderer:has(a[href*="/shorts/"]),
            ytd-video-renderer:has(a[href*="/shorts/"]),
            a[href*="/shorts/"],
            tp-yt-paper-tab:has(div.tab-content:has(yt-formatted-string:matches-css(:contains("Shorts")))),
            #endpoint[title="Shorts"],
            ytd-guide-entry-renderer a[href*="/shorts"],
            ytd-mini-guide-entry-renderer a[href*="/shorts"],
            #chips ytd-feed-filter-chip-bar-renderer a[href*="/shorts"],
            ytd-reel-shelf-renderer + ytd-rich-grid-row,
            ytd-two-column-browse-results-renderer #contents ytd-rich-section-renderer,
            ytd-browse[page-subtype="channels"] ytd-rich-grid-media:has(a[href*="/shorts/"]),
            ytd-search ytd-video-renderer:has(a[href*="/shorts/"]),
            ytd-search ytd-reel-shelf-renderer,
            ytd-browse[page-subtype="home"] ytd-rich-item-renderer:has(a[href*="/shorts/"])
          { display: none !important; visibility: hidden !important; }
          `;

          function ensureStyle() {
            if (document.getElementById('wg-shorts-block-style')) return;
            const style = document.createElement('style');
            style.id = 'wg-shorts-block-style';
            style.textContent = HIDE_STYLE;
            document.documentElement.appendChild(style);
          }

          function hideShortsCandidates(root = document) {
            try {
              const selectors = [
                'a[href*="/shorts/"]',
                'ytd-reel-shelf-renderer',
                'ytd-rich-item-renderer',
                'ytd-grid-video-renderer',
                'ytd-video-renderer',
                'ytd-rich-section-renderer',
              ];
              selectors.forEach(sel => {
                root.querySelectorAll(sel).forEach(el => {
                  try {
                    if (el.matches('a[href*="/shorts/"]')) {
                      el.style.display = 'none';
                      return;
                    }
                    const link = el.querySelector('a[href*="/shorts/"]');
                    if (link) {
                      el.style.display = 'none';
                    }
                  } catch (_) {}
                });
              });
            } catch (_) {}
          }

          function initObserver() {
            const observer = new MutationObserver(muts => {
              for (const m of muts) {
                if (m.type === 'childList') {
                  m.addedNodes.forEach(n => {
                    if (n.nodeType === 1) {
                      ensureStyle();
                      hideShortsCandidates(n);
                    }
                  });
                }
              }
            });
            observer.observe(document.documentElement, { childList: true, subtree: true });
          }

          function onReady(fn){
            if (document.readyState === 'complete' || document.readyState === 'interactive') { fn(); }
            else { document.addEventListener('DOMContentLoaded', fn, { once: true }); }
          }

          onReady(() => {
            ensureStyle();
            hideShortsCandidates(document);
            initObserver();
          });
        })();
        """

        let userScript = WKUserScript(source: shortsBlockerJS, injectionTime: .atDocumentStart, forMainFrameOnly: false)
        self.webView.configuration.userContentController.addUserScript(userScript)

        self.webView.navigationDelegate = self

#if os(iOS)
        self.webView.scrollView.isScrollEnabled = false
#endif

        self.webView.configuration.userContentController.add(self, name: "controller")

        let url = URL(string: "https://www.youtube.com")!
        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        self.webView.load(request)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
#if os(iOS)
        webView.evaluateJavaScript("show('ios')")
#elseif os(macOS)
        webView.evaluateJavaScript("show('mac')")

        SFSafariExtensionManager.getStateOfSafariExtension(withIdentifier: extensionBundleIdentifier) { (state, error) in
            guard let state = state, error == nil else {
                // Insert code to inform the user that something went wrong.
                return
            }

            DispatchQueue.main.async {
                if #available(macOS 13, *) {
                    webView.evaluateJavaScript("show('mac', \(state.isEnabled), true)")
                } else {
                    webView.evaluateJavaScript("show('mac', \(state.isEnabled), false)")
                }
            }
        }
#endif
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
#if os(macOS)
        if (message.body as! String != "open-preferences") {
            return
        }

        SFSafariApplication.showPreferencesForExtension(withIdentifier: extensionBundleIdentifier) { error in
            guard error == nil else {
                // Insert code to inform the user that something went wrong.
                return
            }

            DispatchQueue.main.async {
                NSApp.terminate(self)
            }
        }
#endif
    }

}
