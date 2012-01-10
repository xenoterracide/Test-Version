
use strict;
use warnings;

use 5.006;

use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "Check to see that version's in modules are sane",
  "AUTHOR" => "Caleb Cushing <xenoterracide\@gmail.com>",
  "BUILD_REQUIRES" => {
    "English" => 0,
    "File::Find" => 0,
    "File::Temp" => 0,
    "Scalar::Util" => 0,
    "Test::Exception" => 0,
    "Test::More" => "0.94",
    "Test::Requires" => 0,
    "Test::Tester" => 0
  },
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "Test-Version",
  "EXE_FILES" => [],
  "LICENSE" => "artistic_2",
  "NAME" => "Test::Version",
  "PREREQ_PM" => {
    "Carp" => 0,
    "Exporter" => 0,
    "File::Find::Rule::Perl" => 0,
    "Module::Metadata" => 0,
    "Test::Builder" => 0,
    "Test::More" => 0,
    "parent" => 0,
    "strict" => 0,
    "version" => "0.86",
    "warnings" => 0
  },
  "VERSION" => "1.001004",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



