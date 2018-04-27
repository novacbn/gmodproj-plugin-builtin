import gsub, match from string

import Asset from gmodproj.api
import Set from gmodproj.require "novacbn/novautils/collections/Set"

-- ::PATTERN_HAS_IMPORTS -> pattern
-- Represents a pattern to check if a script has 'import' statements
PATTERN_HAS_IMPORTS = "import"

-- ::PATTERN_HAS_DEPENDENCIES -> pattern
-- Represents a pattern to check if a script has 'dependency' statements
PATTERN_HAS_DEPENDENCIES = "dependency"

-- ::PATTERN_EXTRACT_IMPORTS -> pattern
-- Represents a pattern to extract 'import' statements
PATTERN_EXTRACT_IMPORTS = "import[\\(]?[%s]*['\"]([%w/%-_]+)['\"]"

-- ::PATTERN_EXTRACT_DEPENDENCIES -> pattern
-- Represents a pattern to extract 'dependency' statements
PATTERN_EXTRACT_DEPENDENCIES = "dependency[\\(]?[%s]*['\"]([%w/%-_]+)['\"]"

-- LuaAsset::LuaAsset()
-- Represents a Lua asset
-- export
export LuaAsset = Asset\extend {
    -- LuaAsset::collectDependencies(string contents) -> table
    -- Traverses the asset to collect dependencies of the Lua script
    --
    collectDependencies: (contents) =>
        -- Make a new collection of dependencies
        collectedDependencies = Set\new()

        -- Collect the dependencies with 'import' and 'dependency' statements
        @scanDependencies(PATTERN_HAS_IMPORTS, PATTERN_EXTRACT_IMPORTS, contents, collectedDependencies)
        @scanDependencies(PATTERN_HAS_DEPENDENCIES, PATTERN_EXTRACT_DEPENDENCIES, contents, collectedDependencies)

        -- Return the dependencies converted to a table
        return collectedDependencies\values()

    -- LuaAsset::scanDependencies(string matchPattern, string extractPattern, string contents, Set collectedDependencies) -> void
    -- Scans the asset for dependencies using pattern-matching
    --
    scanDependencies: (matchPattern, extractPattern, contents, collectedDependencies) =>
        if match(contents, matchPattern)
            gsub(contents, extractPattern, (assetName) -> collectedDependencies\push(assetName))
}

-- TODO:
--     * check Lua syntax in preTransform method
--     * Maybe also something like "strict" mode checking, luacheck?