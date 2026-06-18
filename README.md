# Narsil

Narsil is a Swift package for generating random tabletop and worldbuilding text: place names, inn names, meals, beers, locations, adventure prompts, action/danger/treasure oracles, settlements, and simple weather descriptions.

It is a library, not an app target. The package exposes small generator types backed by text resources in `Sources/Narsil/patterns` and `Sources/Narsil/wordlists`.

## Installation

Add this package as a Swift Package Manager dependency and import `Narsil` from the consuming target.

```swift
import Narsil
```

## Quick Start

Most generators are mutable structs because they lazily load and cache their pattern lines on first use.

```swift
import Narsil

var village = VillageName()
print(village.generate())

var inn = InnName()
print(inn.generate())

var meal = MealName()
print(meal.generate())

var plothook = Generator(pattern: "plothook")
print(plothook.generate())
```

Use `Generator(pattern:)` when there is no dedicated wrapper type. It looks for `patterns/<pattern>.txt` first, then `wordlists/<pattern>.txt`.

```swift
var handle = Generator(pattern: "handle", capitalisation: .word)
print(handle.generate())
```

Settlement generation composes several of the text generators into a model object.

```swift
let settlement = SettlementGenerator.generate()
print(settlement.name)
print(settlement.population)
print(settlement.facilities)
print(settlement.inns)
```

Weather generation is separate from the phrase grammar. `Weather` stores four normalized values between `0.0` and `1.0`; calling `generate(...)` returns a new weather state nudged by random rolls and optional die modifiers.

```swift
let today = Weather()
let tomorrow = today.generate(windDM: 0.1, precipitationDM: -0.1)

print(tomorrow.windDescription)
print(tomorrow.precipitationDescription)
print(tomorrow.windIconName)
```

## Architecture

- `Package.swift` defines a single library product, `Narsil`, and copies `wordlists` and `patterns` into the SwiftPM resource bundle.
- `Generatable` is the main public protocol for text generators. Its default `generate()` implementation loads resource lines, picks one at random, expands placeholders, normalizes whitespace, fixes simple `a`/`an` cases, and applies capitalization.
- `Generator` is the generic resource-backed generator. Dedicated wrappers such as `VillageName`, `InnName`, `MealName`, `BeerName`, and `ActionOracle` just provide a `patternFileName` and `CapitalisationType`.
- `PhraseGenerator` is the expansion engine. It recursively expands the first bracketed expression it finds until no expressions remain. Wordlist contents may themselves contain expressions.
- `SettlementGenerator` builds a `Settlement` by combining village names, settlement size/population rules, facilities, inns, food, beer, industries, and fame/oddity text.
- `Weather` is an independent stochastic state model with display descriptions and SF Symbols icon names.

## Public Generators

Dedicated text generator types:

- Names: `InnName`, `VillageName`, `CityName`, `CastleName`, `CorporationName`, `InstallationName`, `HumanName`, `ScifiName`, `DwarfName`, `HalflingName`, `ElfName`, `OrcName`, `BeerName`
- Descriptions: `BeerDescription`, `OddityDescription`, `IndustryDescription`, `LocationDescription`
- Oracles: `ActionOracle`, `DangerOracle`, `TreasureOracle`, `MagicalTreasureOracle`
- Generic: `Generator(pattern:capitalisation:)`

Composite generators and models:

- `SettlementGenerator.generate()` returns `Settlement`
- `SettlementGenerator.regenerateName(for:)` returns a copy with a new name
- `SettlementGenerator.regenerateInns(for:)` returns a copy with regenerated inns
- `Weather.generate(...)` returns the next weather state

## Resource File Format

Narsil's text content lives in two folders:

- `Sources/Narsil/patterns/*.txt`: primary phrase patterns for `Generatable` wrappers.
- `Sources/Narsil/wordlists/*.txt`: word/phrase choices addressed by bracket placeholders.

Each file is plain UTF-8 text. Each non-empty line is one random choice. Blank lines are ignored. There is no comment syntax, so comment lines would be treated as generated content.

### Plain Choices

```text
ale
porter
stout
```

When a placeholder references this file, one line is chosen uniformly. Use duplicate lines if you need weighting; there is no explicit weight syntax.

### Placeholders

Use square brackets to insert another wordlist choice:

```text
[preparation] [ingredient]
```

The placeholder name is lowercased before lookup, so `[Ingredient]` and `[ingredient]` both load `wordlists/ingredient.txt`. If a matching wordlist file cannot be loaded, the placeholder text is emitted literally without brackets.

### Capitalized Placeholders

If the first character inside the placeholder is uppercase, the generated replacement has its first letter capitalized.

```text
[Ingredient] pie
[ingredient] pie
```

This only affects the first character of the replacement. Whole-phrase capitalization is handled separately by the generator's `CapitalisationType`:

- `.initial`: capitalize the first character of the final phrase.
- `.word`: capitalize each whitespace-separated word in the final phrase.
- `.none`: leave the expanded phrase as-is.

### Alternatives

Use `|` inside a placeholder to choose between literal alternatives or wordlist names:

```text
[north|south|east|west]
[Animal|Colour|People|Object]
```

After one alternative is selected, Narsil tries to resolve it as a wordlist name. If there is no matching wordlist, the selected text is emitted literally. This is why `[with|to]` can produce either `with` or `to`.

### Optional Expressions

Add a decimal chance after a colon to make an expression optional:

```text
[sauceadjective:0.5] [sauce]
[Villagetitle:0.2] [Villageprefix][villagesuffix]
```

The chance is a `Double` between `0.0` and `1.0`. If the roll fails, the expression expands to an empty string. Final output is whitespace-normalized, so optional missing words do not usually leave doubled spaces.

### Numeric Ranges

Use an integer range to generate a random integer:

```text
[1-6]
[3-12]
```

Ranges are inclusive. Keep range expressions simple; chance modifiers are not applied to numeric ranges by the current implementation.

### Recursive Expansion

Generated lines may contain more placeholders. Expansion continues until no bracketed expressions remain.

Example lines from `wordlists/location.txt`:

```text
[place][ [placefeature]:0.1]
[Villagename] - [village]
```

This allows wordlists to be composed from other wordlists, not just from literal words.

### Whitespace and Articles

After expansion, `generate()`:

1. Splits on whitespace and rejoins with single spaces.
2. Replaces a simple `a <vowel>` match with `an <vowel>`.
3. Applies the generator's `CapitalisationType`.

The article correction is intentionally simple. It does not understand pronunciation or all-caps acronyms.

## Adding New Content

1. Add a lowercase `.txt` resource in `Sources/Narsil/wordlists` for reusable choices, or in `Sources/Narsil/patterns` for top-level generator patterns.
2. Use one non-empty random choice per line.
3. Use bracket placeholders to compose existing lists.
4. Add a dedicated `Generatable` wrapper in `Sources/Narsil/Generatable.swift` only when the pattern deserves a named public API. Otherwise, use `Generator(pattern:)`.
5. Run `swift test`.

## Development

```sh
swift test
```

The current tests are smoke tests: they instantiate generators repeatedly and assert that generation does not crash. They also print generated examples.
