import DataAsset from gmodproj.api
import decode from gmodproj.require "novacbn/properties/exports"

-- MPropAsset::MPropAsset()
-- Represents a generic MoonScript properties asset that can be imported
-- export
export MPropAsset = DataAsset\extend {
    -- MPropAsset::preTransform(string contents) -> table
    -- Decodes a MoonScript properties asset into a table before reencoding into a Lua asset
    --
    preTransform: (contents) => decode(contents, {propertiesEncoder: "moonscript"})
}