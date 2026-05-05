{ authentik-src
, authentik-version
, authentikComponents
, buildNpmPackage
, nodejs_24
,
}:

buildNpmPackage {
  pname = "authentik-web";
  version = authentik-version; # 0.0.0 specified upstream in package.json

  src = "${authentik-src}/web";

  nodejs = nodejs_24;

  npmDepsFetcherVersion = 2;
  npmDepsHash = "sha256-as04aStHpl/bnwQmomCxhSxlGxD602UF0CZ51T/glVA=";

  env = {
    NODE_ENV = "production";
    CHROMEDRIVER_SKIP_DOWNLOAD = "true";
  };

  preBuild = ''
    ln -sv ${authentikComponents.docs} ../website
    ln -sv ${authentik-src}/package.json ../
  '';

  buildPhase = ''
    runHook preBuild
    
    npm run build
    npm run build:sfe
    
    runHook postBuild
  '';

  installPhase = ''    
    runHook preInstall

    mkdir $out
    mv dist $out/dist
    cp -r authentik icons $out    

    runHook postInstall
  '';
}
