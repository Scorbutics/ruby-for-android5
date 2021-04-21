.PHONY: fetch openssl ruby clean mrproper clean_ruby

OPENSSL_VERSION=1.1.1k
NCURSES_VERSION=6.0
READLINE_VERSION=8.0
GDMB_VERSION=1.18.1
ZLIB_VERSION=1.2.11
RUBY_RELEASE=3.0
RUBY_SRC_VERSION=$(RUBY_RELEASE).0
RUBY_SRC_DIR=ruby-$(RUBY_SRC_VERSION)

TOPDIR=$(shell pwd)

INCLUDE_DIR_USR=$(TOPDIR)/target/usr/include
INCLUDE_DIR_USR_LOCAL=$(TOPDIR)/target/usr/local/include
LINK_DIR_USR=$(TOPDIR)/target/usr/lib
LINK_DIR_USR_LOCAL=$(TOPDIR)/target/usr/local/lib

EXTRA_CFLAGS=-I$(INCLUDE_DIR_USR) -I$(INCLUDE_DIR_USR_LOCAL)
EXTRA_LDFLAGS=-L$(LINK_DIR_USR) -L$(LINK_DIR_USR_LOCAL) -L$(TOPDIR)/$(RUBY_SRC_DIR)

all: .ruby.zip.done

fetch: .fetch.done

openssl: .openssl.done

ncurses: .ncurses.done

readline: .readline.done

gdbm: .gdbm.done

zlib: .zlib.done

ruby: .ruby.done

clean:
	rm -rf extras
	rm -rf interpreter
	rm -rf rubyroot
	rm -rf openssl-$(OPENSSL_VERSION)
	rm -rf ncurses-$(NCURSES_VERSION)
	rm -rf readline-$(READLINE_VERSION)
	rm -rf gdbm-$(GDMB_VERSION)
	rm -rf zlib-$(ZLIB_VERSION)
	rm -rf ruby-$(RUBY_SRC_VERSION)
	rm -f .*.done

mrproper: clean
	rm -f openssl-$(OPENSSL_VERSION).tar.gz
	rm -f ncurses-$(NCURSES_VERSION).tar.gz
	rm -f readline-$(READLINE_VERSION).tar.gz
	rm -f zlib-$(ZLIB_VERSION).tar.gz
	rm -f gdbm-$(GDMB_VERSION).tar.gz
	rm -f $(RUBY_SRC_DIR).tar.xz

clean_ruby:
	rm -f .ruby.done

.fetch.done:
	wget ftp://ftp.gnu.org/gnu/ncurses/ncurses-$(NCURSES_VERSION).tar.gz
	wget ftp://ftp.gnu.org/gnu/readline/readline-$(READLINE_VERSION).tar.gz
	wget -c http://www.openssl.org/source/openssl-$(OPENSSL_VERSION).tar.gz
	wget ftp://ftp.gnu.org/gnu/gdbm/gdbm-$(GDMB_VERSION).tar.gz
	wget http://zlib.net/zlib-$(ZLIB_VERSION).tar.gz
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
		CFLAGS="$$CFLAGS $(EXTRA_CFLAGS)" \
		LDFLAGS="$$LDFLAGS $(EXTRA_LDFLAGS)" \
		CPPFLAGS="$$CPPFLAGS $(EXTRA_CFLAGS)" \
		./configure --host=$$HOST --target=$$HOST --enable-shared && \
		make && \
		make install DESTDIR=$(TOPDIR)/target)
	>.readline.done

.gdbm.done: .readline.done
	rm -rf gdbm-$(GDMB_VERSION)
	tar -zxf gdbm-$(GDMB_VERSION).tar.gz
	(cd gdbm-$(GDMB_VERSION) && \
		CFLAGS="$$CFLAGS $(EXTRA_CFLAGS)" \
		LDFLAGS="$$LDFLAGS $(EXTRA_LDFLAGS)" \
		CPPFLAGS="$$CPPFLAGS $(EXTRA_CFLAGS)" \
		./configure --host=$$HOST --target=$$HOST --enable-shared --disable-static --enable-libgdbm-compat && \
		make && \
		make install DESTDIR=$(TOPDIR)/target)
	>.gdbm.done

.openssl.done: .fetch.done
	rm -rf openssl-$(OPENSSL_VERSION)
	tar -zxf openssl-$(OPENSSL_VERSION).tar.gz
	(cd openssl-$(OPENSSL_VERSION) && ./Configure $$HOST_SHORT "-D__ANDROID_API__=$$ANDROID_API" shared && \
		make && \
		make install DESTDIR=$(TOPDIR)/target)
	>.openssl.done

.zlib.done: .fetch.done
	rm -rf zlib-$(ZLIB_VERSION)
	tar -zxf zlib-$(ZLIB_VERSION).tar.gz
	(cd zlib-$(ZLIB_VERSION) && ./configure && \
		make && \
		make install DESTDIR=$(TOPDIR)/target)
	>.zlib.done

.ruby.done: .readline.done .gdbm.done .zlib.done .openssl.done
	rm -rf $(RUBY_SRC_DIR)
	tar -Jxf $(RUBY_SRC_DIR).tar.xz
	for p in $$(ls patches/ruby); do (cd $(RUBY_SRC_DIR) && patch < $(TOPDIR)/patches/ruby/$$p); done
	(cd $(RUBY_SRC_DIR) && \
		CFLAGS="$$CFLAGS $(EXTRA_CFLAGS)" \
		LDFLAGS="$$LDFLAGS $(EXTRA_LDFLAGS) -lz" \
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

.ruby.zip.done: .ruby.install.done
	rm -f ruby_full.zip
	(cd $(TOPDIR)/target/ && \
		zip --symlinks -r $(TOPDIR)/ruby_full.zip \
			usr/local/lib/ruby/ \
			usr/local/lib/lib*.so* \
			usr/local/bin/irb usr/local/bin/gem usr/local/bin/rake usr/local/bin/ruby usr/local/bin/bundle usr/local/bin/bundler)
	>.ruby.zip.done
