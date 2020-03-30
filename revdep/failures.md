# vroom

<details>

* Version: 1.2.0
* Source code: https://github.com/cran/vroom
* URL: https://github.com/r-lib/vroom
* BugReports: https://github.com/r-lib/vroom/issues
* Date/Publication: 2020-01-13 22:40:02 UTC
* Number of recursive dependencies: 88

Run `revdep_details(,"vroom")` for more info

</details>

## In both

*   checking whether package ‘vroom’ can be installed ... ERROR
    ```
    Installation failed.
    See ‘.../revdep/checks.noindex/vroom/new/vroom.Rcheck/00install.out’ for details.
    ```

## Installation

### Devel

```
* installing *source* package ‘vroom’ ...
** package ‘vroom’ successfully unpacked and MD5 sums checked
** using staged installation
** libs
clang++ -std=gnu++11 -I"/Library/Frameworks/R.framework/Resources/include" -DNDEBUG  -I".../revdep/library.noindex/vroom/progress/include" -I".../revdep/library.noindex/vroom/Rcpp/include" -isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -I/usr/local/include -Imio/include -DWIN32_LEAN_AND_MEAN -Ispdlog/include -fPIC  -Wall -g -O2  -c Iconv.cpp -o Iconv.o
clang++ -std=gnu++11 -I"/Library/Frameworks/R.framework/Resources/include" -DNDEBUG  -I".../revdep/library.noindex/vroom/progress/include" -I".../revdep/library.noindex/vroom/Rcpp/include" -isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -I/usr/local/include -Imio/include -DWIN32_LEAN_AND_MEAN -Ispdlog/include -fPIC  -Wall -g -O2  -c LocaleInfo.cpp -o LocaleInfo.o
clang++ -std=gnu++11 -I"/Library/Frameworks/R.framework/Resources/include" -DNDEBUG  -I".../revdep/library.noindex/vroom/progress/include" -I".../revdep/library.noindex/vroom/Rcpp/include" -isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -I/usr/local/include -Imio/include -DWIN32_LEAN_AND_MEAN -Ispdlog/include -fPIC  -Wall -g -O2  -c RcppExports.cpp -o RcppExports.o
clang++ -std=gnu++11 -I"/Library/Frameworks/R.framework/Resources/include" -DNDEBUG  -I".../revdep/library.noindex/vroom/progress/include" -I".../revdep/library.noindex/vroom/Rcpp/include" -isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -I/usr/local/include -Imio/include -DWIN32_LEAN_AND_MEAN -Ispdlog/include -fPIC  -Wall -g -O2  -c altrep.cc -o altrep.o
clang++ -std=gnu++11 -I"/Library/Frameworks/R.framework/Resources/include" -DNDEBUG  -I".../revdep/library.noindex/vroom/progress/include" -I".../revdep/library.noindex/vroom/Rcpp/include" -isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -I/usr/local/include -Imio/include -DWIN32_LEAN_AND_MEAN -Ispdlog/include -fPIC  -Wall -g -O2  -c delimited_index.cc -o delimited_index.o
clang++ -std=gnu++11 -I"/Library/Frameworks/R.framework/Resources/include" -DNDEBUG  -I".../revdep/library.noindex/vroom/progress/include" -I".../revdep/library.noindex/vroom/Rcpp/include" -isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -I/usr/local/include -Imio/include -DWIN32_LEAN_AND_MEAN -Ispdlog/include -fPIC  -Wall -g -O2  -c delimited_index_connection.cc -o delimited_index_connection.o
clang++ -std=gnu++11 -I"/Library/Frameworks/R.framework/Resources/include" -DNDEBUG  -I".../revdep/library.noindex/vroom/progress/include" -I".../revdep/library.noindex/vroom/Rcpp/include" -isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -I/usr/local/include -Imio/include -DWIN32_LEAN_AND_MEAN -Ispdlog/include -fPIC  -Wall -g -O2  -c fixed_width_index_connection.cc -o fixed_width_index_connection.o
clang++ -std=gnu++11 -I"/Library/Frameworks/R.framework/Resources/include" -DNDEBUG  -I".../revdep/library.noindex/vroom/progress/include" -I".../revdep/library.noindex/vroom/Rcpp/include" -isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -I/usr/local/include -Imio/include -DWIN32_LEAN_AND_MEAN -Ispdlog/include -fPIC  -Wall -g -O2  -c gen.cc -o gen.o
clang -I"/Library/Frameworks/R.framework/Resources/include" -DNDEBUG  -I".../revdep/library.noindex/vroom/progress/include" -I".../revdep/library.noindex/vroom/Rcpp/include" -isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -I/usr/local/include  -fPIC  -Wall -g -O2  -c grisu3.c -o grisu3.o
clang++ -std=gnu++11 -I"/Library/Frameworks/R.framework/Resources/include" -DNDEBUG  -I".../revdep/library.noindex/vroom/progress/include" -I".../revdep/library.noindex/vroom/Rcpp/include" -isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -I/usr/local/include -Imio/include -DWIN32_LEAN_AND_MEAN -Ispdlog/include -fPIC  -Wall -g -O2  -c guess_type.cc -o guess_type.o
clang++ -std=gnu++11 -I"/Library/Frameworks/R.framework/Resources/include" -DNDEBUG  -I".../revdep/library.noindex/vroom/progress/include" -I".../revdep/library.noindex/vroom/Rcpp/include" -isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -I/usr/local/include -Imio/include -DWIN32_LEAN_AND_MEAN -Ispdlog/include -fPIC  -Wall -g -O2  -c index_collection.cc -o index_collection.o
clang -I"/Library/Frameworks/R.framework/Resources/include" -DNDEBUG  -I".../revdep/library.noindex/vroom/progress/include" -I".../revdep/library.noindex/vroom/Rcpp/include" -isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -I/usr/local/include  -fPIC  -Wall -g -O2  -c localtime.c -o localtime.o
clang++ -std=gnu++11 -I"/Library/Frameworks/R.framework/Resources/include" -DNDEBUG  -I".../revdep/library.noindex/vroom/progress/include" -I".../revdep/library.noindex/vroom/Rcpp/include" -isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -I/usr/local/include -Imio/include -DWIN32_LEAN_AND_MEAN -Ispdlog/include -fPIC  -Wall -g -O2  -c vroom.cc -o vroom.o
clang++ -std=gnu++11 -I"/Library/Frameworks/R.framework/Resources/include" -DNDEBUG  -I".../revdep/library.noindex/vroom/progress/include" -I".../revdep/library.noindex/vroom/Rcpp/include" -isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -I/usr/local/include -Imio/include -DWIN32_LEAN_AND_MEAN -Ispdlog/include -fPIC  -Wall -g -O2  -c vroom_big_int.cc -o vroom_big_int.o
clang++ -std=gnu++11 -I"/Library/Frameworks/R.framework/Resources/include" -DNDEBUG  -I".../revdep/library.noindex/vroom/progress/include" -I".../revdep/library.noindex/vroom/Rcpp/include" -isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -I/usr/local/include -Imio/include -DWIN32_LEAN_AND_MEAN -Ispdlog/include -fPIC  -Wall -g -O2  -c vroom_chr.cc -o vroom_chr.o
clang++ -std=gnu++11 -I"/Library/Frameworks/R.framework/Resources/include" -DNDEBUG  -I".../revdep/library.noindex/vroom/progress/include" -I".../revdep/library.noindex/vroom/Rcpp/include" -isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -I/usr/local/include -Imio/include -DWIN32_LEAN_AND_MEAN -Ispdlog/include -fPIC  -Wall -g -O2  -c vroom_date.cc -o vroom_date.o
clang++ -std=gnu++11 -I"/Library/Frameworks/R.framework/Resources/include" -DNDEBUG  -I".../revdep/library.noindex/vroom/progress/include" -I".../revdep/library.noindex/vroom/Rcpp/include" -isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -I/usr/local/include -Imio/include -DWIN32_LEAN_AND_MEAN -Ispdlog/include -fPIC  -Wall -g -O2  -c vroom_dbl.cc -o vroom_dbl.o
clang++ -std=gnu++11 -I"/Library/Frameworks/R.framework/Resources/include" -DNDEBUG  -I".../revdep/library.noindex/vroom/progress/include" -I".../revdep/library.noindex/vroom/Rcpp/include" -isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -I/usr/local/include -Imio/include -DWIN32_LEAN_AND_MEAN -Ispdlog/include -fPIC  -Wall -g -O2  -c vroom_dttm.cc -o vroom_dttm.o
In file included from index_collection.cc:2:
In file included from ./delimited_index_connection.h:1:
In file included from ./delimited_index.h:9:
In file included from mio/include/mio/shared_mmap.hpp:24:
In file included from mio/include/mio/mmap.hpp:24:
In file included from mio/include/mio/page.hpp:27:
In file included from /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/unistd.h:655:
/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/gethostuuid.h:39:17: error: unknown type name 'uuid_t'
int gethostuuid(uuid_t, const struct timespec *) __OSX_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_NA);
                ^
In file included from index_collection.cc:2:
In file included from ./delimited_index_connection.h:1:
In file included from ./delimited_index.h:9:
In file included from mio/include/mio/shared_mmap.hpp:24:
In file included from mio/include/mio/mmap.hpp:24:
In file included from mio/include/mio/page.hpp:27:
/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/unistd.h:662:27: error: unknown type name 'uuid_t'; did you mean 'uid_t'?
int      getsgroups_np(int *, uuid_t);
                              ^
/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/sys/_types/_uid_t.h:31:31: note: 'uid_t' declared here
typedef __darwin_uid_t        uid_t;
                              ^
In file included from index_collection.cc:2:
In file included from ./delimited_index_connection.h:1:
In file included from ./delimited_index.h:9:
In file included from mio/include/mio/shared_mmap.hpp:24:
In file included from mio/include/mio/mmap.hpp:24:
In file included from mio/include/mio/page.hpp:27:
/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/unistd.h:664:27: error: unknown type name 'uuid_t'; did you mean 'uid_t'?
int      getwgroups_np(int *, uuid_t);
                              ^
/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/sys/_types/_uid_t.h:31:31: note: 'uid_t' declared here
typedef __darwin_uid_t        uid_t;
                              ^
In file included from index_collection.cc:2:
In file included from ./delimited_index_connection.h:1:
In file included from ./delimited_index.h:9:
In file included from mio/include/mio/shared_mmap.hpp:24:
In file included from mio/include/mio/mmap.hpp:24:
In file included from mio/include/mio/page.hpp:27:
/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/unistd.h:727:31: error: unknown type name 'uuid_t'; did you mean 'uid_t'?
int      setsgroups_np(int, const uuid_t);
                                  ^
/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/sys/_types/_uid_t.h:31:31: note: 'uid_t' declared here
typedef __darwin_uid_t        uid_t;
                              ^
In file included from index_collection.cc:2:
In file included from ./delimited_index_connection.h:1:
In file included from ./delimited_index.h:9:
In file included from mio/include/mio/shared_mmap.hpp:24:
In file included from mio/include/mio/mmap.hpp:24:
In file included from mio/include/mio/page.hpp:27:
/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/unistd.h:729:31: error: unknown type name 'uuid_t'; did you mean 'uid_t'?
int      setwgroups_np(int, const uuid_t);
                                  ^
/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/sys/_types/_uid_t.h:31:31: note: 'uid_t' declared here
typedef __darwin_uid_t        uid_t;
                              ^
5 errors generated.
make: *** [index_collection.o] Error 1
make: *** Waiting for unfinished jobs....
ERROR: compilation failed for package ‘vroom’
* removing ‘.../revdep/checks.noindex/vroom/new/vroom.Rcheck/vroom’

```
### CRAN

