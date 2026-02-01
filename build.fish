#!/usr/bin/fish

source modules/hr.fish
source modules/get_random_id.fish

set REPO_NAME raur
set REPO_DIR (pwd)/x86_64
set PKGS_DIR (pwd)/src
set PACKAGES yabridge-git yabridgectl-git

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

    # Exit the script entirely so it doesn't try to build the next package
    exit 1
end

for pkg in $PACKAGES
    set RAND_ID (get_random_id)
    # Store path in a global-ish scope so the trap can see it
    set -g CURRENT_BUILD_PATH "/tmp/$RAND_ID-makepkg-$pkg"

    echo "Building $pkg (ID: $RAND_ID)"
    hr

    begin
        cd "$PKGS_DIR/$pkg"; or exit

        mkdir -p "$CURRENT_BUILD_PATH"

        set -x PKGDEST "$REPO_DIR"
        set -x BUILDDIR "$CURRENT_BUILD_PATH"
        set -x SRCDEST "$CURRENT_BUILD_PATH/sources"

        # If makepkg fails or is killed, stop the script
        if not makepkg -scfC --noconfirm
            echo "Build failed or was interrupted."
            # The SIGINT handler above handles the /tmp cleanup
            exit 1
        end

        rm -rf "$CURRENT_BUILD_PATH"
        set -e CURRENT_BUILD_PATH
    end

    echo "Finished $pkg"
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
