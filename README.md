# dotfiles

Based on [nickjj/dotfiles](https://github.com/nickjj/dotfiles).

This readme along with an install script will help you get everything running
in a few minutes.

## 🧬 Who Is This For?

This project is more than a few config files. **In 1 command and ~5 minutes it
can take a new or existing system and install / configure a number of tools
aimed at developers**. It will prompt or warn you if it's doing a destructive
action like overwriting a config file. You can run the idempotent [install
script](./install) multiple times to stay up to date.

### Philosophy

One person's bloat is another person's treasure. All packages, configs and
symlinks are configurable before you modify your system. A mini-goal of this
project is to avoid needing to fork it while still giving you a reasonable
amount of control, and if you want to fork it that's fine too.

Your machine is yours. If you want to dual boot, do it up. If you want multiple
users, sure thing. If you don't want to encrypt your drive, no problem.
Everyone is welcome here and you have full control.

## 🎁 What's in the Box?

### Command line

#### Highlights

- Tweak out your shell (zsh)
- Set up tmux
- Fully configure Neovim
- Create SSH / GPG keys if they don't already exist
- Install modern CLI tools and programming languages

#### OS support

- Arch Linux, both vanilla and Arch-like distros such as CachyOS, etc.
- Debian
- Ubuntu (vanilla and all flavors)
- macOS

### (Optional) Scrolling / tiling desktop environment

*Supports Arch Linux, both vanilla and Arch-like distros such as CachyOS, etc.*

#### Highlights

- [niri](https://github.com/YaLTeR/niri) *(Wayland compositor)*, Waybar *(status bar)*, Walker *(app launcher)* and friends
- Hotkey focused but tons of mouse / trackpad support
- Prefer TUI (Terminal User Interface) apps over GUI apps when possible
- Development / media creation focused apps are ready to go

### Packages, scripts and more

There's docs with a list of [packages](./_docs/packages.md) and
[scripts](./_docs/scripts.md) along with what they're being used for and why.

The source of truth can always be found within the files at
[_install/default/](./_install/default/). You'll find files related to
packages, standalone scripts, programming languages and more.

## 🧾 Documentation

- [Themes](#-themes)
- [Quickly Get Set Up](#-quickly-get-set-up)
- [FAQ](#-faq)
  - [How to personalize these dotfiles?](#how-to-personalize-these-dotfiles)
  - [How to theme custom apps?](#how-to-get-theme-custom-apps)
  - [How to add custom themes?](#how-to-add-custom-themes)
  - [How to install Arch Linux?](#how-to-install-arch-linux)
  - [How do I get started with the desktop environment?](#how-do-i-get-started-with-the-desktop-environment)

## 🎨 Themes

### Tokyonight Moon

![Tokyonight Moon](./themes/tokyonight-moon/_preview.jpg)

### Gruvbox Dark (Medium)

![Gruvbox Dark Medium](./themes/gruvbox-dark-medium/_preview.jpg)

Themes in this repo aim for good contrast ratios. These dotfiles currently
support easily switching between both themes but you can use any theme you'd
like.

If you want to see icons you'll need a "nerd font". There's hundreds of them on
<https://www.nerdfonts.com/font-downloads> with previews. These dotfiles install
IBM Plex Mono Nerd Font by default.

### Setting a theme

```sh
# Get a full list of themes by running: dot-theme-set --list
# There's also a --menu flag to preview themes in the desktop environment.
#
# Optionally you can skip adding a theme name and the next theme will be picked.
dot-theme-set THEME_NAME
```

When switching themes all GTK apps will live update (Thunar, Firefox, GIMP,
etc.) and most terminal apps will live update too. If you have a bunch of
shells already open you can run the `SZ` alias to source new theme related
configs.

*Not all terminals are supported, if yours didn't change then check [theming
custom apps](#how-to-theme-custom-apps).*

You can look in the [_themes/](./_themes/) directory to see which apps are themed
and [add additional apps](#how-to-theme-custom-apps) too. If you don't like the
included themes that's no problem. You can [add custom
themes](#how-to-add-custom-themes) and remove the defaults.

### Wallpapers

*Only available when the desktop environment is set up.*

```sh
# Get a full list of wallpapers by running: dot-theme-set-bg --list
# There's also a --menu flag to preview wallpapers.
#
# Optionally you can skip adding a wallpaper name and the next wallpaper will be picked.
dot-theme-set-bg WALLPAPER_NAME
```

You can cycle between wallpapers that are compatible with the active theme.
This is controlled through the `_theme.json` file in each theme's directory,
it's under the `wallpaper.synergy` object.

## ✨ Quickly Get Set Up

There's an automated script to get you going quickly (we'll go over running it
soon). It handles checking system compatibility and installing / configuring
everything.

You'll be able to choose where you want to clone these dotfiles to and also
have an opportunity to review and edit what gets installed if you want to
customize the defaults.

If you're setting up a brand new system and plan to use the desktop environment
you'll want to set up a bootable USB stick with the official [Arch Linux
ISO](https://fastly.mirror.pkgbuild.com/iso/latest/) and then run the official
[archinstall](https://wiki.archlinux.org/title/Archinstall) script. There is a
FAQ item [covering all of that](#how-to-install-arch-linux).

### 🌱 On a fresh system?

We're in a catch-22 where this project will set everything up for you
but to start using it you need `curl` to download its related install script.

#### Arch Linux and macOS

You're good to go and don't need to do anything since `curl` is installed by
default.

#### Debian / Ubuntu

```sh
# You can run this as root.
apt-get update && apt-get install --yes --no-install-recommends curl
```

### ⚡️ Install

**You can download and run the bootstrap script with this 1 liner:**

```sh
bash <(curl -fsSL https://raw.githubusercontent.com/imrellx/dotfiles/main/bootstrap)
```

You'll be presented with a y/n prompt before installing anything of substance.

*If you're not comfortable blindly running a script on the internet, that's no
problem. You can view the [bootstrap script](./bootstrap) to see exactly what
it does. The bottom of the file is a good place to start. Alternatively you can
look around this repo and reference the config files directly without using any
script.*

🐳 **Try it in Docker without modifying your system:**

```sh
# Start a Debian container, we're passing OS_IN_CONTAINER to be explicit we're in a container.
docker container run --rm -it -e "OS_IN_CONTAINER=1" -v "${PWD}:/app" -w /app debian:stable-slim bash

# Copy / paste all 3 lines into the container's prompt and run it.
#
# Since we can't open a new terminal in a container we'll need to manually
# launch zsh and source a few files. That's what the last line is doing.
apt-get update && apt-get install --yes --no-install-recommends curl \
  && bash <(curl -fsSL https://raw.githubusercontent.com/imrellx/dotfiles/main/bootstrap) \
  && zsh -c ". ~/.config/zsh/.zprofile && . ~/.config/zsh/.zshrc; zsh -i"
```

*Keep in mind with the Docker set up, unless your terminal is already
configured to use Tokyonight Moon then the colors may look off. That's because
your local terminal's config will not get automatically updated.*

**🚀 Keeping things up to date and tinkering**

Once you've installed these dotfiles you can run `cd "${DOTFILES_PATH}"` to
manage them.

Here's a few handy commands, you can run `./install --help` to see all of them:

- `./install`
  - Run the install script based on the local copy of your dotfiles
  - Keeps your system up to date or apply local changes
- `./install --skip-system-packages | -S`
  - Run the install script like above but skip installing or updating packages
  - Helps regenerate symlinks, configs and everything else without modifying packages
- `./install --pull | -p`
  - Pulls in the latest remote commits but doesn't run the install script
  - Lets you review any changes locally before the install script runs
- `./install --update | -u`
  - Pulls in the latest remote commits and runs the install script
  - Shortcut to pull and run the install script together
- `./install --diff-config | -g`
  - Compare your local `install-config` to the local `install-config.example`
  - Helps keep your git ignored `install-config` in sync with new options
- `./install --new-commits | -n`
  - Show new remote commits that do not exist locally
  - Present a quick list of what's available to pull locally
- `./install --changelog | -c`
  - Show all remote commits
  - Present a quick list of all commits to see what has changed
- `./install --local-files | -l`
  - Show all local git ignored files such as configs, history and scripts
  - Useful to see everything not committed and for optionally backing up those files
    - Example: `./install --local-files | xargs zip dotfiles-personal.zip`

### 🔧 Make it your own

If you just ran the install script and haven't done so already please close
your terminal and open a new one. If you've set up GUI mode with Arch Linux
you'll want to reboot instead.

There's a few ways to customize these dotfiles ranging from forking this repo
to customizing [install-config](./install-config.example) which is git ignored.
The second option lets you adjust which packages and programming languages get
installed as well as configure a number of other things without forking this
project.

Before you start customizing other files, please take a look at the
[personalization question in the FAQ](#how-to-personalize-these-dotfiles).

## 🔍 FAQ

### How to personalize these dotfiles?

The [install-config](./install-config.example) lets you customize a few things
but chances are you'll want to personalize more than what's there, such as
various Neovim settings. Since this is a git repo you can always do a
`./install --pull` or `git pull` to get the most up to date copy of these
dotfiles, but then you may find yourself clobbering over your own personal
changes.

A few reasonable options without custom branches or forking:

- For minor changes like adjusting which packages get installed, the install config file lets you do that
- For minor config changes some tools let you include config files, so any git ignored `.local` files you see is a way to customize them without needing to adjust the main config
- For major config changes can configure the `CONFIG_INSTALL` commands
to symlink other files and directories that are git ignored, this lets you keep
your "real" files in the dotfiles repo with a different name

If the above isn't enough, or maybe you want things more streamlined you can
`git checkout -b personalized` and now you're free to make whatever changes you
want on your custom  branch. When it comes time to pull down future updates you
can run a `git pull origin main` and then `git rebase main` to integrate
any updates.

Another option is to fork this repo and use that, then periodically pull and
merge updates.

### How to theme custom apps?

Add its theme file to each theme in [_themes/](./_themes) and update the
[install](./install) script's `set_theme` function to symlink the config. If
the app has no dedicated config file, follow the pattern used for other apps
handled inside `set_theme`.

Contributions welcome via issue or PR.

### How to add custom themes?

1. Locate the [_themes/](./_themes) directory in this repo
2. Copy one of the existing themes' directory
3. Rename your directory, this will be your theme's name
4. Adjust all of the colors as you see fit

Switch to it by running `dot-theme-set NEW_THEME_NAME` and use the name you
picked in step 3.

If you add a theme with good contrast ratios, a pull request is welcome.

### How to install Arch Linux?

Nothing here is too specific to these dotfiles, it's general knowledge on
setting up Arch but these steps are included to help get you going.

#### Set up a bootable USB drive

- Obtain a USB drive (a few gigs is fine)
- Download the [official Arch ISO](https://fastly.mirror.pkgbuild.com/iso/latest/)
  - You'll likely get the `archlinux-YYYY-MM-DD-x86_64.iso` file, it's about ~1.5 GB
- Create a bootable USB drive using the above ISO
  - The tool you use depends on your OS, but likely choose UEFI / GPT options if asked
- Insert the USB drive and reboot
- Configure your BIOS to boot into the USB drive first

#### After booting from the USB drive

- Follow any instructions it says before running `archinstall`
  - For example if you use Wi-Fi you'll want to run `iwctl` to [set up your network](https://wiki.archlinux.org/title/Iwd#iwctl):
    - `iwctl`
      - `device list` shows devices such as `wlan0` which we'll use below
      - `station wlan0 scan` searches for networks (no output is normal)
      - `station wlan0 get-networks` lists your Wi-Fi networks
      - `station wlan0 connect <NETWORK_NAME>` prompts you for your password
      - `exit` brings you back to your shell
      - You should be connected to the internet at this point
        - Verify with `ping example.com` and hit CTRL+c to stop

#### Run `archinstall` from your shell

The script guides you pretty well. Here's a few important callouts in the order
they appear in the menu. These callouts are suggestions, not rules — other
options will also work. The goal is to help you avoid analysis paralysis and
see what's configurable before you do it.

*Nothing you choose will happen immediately, you'll get to review everything at
the end before anything happens. Generally speaking you'll be using enter to
select options, escape to go back, the arrow keys to change selections and
space to toggle checkboxes.*

- **Archinstall language**:
  - Pick what makes sense for your location
- **Locales**:
  - Pick what makes sense to you for all of the sub-sections
- **Mirrors**:
  - Select a region close to where your live
  - *Optional repositories*:
    - You can skip this unless you have reasons otherwise
- **Disk configuration**:
  - If you go with the default "best effort" it will wipe your full drive:
    - This is reasonable if you're *not* dual booting, if you dual boot you'll want to manually set this up
    - Make sure the correct drive you want wiped is selected!
    - For the file system type, `ext4` is mature and a safe default, `btrfs` is also mostly ok
    - It will ask if you want a separate partition for your home directory, picking no keeps things simple and avoids LVM
    - Review the info, you should see `/boot` and `/` (root) partitions at the very least
  - *Disk encryption*:
      - Up to you — encrypting all non-boot partitions with a strong password is recommended; double-check you can remember it
- **Swap**:
  - Up to you, the default zram-based swap is fine
- **Bootloader**:
  - `systemd-boot` is a reasonable default
  - *Unified kernel images*:
    - Leaving this turned off is a safe default but read up if you're interested
- **Kernels**:
  - The normal kernel is a safe default
- **Hostname**:
  - Picking a cool name will probably be the [longest time](https://xkcd.com/910/) you spend in the installer
  - You can always change it afterwards, don't sweat it!
- **Authentication**:
  - *Root password*:
    - Set a password and don't forget it
  - *User account*:
    - Create your main user and pick a password you won't forget
    - Allow this user to be a superuser (sudo) as well
    - You'll be logging in as this user, you can create more users later if needed
- **Profile**:
  - You can skip this (leave it unselected)
  - These dotfiles handle setting up your desktop environment (including GPU drivers)
- **Applications**:
  - These dotfiles will configure "Bluetooth" and "Audio", you can skip them
  - If you have a printer you may want to configure the "Print service""
- **Network configuration**:
  - Go with "Copy ISO network configuration" unless you have other opinions
  - This just means it will use whatever you used in this bootable USB environment
- **Additional packages**:
  - You can skip this as these dotfiles will install everything for you
- **Timezone**:
  - Pick what makes sense for your location
- **Automatic time sync (NTP)**:
  - Yep, turn this on, it will use `systemd-timesyncd` for this

At this point you can write this configuration to the USB drive for next time
(not necessary), install or abort. Choose install which will then show you a
load out of what's going to happen.

Before hitting enter to continue, you can use page up / down to see what's
going to happen. Triple check your drive being formatted is the correct one
and everything else looks good!

- Sit back and relax while everything gets installed in ~2 minutes
- Choose "Exit archinstall" when it prompts you after it has finished
- Remove the USB drive from your computer
- Run `reboot`
- Configure your BIOS to boot from the drive you just installed Arch on

#### Booting up

Depending on what boot loader you used, you can pick Arch Linux to boot into.

If everything worked properly, you'll get booted into a `tty1` black login
screen. You can log in with the user and password you created. If you enabled
drive encryption you'll get prompted for your decrypt password before logging
in.

At this point you have Arch installed and you can run the bootstrap script
[mentioned earlier in this readme](#%EF%B8%8F-install) to install these dotfiles!

### How do I get started with the desktop environment?

After logging in you'll be greeted with an empty desktop and a top bar.

- A few key binds:
  - `Mod + Alt + T  ::  Terminal`
  - `Mod + Alt + B  ::  Browser`
  - `Mod + Alt + /  ::  Show Important Hotkeys`
- Connect to Wi-Fi *if needed* by clicking the Wi-Fi icon in the top right
  - Alternatively you can run `impala` from a terminal
  - If your system has no Wi-Fi adapter this tool won't be installed
- Connect Bluetooth devices *if needed* by clicking the Bluetooth icon in the top right
  - Alternatively you can run `bluetui` from a terminal
  - If your system has no Bluetooth adapter this tool won't be installed
- Verify your sound works by visiting YouTube or some site with audio
  - There's a sound icon in the top right to pick your input and output devices
  - Alternatively you can run `wiremix` from a terminal
  - Both `mpd` and [rmpc](https://github.com/mierak/rmpc) are installed for playing music, configure your music directory!
- Open a terminal and run `dt` to switch to the dotfiles repo and open it in Neovim
  - Explore `.config/niri/config.kdl` for a complete list of key binds
- Have fun with *your* new system!
