name                "Tomcat-85"
description         "Installs/Configures Tomcat 8.5"
version             "0.1.0"
maintainer          "OneOps"
maintainer_email    "support@oneops.com"
license             "Copyright OneOps, All rights reserved."

grouping 'default',
         :access => "global",
         :packages => ["base", "mgmt.catalog", "mgmt.manifest", "catalog", "manifest", "bom"]

# Attributes for Tomcat 8.5 Binary Install
attribute 'tomcat_install_dir',
          :description => "Tomcat Installation Directory",
          :required => "required",
          :default => "/opt",
          :format => {
              :help => "Specify the directory where your Tomcat will be installed.",
              :category => "1.Global",
              :order => 1
          }

attribute 'version',
          :description => "Tomcat Version",
          :required => "required",
          :default => "8.5.2",
          :format => {
              :important => true,
              :help => "Specify the version of Tomcat you wish to install.",
              :form => {"field" => "select", "options_for_select" => [["8.5.2", "8.5.2"]]},
              :pattern => "[0-9\.]+",
              :category => "1.Global",
              :order => 2
          }

attribute 'tomcat_user',
          :description => "Tomcat User",
          :default => "tomcat",
          :format => {
              :help => "Specify the userid that the Tomcat process will run under.",
              :category => "1.Global",
              :order => 3
          }

attribute 'tomcat_group',
          :description => "Tomcat User Group",
          :default => "tomcat",
          :format => {
              :help => "Specify the groupid that the tomcat process will run under.",
              :category => "1.Global",
              :order => 4
          }

=begin
attribute 'webapp_install_dir',
          :description => "Webapps Directory",
          :default => "/opt/tomcat/webapps",
          :format => {
              :help => "Specify the directory path where Tomcat will look for web applications (webapps).",
              :category => "1.Global",
              :order => 5
          }
=end

attribute 'environment_settings',
          :description => "Environment Settings",
          :data_type => "hash",
          :default => "{}",
          :format => {
              :help => "Specify any environment settings that need to be placed in the .profile of the Tomcat User (ex: TZ=UTC).",
              :category => "1.Global",
              :order => 6
          }

# Attributes for context.xml Configuration
attribute 'override_context_enabled',
          :description => "Enable Override of context.xml File",
          :default => "false",
          :format => {
              :help => "Enable the replacement of the contents of the context.xml file.",
              :form => { "field" => "checkbox" },
              :category => "2.Context",
              :order => 1
          }

attribute 'context_tomcat',
          :description => "Replacement Configuration for context.xml",
          :default => IO.read(File.join(File.dirname(__FILE__), "files/context.xml")),
          :data_type => "text",
          :format => {
              :help => "Text in this field will override the existing context.xml file.",
              :filter => {"all" => {"visible" => "override_context_enabled:eq:true"}},
              :category => "2.Context",
              :order => 2
          }

# Attributes for server.xml Configuration
attribute 'override_server_enabled',
          :description => "Enable Override of server.xml File",
          :default => "false",
          :format => {
              :help => "Enable the replacement of the contents of the server.xml file.",
              :form => { "field" => "checkbox" },
              :category => "3.Server",
              :order => 1
          }

attribute 'server_tomcat',
          :description => "Additional Configuration for server.xml",
          :default => "",
          :data_type => "text",
          :format => {
              :help => "Define the values that you want to override the existing server.xml file.",
              :filter => {"all" => {"visible" => "override_server_enabled:eq:true"}},
              :category => "3.Server",
              :order => 2
          }

attribute 'autodeploy_enabled',
	        :description => "WAR File autoDeploy",
	        :default => "false",
          :format => {
              :help => "Enable autoDeploy",
              :filter => {"all" => {"visible" => "override_server_enabled:eq:false"}},
              :form => {"field" => "checkbox"},
              :category => "3.Server",
              :order => 3
          }

attribute 'http_NIO_connector_enabled',
          :description => "Enable HTTP Connector",
          :default => "false",
          :format => {
                :help => "Enable the HTTP Connector (Non-SSL/TLS) Connector.",
                :filter => {"all" => {"visible" => "override_server_enabled:eq:false"}},
                :form => {"field" => "checkbox"},
                :category => "3.Server",
                :order => 4
            }
