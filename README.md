zsh-functions
=============

My shell prompt is hideous and grotesque, with warts from compatibility hacks
for ancient versions of zsh.  Every time I think "I can drop that hack" I end
up cloning my `~/.personal` repo onto a box with an even more ancient version
of zsh and crying a little inside, before restoring compatibility hacks.

Nonetheless, various friends and former co-workers have asked for my prompt
setup.  So I threw together this repo to hold a few zsh functions which are
_potentially_ useful to others.

With the above in mind, complaints about the grotesqueness of the code will be
filed in the circular filing cabinet on the floor.  Bug-fixes without snark
gratefully received.

Note that zstyle is needed to turn some prompt features on or off, or invoking
with options to toggle features.

Licensed per [LICENSE.txt](LICENSE.txt).  
Note: the first copyright year is my best guess of when this version of the
shell prompt started growing.  It might be a year or two off.  I don't want to
have to resurrect svn or ask around for old CVS repos to be sure.  If this is
ever seriously an issue, I'll cry a little more.


## Setup

In `~/.zshrc` or equivalent:

```sh
# zstyle ':prompt:pdp*:*' use-cache on
autoload promptinit
promptinit
prompt pdp
```

I actually have setup to maintain a per-host cache in an OS-specific cache
location, so that `~/Library/Caches/zsh/osmium` is correct for my current
laptop; this then feeds into uncommenting the `use-cache` above.

My laptop has:

```sh
zstyle ':prompt:pdp*:*' employer-domain pennock-tech.net
zstyle ':prompt:pdp*:*' employer-prompt $'@%{\e[38;2;0;180;222m%}PennockTech%{\e[0m%}'
zstyle ':prompt:pdp*:*' show-domain off
zstyle ':prompt:pdp*:*' auto-kerberos on
zstyle ':prompt:pdp*:*' show-awscreds on
```

Another box just has:

```sh
zstyle ':prompt:pdp*:*' show-sshkeys on
zstyle ':prompt:pdp*:*' show-gpgagent on
```

## Functions

Set up autoload for these and most of them will help with tab-completion.

* `_aws_profiles` — let `AWS_PROFILE=` tab-complete usefully
* `_pyenv_versions` — let `PYENV_VERSION=` tab-complete usefully
* `_ssh-kube-gcloud` — completion for `bin/ssh-kube-gcloud` which is a wrapper
  around `gcloud compute ssh`; gcloud's tab-completion hits a remote end-point
  every time you press tab, so is hideously slow.  This completion caches,
  making it occasionally slow but usually fast.
* `_vagrant` — decent fast tab-completion for Vagrant
* `prompt_pdp_setup` — invoked by zsh's prompt framework when told to use the
  `pdp` prompt
* `kerb_remaining_time` — cached invocation of `klist(1)` to determine
  remaining kerberos ticket lifetime, for prompt display
* `iterm_tabcolor_rgb` — setting tab colors for iTerm without another
  fork/exec

