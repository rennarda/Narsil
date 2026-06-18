# Claude Code Notes

Read `AGENTS.md` first for the architecture and resource grammar. This Swift package is a resource-backed random text generator, not an app target.

Key paths:

- `Sources/Narsil/Generatable.swift`: public generator wrappers and lazy resource loading.
- `Sources/Narsil/PhraseGenerator.swift`: recursive bracket-expression expansion.
- `Sources/Narsil/patterns`: top-level generator patterns.
- `Sources/Narsil/wordlists`: vocabulary and reusable phrase fragments.
- `Sources/Narsil/Village Generator/SettlementGenerator.swift`: composite settlement generation.
- `Sources/Narsil/weather/weather.swift`: independent weather state generation.

Before changing syntax or parser behavior, update the README's "Resource File Format" section and add focused tests. Run `swift test` for verification.
