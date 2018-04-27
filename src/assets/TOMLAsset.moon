import parse from "jonstoler/toml/main"

import DataAsset from gmodproj.api

-- TOMLAsset::TOMLAsset()
-- Represents a generic TOML asset that can be imported
-- export
export TOMLAsset = DataAsset\extend {
    -- TOMLAsset::preTransform(string contents, boolean isProduction) -> string
    -- Decodes the TOML asset into a Lua Table for later encoding into a Lua Table string
    --
    preTransform: (contents, isProduction) => parse(contents)
}