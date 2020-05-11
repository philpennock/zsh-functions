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

setopt transient_rprompt
```

I actually have setup to maintain a per-host cache in an OS-specific cache
location, so that `~/Library/Caches/zsh/osmium` is correct for my current
laptop; this then feeds into uncommenting the `use-cache` above.

My macOS laptop had:

```sh
zstyle ':prompt:pdp*:*' employer-domain pennock-tech.net
zstyle ':prompt:pdp*:*' employer-prompt $'@%{\e[38;2;0;180;222m%}PennockTech%{\e[0m%}'
zstyle ':prompt:pdp*:*' show-domain off
zstyle ':prompt:pdp*:*' auto-kerberos on
zstyle ':prompt:pdp*:*' show-awscreds on
```

My Linux laptop, unable to use the aws-vault info sub-command to get rotation
times, skips `show-awscreds` but does have:

```sh
zstyle ':prompt:pdp*:*' show-awsprofile on
zstyle ':prompt:pdp*:*' show-pyenv on
```

Another box just has:

```sh
zstyle ':prompt:pdp*:*' show-sshkeys on
zstyle ':prompt:pdp*:*' show-gpgagent on
```

There is now support for displaying the current `pyenv version-name` in the
right-hand-side prompt `RPS1`; it also supports being auto-enabled via setting
an environment variable, to integrate with [`direnv(1)`](https://direnv.net/).
To use it, wherever you `export PYENV_VERSION=...` also
`export _prompt_pdp_pyenv='!'` as a trigger.  The prompt functions will spot
that the internal variable is exported and unexport it, before turning on its
own pyenv mode.  This support doesn't handle arbitrary "something assigned to
`PYENV_VERSION`, unfortunately.  We'd need watches on variables for that.

I now display by default a rendering of `$KUBE_CONTEXT` and `$KUBE_NAMESPACE`
in my RHS prompt, used by my wrappers around `kubectl` and `helm` so that I
can change into a directory with a `.envrc` containing something like
`export KUBE_NAMESPACE=top-www` and be automatically pointed to the right bit
of a Kubernetes cluster for a given app.

When setting authentication credentials or the like into variables, it's handy
to be able to tell apart the tabs and know which variables are available to
me.  Arbitrary content can be assigned to `PDP_LABEL` (non-exported) just to
get a convenient red tag.

With this expansion in the use of `$RPS1`, setting the zsh `transient_rprompt`
option makes it much easier to copy/paste commands without the RHS prompt
getting in the way.

## Functions

Set up autoload for these and most of them will help with tab-completion.

* `_aws` — wrapper around bash completion, this one actually works
* `_aws_profiles` — let `AWS_PROFILE=` tab-complete usefully
* `_aws-vault` — completion for `aws-vault`
* `_pyenv_versions` — let `PYENV_VERSION=` tab-complete usefully
* `_ssh-kube-gcloud` — completion for `bin/ssh-kube-gcloud` which is a wrapper
  around `gcloud compute ssh`; gcloud's tab-completion hits a remote end-point
  every time you press tab, so is hideously slow.  This completion caches,
  making it occasionally slow but usually fast.
* `_vagrant` — decent fast tab-completion for Vagrant
* `_kube_contexts` & `_kube_namespaces` — completion for
  `$KUBE_CONTEXT` & `$KUBE_NAMESPACE`
* `_nodenv_versions`, `_pyenv_versions`, `_rbenv_versions` — completion for
  shell variables for controlling the respective interpreter dispatchers.
* `prompt_pdp_setup` — invoked by zsh's prompt framework when told to use the
  `pdp` prompt
* `kerb_remaining_time` — cached invocation of `klist(1)` to determine
  remaining kerberos ticket lifetime, for prompt display
* `iterm_tabcolor_rgb` — setting tab colors for iTerm without another
  fork/exec

I also use some items in `zfuncs.zsh` which are not auto-loaded but are
directly in-line, typically to avoid defining them unless some command is
installed.
