import Template from gmodproj.api

-- ::TEMPLATE_DUMMY_PACKAGE(string projectAuthor, string projectName) -> string
-- Template for formatting a new dummy main file for the project
--
TEMPLATE_DUMMY_PACKAGE = (projectAuthor, projectName) -> "-- Code within this project can be imported by dependent project that have this installed
-- E.g. If this was exported:
function add(x, y)
    return x + y
end

-- Then project that have this project installed via 'gmodproj install' could import it via:
local #{projectName} = imp".."ort('#{projectAuthor}/#{projectName}/main')
print(#{projectName}.add(1, 2)) -- Prints '3' to console



-- Alternatively, if this package was built with `gmodproj build`, you could import the entire library in Garry's Mod:
local #{projectName} = include('#{projectAuthor}.#{projectName}.lua')
print(#{projectName}.add(1, 2)) -- Prints '3' to console

-- NOTE: when doing this, only the 'main.lua' exports can be used
-- If you were to have this in 'substract.lua':
function substract(a, b)
    return a - b
end

-- You would need to alias the export in 'main.lua' to use it in a standard script:
exports.substract = imp".."ort('#{projectAuthor}/#{projectName}/substract')

-- Then in a standard Garry's Mod script:
local #{projectName} = include('#{projectAuthor}.#{projectName}.lua')
print(#{projectName}.substract(3, 1)) -- Prints '2' to console
"

-- PackageTemplate::PackageTemplate()
-- Represents the project template to create new importable packages
-- export
export PackageTemplate = Template\extend {
    -- PackageTemplate::createProject() -> void
    -- Event called to construct the new project
    -- event
    createProject: () =>
        -- Create the project directories
        @createDirectory("dist")
        @createDirectory("src")

        -- Create the main file of the project
        @write("src/main.lua", TEMPLATE_DUMMY_PACKAGE(
            @projectAuthor, @projectName
        ))

        -- Create the project's manifest
        @writeProperties(".gmodmanifest", {
            name:       @projectName
            author:     @projectAuthor
            version:    "0.0.0"
            repository: "unknown://unknown"

            projectBuilds: {
                "#{@projectAuthor}/#{@projectName}/main": "#{@projectAuthor}_#{@projectName}"
            }
        })
}