# Copilot Instructions

Narsil is a Swift Package Manager library for random tabletop/worldbuilding content. It has no executable app target.

Architecture to preserve:

- `Generatable.swift` defines the public generator protocol, generic `Generator`, and named wrappers such as `VillageName`, `InnName`, `MealName`, and oracle generators.
- `PhraseGenerator.swift` expands resource grammar expressions recursively.
- `patterns/*.txt` are top-level phrase templates. `wordlists/*.txt` are reusable choices loaded by bracket placeholders.
- `SettlementGenerator.swift` composes generators and model rules into `Settlement`.
- `weather.swift` is separate from the text grammar and models weather state transitions.

Resource syntax:

- One non-empty line is one random choice.
- `[keyword]` loads `wordlists/keyword.txt`.
- `[Keyword]` capitalizes the replacement's first character.
- `[a|b|c]` chooses an alternative, resolving it as a wordlist if possible.
- `[keyword:0.5]` makes the expression optional.
- `[1-6]` generates an inclusive random integer.

Run `swift test` after changing Swift code or generation resources.
