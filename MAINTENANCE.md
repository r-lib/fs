## Current state

fs is generally stable and new development is pretty rare.

## Known outstanding issues

Fairly often someone will run into problems compiling fs due to autotools / configure problems with the libuv dependency.
I don't have any great suggestions on work arounds for these things, other than
maybe harmonizing the Makevars with the one in httuv, which also needs to
compile libuv. https://github.com/rstudio/httpuv/blob/main/src/Makevars

The other outstanding issue is around networked drive shares / UNC paths on windows, e.g. (https://github.com/r-lib/fs/issues/296, https://github.com/r-lib/fs/issues/223, https://github.com/r-lib/fs/issues/147)
These partially stem from deficiencies in the OS APIs and the fs node package ended up going back to a javascript only implementation to avoid the issues.
