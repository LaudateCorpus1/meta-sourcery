def get_toolchain_bindir(d):
    from pathlib import Path

    external = d.getVar('EXTERNAL_TOOLCHAIN')
    bin = d.getVar('EXTERNAL_TOOLCHAIN_BIN')
    if external and bin:
        external = Path(external)
        bin = Path(bin)
        if external.parent.name == 'toolchains':
            return Path(external.name) / bin.relative_to(external)
    return 'UNKNOWN'

create_sdk_files:append:tcmode-external-sourcery () {
    script=${SDK_OUTPUT}/${SDKPATH}/environment-setup-${REAL_MULTIMACH_TARGET_SYS}
    cat >>"$script" <<END
toolchainsdir="${SDKPATH}/../../../toolchains"
bindir="\$toolchainsdir/${@get_toolchain_bindir(d)}"
if [ -e "\$bindir" ]; then
    PATH="\$PATH:\$bindir"
else
    echo >&2 "Warning: failed to add \$bindir to the path: No such file or directory"
fi
END
}
