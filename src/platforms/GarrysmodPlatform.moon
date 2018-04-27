import LuaPlatform, TEMPLATE_HEADER_PACKAGE from "novacbn/gmodproj-plugin-builtin/platforms/LuaPlatform"

-- ::TEMPLATE_HEADER_DEVELOPMENT(string entryPoint) -> string
-- Templates the header of the platform package, providing development niceties
-- export
export TEMPLATE_HEADER_DEVELOPMENT = (entryPoint) -> TEMPLATE_HEADER_PACKAGE(entryPoint, "local CompileString = _G.CompileString

    for moduleName, assetChunk in pairs(modules) do
        modules[moduleName] = CompileString('return function (module, exports, import, dependency, ...) '..assetChunk..' end', moduleName)()
    end")

-- GarrysmodPlatform::GarrysmodPlatform()
-- Represents the Garry's Mod targetable scripting platform
-- export
export GarrysmodPlatform = LuaPlatform\extend {
    -- GarrysmodPlatform::generatePackageHeader(string entryPoint) -> string
    -- Generates the header code of the built package
    --
    generatePackageHeader: (entryPoint) => @isProduction and TEMPLATE_HEADER_PACKAGE(entryPoint, "") or TEMPLATE_HEADER_DEVELOPMENT(entryPoint)
}