

notice("this is hello from puppet")

file { "/tmp/test.txt":
  content => "content get from puppet",
  ensure => "file"
}
