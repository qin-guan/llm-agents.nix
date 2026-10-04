{
  lib,
  flake,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  fontconfig,
  versionCheckHook,
  versionCheckHomeHook,
}:

buildDotnetModule rec {
  pname = "codealta";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "CodeAlta";
    repo = "CodeAlta";
    tag = version;
    hash = "sha256-OCUycST9kN5EAetNXjITeI0rTS4YYWrq/plmVCfpfg0=";
  };

  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.runtime_10_0;
  projectFile = "src/CodeAlta/CodeAlta.csproj";
  executables = [ "alta" ];
  nugetDeps = ./deps.json;
  # SkiaSharp's native library (terminal graphics) links against libfontconfig.
  runtimeDeps = [ fontconfig ];

  # MinVer derives the version from git tags, which the source tarball lacks.
  dotnetFlags = [ "-p:MinVerVersionOverride=${version}" ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    versionCheckHomeHook
  ];

  passthru.category = "AI Coding Agents";

  meta = with lib; {
    description = "Terminal workspace for agentic coding";
    homepage = "https://codealta.github.io/";
    changelog = "https://github.com/CodeAlta/CodeAlta/releases/tag/${version}";
    license = licenses.bsd2;
    sourceProvenance = with sourceTypes; [ fromSource ];
    maintainers = with flake.lib.maintainers; [ qin-guan ];
    mainProgram = "alta";
    platforms = platforms.unix;
  };
}
