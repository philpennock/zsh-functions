functions >/dev/null have_cmd || \
        if zmodload zsh/parameter; then
                function have_cmd { (( $+commands[$1] )) }
        else
                # this is a little flaky under `-e`:
                function have_cmd { [[ -x =$1 ]] 2>/dev/null }
        fi

# ----------------------------------------------------------------------
# Kubernetes / K8s; Docker

if have_cmd kubectl; then

  # I might remove kubectl here, if I can get in the habit of using k instead
  function kubectl k {
    local -a extra
    [[ -z "${KUBE_NAMESPACE:-}" ]] || extra+=(--namespace "$KUBE_NAMESPACE")
    [[ -z "${KUBE_CONTEXT:-}" ]] || extra+=(--context "$KUBE_CONTEXT")
    command kubectl "${extra[@]}" "$@"
  }

  for T in {purple,pink,pastel}{,-root}; do
    eval "function k-$T { local n=\"$T-\$RANDOM\"; echo >&2 \"pod: \$n\"; k run -it --rm --restart=Never --image='pennocktech/ci:$T' \$n -- \"\$@\" }"
  done; unset T

  # These k-OS functions can take an optional :TAG first parameter, eg `k-ubuntu :focal`
  # Other parameters are passed through
  for I in alpine busybox debian ubuntu; do
    eval "function k-$I {
      local n tag;
      case \$1 in (:*) tag=\"\${1#:}\"; shift;; (*) tag=latest;; esac;
      n=\"$I-\${tag//./-}-\$RANDOM\";
      echo >&2 \"pod: \$n\";
      k run -it --rm --restart=Never --image=\"$I:\$tag\" \$n -- \"\$@\"
    }"
  done; unset I

fi  # have kubectl

if have_cmd helm; then

  function helm {
    local -a extra
    [[ -z "${KUBE_NAMESPACE:-}" ]] || extra+=(--namespace "$KUBE_NAMESPACE")
    [[ -z "${KUBE_CONTEXT:-}" ]] || extra+=(--kube-context "$KUBE_CONTEXT")
    command helm "${extra[@]}" "$@"
  }

fi  # have helm

if have_cmd docker; then

  function docker-escape-to-vm {
    docker run -it --rm --privileged --pid=host debian nsenter -t 1 -m -u -n -i sh
  }

  for T in {purple,pink,pastel}{,-root}; do
    eval "function d-$T { docker run -it --rm 'pennocktech/ci:$T' \"\$@\" }"
  done; unset T

fi  # have docker

