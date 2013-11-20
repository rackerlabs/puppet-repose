%define base_name repose

Name:      puppet-module-%{base_name}
Version:   1.0.0
Release:   1
BuildArch: noarch
Summary:   Puppet module to configure %{base_name}
License:   GPLv3+
URL:       http://github.rackspace.com/cloud-integration-ops/%{base_name}
Source0:   %{name}.tgz

%description
Repose is an API proxy service htat provides validation,
keystone authentication, and several other features.

%define module_dir /usr/share/puppet/modules/%{base_name}

%prep
%setup -q -c -n %{base_name}

%build

%install
mkdir -p %{buildroot}%{module_dir}
cp -pr * %{buildroot}%{module_dir}/

%files
%defattr (0644,root,root)
%{module_dir}
%config %{module_dir}/manifests/config.pp

%changelog
* Wed Nov 20 2013 Alex Schultz <alex.schultz@rackspace.com> - 1.0.0-1
- Version 1.0.0 of the package
* Mon Nov 18 2013 Greg Swift <greg.swift@rackspace.com> - 0.1.0-1
- Initial version of the package
