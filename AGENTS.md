# Agent Notes

This repository is a Swift Package Manager library named `Narsil`. It generates random tabletop/worldbuilding text from plain-text resources, plus composite settlement and weather models. There is no executable app target.

## Architecture

- `Sources/Narsil/Generatable.swift` is the public text-generator surface. `Generatable.generate()` lazily loads a resource file, selects a random line, expands placeholders through `PhraseGenerator.shared`, normalizes whitespace, fixes simple `a`/`an` cases, and applies `CapitalisationType`.
- `Sources/Narsil/PhraseGenerator.swift` is the recursive grammar engine. It finds the first bracketed expression, expands it, replaces it in the string, then recurses until no expressions remain.
- `Sources/Narsil/patterns` contains top-level phrase patterns. `Sources/Narsil/wordlists` contains reusable vocabulary and lower-level phrase fragments. SwiftPM copies both directories as resources.
- `Sources/Narsil/Village Generator/SettlementGenerator.swift` composes several text generators with `SettlementSize`, `Facility`, `Inn`, and `Beer` models to produce a `Settlement`.
- `Sources/Narsil/weather/weather.swift` is independent of the phrase grammar. It tracks normalized weather values and exposes descriptions plus SF Symbols icon names.
- `Tests/NarsilTests/NarsilTests.swift` contains smoke tests that repeatedly generate text and print examples.

## Resource Grammar

Resource files are plain UTF-8 text. Each non-empty line is one random choice; blank lines are ignored. There is no comment syntax.

- `[keyword]`: load one random line from `wordlists/keyword.txt`.
- `[Keyword]`: same lookup, but capitalize the replacement's first character.
- `[a|b|c]`: choose one alternative, then resolve it as a wordlist if possible; otherwise emit the literal text.
- `[keyword:0.5]`: include the expression with the given probability, otherwise emit an empty string.
- `[1-6]`: emit an inclusive random integer in that range.
- Wordlist lines can contain more placeholders; expansion is recursive.

Lookup lowercases placeholder names, so prefer lowercase resource filenames for portability. The current package contains some mixed-case filenames that work on case-insensitive filesystems.

## Working Guidelines

- Keep public API additions small: prefer `Generator(pattern:)` unless a resource needs a named wrapper type.
- When adding resources, use one choice per line and duplicate lines for weighting.
- Do not add comment lines to resource files unless you also change the parser.
- Run `swift test` after code or resource changes. The tests print a lot of generated output.
- Be careful with `PhraseGenerator.shared`: it stores a wordlist cache and is mutated during generation.
