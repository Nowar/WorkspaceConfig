function filegrep() {
  echo "find . -name \".repo\" -prune -o -name \".git\" -prune -o -name \".svn\" -prune -o -type f | egrep --color -n $@"
  find . -name ".repo" -prune -o -name ".git" -prune -o -name ".svn" -prune -o -type f | egrep --color -n "$@"
}

function srcgrep() {
  echo "egrep --color -n -I -r --exclude-dir=\".repo\" --exclude-dir=\".svn\" --exclude-dir=\".git\" --exclude=\"*.swp\" $@ ./ 2> /dev/null"
  egrep --color -n -I -r --exclude-dir=".repo" --exclude-dir=".svn" --exclude-dir=".git" --exclude="*.swp" "$@" ./ 2> /dev/null
}

function srcgrep-only() {
  echo "find . -maxdepth 4 -name \".repo\" -prune -o -name \".git\" -prune -o -name \".svn\" -prune -o -type f | egrep '\.c$|\.cc$|\.cpp$|\.cxx$|\.C$|\.h$|\.hpp$|\.hxx$|\.def$|\.opt$|\.td$|\.inc$' | xargs egrep --color -n $@"
  find . -maxdepth 4 -name ".repo" -prune -o -name ".git" -prune -o -name ".svn" -prune -o -type f | egrep '\.c$|\.cc$|\.cpp$|\.cxx$|\.C$|\.h$|\.hpp$|\.hxx$|\.def$|\.opt$|\.td$|\.inc$' | xargs egrep --color -n "$@"
}

function headergrep-only() {
  echo "find . -maxdepth 4 -name \".repo\" -prune -o -name \".git\" -prune -o -name \".svn\" -prune -o -type f | egrep '\.h$|\.hpp$|\.hxx$' | xargs egrep --color -n $@"
  find . -maxdepth 4 -name ".repo" -prune -o -name ".git" -prune -o -name ".svn" -prune -o -type f | egrep '\.h$|\.hpp$|\.hxx$' | xargs egrep --color -n "$@"
}

function goto-gcc-build-dir() {
  cd $HOME/nobackup/making/gcc/gcc
}

function goto-gcc-aarch64-build-dir() {
  cd $HOME/nobackup/making/gcc-aarch64/build/gcc/gcc
}

function __git_ps1() {
  local b="$(git symbolic-ref HEAD 2> /dev/null)"
  if [ -n "$b" ]; then
    printf "%s""${b##refs/heads/}"
  fi
}

# Copy from AOSP, this is a good replacement
function make ()
{
    local start_time=$(date +"%s");
    $(which make) $@;
    local ret=$?;
    local end_time=$(date +"%s");
    local tdiff=$(($end_time-$start_time));
    local hours=$(($tdiff / 3600 ));
    local mins=$((($tdiff % 3600) / 60));
    local secs=$(($tdiff % 60));
    echo;
    if [ $ret -eq 0 ]; then
        echo -n -e "\e[0;32m#### make completed successfully ";
    else
        echo -n -e "\e[0;31m#### make failed to build some targets ";
    fi;
    if [ $hours -gt 0 ]; then
        printf "(%02g:%02g:%02g (hh:mm:ss))" $hours $mins $secs;
    else
        if [ $mins -gt 0 ]; then
            printf "(%02g:%02g (mm:ss))" $mins $secs;
        else
            if [ $secs -gt 0 ]; then
                printf "(%s seconds)" $secs;
            fi;
        fi;
    fi;
    echo -e " ####\e[00m";
    echo;
    return $ret
}