attribute 'https_NIO_connector_enabled',
          :description => "Enable HTTPS Connector",
          :default => "true",
          :format => {
                :help => "Enable the HTTPS Connector (SSL/TLS) Connector.",
                :filter => {"all" => {"visible" => "override_server_enabled:eq:false"}},
                :form => {"field" => "checkbox"},
                :category => "3.Server",
                :order => 5
            }

attribute 'advanced_NIO_connector_config',
          :description => "Additional Attributes for Tomcat Connector",
          :data_type => "hash",
          :required => "required",
          :default => '{"connectionTimeout":"20000","maxKeepAliveRequests":"100"}',
          :format => {
              :help => 'These additional attributes (ex: attr_name1="value1" attr_name2="value2") will be appended to both HTTP and HTTPS connector elements in server.xml (enabled or not).',
              :filter => {"all" => {"visible" => "override_server_enabled:eq:false"}},
              :category => "3.Server",
              :order => 6
          }

attribute 'port',
          :description => "HTTP Port",
          :required => "required",
          :default => "8080",
          :format => {
              :help => "Specify the port that Tomcat will listen on for incoming HTTP (Non-SSL) requests",
              :filter => {"all" => {"visible" => "http_connector_enabled:eq:true && override_server_enabled:eq:false"}},
              :pattern => "[0-9]+",
              :category => "3.Server",
              :order => 7
          }

attribute 'ssl_port',
          :description => "HTTPS Port",
          :required => "required",
          :default => "8443",
          :format => {
              :help => "Specify the port that Tomcat will listen on for incoming HTTPS (SSL) requests",
              :pattern => "[0-9]+",
              :category => "3.Server",
              :order => 8
          }

attribute 'advanced_security_options',
          :description => "Advanced Security Options",
          :default => "false",
          :format => {
              :help => "Display advanced security options (Note: Hiding the options does not disable or default any settings changed by the user.)",
              :form => { "field" => "checkbox" },
              :category => "3.Server",
              :order => 9
          }

attribute 'tlsv11_protocol_enabled',
          :description => "Enable TLSv1.1",
          :default => "false",
          :format => {
              :help => "If TLS is enabled by adding a certificate and keystore, this attribute determines if the TLSv1.1 protocol and ciphers are enabled.",
              :filter => {"all" => {"visible" => "advanced_security_options:eq:true"}},
              :form => { "field" => "checkbox" },
              :category => "3.Server",
              :order => 10
          }

attribute 'tlsv12_protocol_enabled',
          :description => "Enable TLSv1.2",
          :default => "true",
          :format => {
              :help => "If SSL/TLS is enabled by adding a certificate and keystore, this attribute determines if the TLSv1.2 protocol and ciphers are enabled.",
              :filter => {"all" => {"visible" => "advanced_security_options:eq:true"}},
              :form => { "field" => "checkbox" },
              :category => "3.Server",
              :order => 11
          }

attribute 'enable_method_get',
          :description => "Enable GET HTTP method",
          :default => "true",
          :format => {
              :help => "Enable the GET HTTP method",
              :filter => {"all" => {"visible" => "advanced_security_options:eq:true"}},
              :form => { "field" => "checkbox" },
              :category => "3.Server",
              :order => 12
          }

attribute 'enable_method_put',
          :description => "Enable PUT HTTP method",
          :default => "true",
          :format => {
              :help => "Enable the PUT HTTP method",
              :filter => {"all" => {"visible" => "advanced_security_options:eq:true"}},
              :form => { "field" => "checkbox" },
              :category => "3.Server",
              :order => 13
          }

attribute 'enable_method_post',
          :description => "Enable POST HTTP method",
          :default => "true",
          :format => {
              :help => "Enable the POST HTTP method",
              :filter => {"all" => {"visible" => "advanced_security_options:eq:true"}},
              :form => { "field" => "checkbox" },
              :category => "3.Server",
              :order => 14
          }

