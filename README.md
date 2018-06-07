# gmodproj-plugin-builtin

> **gmodproj >= 0.4.0**

> **WARNING:** This is automatically bundled and enabled with `gmodproj`, you should not have to download it!

## Description

This is the bundled plugin that comes with [gmodproj](https://github.com/novacbn/gmodproj), it adds the support for the following programming languages:
* `.lua`
* `.moon`

For the following data files:
* `.datl` *(DEPRECATED)*
* `.json`
* `.lprop`
* `.mprop`
* `.toml`

And the following target platforms:
* `lua`
* `garrysmod`

## Installation

Download the latest `gmodproj-plugin-builtin.lua` build from [Releases](https://github.com/novacbn/gmodproj-plugin-builtin/releases). Place file in `{PROJECTHOME}/.gmodproj/plugins` for specific projects. Or place file in `%APPDATA%\.gmodproj\plugins` _(Windows)_ or `~/.gmodproj/plugins` _(Linux)_.

## Building

```bash
# Clone the repository
git clone https://github.com/novacbn/gmodproj-plugin-builtin

# Move into the project and make the build directory
cd gmodproj-plugin-builtin
mkdir ./dist

# Building the project will produce `./dist/gmodproj-plugin-builtin.lua`
gmodproj build # Or gmodproj build production
```

## Configuration

The following options and their defaults is supported in your `.gmodmanifest`:
```moonscript
Plugins:
    'gmodproj-plugin-builtin':
        -- Supports the following minification levels:
        --  * none - No minification is performed on packages
        --  * basic - Comments, whitespace, and emptylines are optimized
        --  * debug - Whitespace, comments, entropy, numbers, and locals are optimized
        --  * default - Comments, whitespace, emptylines, numbers, and locals are optimized
        --  * full - Comments, whitespace, emptylines, end of lines, strings, numbers, locals, and entropy are optimized
        minificationLevel: 'default'
```

## Dependencies/Third-Party

* [jonstoler/lua-toml](https://github.com/jonstoler/lua-toml)
* [matthewwild](http://matthewwild.co.uk/projects/squish/home)
* [rxi/json](https://github.com/rxi/json)