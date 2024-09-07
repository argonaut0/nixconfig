# Overlay to get DRM for Spotify etc working on chromium and firefox.
# This will probably be unnecessary in a few weeks if the options and installer get merged into nixpkgs
# https://github.com/tpwrules/nixos-apple-silicon/issues/145
# https://gist.github.com/psanford/1f70a0838c308d28478cf27a9b55c43d
final: prev:
let
  lacrosVersion = "120.0.6098.0";
  widevine-installer = prev.stdenv.mkDerivation rec {
    name = "widevine-installer";
    version = "7a3928fe1342fb07d96f61c2b094e3287588958b";
    src = prev.fetchFromGitHub {
      owner = "AsahiLinux";
      repo = "${name}";
      rev = "${version}";
      sha256 = "sha256-XI1y4pVNpXS+jqFs0KyVMrxcULOJ5rADsgvwfLF6e0Y=";
    };

    buildInputs = with prev.pkgs; [ which python3 squashfsTools ];

    installPhase = ''
      mkdir -p "$out/bin"
      mkdir -p "$out/conf"
      cp widevine-installer "$out/bin/"
      cp widevine_fixup.py "$out/bin/"
      cp conf/gmpwidevine.js "$out/conf/"
      echo "$(which unsquashfs)"
      sed -e "s|unsquashfs|$(which unsquashfs)|" -i "$out/bin/widevine-installer"
      sed -e "s|python3|$(which python3)|" -i "$out/bin/widevine-installer"
      sed -e "s|read|#read|" -i "$out/bin/widevine-installer"
      sed -e 's|$(whoami)|root|' -i "$out/bin/widevine-installer"
      sed -e 's|URL=.*|URL="$DISTFILES_BASE"|' -i "$out/bin/widevine-installer"
    '';
  };
  widevine = prev.stdenv.mkDerivation {
    name = "widevine";
    version = "";
    buildInputs = with prev.pkgs; [ curl widevine-installer ];

    src = prev.fetchurl {
      urls = [ "https://commondatastorage.googleapis.com/chromeos-localmirror/distfiles/chromeos-lacros-arm64-squash-zstd-${lacrosVersion}" ];
      hash = "sha256-OKV8w5da9oZ1oSGbADVPCIkP9Y0MVLaQ3PXS3ZBLFXY=";
    };

    unpackPhase = "true";
    installPhase = ''
      mkdir -p "$out/"
      COPY_CONFIGS=0 INSTALL_BASE="$out" DISTFILES_BASE="file://$src" widevine-installer
    '';
  };
  chromiumWV = prev.runCommand "chromium-wv" { version = prev.chromium.version; }
      ''
        mkdir -p $out
        cp -a ${prev.chromium.browser}/* $out/
        chmod u+w $out/libexec/chromium
        cp -Lr ${widevine}/WidevineCdm $out/libexec/chromium/
      '';
in
{
  firefox = prev.firefox.overrideAttrs (old: {
    buildCommand = old.buildCommand + ''
      cat ${widevine-installer}/conf/gmpwidevine.js >> "$out/lib/firefox/mozilla.cfg"
      
      wrapProgram "$oldExe" \
        --set MOZ_GMP_PATH "${widevine}/gmp-widevinecdm/system-installed"
    '';
  });
  chromium = prev.chromium.overrideAttrs (old: {
    buildCommand = builtins.replaceStrings [ "${prev.chromium.browser}" ] [ "${chromiumWV}" ] old.buildCommand;
  });
} 
