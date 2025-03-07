{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "kn";
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "knative";
    repo = "client";
    rev = "knative-v${version}";
    sha256 = "sha256-bXICU1UBNPVIumzRPSOWa1I5hUYWEvo6orBpUvbPEvg=";
  };

  vendorHash = null;

  subPackages = [ "cmd/kn" ];

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-X knative.dev/client/pkg/kn/commands/version.Version=v${version}"
    "-X knative.dev/client/pkg/kn/commands/version.VersionEventing=v${version}"
    "-X knative.dev/client/pkg/kn/commands/version.VersionServing=v${version}"
  ];

  postInstall = ''
    installShellCompletion --cmd kn \
      --bash <($out/bin/kn completion bash) \
      --zsh <($out/bin/kn completion zsh)
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/kn version | grep ${version} > /dev/null
  '';

  meta = with lib; {
    description = "Knative client kn is your door to the Knative world. It allows you to create Knative resources interactively from the command line or from within scripts";
    mainProgram = "kn";
    homepage = "https://github.com/knative/client";
    changelog = "https://github.com/knative/client/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ bryanasdev000 ];
  };
}
