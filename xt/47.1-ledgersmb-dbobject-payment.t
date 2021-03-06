#!/usr/bin/perl

=head1 UNIT TESTS FOR LedgerSMB::DBObject::Payment

Unit tests for the LedgerSMB::DBObject::Payment module that exercise
interaction with a test database.

=cut

use strict;
use warnings;

use DBI;
use Test::More;
use LedgerSMB::DBObject::Payment;
use LedgerSMB::Setting;


# Create test run conditions
my $payment;
my $dbh = DBI->connect(
    "dbi:Pg:dbname=$ENV{LSMB_NEW_DB}",
    undef,
    undef,
    { AutoCommit => 0, PrintError => 0 }
) or BAIL_OUT "Can't connect to template database: " . DBI->errstr;

my $setting = LedgerSMB::Setting->new()
    or BAIL_OUT('Failed to initialise LedgerSMB::Setting object');
$setting->set_dbh($dbh)
    or BAIL_OUT('Failed to initialise LedgerSMB::Setting dbh');
$setting->set('curr', 'EUR')
    or BAIL_OUT('Failed to initialise default currency');


plan tests => (4);

# Initialise Object
$payment = LedgerSMB::DBObject::Payment->new({base => {
    dbh => $dbh,
    account_class => 1,
}});
isa_ok($payment, 'LedgerSMB::DBObject::Payment', 'instantiated object');
ok($payment->set_dbh($dbh), 'set dbh');

is($payment->get_default_currency(), 'EUR', 'get_default_currency returns expected currency code');
is($payment->{default_currency}, 'EUR', 'object `default_currency` property set correctly');


# Don't commit any of our changes
$dbh->rollback;
