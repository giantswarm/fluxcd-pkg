module github.com/fluxcd/pkg/git/gogit

go 1.20

replace (
	github.com/fluxcd/pkg/git => ../../git
	github.com/fluxcd/pkg/gittestserver => ../../gittestserver
	github.com/fluxcd/pkg/ssh => ../../ssh
	github.com/fluxcd/pkg/version => ../../version
)

require (
	github.com/Masterminds/semver/v3 v3.2.1
	github.com/armon/go-socks5 v0.0.0-20160902184237-e75332964ef5
	github.com/cyphar/filepath-securejoin v0.2.3
	github.com/elazarl/goproxy v0.0.0-20221015165544-a0805db90819
	github.com/fluxcd/gitkit v0.6.0
	github.com/fluxcd/pkg/git v0.12.3
	github.com/fluxcd/pkg/gittestserver v0.8.4
	github.com/fluxcd/pkg/ssh v0.8.0
	github.com/fluxcd/pkg/version v0.2.2
	github.com/go-git/go-billy/v5 v5.4.1
	github.com/go-git/go-git/v5 v5.7.0
	github.com/onsi/gomega v1.27.8
	golang.org/x/crypto v0.10.0
	golang.org/x/sys v0.9.0
)

require (
	github.com/Microsoft/go-winio v0.6.1 // indirect
	github.com/ProtonMail/go-crypto v0.0.0-20230619160724-3fbb1f12458c // indirect
	github.com/acomagu/bufpipe v1.0.4 // indirect
	github.com/cloudflare/circl v1.3.3 // indirect
	github.com/emirpasic/gods v1.18.1 // indirect
	github.com/go-git/gcfg v1.5.1-0.20230307220236-3a3c6141e376 // indirect
	github.com/gofrs/uuid v4.2.0+incompatible // indirect
	github.com/golang/groupcache v0.0.0-20210331224755-41bb18bfe9da // indirect
	github.com/google/go-cmp v0.5.9 // indirect
	github.com/imdario/mergo v0.3.15 // indirect
	github.com/jbenet/go-context v0.0.0-20150711004518-d14ea06fba99 // indirect
	github.com/kevinburke/ssh_config v1.2.0 // indirect
	github.com/pjbgf/sha1cd v0.3.0 // indirect
	github.com/sergi/go-diff v1.3.1 // indirect
	github.com/skeema/knownhosts v1.1.1 // indirect
	github.com/xanzy/ssh-agent v0.3.3 // indirect
	golang.org/x/mod v0.10.0 // indirect
	golang.org/x/net v0.10.0 // indirect
	golang.org/x/text v0.10.0 // indirect
	golang.org/x/tools v0.9.1 // indirect
	gopkg.in/warnings.v0 v0.1.2 // indirect
	gopkg.in/yaml.v3 v3.0.1 // indirect
)
