{
  rev,
  lib,
  python3,
  installShellFiles,
  swappy,
  libnotify,
  slurp,
  wl-clipboard,
  cliphist,
  app2unit,
  dart-sass,
  grim,
  fuzzel,
  gpu-screen-recorder,
  dconf,
  killall,
  aura-shell,
  withShell ? false,
  discordBin ? "discord",
  qtctStyle ? "Darkly",
}:
python3.pkgs.buildPythonApplication {
  pname = "aura-cli";
  version = "${rev}";
  src = ./.;
  pyproject = true;

  build-system = with python3.pkgs; [
    hatch-vcs
    hatchling
  ];

  dependencies = with python3.pkgs; [
    materialyoucolor
    pillow
  ];

  pythonImportsCheck = ["aura"];

  nativeBuildInputs = [installShellFiles];
  propagatedBuildInputs =
    [
      swappy
      libnotify
      slurp
      wl-clipboard
      cliphist
      app2unit
      dart-sass
      grim
      fuzzel
      gpu-screen-recorder
      dconf
      killall
    ]
    ++ lib.optional withShell aura-shell;

  SETUPTOOLS_SCM_PRETEND_VERSION = 1;

  patchPhase = ''
    # Replace qs config call with nix shell pkg bin
    substituteInPlace src/aura/subcommands/shell.py \
    	--replace-fail '"qs", "-c", "aura"' '"aura-shell"'
    substituteInPlace src/aura/subcommands/screenshot.py \
    	--replace-fail '"qs", "-c", "aura"' '"aura-shell"'

    # Use config bin instead of discord + fix todoist + fix app2unit
    substituteInPlace src/aura/subcommands/toggle.py \
    	--replace-fail 'discord' ${discordBin} \
      --replace-fail 'todoist' 'todoist.desktop'\
      --replace-fail 'app2unit' ${app2unit}/bin/app2unit

    # Use config style instead of darkly
    substituteInPlace src/aura/data/templates/qtct.conf \
    	--replace-fail 'Darkly' '${qtctStyle}'
  '';

  postInstall = "installShellCompletion completions/aura.fish";

  meta = {
    description = "The main control script for the Aura dotfiles";
    homepage = "https://github.com/CjLogic/aura-cli";
    license = lib.licenses.gpl3Only;
    mainProgram = "aura";
    platforms = lib.platforms.linux;
  };
}
