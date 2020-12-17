if $osfamily == "RedHat" {
$pkg = "httpd"
notify { "greeting\n": message => "Setting the value of pkg variable as httpd as the operating system is RedHat based\n" }
}
if $osfamily == "Debian" { 
$pkg = "apache2"
notify { "greeting": message => "Setting the value of pkg variable as apache2 as the operating system is Debian based" }
}

package {"$pkg":
ensure => present,
}
->
service {"$pkg":
ensure => running,
}
->
file {"/var/www/html/index.html":
ensure => present,
content => "Hello world",
#source => "/tmp/index.html",
}