#export PS1="\n\[\033[01;37m\]\t\[\033[00m\] \[\033[01;36m\]\u\[\033[00m\]@\[\033[01;33m\]\h\[\033[00m\]:\[\033[01;35m\]\w\[\033[00m\] \[\033[01;31m\]◢▆▅▄▃崩╰(〒皿〒)╯潰▃▄▅▇◣\[\033[00m\] \[\033[01;30m\]\$(__git_ps1)\[\033[00m\]\n\[\033[0;32m\]（╯－＿－）╯\[\033[00m\] "
#export PS1="\[\033[01;37m\]\t\[\033[00m\] \[\033[01;36m\]\u\[\033[00m\]@\[\033[01;33m\]\h\[\033[00m\]:\[\033[01;35m\]\w\[\033[00m\] \[\033[01;31m\]◢▆▅▄▃崩╰(〒皿〒)╯潰▃▄▅▇◣\[\033[00m\]\n\[\033[0;32m\]^w^\[\033[00m\] "
#export PS1="\$(mem_status)\$(top_users_name)\n(\A) \[\033[01;36m\]\u\[\033[00m\]@\[\033[01;33m\]\h\[\033[00m\]:\[\033[01;35m\]\w\[\033[00m\] "
export PS1="\n(\A) \[\033[01;36m\]\u\[\033[00m\]@\[\033[01;33m\]\h\[\033[00m\]:\[\033[01;35m\]\w\[\033[00m\]\[\033[01;30m\]\$(__git_ps1)\[\033[00m\] "
function append_customized_rules() {
  local NDKROOT=$HOME/snapshot/android-ndk-r9c
  local SDKROOT=$HOME/snapshot/android-sdk-linux
  local SYSROOT=$HOME/sysroot
  local AOSPROOT=$HOME/works/aosp

  # Clear anything we already appended first.
  export PATH=`echo $PATH | tr ':' '\n' | grep -v $USER | tr '\n' ':'`
  export LD_LIBRARY_PATH=`echo $PATH | tr ':' '\n' | grep -v $USER | tr '\n' ':'`
  #export MANPATH=`echo $PATH | tr ':' '\n' | grep -v $USER | tr '\n' ':'`
  unset MANPATH
  export PKG_CONFIG_PATH=`echo $PATH | tr ':' '\n' | grep -v $USER | tr '\n' ':'`

  ## Setup java
  #export JAVA_HOME=/usr/lib/jvm/jdk1.6.0_45
  export JAVA_HOME=/usr/lib/jvm/java-1.7.0-openjdk-amd64
  export ANDROID_JAVA_HOME=/usr/lib/jvm/java-1.7.0-openjdk-amd64
  export PATH=$JAVA_HOME/bin:$PATH

  # Setup script
  export PATH=$HOME/scripts:$PATH

  # Some apps install in this place
  export PATH=$HOME/.local/bin:$PATH

  # Setup SDK toolchain for convinence
  export PATH=$SDKROOT/tools:$SDKROOT/platform-tools:$PATH

  # Setup NDK toolchain for convinence
  #for PREFIX in arm-linux-androideabi x86 mipsel-linux-android aarch64-linux-android x86_64 mips64el-linux-android; do
  #  export PATH=$AOSPROOT/ndk/toolchains/$PREFIX-4.9/prebuilt/linux-x86/bin:$PATH
  #done
  #export PATH=/home/mtk06246/snapshot/gcc-linaro-arm-linux-gnueabihf-4.8-2013.08_linux/bin:$PATH

  #export PATH=$HOME/works/DS-5/bin:$PATH
  #export PATH=$HOME/works/DS-5/sw/ARMCompiler6.00/bin:$PATH

  # Setup bin PATH
  USR_LIST="`env ls $SYSROOT | grep -v exclude | xargs`"
  for usr in $USR_LIST; do
    export PATH=$SYSROOT/$usr/bin:$PATH
  done

  # Setup lib PATH
  for usr in $USR_LIST; do
    export LD_LIBRARY_PATH=$SYSROOT/$usr/lib:$LD_LIBRARY_PATH
  done

  # Setup man PATH
  for usr in $USR_LIST; do
    export MANPATH=$SYSROOT/$usr/man:$MANPATH
  done

  # Setup pkg PATH
  for usr in $USR_LIST; do
    export PKG_CONFIG_PATH=$SYSROOT/$usr/lib/pkgconfig:$PKG_CONFIG_PATH
  done
}

#export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
append_customized_rules
export PAGER="$(which less)"
export EDITOR="$(which vim)"
export HISTCONTROL="ignoreboth"
export HISTSIZE=1000
export ANDROID_SWT=$HOME/snapshot/android-sdk-linux/tools/lib/x86_64
export http_proxy=http://pc0909211214:8080
export https_proxy=$http_proxy
export ftp_proxy=$http_proxy
#export http_proxy=http://hqproxy242.mediatek.inc:8080
#export https_proxy=http://hqproxy242.mediatek.inc:8080
export LANG=en_US.UTF-8
#export LANG=zh_TW.UTF-8
export JOBS=16
export CSMITH_HOME=$HOME/sysroot/usr-csmith-2.2.0git/src
export SOUPER_SOLVER="-z3-path=$HOME/sysroot/usr-z3/bin/z3"

