import decode from "rxi/json/main"

import DataAsset from gmodproj.api

-- JSONAsset::JSONAsset()
-- Represents a generic JSON asset that can be imported
-- export
export JSONAsset = DataAsset\extend {
    -- JSONAsset::preTransform(string contents) -> table
    -- Decodes a JSON asset into a table before reencoding into a Lua asset
    --
    preTransform: (contents) => decode(contents)
}