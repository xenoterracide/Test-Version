use ExtUtils::MakeMaker;

my $tests = do {
	local @ARGV = qw{ t/test_manifest };
	my $data = join ' ', map { chomp; "t/$_" } <>;
};

WriteMakefile(
    'NAME' => 'Test::Version',
    'VERSION_FROM' => 'lib/Version.pm',
    'PREREQ_PM'	=> {
 		'Test::More' => 0,
 		'Test::Builder::Tester' => 0,
	},
	'PM' => {
		'lib/Version.pm' => '$(INST_LIBDIR)/Version.pm',
	},
	depend => { Makefile => 't/test_manifest' },
	test => { TESTS => $tests },
);
