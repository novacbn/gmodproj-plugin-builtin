import DataAsset from gmodproj.api
import fromString from gmodproj.require "novacbn/gmodproj/lib/datafile"

-- DataFileAsset::DataFileAsset()
-- Represents a generic DataFile asset that can be imported
-- export
export DataFileAsset = DataAsset\extend {
    -- DataFileAsset::preTransform(string contents) -> table
    -- Decodes a DataFile asset into a table before reencoding into a Lua asset
    --
    preTransform: (contents) => fromString(contents)
}