#!/bin/sh

. "$(dirname "$0")"/sharness.sh

GIT_AUTHOR_EMAIL=author@example.com
GIT_AUTHOR_NAME='A U Thor'
GIT_COMMITTER_EMAIL=committer@example.com
GIT_COMMITTER_NAME='C O Mitter'
export GIT_AUTHOR_EMAIL GIT_AUTHOR_NAME
export GIT_COMMITTER_EMAIL GIT_COMMITTER_NAME

test_must_fail() {
        "$@"
	test $? != 0
}

test_cmp() {
	diff -u "$@"
}
