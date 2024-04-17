RM ?= rm -f

T = $(wildcard *.t)

all: test

test: $(T)
	$(MAKE) clean

$(T):
	$(SHELL) $@ $(TEST_OPTS)

clean:
	$(RM) -r test-results

.PHONY: all test $(T) clean
