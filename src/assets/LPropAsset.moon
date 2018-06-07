import DataAsset from gmodproj.api
import decode from gmodproj.require "novacbn/properties/exports"

-- LPropAsset::LPropAsset()
-- Represents a generic Lua properties asset that can be imported
-- export
export LPropAsset = DataAsset\extend {
    -- LPropAsset::preTransform(string contents) -> table
    -- Decodes a Lua properties asset into a table before reencoding into a Lua asset
    --
    preTransform: (contents) => decode(contents, {propertiesEncoder: "lua"})
}