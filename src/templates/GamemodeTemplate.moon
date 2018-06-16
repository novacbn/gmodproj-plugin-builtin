import format from string
import concat, insert from table

import Template from gmodproj.api

-- ::TEMPLATE_GAMEMODE_MANIFEST(string projectName) -> string
-- Template for creating a Garry's Mod gamemode manifest file
--
TEMPLATE_GAMEMODE_MANIFEST = (projectName) ->
    -- HACK: would rather use MoonScript's templating, but it only works with double quotes
    return format([["%s"
{
    "base"			"base"
    "title"			"%s"
    "maps"			""
    "menusystem"	"1"

    "settings" {}
}]], projectName, projectName)

-- ::TEMPLATE_PROJECT_BOOTLOADER(table clientFiles, table includeFiles) -> string
-- Template for creating Lua project bootloader scripts
--
TEMPLATE_PROJECT_BOOTLOADER = (clientFiles, includeFiles) ->
    bootloaderLines = {}

    -- If there are scripts to send to the client, template them
    if clientFiles
        insert(bootloaderLines, "-- These scripts are sent to the client")
        insert(bootloaderLines, "AddCSLuaFile('#{file}')") for file in *clientFiles

    -- If there are scripts to bootload, template them
    if includeFiles
        insert(bootloaderLines, "-- These scripts are bootloaded by this script")
        insert(bootloaderLines, "include('#{file}')") for file in *includeFiles

    -- Combine lines via newline
    return concat(bootloaderLines, "\n")

-- GamemodeTemplate::GamemodeTemplate()
-- Represents the project template to create new Garry's Mod gamemodes
-- export
export GamemodeTemplate = Template\extend {
    -- GamemodeTemplate::createProject() -> void
    -- Event called to construct the new project
    -- event
    createProject: () =>
        -- Create the project directories
        @createDirectory("gamemodes")
        @createDirectory("gamemodes/#{@projectName}")
        @createDirectory("gamemodes/#{@projectName}/gamemode")
        @createDirectory("src")

        -- Create the Garry's Mod gamemode manifest
        @write("gamemodes/#{@projectName}/#{@projectName}.txt", TEMPLATE_GAMEMODE_MANIFEST(
            @projectName
        ))

        -- Create the Garry's Mod bootloader scripts
        @write("gamemodes/#{@projectName}/gamemode/cl_init.lua", TEMPLATE_PROJECT_BOOTLOADER(
            nil, {"#{@projectName}.client.lua"}
        ))

        @write("gamemodes/#{@projectName}/gamemode/init.lua", TEMPLATE_PROJECT_BOOTLOADER(
            {"cl_init.lua", "#{@projectName}.client.lua"},
            {"#{@projectName}.server.lua"}
        ))

        -- Format a header prefix for brevity
        moduleHeader = @projectAuthor.."/"..@projectName

        -- Create the project's entry points
        -- HACK: gmodproj currently doesn't do lexical lookup of import/dependency statements...
        @write("src/client.lua", "imp".."ort('#{moduleHeader}/shared').sharedFunc()\nprint('I was called on the client!')")
        @write("src/server.lua", "imp".."ort('#{moduleHeader}/shared').sharedFunc()\nprint('I was called on the server!')")
        @write("src/shared.lua", "function sharedFunc()\n\tprint('I was called on the client and server!')\nend")

        -- Create the project's manifest
        @writeProperties(".gmodmanifest", {
            name:       @projectName
            author:     @projectAuthor
            version:    "0.0.0"
            repository: "unknown://unknown"

            buildDirectory: "gamemodes/#{@projectName}/gamemode"

            projectBuilds: {
                "#{moduleHeader}/client": "#{@projectName}_client"
                "#{moduleHeader}/server": "#{@projectName}_server"
            }
        })
}