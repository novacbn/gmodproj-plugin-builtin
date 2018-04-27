local table_concat = table.concat

local llex      = import "matthewwild/minify/llex"
local lparser   = import "matthewwild/minify/lparser"
local optlex    = import "matthewwild/minify/optlex"
local optparser = import "matthewwild/minify/optparser"

local minificationLevels = {
	basic   = {"comments", "whitespace", "emptylines"},
	debug   = {"whitespace", "locals", "entropy", "comments", "numbers"},
	default = {"comments", "whitespace", "emptylines", "numbers", "locals"},
	full    = {"comments", "whitespace", "emptylines", "eols", "strings", "numbers", "locals", "entropy"}
}

local optionsMap = {
    ["comments"]    = "opt-comments",
    ["emptylines"]  = "opt-emptylines",
    ["entropy"]     = "opt-entropy",
    ["eols"]        = "opt-eols",
    ["locals"]      = "opt-locals",
    ["numbers"]     = "opt-numbers",
    ["strings"]     = "opt-strings",
    ["whitespace"]  = "opt-whitespace"
}

local function remapOptions(options)
    local remappedOptions = {}

    local optionKey
    for key, value in pairs(options) do
        optionKey = optionsMap[value]
        if optionKey then
            remappedOptions[optionKey] = true
        end
    end

    return remappedOptions
end

function minify(contents, options)
    if options == "none" then return contents end

    assert(type(options) == "string", "bad argument #1 to 'minify' (expected string)")
    assert(type(options) == "table" or type(options) == "string", "bad argument #2 to 'minify' (expected string or table)")

    if type(options) == "string" then
        options = assert(minificationLevels[options], "bad argument #2 to 'minify' (invalid minification level)")
    end

    options = remapOptions(options)

    llex.init(contents)
    llex.llex()

    local toklist, seminfolist, toklnlist = llex.tok, llex.seminfo, llex.tokln
    if options["opt-locals"] then
        lparser.init(toklist, seminfolist, toklnlist)
        local globalinfo, localinfo = lparser.parser()
        optparser.optimize(options, toklist, seminfolist, globalinfo, localinfo)
    end

    toklist, seminfolist, toklnlist = optlex.optimize(options, toklist, seminfolist, toklnlist)

    return table_concat(seminfolist)
end