attribute 'enable_method_delete',
          :description => 'Enable DELETE HTTP method',
          :default => 'true',
          :format => {
              :help => "Enable the DELETE HTTP method",
              :filter => {"all" => {"visible" => "advanced_security_options:eq:true"}},
              :form => { "field" => "checkbox" },
              :category => "3.Server",
              :order => 13
          }

attribute 'enable_method_connect',
          :description => 'Enable CONNECT HTTP method',
          :default => 'false',
          :format => {
              :help => "Enable the CONNECT HTTP method",
              :filter => {"all" => {"visible" => "advanced_security_options:eq:true"}},
              :form => { "field" => "checkbox" },
              :category => "3.Server",
              :order => 14
          }

attribute 'enable_method_options',
          :description => 'Enable OPTIONS HTTP method',
          :default => 'false',
          :format => {
              :help => "Enable the OPTIONS HTTP method",
              :filter => {"all" => {"visible" => "advanced_security_options:eq:true"}},
              :form => { "field" => "checkbox" },
              :category => "3.Server",
              :order => 15
          }

attribute 'enable_method_head',
          :description => 'Enable HEAD HTTP method',
          :default => 'true',
          :format => {
              :help => "Enable the HEAD HTTP method",
              :filter => {"all" => {"visible" => "advanced_security_options:eq:true"}},
              :form => { "field" => "checkbox" },
              :category => "3.Server",
              :order => 16
          }

attribute 'enable_method_trace',
          :description => 'Enable TRACE HTTP method',
          :default => 'false',
          :format => {
              :help => "Enable the TRACE HTTP method",
              :filter => {"all" => {"visible" => "advanced_security_options:eq:true"}},
              :form => { "field" => "checkbox" },
              :category => "3.Server",
              :order => 17
          }

attribute 'max_threads',
          :description => 'Max Number of Threads',
          :required => 'required',
          :default => '50',
          :format => {
              :help => "Specify the max number of active threads in Tomcat's threadpool.",
              :pattern => '[0-9]+',
              :category => "3.Server",
              :order => 20
          }

attribute 'min_spare_threads',
          :description => 'Min Number of Spare Threads',
          :required => 'required',
          :default => '25',
          :format => {
              :help => 'Specify the minimum number of threads always kept alive in the threadpool.',
              :pattern => '[0-9]+',
              :category => "3.Server",
              :order => 21
          }

# Attributes set in the setenv.sh script
attribute 'java_options',
          :description => "Java Options",
          :default => '-Djava.awt.headless=true',
          :format => {
              :help => 'Specify any JVM command line options needed in your Tomcat instance.',
              :category => '5.Java',
              :order => 1
          }

attribute 'system_properties',
          :description => "System Properties",
          :data_type => 'hash',
          :default => "{}",
          :format => {
              :important => true,
              :help => 'Specify any key value pairs for -D args to the jvm.',
              :category => '5.Java',
              :order => 2
          }

attribute 'startup_params',
          :description => "Startup Parameters",
          :data_type => 'array',
          :default => '["+UseConcMarkSweepGC +PrintGCDetails +PrintGCDateStamps -DisableExplicitGC +UseGCLogFileRotation NumberOfGCLogFiles=5 GCLogFileSize=10M"]',
          :format => {
              :help => 'Specify any -XX arguments (without the -XX: in the values) needed.',
              :category => '5.Java',
              :order => 3
          }

attribute 'mem_max',
          :default => '512M',
          :description => "Max Heap Size",
          :format => {
              :important => true,
              :help => 'Set the Max Memory Heap Size for the Tomcat JVM.',
              :category => '5.Java',
              :order => 4
          }

attribute 'mem_start',
          :default => '256M',
          :description => 'Starting Heap Size',
          :format => {
              :help => 'Specify the starting Heap Size for the Tomcat JVM.',
              :category => '5.Java',
              :order => 5
          }

# Attributes to control log settings
attribute 'logfiles_path',
          :description => "Cantalina and Access Log Directory Path",
          :required => "required",
          :default => "/opt/tomcat/logs",
          :format => {
              :help => "Specify the directory that catalina.out and access.log will be written to.",
              :category => "6.Logs",
              :order => 1
          }