alias grep="$(which egrep) --color"
alias less="$PAGER -M"
alias cd..="cd .."
alias cd-="cd -"
alias cd~="cd ~"
alias vi=$(which vim)
alias ssh="$(which ssh) -X"
alias cp="$(which cp) -i -v"
alias mv="$(which mv) -i -v"
alias rm="$(which rm) -i -v"
alias size="$(which size) --format=SysV -x"
alias ls="$(which ls) --color"
alias ll="$(which ls) -lht --color"
alias nm="$(which nm) -f sysv"
alias od="$(which od) -A x -t x1z"
alias screen="$(which tmux) attach -d || $(which tmux) new"
alias qemu-aarch64-android="qemu-aarch64 -L $HOME/nobackup/arm64_sysroot_from_AOSP_5.0.0_r7_master_1210"
alias ssh-my-ubuntu="$(which ssh) 172.22.82.160"
alias makegcc="$(which make) all-gcc -j$JOBS && $(which make) all-target-libgcc -j$JOBS && $(which make) install-gcc && $(which make) install-target-libcc"
alias gdb="$(which gdb) -iex 'set auto-load safe-path $HOME/nobackup/making/gcc:$HOME/nobackup/making/gcc-aarch64/build/gcc/gcc'"
#alias pollycc="$(which clang) -Xclang -load -Xclang $HOME/nobackup/making/llvm/tools/polly/Debug+Asserts/lib/LLVMPolly.so -mllvm -polly -mllvm -polly-vectorizer=polly"
alias sclang="$HOME/works/souper/third_party/llvm/Release+Asserts/bin/clang -Xclang -load -Xclang $HOME/nobackup/making/souper/libsouperPass.so -mllvm -z3-path=$HOME/sysroot/usr-exclude-z3/bin/z3"
alias sclang++="$HOME/works/souper/third_party/llvm/Release+Asserts/bin/clang++ -Xclang -load -Xclang $HOME/nobackup/making/souper/libsouperPass.so -mllvm -z3-path=$HOME/sysroot/usr-exclude-z3/bin/z3"
alias sopt="$HOME/works/souper/third_party/llvm/Release+Asserts/bin/opt -load $HOME/nobackup/making/souper/libsouperPass.so -souper -z3-path=$HOME/sysroot/usr-exclude-z3/bin/z3"

if [ -f "/etc/bash_completion" ]; then
  source "/etc/bash_completion"
fi

# Set screen title
if [ "$TERM" = "screen-256color" ]; then
  screen_set_window_title() {
    local HPWD="$PWD"
    local BASEWD="`basename $HPWD`"
    case $HPWD in
      $HOME)    HPWD='$HOME';;
      $HOME/*)  HPWD="~/.../$BASEWD";;
      /)        HPWD="/";;
      /*)       HPWD="/.../$BASEWD";;
      *)        HPWD=".../$BASEWD";;
    esac
    printf '\ek%s\e\\' "$HPWD"
  }
  PROMPT_COMMAND="screen_set_window_title; $PROMPT_COMMAND"
fi

export ANDROID_ADB_SERVER_PORT=12333
export BUILD_NUM_CPUS=$JOBS

# Finally, clear the cache
hash -r

# Add PNDK-only flags This is so useful
#export ANDROID_ADB_SERVER_PORT=5566 # Real device as default
#export NDK_ABI_FILTER="NDK_APP_ABI:=\$\$(NDK_APP_ABI:%=+bc%)"
#export NDK_TOOLCHAIN_VERSION=clang3.5
#export STLPORT_FORCE_REBUILD=true
#export LIBCXX_FORCE_REBUILD=true
NDK_TMPDIR=$HOME/nobackup/tmp/ndk-$USER # To speed up download-src by same fs

export P4PORT=p4alps.gslb.mediatek.inc:3010
export P4USER=Wenhan.gu

export ARMLMD_LICENSE_FILE=8224@mtklc06:8224@mtklc07
export LM_LICENSE_FILE=8224@mtklc06:8224@mtklc07
export ARMCOMPILER6_ASMOPT=--tool_variant=ult
export ARMCOMPILER6_CLANGOPT=--tool_variant=ult
export ARMCOMPILER6_FROMELFOPT=--tool_variant=ult
export ARMCOMPILER6_LINKOPT=--tool_variant=ult

tmux_query="`ps -ef | grep tmux | grep $USER | grep -v grep | wc -l`"
if [ "$tmux_query" = "0" ]; then
  tmux new
elif [ "$tmux_query" = "1" ]; then
  tmux attach -d
fi

#alias aarch64-mtk-gcc="$HOME/works/toolchain-mtk/prebuilts/gcc/linux-x86_64/aarch64/aarch64-linux-gnu-4.9/bin/aarch64-linux-gnu-gcc"

function pndk_env () {
  echo 'NDK_ABI_FILTER="NDK_APP_ABI:=\$\$(NDK_APP_ABI:%=+bc%)" NDK_TOOLCHAIN_VERSION=clang'
}
