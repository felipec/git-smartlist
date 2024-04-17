#!/bin/sh

test_description='Test git smartlist'

. "$(dirname "$0")"/test-lib.sh

test_smartlist () {
	cat > expected &&
	git smartlist echo "$@" > actual &&
	cat actual &&
	test_cmp expected actual
}

test_commit () {
	echo "$1" > content &&
	git add content &&
	git commit -q -m "$1"
}

setup () {
	git init -q &&

	test_commit one &&
	test_commit two &&

	git checkout -q -b feature master^ &&
	test_commit feature &&
	git branch -q -u master &&

	git checkout -q -b ns/feature1 master^ &&
	test_commit feature1 &&

	git checkout -q -b ns/feature2 master^ &&
	test_commit feature2 &&

	git checkout -q feature
}

setup

test_expect_success 'usage' '
	test_must_fail git smartlist 2> usage &&
	grep -q "usage: " usage
'

test_expect_success 'all' '
	test_smartlist all <<-\EOF
	--branches --remotes --not feature~1
	EOF
'

test_expect_success 'all: extra opts' '
	test_smartlist all -- README <<-\EOF
	--branches --remotes --not feature~1 -- README
	EOF
'

test_expect_success 'branch' '
	test_smartlist branches <<-\EOF
	--branches --not feature~1
	EOF
'

test_expect_success 'branch: single branch' '
	test_smartlist branches master <<-\EOF
	master
	EOF
'

test_expect_success 'branch: multiple branches' '
	test_smartlist branches master feature <<-\EOF
	master feature --not feature~1
	EOF
'

test_expect_success 'branch: extra opts' '
	test_smartlist branches master feature -- README <<-\EOF
	master feature --not feature~1 -- README
	EOF
'

test_expect_success 'branch: prefix' '
	test_smartlist branches "ns/*" <<-\EOF
	--branches=ns/* --not ns/feature1~1
	EOF
'

test_expect_success 'branch: namespace' '
	test_smartlist branches "ns/" <<-\EOF
	--branches=ns/ --not ns/feature1~1
	EOF
'

test_expect_success 'from' '
	test_smartlist from <<-\EOF
	master..@
	EOF
'

test_expect_success 'from: branch' '
	test_smartlist from ns/feature1 <<-\EOF
	master..ns/feature1
	EOF
'

test_expect_success 'from-upstream' '
	test_smartlist from-upstream <<-\EOF
	@@{u}..@
	EOF
'

test_expect_success 'from-upstream: default' '
	git checkout ns/feature1 &&
	test_smartlist from-upstream <<-\EOF
	master..@
	EOF
'

test_expect_success 'from-upstream: branch' '
	test_smartlist from-upstream feature <<-\EOF
	feature@{u}..feature
	EOF
'

test_expect_success 'negate-upstreams' '
	test_smartlist negate-upstreams feature ns/feature1 <<-\EOF
	feature@{u}..feature
	master..ns/feature1
	EOF
'

test_expect_success 'specific' '
	git checkout feature &&
	test_smartlist specific <<-\EOF
	@@{u}..@
	EOF
'

test_expect_success 'specific: branch' '
	test_smartlist specific feature <<-\EOF
	feature@{u}..feature
	EOF
'

test_expect_success 'specific: multiple branches' '
	test_smartlist specific master feature <<-\EOF
	master feature --not feature~1
	EOF
'

test_expect_success 'main: check revision range' '
	test_smartlist specific master..feature <<-\EOF
	master..feature
	EOF
'

test_done
