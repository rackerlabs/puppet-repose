%define base_name repose

Name:      cit-puppet-module-%{base_name}
Version:   0.1
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
mkdir -p %{buildroot}%{module_dir}

%install
cp -pr * %{buildroot}%{module_dir}/

%files
%defattr (0644,root,root)
%{module_dir}
%config %{module_dir}/manifests/config.pp

%changelog
* Thu Sep 27 2012 Ra Cker <ra.cker@rackspace.com> - 0.1-1
- Initial version of the package
