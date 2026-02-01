#!/usr/bin/fish

source modules/hr.fish
source modules/get_random_id.fish

set REPO_NAME raur
set REPO_DIR (pwd)/x86_64
set PKGS_DIR (pwd)/src
set ALL_PACKAGES yabridge-git yabridgectl-git musesounds-manager

argparse h/help a/all -- $argv
or return

if set -q _flag_help
    echo "Usage: ./build.fish [flags] [package_names...]"
    echo ""
    echo "Flags:"
    echo "  -h, --help    Show this help menu"
    echo "  -a, --all     build every package in the list"
    echo ""
    echo "Examples:"
    echo "  ./build.fish -a                     Builds everything"
    echo "  ./build.fish musesounds-manager     Builds only Muse"
    exit 0
end

# Determine which packages to build
if set -q _flag_all
    set BUILD_LIST $ALL_PACKAGES
else if count $argv >/dev/null
    # Filter the list based on user input
    for arg in $argv
        if contains -- $arg $ALL_PACKAGES
            set -a BUILD_LIST $arg
        else
            set_color yellow
            echo "Warning: '$arg' is not in the package list. Skipping."
            set_color normal
        end
    end
else
    echo "Error: No packages specified. Use -a for all or provide names."
    exit 1
end

function cleanup_on_interrupt --on-signal SIGINT
    if set -q CURRENT_BUILD_PATH
        if test -d "$CURRENT_BUILD_PATH"
            hr
            set_color red
            echo "Error: Interrupt detected. Cleaning up: $CURRENT_BUILD_PATH"
            set_color normal
            rm -rf "$CURRENT_BUILD_PATH"
        end
    end
    exit 1
end

for pkg in $BUILD_LIST
    set RAND_ID (get_random_id)
    set -g CURRENT_BUILD_PATH "/tmp/$RAND_ID-makepkg-$pkg"

    echo "Building $pkg (ID: $RAND_ID)"
    hr

    begin
        cd "$PKGS_DIR/$pkg"; or exit
        mkdir -p "$CURRENT_BUILD_PATH"

        set -x PKGDEST "$REPO_DIR"
        set -x BUILDDIR "$CURRENT_BUILD_PATH"
        set -x SRCDEST "$CURRENT_BUILD_PATH/sources"

        if not makepkg -scfC --noconfirm
            echo "Build failed or was interrupted."
            exit 1
        end

        rm -rf "$CURRENT_BUILD_PATH"
        set -e CURRENT_BUILD_PATH
    end

    echo "Finished $pkg"
    hr
end

echo "Updating repository database..."
hr

cd "$REPO_DIR"; or exit
repo-add "$REPO_NAME.db.tar.gz" *.pkg.tar.zst

rm -f "$REPO_NAME.db" "$REPO_NAME.files"
cp "$REPO_NAME.db.tar.gz" "$REPO_NAME.db"
cp "$REPO_NAME.files.tar.gz" "$REPO_NAME.files"

hr
echo "Repository is ready to push!"
