# Package

version       = "0.1.0"
author        = "Stas Ukolov"
description   = "Twitter clone"
license       = "MIT"
srcDir        = "src"

bin           = @["tweeter"]
binDir        = "bin"
skipExt       = @["nim"]

# Dependencies

requires "nim >= 1.2.6"
requires "jester >= 0.4"
requires "karax >= 1.0.0"
