{
  lib,
  stdenv,
  fetchurl,
  buildEnv,
  cmake,
  espeak-ng,
  fetchpatch,
  ffmpeg,
  fontconfig,
  hunspell,
  hyphen,
  icu,
  imagemagick,
  libjpeg,
  libmtp,
  libpng,
  libstemmer,
  libuchardet,
  libusb1,
  libwebp,
  nix-update-script,
  onnxruntime,
  optipng,
  piper-tts,
  pkg-config,
  podofo0,
  poppler-utils,
  python314Packages,
  qt6,
  speechd-minimal,
  sqlite,
  xdg-utils,
  wrapGAppsHook3,
  popplerSupport ? true,
  speechSupport ? !stdenv.hostPlatform.isDarwin,
  unrarSupport ? false,
}:
let
  python3Packages =
    if stdenv.hostPlatform.isDarwin then
      python314Packages.overrideScope (
        _self: super: {
          pyqt6 = super.pyqt6.override { withPdf = false; };
        }
      )
    else
      python314Packages;
  darwinDeps = buildEnv {
    name = "calibre-darwin-dependencies";
    paths = [
      hunspell
      libuchardet
    ];
    extraOutputsToInstall = [ "dev" ];
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "calibre";
  version = "9.10.0";

  src = fetchurl {
    url = "https://download.calibre-ebook.com/${finalAttrs.version}/calibre-${finalAttrs.version}.tar.xz";
    hash = "sha256-U7iid8dm5sP7Xfsm+ikRn0oSm/j5qVS0I1qWPIowwwE=";
  };

  patches =
    let
      debian-source = "ds+_0.10.6-1";
      debian-tag = "${finalAttrs.version}+${debian-source}";
    in
    [
      #  allow for plugin update check, but no calibre version check
      (fetchpatch {
        name = "0001-only-plugin-update-${debian-tag}.patch";
        url = "https://github.com/debian-calibre/calibre/raw/refs/tags/debian/${debian-tag}/debian/patches/0001-only-plugin-update.patch";
        hash = "sha256-/Hz8DSL1VC/wwQPOssM54MInLidfo7kJoR69yi2wAP4=";
      })
      (fetchpatch {
        name = "0007-Hardening-Qt-code-${debian-tag}.patch";
        url = "https://github.com/debian-calibre/calibre/raw/refs/tags/debian/${debian-tag}/debian/patches/hardening/0007-Hardening-Qt-code.patch";
        hash = "sha256-lKp/omNicSBiQUIK+6OOc8ysM6LImn5GxWhpXr4iX+U=";
      })
    ]
    ++ lib.optional (!unrarSupport) ./dont_build_unrar_plugin.patch
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      ./lift-build-platform-restrictions.patch
      ./darwin-use-linux-layout.patch
    ];

  prePatch = ''
    sed -i "s@\[tool.sip.project\]@[tool.sip.project]\nsip-include-dirs = [\"${python3Packages.pyqt6}/${python3Packages.python.sitePackages}/PyQt6/bindings\"]@g" \
      setup/build.py

    # Remove unneeded files and libs
    rm -rf src/odf resources/calibre-portable.*
  '';

  dontUseQmakeConfigure = true;
  dontUseCmakeConfigure = true;
  dontUseNinjaBuild = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    python3Packages.python
    qt6.qmake
    qt6.wrapQtAppsHook
    wrapGAppsHook3
  ];

  buildInputs = [
    espeak-ng
    ffmpeg
    fontconfig
    hunspell
    hyphen
    icu
    imagemagick
    libjpeg
    libmtp
    libpng
    libstemmer
    libuchardet
    libusb1
    onnxruntime
    podofo0
    poppler-utils
    qt6.qtbase
    sqlite
    (python3Packages.python.withPackages (
      _:
      [
        (python3Packages.apsw.overrideAttrs (_oldAttrs: {
          setupPyBuildFlags = [ "--enable=load_extension" ];
        }))
        python3Packages.beautifulsoup4
        python3Packages.css-parser
        python3Packages.cssselect
        python3Packages.fonttools
        python3Packages.python-dateutil
        python3Packages.dnspython
        python3Packages.faust-cchardet
        python3Packages.feedparser
        python3Packages.html2text
        python3Packages.html5-parser
        python3Packages.lxml
        python3Packages.markdown
        python3Packages.mechanize
        python3Packages.msgpack
        python3Packages.netifaces
        python3Packages.pillow
        python3Packages.pychm
        python3Packages.pykakasi
        python3Packages.pyqt-builder
        python3Packages.pyqt6
        python3Packages.pystache
        python3Packages.python
        python3Packages.regex
        python3Packages.sip
        python3Packages.setuptools
        python3Packages.tzdata
        python3Packages.tzlocal
        python3Packages.zeroconf
        python3Packages.pycryptodome
        python3Packages.xxhash
        # the following are distributed with calibre, but we use upstream instead
        python3Packages.odfpy
      ]
      ++
        lib.optionals
          (
            !stdenv.hostPlatform.isDarwin
            && lib.lists.elem stdenv.hostPlatform.system python3Packages.pyqt6-webengine.meta.platforms
          )
          [
            # much of calibre's functionality is usable without a web
            # browser, so we enable building on platforms which qtwebengine
            # does not support by simply omitting qtwebengine.
            python3Packages.pyqt6-webengine
          ]
      ++ lib.optional unrarSupport python3Packages.unrardll
      ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [ python3Packages.jeepney ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [
        python3Packages.macfsevents
      ]
    ))
    xdg-utils
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [ qt6.qtwayland ]
  ++ lib.optionals speechSupport [
    piper-tts
    (speechd-minimal.override { inherit python3Packages; })
  ];

  env = {
    HOME = "/tmp";
    MAGICK_INC = "${lib.getDev imagemagick}/include/ImageMagick";
    MAGICK_LIB = "${lib.getLib imagemagick}/lib";
    FC_INC_DIR = "${lib.getDev fontconfig}/include/fontconfig";
    FC_LIB_DIR = "${lib.getLib fontconfig}/lib";
    PODOFO_INC_DIR = "${lib.getDev podofo0}/include/podofo";
    PODOFO_LIB_DIR = "${lib.getLib podofo0}/lib";
    XDG_DATA_HOME = "${placeholder "out"}/share";
    XDG_UTILS_INSTALL_MODE = "user";
  }
  // lib.optionalAttrs popplerSupport {
    POPPLER_INC_DIR = "${lib.getDev poppler-utils}/include/poppler";
    POPPLER_LIB_DIR = "${lib.getLib poppler-utils}/lib";
  }
  // lib.optionalAttrs speechSupport {
    PIPER_TTS_DIR = "${lib.getBin piper-tts}/bin";
  };

  installPhase = ''
    runHook preInstall
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    export HOME="$TMPDIR/fakehome"
    mkdir -p "$HOME"
    ln -s ${darwinDeps} "$HOME/sw"
  ''
  + ''
    python setup.py install --root=$out \
      --prefix=$out \
      --libdir=$out/lib \
      --staging-root=$out \
      --staging-libdir=$out/lib \
      --staging-sharedir=$out/share

    PYFILES="$out/bin/* $out/lib/calibre/calibre/web/feeds/*.py
      $out/lib/calibre/calibre/ebooks/metadata/*.py
      $out/lib/calibre/calibre/ebooks/rtf2xml/*.py"

    sed -i "s/env python[0-9.]*/python/" $PYFILES
    sed -i "2i import sys; sys.argv[0] = 'calibre'" $out/bin/calibre

    mkdir -p $out/share
    cp -a man-pages $out/share/man

    runHook postInstall
  '';

  # Wrap manually
  dontWrapQtApps = true;
  dontWrapGApps = true;

  preFixup =
    let
      popplerArgs = "--prefix PATH : ${poppler-utils.out}/bin";
    in
    ''
      for program in $out/bin/*; do
        wrapProgram $program \
          ''${qtWrapperArgs[@]} \
          ''${gappsWrapperArgs[@]} \
          --set QTWEBENGINE_CHROMIUM_FLAGS "--disable-gpu" \
          --prefix PATH : ${
            lib.makeBinPath [
              libjpeg
              libwebp
              optipng
            ]
          } \
          ${lib.optionalString popplerSupport popplerArgs}
      done
    '';

  doInstallCheck = true;
  installCheckInputs = with python3Packages; [
    psutil
  ];
  installCheckPhase =
    let
      excludedTestNames = [
        "test_7z" # we don't include 7z support
        "test_zstd" # we don't include zstd support
        "test_qt" # we don't include svg or webp support
        "test_import_of_all_python_modules" # explores actual file paths, gets confused
        "test_websocket_basic" # flaky

        # hangs with cuda enabled, also:
        # eglInitialize: Failed to get system egl display
        # Failed to connect to socket /run/dbus/system_bus_socket: No such file or directory
        "test_recipe_browser_webengine"
        # Flaky test, occasionally errors with python exception:
        # urllib.error.URLError: <urlopen error NetworkError.RemoteHostClosedError: Connection closed>
        "test_recipe_browser_qt"
      ]
      ++ lib.optionals stdenv.hostPlatform.isAarch64 [
        # https://github.com/microsoft/onnxruntime/issues/10038
        "test_piper"

        # terminate called after throwing an instance of 'onnxruntime::OnnxRuntimeException'
        #  what():  /build/source/include/onnxruntime/core/common/logging/logging.h:371
        # static const onnxruntime::logging::Logger& onnxruntime::logging::LoggingManager::DefaultLogger()
        # Attempt to use DefaultLogger but none has been registered.
        "test_plugins"
      ]
      ++ lib.optionals (!speechSupport) [
        "test_speech_dispatcher"
      ]
      ++ lib.optionals (!unrarSupport) [
        "test_unrar"
      ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [
        "test_mem_leaks"
        "test_openssl"
      ];

      testFlags = lib.concatStringsSep " " (
        lib.map (testName: "--exclude-test-name ${testName}") excludedTestNames
      );
    in
    ''
      runHook preInstallCheck

      python setup.py test ${testFlags}

      runHook postInstallCheck
    '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--url=https://github.com/kovidgoyal/calibre" ];
  };

  meta = {
    homepage = "https://calibre-ebook.com";
    description = "Comprehensive e-book software";
    longDescription = ''
      calibre is a powerful and easy to use e-book manager. Users say it’s
      outstanding and a must-have. It’ll allow you to do nearly everything and
      it takes things a step beyond normal e-book software. It’s also completely
      free and open source and great for both casual users and computer experts.
    '';
    changelog = "https://github.com/kovidgoyal/calibre/releases/tag/v${finalAttrs.version}";
    license = if unrarSupport then lib.licenses.unfreeRedistributable else lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      pSub
      sempiternal-aurora
    ];
    platforms = lib.platforms.unix;
  };
})
