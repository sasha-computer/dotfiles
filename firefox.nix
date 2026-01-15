{ pkgs, ... }:

{
  programs.firefox = {
    enable = true;

    nativeMessagingHosts.packages = [
      pkgs.tridactyl-native
      pkgs.kdePackages.plasma-browser-integration
    ];

    policies = {
      # ======================================================================
      # Privacy & Telemetry
      # ======================================================================

      DisableFirefoxAccounts = true;
      DisableFirefoxStudies = true;
      DisableTelemetry = true;

      # Disable AI features
      GenerativeAI = {
        Enabled = false;
        Chatbot = false;
        LinkPreviews = false;
        TabGroups = false;
        Locked = true;
      };

      # Disable Firefox Suggest
      FirefoxSuggest = {
        WebSuggestions = false;
        SponsoredSuggestions = false;
        ImproveSuggest = false;
        Locked = true;
      };

      # Strict tracking protection
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
        EmailTracking = true;
        Category = "strict";
        BaselineExceptions = false;
        ConvenienceExceptions = false;
      };

      # ======================================================================
      # Security
      # ======================================================================

      HttpsOnlyMode = "force_enabled";
      NetworkPrediction = false;

      # DNS over HTTPS (Cloudflare)
      DNSOverHTTPS = {
        Enabled = true;
        ProviderURL = "https://cloudflare-dns.com/dns-query";
        Locked = true;
      };

      # ======================================================================
      # Passwords & Autofill (disabled - using 1Password)
      # ======================================================================

      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      OfferToSaveLogins = false;
      PasswordManagerEnabled = false;

      # ======================================================================
      # Search
      # ======================================================================

      SearchEngines.Default = "DuckDuckGo";
      SearchSuggestEnabled = true;

      # ======================================================================
      # Homepage & New Tab
      # ======================================================================

      Homepage = {
        URL = "about:blank";
        Locked = true;
        StartPage = "homepage";
      };

      NewTabPage = false;

      FirefoxHome = {
        Search = false;
        TopSites = false;
        SponsoredTopSites = false;
        Highlights = false;
        Pocket = false;
        SponsoredPocket = false;
        Snippets = false;
        Locked = true;
      };

      # ======================================================================
      # UI & UX
      # ======================================================================

      DisplayBookmarksToolbar = "never";
      DisableSetDesktopBackground = true;
      DontCheckDefaultBrowser = true;

      # Downloads
      PromptForDownloadLocation = false;
      DefaultDownloadDirectory = "~/Downloads";

      # Disable recommendations and onboarding
      UserMessaging = {
        ExtensionRecommendations = false;
        FeatureRecommendations = false;
        FirefoxLabs = false;
        MoreFromMozilla = false;
        SkipOnboarding = true;
        UrlbarInterventions = false;
        Locked = false;
      };

      # ======================================================================
      # Preferences (about:config)
      # ======================================================================

      Preferences = {
        # Disable password breach alerts
        "signon.management.page.breach-alerts.enabled" = {
          Value = false;
          Status = "locked";
        };

        # Disable Safe Browsing (using uBlock Origin instead)
        "browser.safebrowsing.malware.enabled" = {
          Value = false;
          Status = "locked";
        };
        "browser.safebrowsing.phishing.enabled" = {
          Value = false;
          Status = "locked";
        };
        "browser.safebrowsing.downloads.enabled" = {
          Value = false;
          Status = "locked";
        };
        "browser.safebrowsing.downloads.remote.block_potentially_unwanted" = {
          Value = false;
          Status = "locked";
        };
        "browser.safebrowsing.downloads.remote.block_uncommon" = {
          Value = false;
          Status = "locked";
        };

        # Disable crash reports and telemetry
        "browser.crashReports.unsubmittedCheck.autoSubmit2" = {
          Value = false;
          Status = "locked";
        };
        "browser.tabs.crashReporting.sendReport" = {
          Value = false;
          Status = "locked";
        };
        "toolkit.telemetry.reportingpolicy.firstRun" = {
          Value = false;
          Status = "locked";
        };
        "datareporting.policy.dataSubmissionEnabled" = {
          Value = false;
          Status = "locked";
        };

        # WebGPU
        "dom.webgpu.enabled" = {
          Value = true;
          Status = "locked";
        };
      };

      # ======================================================================
      # Extensions
      # ======================================================================

      ExtensionSettings = {
        # Privacy & Security
        "uBlock0@raymondhill.net" = {
          installation_mode = "normal_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
        };
        "idcac-pub@guus.ninja" = {
          installation_mode = "normal_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/istilldontcareaboutcookies/latest.xpi";
        };

        # Password Manager
        "{d634138d-c276-4fc8-924b-40a0ea21d284}" = {
          installation_mode = "normal_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/1password-x-password-manager/latest.xpi";
        };

        # Vim Navigation
        "tridactyl.vim@cmcaine.co.uk" = {
          installation_mode = "normal_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/tridactyl-vim/latest.xpi";
        };

        # Appearance
        "addon@darkreader.org" = {
          installation_mode = "normal_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
        };
        "{e7476172-097c-4b77-b56e-f56a894adca9}" = {
          installation_mode = "normal_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/minimaltwitter/latest.xpi";
        };

        # Productivity
        "team@readwise.io" = {
          installation_mode = "normal_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/readwise-highlighter/latest.xpi";
        };
        "clipper@obsidian.md" = {
          installation_mode = "normal_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/web-clipper-obsidian/latest.xpi";
        };

        # KDE Integration
        "kde-connect@0xc0dedbad.com" = {
          installation_mode = "normal_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/kde_connect/latest.xpi";
        };
      };
    };
  };
}
