# Gemini Notes

Read `AGENTS.md` first for the architecture and resource grammar. Narsil is a Swift Package Manager library for random tabletop/worldbuilding generation.

The main flow is:

1. A `Generatable` wrapper names a pattern file.
2. `loadPatterns()` loads `patterns/<name>.txt`, falling back to `wordlists/<name>.txt`.
3. `generate()` picks a random line.
4. `PhraseGenerator.expand(string:)` recursively replaces bracketed expressions from `wordlists`.
5. The final phrase is whitespace-normalized, lightly article-corrected, and capitalized.

Keep resource files as one random choice per non-empty line. Do not add comments to resource files. Prefer lowercase filenames because placeholder lookup lowercases names.
