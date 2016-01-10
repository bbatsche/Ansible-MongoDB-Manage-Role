Ansible Manage MongoDB Role
===========================

[![Build Status](https://travis-ci.org/bbatsche/Ansible-MongoDB-Manage-Role.svg?branch=master)](https://travis-ci.org/bbatsche/Ansible-MongoDB-Manage-Role)

This is a simple role for just creating users in MongoDB. It can either create users for a single database or for the server as a whole.

New users are assigned database roles automatically based on the `db_name`. If `db_name` is omitted, or is "admin", the user will be given the roles `root`, `backup`, and `restore`. If the `db_name` has a value other than "admin", the user will be given the role `dbOwner`.

Role Variables
--------------

- `mongodb_admin` &mdash; MongoDB admin username. Default: "vagrant"
- `mongodb_pass` &mdash; Password for admin user. Default: "vagrant"
- `new_mongodb_user` &mdash; New MongoDB user to be created
- `new_mongodb_pass` &mdash; Password for new MongoDB user
- `db_name` &mdash; Database new user belongs to. Default: "admin"

Dependencies
------------

This role depends on `bbatsche.MongoDB-Install`. You must install that role first using:

```bash
ansible-galaxy install bbatsche.MongoDB-Install
```

Example Playbook
----------------

```yml
- hosts: servers
  roles:
  - role: bbatsche.MongoDB-Manage
    new_mongodb_user: mongo_user
    new_mongodb_pass: secretPassword
```

License
-------

MIT

Testing
-------

Included with this role is a set of specs for testing each task individually or as a whole. To run these tests you will first need to have [Vagrant](https://www.vagrantup.com/) and [VirtualBox](https://www.virtualbox.org/) installed. The spec files are written using [Serverspec](http://serverspec.org/) so you will need Ruby and [Bundler](http://bundler.io/). _**Note:** To keep things nicely encapsulated, everything is run through `rake`, including Vagrant itself. Because of this, your version of bundler must match Vagrant's version requirements. As of this writing (Vagrant version 1.8.1) that means your version of bundler must be between 1.5.2 and 1.10.6._

To run the full suite of specs:

```bash
$ gem install bundler -v 1.10.6
$ bundle install
$ rake
```

To see the available rake tasks (and specs):

```bash
$ rake -T
```

There are several rake tasks for interacting with the test environment, including:

- `rake vagrant:up` &mdash; Boot the test environment (_**Note:** This will **not** run any provisioning tasks._)
- `rake vagrant:provision` &mdash; Provision the test environment
- `rake vagrant:destroy` &mdash; Destroy the test environment
- `rake vagrant[cmd]` &mdash; Run some arbitrary Vagrant command in the test environment. For example, to log in to the test environment run: `rake vagrant[ssh]`

These specs are **not** meant to test for idempotence. They are meant to check that the specified tasks perform their expected steps. Idempotency can be tested independently as a form of integration testing.
