import format from string

import Platform from gmodproj.api

import minify from "matthewwild/minify/main"

-- ::PRODUCTION_MINIFICATION_LEVEL -> string
-- Represents the minification level of production packages
--
PRODUCTION_MINIFICATION_LEVEL = "full"

-- ::TEMPLATE_HEADER_PACKAGE(string entryPoint, string postChunk) -> string 
-- Templates the header of the platform package, allowing for a post-definition code chunk to be defined
-- export
export TEMPLATE_HEADER_PACKAGE = (entryPoint, postChunk) -> "return (function (modules, ...)
    local _G            = _G
    local error         = _G.error
    local setfenv       = _G.setfenv
    local setmetatable  = _G.setmetatable

    local moduleCache       = {}
    local packageGlobals    = {}

    local function makeEnvironment(moduleChunk)
        local exports = {}

        local moduleEnvironment = setmetatable({}, {
            __index = function (self, key)
                if exports[key] ~= nil then
                    return exports[key]
                end

                return _G[key]
            end,

            __newindex = exports
        })

        return setfenv(moduleChunk, moduleEnvironment), exports
    end

    local function makeModuleHeader(moduleName)
        return {
            name    = moduleName,
            globals = packageGlobals
        }
    end

    local function makeReadOnly(tbl)
        return setmetatable({}, {
            __index = tbl,
            __newindex = function (self, key, value) error(\"module 'exports' table is read only\") end
        })
    end

    local import = nil
    function import(moduleName, ...)
        local moduleChunk = modules[moduleName]
        if not moduleChunk then error(\"bad argument #1 to 'import' (invalid module, got '\"..moduleName..\"')\") end

        if not moduleCache[moduleName] then
            local moduleHeader                  = makeModuleHeader(moduleName)
            local moduleEnvironment, exports    = makeEnvironment(moduleChunk)

            moduleEnvironment(moduleHeader, exports, import, import, ...)

            moduleCache[moduleName] = makeReadOnly(exports)
        end

        return moduleCache[moduleName]
    end

    #{postChunk}

    return import('#{entryPoint}', ...)
end)({"

-- ::TEMPLATE_HEADER_DEVELOPMENT(string entryPoint) -> string
-- Templates the header of the platform package, providing development niceties
-- export
export TEMPLATE_HEADER_DEVELOPMENT = (entryPoint) -> TEMPLATE_HEADER_PACKAGE(entryPoint, "local loadstring = _G.loadstring

    for moduleName, assetChunk in pairs(modules) do
        modules[moduleName] = loadstring('return function (module, exports, import, dependency, ...) '..assetChunk..' end', moduleName)()
    end")

-- ::TEMPLATE_FOOTER_PACKAGE() -> string
-- Templates the footer of the platform package
-- export
export TEMPLATE_FOOTER_PACKAGE = () -> "}, ...)"

-- ::TEMPLATE_MODULE_PACKAGE(string assetName, string assetChunk) -> string
-- Templates an asset as a module for the platform package
-- export
export TEMPLATE_MODULE_PACKAGE = (assetName, assetChunk) -> "['#{assetName}'] = function (module, exports, import, dependency, ...) #{assetChunk} end,\n"

-- ::TEMPLATE_MODULE_DEVELOPMENT(string assetName, string assetChunk) -> string
-- Templates an asset as a module for the platform package, providing development niceties
-- export
export TEMPLATE_MODULE_DEVELOPMENT = (assetName, assetChunk) -> "['#{assetName}'] = #{format('%q', assetChunk)},\n"

-- LuaPlatform::LuaPlatform()
-- Represents the Garry's Mod targetable scripting platform
-- export
export LuaPlatform = Platform\extend {
    -- LuaPlatform::generatePackageHeader(string entryPoint) -> string
    -- Generates the header code of the built package
    --
    generatePackageHeader: (entryPoint) => @isProduction and TEMPLATE_HEADER_PACKAGE(entryPoint, "") or TEMPLATE_HEADER_DEVELOPMENT(entryPoint)

    -- LuaPlatform::generatePackageModule(string assetName, string assetChunk) -> string
    -- Transforms an asset and generates code understood by the platform's module system
    --
    generatePackageModule: (assetName, assetChunk) => @isProduction and TEMPLATE_MODULE_PACKAGE(assetName, assetChunk) or TEMPLATE_MODULE_DEVELOPMENT(assetName, assetChunk)

    -- LuaPlatform::generatePackageFooter() -> string
    -- Generates the footer code of the built package
    --
    generatePackageFooter: () => TEMPLATE_FOOTER_PACKAGE()

    -- LuaPlatform::transformPackage(string packageContents) -> string
    -- Performs a final transformation on the built package
    --
    transformPackage: (packageContents) => @isProduction and minify(packageContents, PRODUCTION_MINIFICATION_LEVEL) or packageContents
}

-- ::setMinificationLevel(string level) -> void
-- Sets the the level of minification performed on production packages
-- export
export setMinificationLevel = (level) ->
    PRODUCTION_MINIFICATION_LEVEL = level