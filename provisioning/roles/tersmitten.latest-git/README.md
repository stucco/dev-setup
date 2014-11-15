## latest-git [![Build Status](https://travis-ci.org/Oefenweb/ansible-latest-git.svg?branch=master)](https://travis-ci.org/Oefenweb/ansible-latest-git)

Set up the latest version of git in Ubuntu systems.

#### Requirements

* `python-apt`

#### Variables

* `latest_git_install`: [default: `[git]`]: Packages to install (from PPA repository)

## Dependencies

None

#### Example

```yaml
---
- hosts: all
  roles:
  - latest-git
```

#### License

MIT

#### Author Information

Mischa ter Smitten

#### Feedback, bug-reports, requests, ...

Are [welcome](https://github.com/Oefenweb/ansible-latest-git/issues)!
