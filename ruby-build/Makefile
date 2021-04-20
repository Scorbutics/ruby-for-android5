.PHONY: fetch openssl ruby zips clean mrproper clean_ruby

RELEASE=3

OPENSSL_VERSION=1.1.1k
NCURSES_VERSION=6.0
READLINE_VERSION=8.0
RUBY_RELEASE=3.0
RUBY_VERSION=3.0.0
RUBY_SRC_VERSION=3.0.0
RUBY_SRC_DIR=ruby-3.0.0

INCLUDE_DIR_USR=$(TOPDIR)/target/usr/include
INCLUDE_DIR_USR_LOCAL=$(TOPDIR)/target/usr/local/include
LINK_DIR_USR=$(TOPDIR)/target/usr/lib
LINK_DIR_USR_LOCAL=$(TOPDIR)/target/usr/local/lib

EXTRA_CFLAGS=-I$(INCLUDE_DIR_USR) -I$(INCLUDE_DIR_USR_LOCAL)
EXTRA_LDFLAGS=-L$(LINK_DIR_USR) -L$(LINK_DIR_USR_LOCAL)

TOPDIR=$(shell pwd)

zips: ruby_r$(RELEASE).zip ruby_extras_r$(RELEASE).zip

fetch: .fetch.done

openssl: .openssl.done

ncurses: .ncurses.done

ruby: .ruby.done

clean:
	rm -rf extras
	rm -rf interpreter
	rm -rf rubyroot
	rm -rf openssl-$(OPENSSL_VERSION)
	rm -rf ncurses-$(NCURSES_VERSION)
	rm -rf readline-$(READLINE_VERSION)
	rm -rf ruby-$(RUBY_SRC_VERSION)
	rm -f .*.done

mrproper: clean
	rm -f openssl-$(OPENSSL_VERSION).tar.gz
	rm -f ncurses-$(NCURSES_VERSION).tar.gz
	rm -f readline-$(READLINE_VERSION).tar.gz
	rm -f $(RUBY_SRC_DIR).tar.xz
	rm -f ruby_r$(RELEASE).zip
	rm -f ruby_extras_r$(RELEASE).zip

clean_ruby:
	rm -f .ruby.done

.fetch.done:
	wget ftp://ftp.gnu.org/gnu/ncurses/ncurses-$(NCURSES_VERSION).tar.gz
	wget ftp://ftp.gnu.org/gnu/readline/readline-$(READLINE_VERSION).tar.gz
	wget -c http://www.openssl.org/source/openssl-$(OPENSSL_VERSION).tar.gz
	wget -c http://ftp.ruby-lang.org/pub/ruby/$(RUBY_RELEASE)/$(RUBY_SRC_DIR).tar.xz
	mkdir -p $(TOPDIR)/target
	>.fetch.done

.ncurses.done: .fetch.done
	rm -rf ncurses-$(NCURSES_VERSION)
	tar -zxf ncurses-$(NCURSES_VERSION).tar.gz
	(cd ncurses-$(NCURSES_VERSION) && \
		CPPFLAGS="-P" ./configure --host=$$HOST --target=$$HOST --enable-term-driver --enable-sp-funcs --with-shared && \
		make && \
		make install DESTDIR=$(TOPDIR)/target)
	>.ncurses.done

.readline.done: .ncurses.done
	rm -rf readline-$(READLINE_VERSION)
	tar -zxf readline-$(READLINE_VERSION).tar.gz
	(cd readline-$(READLINE_VERSION) && \
		autoconf && \
		CFLAGS="$(EXTRA_CFLAGS)" \
		LDFLAGS="$(EXTRA_LDFLAGS)" \
		./configure --host=$$HOST --target=$$HOST --enable-shared && \
		make && \
		make install DESTDIR=$(TOPDIR)/target)
	>.readline.done

.openssl.done: .fetch.done
	rm -rf openssl-$(OPENSSL_VERSION)
	tar -zxf openssl-$(OPENSSL_VERSION).tar.gz
	(cd openssl-$(OPENSSL_VERSION) && ./Configure $$HOST_SHORT "-D__ANDROID_API__=$$ANDROID_API" shared && \
		make && \
		make install DESTDIR=$(TOPDIR)/target)
	>.openssl.done

.ruby.done: .readline.done .openssl.done
	rm -rf $(RUBY_SRC_DIR)
	tar -Jxf $(RUBY_SRC_DIR).tar.xz
	for p in $$(ls patches); do (cd $(RUBY_SRC_DIR) && patch < $(TOPDIR)/patches/$$p); done
	(cd $(RUBY_SRC_DIR) && \
		CFLAGS="$$CFLAGS $(EXTRA_CFLAGS)" \
		LDFLAGS="$$LDFLAGS $(EXTRA_LDFLAGS)" \
		CPPFLAGS="$$CPPFLAGS $(EXTRA_CFLAGS)" \
		./configure \
		--host=$$HOST \
		--target=$$HOST \
		--enable-shared \
		--disable-install-doc && \
		make)
	>.ruby.done

.ruby.install.done: .ruby.done
	rm -rf rubyroot
	(cd ruby-$(RUBY_SRC_VERSION) && make install-nodoc DESTDIR=$(TOPDIR)/target)
	>.ruby.install.done

ruby_r$(RELEASE).zip: .ruby.install.done
	rm -rf interpreter
	mkdir -p interpreter/ruby
	mkdir -p interpreter/ruby/bin
	cp rubyroot/bin/ruby interpreter/ruby/bin
	cp rubyroot/bin/irb interpreter/ruby/bin
	mkdir -p interpreter/ruby/lib/ruby/$(RUBY_VERSION)
	cp -r rubyroot/lib/ruby/$(RUBY_VERSION)/$$HOST interpreter/ruby/lib/ruby/$(RUBY_VERSION)
	cp rubyroot/lib/libruby.so.$(RUBY_VERSION) interpreter/ruby/lib
	cp openssl-$(OPENSSL_VERSION)/lib*.so.* interpreter/ruby/lib
	find interpreter -name *.so -exec $$HOST-strip {} \;
	$$HOST-strip interpreter/ruby/bin/ruby
	(cd interpreter && zip -r ../ruby_r$(RELEASE).zip ruby)

ruby_extras_r$(RELEASE).zip: .ruby.install.done
	rm -rf extras
	mkdir -p extras/ruby
	mkdir -p extras/ruby/lib/ruby/$(RUBY_VERSION)
	cp -r rubyroot/lib/ruby/$(RUBY_VERSION)/* extras/ruby/lib/ruby/$(RUBY_VERSION)
	rm -rf extras/ruby/lib/ruby/$(RUBY_VERSION)/$$HOST
	(cd extras && zip -r ../ruby_extras_r$(RELEASE).zip ruby)
