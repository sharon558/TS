#  See LICENSE for details
#
#  The version number in AC_INIT is for the tmap package.
#  Developers - the version number should *NEVER* be changed except by, 
#  or with explicit permission from, Nils Homer.  If you really feel 
#  like changing the version number, you must change the following files:
#  - doc/tmap-book.tex  (edit one instance of version #)
#  - doc/tmap-book.pdf  (type make in the doc directory)
#  - scripts/doxygen/doxygen_config.ini (edit one instance of version #)

AC_PREREQ(2.61);
AC_INIT([tmap],[3.4.1],[http://ioncommunity.thermofisher.com],[tmap])
AC_COPYRIGHT([See LICENSE for copyright information.])
AC_CONFIG_AUX_DIR(config)
AM_INIT_AUTOMAKE([dist-bzip2 subdir-objects])
AC_CONFIG_SRCDIR([config.h.in])
AC_CONFIG_HEADERS([config.h])

# Sets build_cpu, build_vendor and build_os variables
AC_CANONICAL_BUILD

# Check for C and C++ compilers
CFLAGS_TMP=${CFLAGS}; # Save, as AC_PROG_CC sets CFLAGS
CXXFLAGS_TMP=${CXXFLAGS}; # Save, as AC_PROG_CC sets CFLAGS
AC_PROG_CC
AM_PROG_CC_C_O
AC_PROG_CXX
AC_PROG_CXX_C_O
CFLAGS=${CFLAGS_TMP}; # Restore CFLAGS
CXXFLAGS=${CXXFLAGS_TMP}; # Restore CXXFLAGS

AC_PROG_INSTALL
AC_GNU_SOURCE
#AC_PROG_RANLIB

# set CFLAGS and CXXFLAGS
# condition on BWT Type!
## 0 - Use this to use the original BWT code 
extended_CFLAGS="-D_TMAP_BWT_RUN_TYPE=0 -D_USE_KNETFILE -Isrc/samtools -DSAMTOOLS_MAIN";
default_CFLAGS="-Wall -g -O3 -pthread -msse3";
default_CXXFLAGS="-Wall -g -O3 -pthread -msse3";
extended_CXXFLAGS="-D__STDC_LIMIT_MACROS -D__STDC_CONSTANT_MACROS -D__STDC_FORMAT_MACROS"; # for <stdint.h> and <inttypes.h>
## 1 - Use this to use the optimized code 
#extended_CFLAGS="-D_TMAP_BWT_RUN_TYPE=0";
#default_CFLAGS="-Wall -g -O3 -pthread -msse4.1";
## 2 - Use this to test the optimized code against the original BWT code 
#extended_CFLAGS="-D_TMAP_BWT_RUN_TYPE=0";
#default_CFLAGS="-Wall -g -O3 -pthread -msse4.1";

AC_MSG_CHECKING(whether the git revision is available)
gitrev="`git log 2>/dev/null | grep -m 1 commit | awk '{print $2}'`";
if test -n "${gitrev}"; then
    GITREV="${gitrev}";
	echo "${gitrev}" > tmap.git.rev;
elif test -f "tmap.git.rev"; then
	GITREV="`head -n 1 tmap.git.rev`";
fi
if test -n "${GITREV}"; then
    AC_REVISION(["${GITREV}"])
    AC_DEFINE_UNQUOTED(GIT_REV, "${GITREV}", [Define to be the git revision number])
    AC_MSG_RESULT(yes)
else
	AC_MSG_RESULT(no)
fi

AC_ARG_ENABLE(intel64, [  --enable-intel64        optimize for Intel64 CPU such as Xeon and Core2], [extended_CFLAGS="${extended_CFLAGS} -mtune=nocona"], [])
AC_ARG_ENABLE(bz2, [  --disable-bz2         use this option to disable bz2 support], [AC_DEFINE(DISABLE_BZ2,1,[Define 1 if we want to disable bz2 support])], [AC_CHECK_LIB([bz2], [BZ2_bzRead])])
AC_ARG_ENABLE(debug-functions, [  --enable-debug-functions        use this option to enable debugging functions support], [AC_DEFINE(ENABLE_TMAP_DEBUG_FUNCTIONS,1,[Define 1 if we want to enable TMAP debugging functions support])], [])
# NB: what happens if --disable-tcmalloc is used with --enable-perftools ?
AC_ARG_ENABLE(tcmalloc, [  --disable-tcmalloc      disable tcmalloc for memory allocation], [], [AC_CHECK_LIB([tcmalloc],malloc)]) 
AC_ARG_ENABLE(perftools, [  --enable-perftools      enable google performance tools for profiling and heap checking], [LIBS="${LIBS} -lprofiler"], [])
AC_ARG_ENABLE(32bit-support, 
			  [  --enable-32bit-support     use this option to enable 32bit support (64bit by default)], 
			  [AC_MSG_WARN("Using 32-bit SA intervals; Genome sizes limited to 4Gb")
			  AC_DEFINE(TMAP_BWT_32_BIT,1,[Define 1 if we want to enable TMAP 32bit support])],
			  [AC_MSG_WARN("Using 64-bit SA intervals; Genome sizes greater than 4Gb are supported")])
AC_ARG_ENABLE(coloring, [  --disable-coloring      disable terminal coloring], [AC_DEFINE(DISABLE_COLORING,1,[Define 1 if we want to disable terminal coloring])], [])
AC_ARG_ENABLE(adjacent-indels, [  --enable-adjacent-indels      enable adjacent insertion and deletions in the alignment], [AC_DEFINE(ENABLE_ADJACENT_INDELS,1,[Define 1 if we want to enable adjacent indels support])], [])

CFLAGS="${CFLAGS} ${default_CFLAGS} ${extended_CFLAGS}";
CXXFLAGS="${CXXFLAGS} ${default_CXXFLAGS} ${extended_CXXFLAGS}";


# Checks for typedefs, structures, and compiler characteristics.
AC_C_CONST
AC_C_VOLATILE
AC_C_INLINE
# Checks for library functions.
AC_FUNC_MALLOC 
AC_FUNC_REALLOC
AC_FUNC_ALLOCA
AC_FUNC_ERROR_AT_LINE
AC_FUNC_FSEEKO
AC_FUNC_MEMCMP
AC_FUNC_SELECT_ARGTYPES
AC_FUNC_STAT
AC_FUNC_STRTOD
AC_FUNC_VPRINTF
AC_CHECK_LIB([z], [gzread])
AC_CHECK_LIB([m], [pow])
AC_CHECK_LIB([pthread], [pthread_create])
#AC_CHECK_LIB([libtcmalloc_minimal],malloc) # Use this to not include the heap profiler and checker
AC_CHECK_FUNCS([pow strdup memset strchr strdup strstr memmove getopt_long gettimeofday])
AC_CHECK_FUNCS([gethostbyaddr gethostbyname memchr select socket sqrt strerror strtol])

# Check types
AC_TYPE_INT8_T
AC_TYPE_INT16_T
AC_TYPE_INT32_T
AC_TYPE_INT64_T
AC_TYPE_UINT8_T
AC_TYPE_UINT16_T
AC_TYPE_UINT32_T
AC_TYPE_UINT64_T
AC_TYPE_SIZE_T
AC_TYPE_OFF_T
AC_TYPE_SIGNAL
AC_TYPE_SSIZE_T

# Set proprocessor SIZEOF_short_int, SIZEOF_int, SIZEOF_long_int
AC_CHECK_SIZEOF([short int])
AC_CHECK_SIZEOF([int])
AC_CHECK_SIZEOF([long int])

# Checks for header files.
AC_HEADER_STDC
AC_HEADER_STDBOOL
AC_HEADER_TIME
AC_CHECK_HEADERS([stdlib.h stdio.h stdint.h string.h sys/time.h unistd.h float.h zlib.h bzlib.h pthread.h limits.h netinet/in.h x86intrin.h getopt.h])
AC_CHECK_HEADERS([arpa/inet.h fcntl.h netdb.h stddef.h sys/socket.h wchar.h curses.h xcurses.h])

AC_CONFIG_FILES([Makefile])

AC_OUTPUT