```
* installing *source* package ‘vroom’ ...
** package ‘vroom’ successfully unpacked and MD5 sums checked
** using staged installation
** libs
clang++ -std=gnu++11 -I"/Library/Frameworks/R.framework/Resources/include" -DNDEBUG  -I".../revdep/library.noindex/vroom/progress/include" -I".../revdep/library.noindex/fs/old/Rcpp/include" -isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -I/usr/local/include -Imio/include -DWIN32_LEAN_AND_MEAN -Ispdlog/include -fPIC  -Wall -g -O2  -c Iconv.cpp -o Iconv.o
clang++ -std=gnu++11 -I"/Library/Frameworks/R.framework/Resources/include" -DNDEBUG  -I".../revdep/library.noindex/vroom/progress/include" -I".../revdep/library.noindex/fs/old/Rcpp/include" -isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -I/usr/local/include -Imio/include -DWIN32_LEAN_AND_MEAN -Ispdlog/include -fPIC  -Wall -g -O2  -c LocaleInfo.cpp -o LocaleInfo.o
clang++ -std=gnu++11 -I"/Library/Frameworks/R.framework/Resources/include" -DNDEBUG  -I".../revdep/library.noindex/vroom/progress/include" -I".../revdep/library.noindex/fs/old/Rcpp/include" -isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -I/usr/local/include -Imio/include -DWIN32_LEAN_AND_MEAN -Ispdlog/include -fPIC  -Wall -g -O2  -c RcppExports.cpp -o RcppExports.o
clang++ -std=gnu++11 -I"/Library/Frameworks/R.framework/Resources/include" -DNDEBUG  -I".../revdep/library.noindex/vroom/progress/include" -I".../revdep/library.noindex/fs/old/Rcpp/include" -isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -I/usr/local/include -Imio/include -DWIN32_LEAN_AND_MEAN -Ispdlog/include -fPIC  -Wall -g -O2  -c altrep.cc -o altrep.o
clang++ -std=gnu++11 -I"/Library/Frameworks/R.framework/Resources/include" -DNDEBUG  -I".../revdep/library.noindex/vroom/progress/include" -I".../revdep/library.noindex/fs/old/Rcpp/include" -isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -I/usr/local/include -Imio/include -DWIN32_LEAN_AND_MEAN -Ispdlog/include -fPIC  -Wall -g -O2  -c delimited_index.cc -o delimited_index.o
clang++ -std=gnu++11 -I"/Library/Frameworks/R.framework/Resources/include" -DNDEBUG  -I".../revdep/library.noindex/vroom/progress/include" -I".../revdep/library.noindex/fs/old/Rcpp/include" -isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -I/usr/local/include -Imio/include -DWIN32_LEAN_AND_MEAN -Ispdlog/include -fPIC  -Wall -g -O2  -c delimited_index_connection.cc -o delimited_index_connection.o
clang++ -std=gnu++11 -I"/Library/Frameworks/R.framework/Resources/include" -DNDEBUG  -I".../revdep/library.noindex/vroom/progress/include" -I".../revdep/library.noindex/fs/old/Rcpp/include" -isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -I/usr/local/include -Imio/include -DWIN32_LEAN_AND_MEAN -Ispdlog/include -fPIC  -Wall -g -O2  -c fixed_width_index_connection.cc -o fixed_width_index_connection.o
clang++ -std=gnu++11 -I"/Library/Frameworks/R.framework/Resources/include" -DNDEBUG  -I".../revdep/library.noindex/vroom/progress/include" -I".../revdep/library.noindex/fs/old/Rcpp/include" -isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -I/usr/local/include -Imio/include -DWIN32_LEAN_AND_MEAN -Ispdlog/include -fPIC  -Wall -g -O2  -c gen.cc -o gen.o
clang -I"/Library/Frameworks/R.framework/Resources/include" -DNDEBUG  -I".../revdep/library.noindex/vroom/progress/include" -I".../revdep/library.noindex/fs/old/Rcpp/include" -isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -I/usr/local/include  -fPIC  -Wall -g -O2  -c grisu3.c -o grisu3.o
clang++ -std=gnu++11 -I"/Library/Frameworks/R.framework/Resources/include" -DNDEBUG  -I".../revdep/library.noindex/vroom/progress/include" -I".../revdep/library.noindex/fs/old/Rcpp/include" -isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -I/usr/local/include -Imio/include -DWIN32_LEAN_AND_MEAN -Ispdlog/include -fPIC  -Wall -g -O2  -c guess_type.cc -o guess_type.o
clang++ -std=gnu++11 -I"/Library/Frameworks/R.framework/Resources/include" -DNDEBUG  -I".../revdep/library.noindex/vroom/progress/include" -I".../revdep/library.noindex/fs/old/Rcpp/include" -isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -I/usr/local/include -Imio/include -DWIN32_LEAN_AND_MEAN -Ispdlog/include -fPIC  -Wall -g -O2  -c index_collection.cc -o index_collection.o
clang -I"/Library/Frameworks/R.framework/Resources/include" -DNDEBUG  -I".../revdep/library.noindex/vroom/progress/include" -I".../revdep/library.noindex/fs/old/Rcpp/include" -isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -I/usr/local/include  -fPIC  -Wall -g -O2  -c localtime.c -o localtime.o
clang++ -std=gnu++11 -I"/Library/Frameworks/R.framework/Resources/include" -DNDEBUG  -I".../revdep/library.noindex/vroom/progress/include" -I".../revdep/library.noindex/fs/old/Rcpp/include" -isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -I/usr/local/include -Imio/include -DWIN32_LEAN_AND_MEAN -Ispdlog/include -fPIC  -Wall -g -O2  -c vroom.cc -o vroom.o
clang++ -std=gnu++11 -I"/Library/Frameworks/R.framework/Resources/include" -DNDEBUG  -I".../revdep/library.noindex/vroom/progress/include" -I".../revdep/library.noindex/fs/old/Rcpp/include" -isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -I/usr/local/include -Imio/include -DWIN32_LEAN_AND_MEAN -Ispdlog/include -fPIC  -Wall -g -O2  -c vroom_big_int.cc -o vroom_big_int.o
clang++ -std=gnu++11 -I"/Library/Frameworks/R.framework/Resources/include" -DNDEBUG  -I".../revdep/library.noindex/vroom/progress/include" -I".../revdep/library.noindex/fs/old/Rcpp/include" -isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -I/usr/local/include -Imio/include -DWIN32_LEAN_AND_MEAN -Ispdlog/include -fPIC  -Wall -g -O2  -c vroom_chr.cc -o vroom_chr.o
clang++ -std=gnu++11 -I"/Library/Frameworks/R.framework/Resources/include" -DNDEBUG  -I".../revdep/library.noindex/vroom/progress/include" -I".../revdep/library.noindex/fs/old/Rcpp/include" -isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -I/usr/local/include -Imio/include -DWIN32_LEAN_AND_MEAN -Ispdlog/include -fPIC  -Wall -g -O2  -c vroom_date.cc -o vroom_date.o
clang++ -std=gnu++11 -I"/Library/Frameworks/R.framework/Resources/include" -DNDEBUG  -I".../revdep/library.noindex/vroom/progress/include" -I".../revdep/library.noindex/fs/old/Rcpp/include" -isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -I/usr/local/include -Imio/include -DWIN32_LEAN_AND_MEAN -Ispdlog/include -fPIC  -Wall -g -O2  -c vroom_dbl.cc -o vroom_dbl.o
clang++ -std=gnu++11 -I"/Library/Frameworks/R.framework/Resources/include" -DNDEBUG  -I".../revdep/library.noindex/vroom/progress/include" -I".../revdep/library.noindex/fs/old/Rcpp/include" -isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -I/usr/local/include -Imio/include -DWIN32_LEAN_AND_MEAN -Ispdlog/include -fPIC  -Wall -g -O2  -c vroom_dttm.cc -o vroom_dttm.o
In file included from index_collection.cc:2:
In file included from ./delimited_index_connection.h:1:
In file included from ./delimited_index.h:9:
In file included from mio/include/mio/shared_mmap.hpp:24:
In file included from mio/include/mio/mmap.hpp:24:
In file included from mio/include/mio/page.hpp:27:
In file included from /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/unistd.h:655:
/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/gethostuuid.h:39:17: error: unknown type name 'uuid_t'
int gethostuuid(uuid_t, const struct timespec *) __OSX_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_NA);
                ^
In file included from index_collection.cc:2:
In file included from ./delimited_index_connection.h:1:
In file included from ./delimited_index.h:9:
In file included from mio/include/mio/shared_mmap.hpp:24:
In file included from mio/include/mio/mmap.hpp:24:
In file included from mio/include/mio/page.hpp:27:
/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/unistd.h:662:27: error: unknown type name 'uuid_t'; did you mean 'uid_t'?
int      getsgroups_np(int *, uuid_t);
                              ^
/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/sys/_types/_uid_t.h:31:31: note: 'uid_t' declared here
typedef __darwin_uid_t        uid_t;
                              ^
In file included from index_collection.cc:2:
In file included from ./delimited_index_connection.h:1:
In file included from ./delimited_index.h:9:
In file included from mio/include/mio/shared_mmap.hpp:24:
In file included from mio/include/mio/mmap.hpp:24:
In file included from mio/include/mio/page.hpp:27:
/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/unistd.h:664:27: error: unknown type name 'uuid_t'; did you mean 'uid_t'?
int      getwgroups_np(int *, uuid_t);
                              ^
/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/sys/_types/_uid_t.h:31:31: note: 'uid_t' declared here
typedef __darwin_uid_t        uid_t;
                              ^
In file included from index_collection.cc:2:
In file included from ./delimited_index_connection.h:1:
In file included from ./delimited_index.h:9:
In file included from mio/include/mio/shared_mmap.hpp:24:
In file included from mio/include/mio/mmap.hpp:24:
In file included from mio/include/mio/page.hpp:27:
/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/unistd.h:727:31: error: unknown type name 'uuid_t'; did you mean 'uid_t'?
int      setsgroups_np(int, const uuid_t);
                                  ^
/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/sys/_types/_uid_t.h:31:31: note: 'uid_t' declared here
typedef __darwin_uid_t        uid_t;
                              ^
In file included from index_collection.cc:2:
In file included from ./delimited_index_connection.h:1:
In file included from ./delimited_index.h:9:
In file included from mio/include/mio/shared_mmap.hpp:24:
In file included from mio/include/mio/mmap.hpp:24:
In file included from mio/include/mio/page.hpp:27:
/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/unistd.h:729:31: error: unknown type name 'uuid_t'; did you mean 'uid_t'?
int      setwgroups_np(int, const uuid_t);
                                  ^
/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/sys/_types/_uid_t.h:31:31: note: 'uid_t' declared here
typedef __darwin_uid_t        uid_t;
                              ^
5 errors generated.
make: *** [index_collection.o] Error 1
make: *** Waiting for unfinished jobs....
ERROR: compilation failed for package ‘vroom’
* removing ‘.../revdep/checks.noindex/vroom/old/vroom.Rcheck/vroom’

```
