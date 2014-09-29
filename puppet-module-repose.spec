%define user citops
%define base_name repose

Name:      puppet-module-%{user}-%{base_name}
Version:   1.1.0
Release:   1
BuildArch: noarch
Summary:   Puppet module to configure %{base_name}
License:   GPLv3+
URL:       http://github.com/rackerlabs/puppet-%{base_name}
Source0:   %{name}.tgz

%description
Repose is an API proxy service htat provides validation,
keystone authentication, and several other features.

%define module_dir /etc/puppet/modules/%{base_name}

%prep
%setup -q -c -n %{base_name}

%build

%install
mkdir -p %{buildroot}%{module_dir}
cp -pr * %{buildroot}%{module_dir}/

%files
%defattr (0644,root,root)
%{module_dir}

%changelog
* Mon Sep 29 2014 Greg Swift <greg.swift@rackspace.com> - 1.1.0-1
- Add support for running on https port
* Tue Sep 15 2014 Alex Schultz <alex.schultz@rackspace.com> - 1.0.7-1
- Deprecation of http-logging filter, updates to log4j to support slf4j logging
* Tue Jun 03 2014 Alex Schultz <alex.schultz@rackspace.com> - 1.0.6-1
- Fixing minor logic issues, adding spec tests
* Mon May 19 2014 Alex Schultz <alex.schultz@rackspace.com> - 1.0.5-1
- slf4j http logging filter support
* Thu Jan 09 2014 Alex Schultz <alex.schultz@rackspace.com> - 1.0.4-1
- Fix for service-cluster in system-model.cfg.xml
* Mon Dec 16 2013 Alex Schultz <alex.schultz@rackspace.com> - 1.0.3-1
- Added daemonize options to fix the bad options that ship before 2.10
* Fri Nov 22 2013 Alex Schultz <alex.schultz@rackspace.com> - 1.0.2-1
- Added response-messaging filter
* Thu Nov 21 2013 Alex Schultz <alex.schultz@rackspace.com> - 1.0.1-1
- Minor fix for undef vars
* Wed Nov 20 2013 Alex Schultz <alex.schultz@rackspace.com> - 1.0.0-1
- Version 1.0.0 of the package
* Mon Nov 18 2013 Greg Swift <greg.swift@rackspace.com> - 0.1.0-1
- Initial version of the package
