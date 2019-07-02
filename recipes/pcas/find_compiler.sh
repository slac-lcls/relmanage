echo "Attempting to determine the compiler used by the build script..."
if [ -n "$CLANG" ]; then
    COMPILER_PATH="$(which $CLANG)"
    COMPILER_BASE="$(basename $CLANG)"
    COMPILER_NAME="clang"
elif [ -n "$GCC" ]; then
    COMPILER_PATH="$(which $GCC)"
    COMPILER_BASE="$(basename $GCC)"
    COMPILER_NAME="gcc"
elif [ -n "$CC" ]; then
    COMPILER_PATH="$(which $CC)"
    COMPILER_BASE="$(basename $CC)"
    COMPILER_NAME="cc"
else
    COMPILER_PATH="$(which gcc)"
    COMPILER_BASE="gcc"
    COMPILER_NAME="$COMPILER_BASE"
fi
export GNU_DIR_OVERRIDE="$(dirname $(dirname $COMPILER_PATH))"
export CMPLR_PREFIX_OVERRIDE="${COMPILER_BASE%$COMPILER_NAME*}"
echo "Using compiler ${COMPILER_PATH} for EPICS build"
echo "Setting GNU_DIR to ${GNU_DIR_OVERRIDE}"
echo "Setting CMPLR_PREFIX to ${CMPLR_PREFIX_OVERRIDE=}"
