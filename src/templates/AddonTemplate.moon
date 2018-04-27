import Template from gmodproj.api

-- AddonTemplate::AddonTemplate()
-- Represents the project template to create new Garry's Mod addons
-- export
export AddonTemplate = Template\extend {
    -- AddonTemplate::createProject() -> void
    -- Event called to construct the new project
    -- event
    createProject: () =>
        -- Create the project directories
        @createDirectory("addons")
        @createDirectory("addons/#{@projectName}")
        @createDirectory("addons/#{@projectName}/lua")
        @createDirectory("addons/#{@projectName}/lua/autorun")
        @createDirectory("addons/#{@projectName}/lua/autorun/client")
        @createDirectory("addons/#{@projectName}/lua/autorun/server")
        @createDirectory("src")

        -- Create the Garry's Mod addon manifest
        @writeJSON("addons/#{@projectName}/addon.json", {
            title:          @projectName,
            type:           "",
            tags:           {},
            description:    "",
            ignore:         {}
        })

        -- Format a header prefix for brevity
        moduleHeader = @projectAuthor.."/"..@projectName

        -- Create the project's entry points HACK: gmodproj currently doesn't do lexical lookup of import/dependency statements...
        @write("src/client.lua", "imp".."ort('#{moduleHeader}/shared').sharedFunc()\nprint('I was called on the client!')")
        @write("src/server.lua", "imp".."ort('#{moduleHeader}/shared').sharedFunc()\nprint('I was called on the server!')")
        @write("src/shared.lua", "function sharedFunc()\n\tprint('I was called on the client and server!')\nend")

        -- Create the project's manifest
        @writeDataFile("manifest.gmodproj", {
            Project: {
                projectName:        @projectName
                projectAuthor:      @projectAuthor
                projectVersion:     "0.0.0"
                projectRepository:  "unknown://unknown"

                buildDirectory: "addons/#{@projectName}/lua"

                entryPoints: {
                    {"#{moduleHeader}/client", "autorun/client/#{@projectName}.client"},
                    {"#{moduleHeader}/server", "autorun/server/#{@projectName}.server"}
                }
            }
        })
}