import Plugin from gmodproj.api

import PluginOptions from "novacbn/gmodproj-plugin-builtin/PluginOptions"

import DataFileAsset from "novacbn/gmodproj-plugin-builtin/assets/DataFileAsset"
import JSONAsset from "novacbn/gmodproj-plugin-builtin/assets/JSONAsset"
import LuaAsset from "novacbn/gmodproj-plugin-builtin/assets/LuaAsset"
import MoonAsset from "novacbn/gmodproj-plugin-builtin/assets/MoonAsset"
import TOMLAsset from "novacbn/gmodproj-plugin-builtin/assets/TOMLAsset"

import GarrysmodPlatform from "novacbn/gmodproj-plugin-builtin/platforms/GarrysmodPlatform"
import LuaPlatform, setMinificationLevel from "novacbn/gmodproj-plugin-builtin/platforms/LuaPlatform"

import AddonTemplate from "novacbn/gmodproj-plugin-builtin/templates/AddonTemplate"
import GamemodeTemplate from "novacbn/gmodproj-plugin-builtin/templates/GamemodeTemplate"
import PackageTemplate from "novacbn/gmodproj-plugin-builtin/templates/PackageTemplate"

-- Plugin::Plugin()
-- Represents the plugin providing built-in functionality to the gmodproj command-line application
-- export
exports.Plugin = Plugin\extend {
    -- Plugin::schema -> Schema
    -- Represents the Schema validator for the plugin
    schema: PluginOptions

    -- Plugin::registerAssets(Resolver resolver) -> void
    -- Event for registering extra Asset types with gmodproj
    -- event
    registerAssets: (resolver) =>
        -- Register the built-in scripting language support
        resolver\registerAsset("lua", LuaAsset)
        resolver\registerAsset("moon", MoonAsset)

        -- Register the built-in flatfile data support
        resolver\registerAsset("datl", DataFileAsset)
        resolver\registerAsset("json", JSONAsset)
        resolver\registerAsset("toml", TOMLAsset)

    -- Plugin::registerTemplates(Application application) -> void
    -- Event for registering extra Project Templates with gmodproj
    -- event
    registerTemplates: (application) =>
        -- Register the built-in project templates
        application\registerTemplate("addon", AddonTemplate)
        application\registerTemplate("gamemode", GamemodeTemplate)
        application\registerTemplate("package", PackageTemplate)

    -- Plugin::registerPlatforms(Packager packager) -> void
    -- Event for registering extra platform support with gmodproj
    -- event
    registerPlatforms: (packager) =>
        -- Set the minification of packages for the supported platforms
        setMinificationLevel(@options\get("minificationLevel"))

        -- Register the built-in platform support classes
        packager\registerPlatform("garrysmod", GarrysmodPlatform)
        packager\registerPlatform("lua", LuaPlatform)
}