attribute 'access_log_pattern',
          :default => '%h %l %u %t &quot;%r&quot; %s %b %D %F',
          :description => "Format of the Access Log",
          :format => {
              :help => 'Specify the format the the access log data will be logged as.',
              :category => '6.Logs',
              :order => 2
          }

# Attributes for Tomcat instance startup and shutdown processes
attribute 'stop_time',
          :default => '45',
          :description => "Tomcat Shutdown Time Limit (secs)",
          :format => {
              :help => 'Specify the time limit to shutdown the Tomcat server (seconds).',
              :pattern => "[0-9]+",
              :category => '7.Startup_Shutdown',
              :order => 1
          }

attribute 'pre_shutdown_command',
          :default => '',
          :description => 'Pre-Shutdown Command',
          :data_type => 'text',
          :format => {
              :help => 'Specify the command to be executed before catalina stop is invoked. (Ex: It can be used to post request (using curl), which can trigger an ecv failure(response code 503). This will allow the load balancer to take the instance out of traffic.)',
              :category => '7.Startup_Shutdown',
              :order => 2
          }

attribute 'time_to_wait_before_shutdown',
          :default => '30',
          :description => 'Time (in seconds) Between Pre-Shutdown Command Execution and Tomcat Shutdown',
          :format => {
              :help=> "Specify the time (in seconds) to wait between the 'catalina stop' and the pre-shutdown commands executing.",
              :pattern => '[0-9]+',
              :category => '7.Startup_Shutdown',
              :order => 3
          }

attribute 'post_shutdown_command',
          :default => '',
          :description => 'Post-Shutdown Command',
          :data_type => 'text',
          :format => {
              :help => 'Specify the command to be executed after catalina stop is invoked.',
              :category => '7.Startup_Shutdown',
              :order => 4
          }

attribute 'pre_startup_command',
          :default => '',
          :description => 'Command to be executed before Tomcat has been started',
          :data_type => 'text',
          :format => {
              :help => "Specify the command to be executed before catalina start is invoked. The command should return a '0' for successful execution and a '1' for failure. (A returned '1' will cause the Tomcat startup to fail.)",
              :category => '7.Startup_Shutdown',
              :order => 5
          }

attribute 'post_startup_command',
          :default => '',
          :description => 'Command to be executed after Tomcat has been started',
          :data_type => 'text',
          :format => {
              :help => "Specify the command to be executed after catalina start is invoked. The command should return a '0' for successful execution and a '1' for failure. (A returned '1' will cause the Tomcat startup to fail.)",
              :category => '7.Startup_Shutdown',
              :order => 6
          }

attribute 'polling_frequency_post_startup_check',
          :default => '1',
          :description => 'Time (in seconds) between validation that Tomcat instance startup completed.',
          :format => {
              :help => "Specify how many seconds desired between status checks of Tomcat. If a post-startup command is specified, the command will run after Tomcat's status is validated as up.",
              :pattern => '[0-9]+',
              :category => '7.Startup_Shutdown',
              :order => 7
          }

attribute 'max_number_of_retries_for_post_startup_check',
          :default => '15',
          :description => 'Max number of retries validating Tomcat instance startup before post-startup command runs',
          :format => {
              :help => "Specify the number of times that verification the status of the Tomcat instance will be retried.",
              :pattern => '[0-9]+',
              :category => '7.Startup_Shutdown',
              :order => 8
          }

# Included Recipes that you can run as an action from the Operations phase
recipe 'status', 'Tomcat Status'
recipe 'start', 'Start Tomcat'
recipe 'stop', 'Stop Tomcat'
recipe 'force-stop', 'Skips PreShutDownHook'
recipe 'force-restart', 'Skips PreShutDownHook'
recipe 'restart', 'Restart Tomcat'
recipe 'repair', 'Repair Tomcat'
recipe 'debug', 'Debug Tomcat'
recipe 'validateAppVersion', 'Server started after app deployment'
recipe 'threaddump','Java Thread Dump'
