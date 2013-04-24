puppet-module-template
====================
This repository is here to provide a generic puppet module repository to clone

Usage of template: 
-------

1: [Create new repository](https://github.rackspace.com/new)
* Owner: `Preferably cloud-integration-ops`
* Name: `puppet-${module name}`

2: Populate the new repository, this process will do it, all you have to do is
   edit this first line and then copy-paste the block into a shell

    module=SOMETHING
    repo=puppet-${module}
    mkdir ${repo}
    cd ${repo}
    git init
    cd ..
    git clone git://github.rackspace.com/cloud-integration-ops/puppet-module-template.git
    cd puppet-module-template
    git checkout-index -f -a --prefix=../${repo}/
    cd ../${repo}
    mv module.spec ${repo}.spec
    git add *
    git commit -m "Initial import of template"
    git remote add origin https://github.rackspace.com/cloud-integration-ops/${repo}.git
    git push -u origin master

2: Then update the following files:

* README.md - Remove this file, it is just for the template repository
* README.rdoc - Update and augment to provide a general usage guide to your module
* puppet-${module}.spec - Follow instructions at top of file
* ModuleFile - Update at least name, dependency, and description, should match puppet-${module}.spec

3: Build the module following CIT-Ops Puppet module Best Practices!

4: Remove any files or directories that aren't going to be relevant.

Using your new module in staging:
-------

    module=SOMETHING
    repo=puppet-${module}
    git clone git://github.rackspace.com/cloud-integration-ops/${repo}.git /etc/puppet/modules/

Using new module in production:
-------

TBD
