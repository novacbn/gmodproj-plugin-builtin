import Schema from gmodproj.api

-- PluginOptions::PluginOptions()
-- Represents the LIVR schema for validating options for 'gmodproj-plugin-builtin'
-- export
export PluginOptions = Schema\extend {
    -- PluginOptions::namespace -> string
    -- Represents the nested namespace of the schema
    --
    namespace: "gmodproj-plugin-builtin"

    -- PluginOptions::schema -> table
    -- Represents the LIVR validation schema
    --
    schema: {
        minificationLevel: {
            one_of: {
                "none",
                "basic",
                "debug",
                "default",
                "full"
            }
        }
    }

    -- PluginOptions::default -> table
    -- Represents the default values that are merged before validation
    --
    default: {
        minificationLevel: "default"
    }
}