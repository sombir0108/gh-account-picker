# Contributing

Thanks for helping out. This project accepts changes **only through pull
requests** — nobody pushes straight to `main`, including the maintainer.

## How to contribute

1. Fork the repo and create a branch from `main`.
2. Make your change. Keep it small and focused — one fix or feature per PR.
3. Open a pull request and fill in the template. Describe *what* changed and
   *why*, and say how you tested it and on which OS.
4. The maintainer reviews and merges. Expect questions; that's normal.

Found a bug or have an idea but don't want to write code? Open an issue.

## Ground rules

- **Never commit secrets.** No tokens (`gho_…`, `ghp_…`), passwords or
  personal emails — in code, tests, logs or screenshots. Test with stubs or
  throwaway accounts.
- **Shell scripts stay on LF line endings** (`.gitattributes` enforces it)
  and must pass `bash -n <file>`.
- **PowerShell scripts** must parse cleanly under Windows PowerShell 5.1.
- **Don't change behaviour silently.** The tool is meant to stay quiet in
  day-to-day git use and only prompt on a real problem; changes that add
  prompts need a clear reason in the PR.
- Update the README when behaviour or install steps change.

## Where help is most welcome

- Real-world testing on **macOS and Linux** (the popups use `osascript`,
  `zenity` and `kdialog`; they are written but have had little testing).
- An **Add account** option in the terminal menu and the macOS/Linux popups
  (the Windows popup already has it).
- A **Remove account** option.

## Checking your change

```bash
bash -n install.sh uninstall.sh bin/*.sh lib/*.sh
```

and, on Windows, parse-check each `.ps1` you touched:

```powershell
$e=$null; [void][System.Management.Automation.Language.Parser]::ParseFile("gui\switch-account.ps1",[ref]$null,[ref]$e); $e
```

By submitting a pull request you agree your contribution is licensed under
the project's [MIT License](LICENSE).
