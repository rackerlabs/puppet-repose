%define user citops
%define base_name repose

Name:      puppet-module-%{user}-%{base_name}
Version:   2.13.0
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

#

%changelog
* Wed Sep 23 2019 Uma Samudrala <uma.samudrala@rackspace.com> 2.13.0-1
- Added global rate limits for Rate Limiting Filter
* Tue Oct 29 2019 Cory Ringdahl <cory.ringdahl@rackspace.com> 2.12.1-1
- removed PID_FILE var for repose9; startup script already takes care of this var
* Tue Oct 22 2019 Senthil Natarajan <senthil.natarajan@rackspace.com> 2.12.0-1
- Added support for url encoded header
* Thu Aug 21 2019 Josh Bell <josh.bell@rackspace.com> 2.11.0-1
- Add basic support for Repose 9 in system model and other filters
- Add support for installing identity filter bundle
* Tue Jun 18 2019 Lokesh Belwal <Lokesh.Belwal@rackspace.com> - 2.10.0-1
- Add log_file_perm param to provide world read access on logs if set to 'public' 
* Mon Dec 17 2018 Josh Bell <josh.bell@rackspace.com> - 2.9.0-1
- Add via_header and repose_version options to container filter
* Mon May 12 2018  Josh Bell <josh.bell@rackspace.com> - 2.8.0-1
- Add ssl protocol and tls renegotiation options to container filter
* Mon Apr 02 2018 Dimitry Ushakov <dimitry.ushakov@rackspace.com> - 2.7.0-1
- Add opentracing module and tests
* Wed Mar 21 2018 Meynard Alconis <meynard.alconis@rackspace.com> - 2.6.2-1
- Fix for header user module and tests
* Mon Mar 19 2018 Meynard Alconis <meynard.alconis@rackspace.com> - 2.6.1-1
- Backwards compatability issue with tracing-header configuration
* Fri Jan 26 2018 Josh Bell <josh.bell@rackspace.com> - 2.6.0-1
- Add support to modify per filter logging levels in log4j2
* Fri Nov 10 2017 Josh Bell <josh.bell@rackspace.com> - 2.4.0-1
- Add support for Repose 8 tracing header options
* Thu Jul 27 2017 Geoffrey McCammon <geoff.mccammon@rackspace.com> - 2.2.0-1
- Add connection pool ID configuration for dist datastore
* Fri May 19 2017 Jason Straw <jason.straw@rackspace.com> - 2.1.0-1
- Add SSL Ciphers to repose configuration
* Thu Apr 06 2017 Josh Bell <josh.bell@rackspace.com> - 2.0.0-1
- Add support to install experimental filters bundle pacakge
- Add scripting filter, template and supporting tests 
* Fri Feb 24 2017 Josh Bell <josh.bell@rackspace.com> - 1.12.0-1
- Add saml-policy filter, template and supporting tests 
* Wed Feb 15 2017 Josh Bell <josh.bell@rackspace.com> - 1.11.0-1
- Add option to enable intrafilter trace logging
* Fri Jan 20 2017 Josh Bell <josh.bell@rackspace.com> - 1.10.0-1
- Add uri-user filter and supporting template and tests
* Tue Jan 17 2017 Josh Bell <josh.bell@rackspace.com> - 1.9.0-1
- Add ip-user filter and supporting template and tests
* Wed Jun 17 2016 Josh Bell <josh.bell@rackspace.com> - 1.6.5-1
- Bump version to match Modulefile
* Wed Jun 17 2016 Josh Bell <josh.bell@rackspace.com> - 1.4.4-1
- Adding rewrite-host-header support
* Wed Apr 01 2015 Alex Schultz <alex.schultz@rackspace.com> - 1.4.3-1
- Adding uri-stripper and destination-router support
* Mon Mar 30 2015 Alex Schultz <alex.schultz@rackspace.com> - 1.4.2-1
- Adding Highly Efficient Record Processor configuration
* Wed Mar 25 2015 Alex Schultz <alex.schultz@rackspace.com> - 1.4.1-1
- Backwards compatibility config file fixes
* Fri Mar 20 2015 Alex Schultz <alex.schultz@rackspace.com> - 1.4.0-1
- Repose 7 configuration support
* Tue Jan 20 2015 Alex Schultz <alex.schultz@rackspace.com> - 1.3.6-1
- Adding configuration for travis-ci
* Mon Jan 05 2015 Alex Schultz <alex.schultz@rackspace.com> - 1.3.5-1
- Make send-all-tenant-ids for client_auth_n optional
* Fri Dec 19 2014 Alex Schultz <alex.schultz@rackspace.com> - 1.3.4-1
- Add send-all-tenant-ids for client_auth_n
* Thu Nov 13 2014 Alex Schultz <alex.schultz@rackspace.com> - 1.3.3-1
- Actually allow facility configuration for syslog
* Tue Nov 04 2014 Alex Schultz <alex.schultz@rackspace.com> - 1.3.2-1
- Adding rackspace-identity-basic-auth filter
* Tue Nov 04 2014 Chad Wilson <chad.wilson@rackspace.com> - 1.3.1-1
- Added mask_rax_roles_403 to validator template
- Add tests for content if enable-rax-roles/mask-rax-roles-403 set in validator
* Thu Oct 23 2014 Alex Schultz <alex.schultz@rackspace.com> - 1.3.0-1
- Updating to support specifying a specific version of repose be installed
- Fixing ensure absent on filters
* Tue Oct 21 2014 Nick Bales <nick.bales@rackspace.com> - 1.2.1-1
- moving ignore_tenant_role closing tag outside of loop
* Mon Oct 13 2014 Alex Schultz <alex.schultz@rackspace.com> - 1.2.0-1
- Removing -s shutdown port as it is not supported in repose >= 6.1.1.1
* Wed Oct 01 2014 Alex Schultz <alex.schultz@rackspace.com> - 1.1.1-1
- fixing log_local_size to be MB not M
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
