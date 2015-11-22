.PHONY: fetch openssl ruby zips clean mrproper clean_ruby

RELEASE=3

OPENSSL_VERSION=1.0.2d
RUBY_RELEASE=2.2
RUBY_VERSION=2.2.0
RUBY_SRC_VERSION=2.2.3
RUBY_SRC_DIR=ruby-2.2.3

TOPDIR=$(shell pwd)

zips: ruby_r$(RELEASE).zip ruby_extras_r$(RELEASE).zip

fetch: .fetch.done

openssl: .openssl.done

ruby: .ruby.done

clean:
	rm -rf extras
	rm -rf interpreter
	rm -rf rubyroot
	rm -rf openssl-$(OPENSSL_VERSION)
	rm -rf ruby-$(RUBY_SRC_VERSION)
	rm -f .*.done

mrproper: clean
	rm -f openssl-$(OPENSSL_VERSION).tar.gz
	rm -f $(RUBY_SRC_DIR).tar.xz
	rm -f ruby_r$(RELEASE).zip
	rm -f ruby_extras_r$(RELEASE).zip

clean_ruby:
	rm -f .ruby.done

.fetch.done:
	wget -c http://www.openssl.org/source/openssl-$(OPENSSL_VERSION).tar.gz
	wget -c http://ftp.ruby-lang.org/pub/ruby/$(RUBY_RELEASE)/$(RUBY_SRC_DIR).tar.xz
	>.fetch.done

.openssl.done: .fetch.done
	rm -rf openssl-$(OPENSSL_VERSION)
	tar -zxf openssl-$(OPENSSL_VERSION).tar.gz
	(cd openssl-$(OPENSSL_VERSION) && CC=arm-linux-androideabi-gcc MACHINE=arm ./config shared && make)
	>.openssl.done

.ruby.done: .openssl.done
	rm -rf $(RUBY_SRC_DIR)
	tar -Jxf $(RUBY_SRC_DIR).tar.xz
	(cd $(RUBY_SRC_DIR) && \
		export CFLAGS="-I$(TOPDIR)/openssl-$(OPENSSL_VERSION)/include -pie" && \
		export LDFLAGS="-L$(TOPDIR)/openssl-$(OPENSSL_VERSION)" && \
		./configure --target=arm-linux-androideabi --host=arm-linux-androideabi --prefix=$(TOPDIR)/rubyroot --enable-shared)
	(cd $(RUBY_SRC_DIR) && make main)
	>.ruby.done

.ruby.install.done: .ruby.done
	rm -rf rubyroot
	(cd ruby-$(RUBY_SRC_VERSION) && make install-nodoc)
	>.ruby.install.done

ruby_r$(RELEASE).zip: .ruby.install.done
	rm -rf interpreter
	mkdir -p interpreter/ruby
	mkdir -p interpreter/ruby/bin
	cp rubyroot/bin/ruby interpreter/ruby/bin
	cp rubyroot/bin/irb interpreter/ruby/bin
	mkdir -p interpreter/ruby/lib/ruby/$(RUBY_VERSION)
	cp -r rubyroot/lib/ruby/$(RUBY_VERSION)/arm-linux-androideabi interpreter/ruby/lib/ruby/$(RUBY_VERSION)
	cp rubyroot/lib/libruby.so.$(RUBY_VERSION) interpreter/ruby/lib
	cp openssl-$(OPENSSL_VERSION)/lib*.so.* interpreter/ruby/lib
	find interpreter -name *.so -exec arm-linux-androideabi-strip {} \;
	arm-linux-androideabi-strip interpreter/ruby/bin/ruby
	(cd interpreter && zip -r ../ruby_r$(RELEASE).zip ruby)

ruby_extras_r$(RELEASE).zip: .ruby.install.done
	rm -rf extras
	mkdir -p extras/ruby
	mkdir -p extras/ruby/lib/ruby/$(RUBY_VERSION)
	cp -r rubyroot/lib/ruby/$(RUBY_VERSION)/* extras/ruby/lib/ruby/$(RUBY_VERSION)
	rm -rf extras/ruby/lib/ruby/$(RUBY_VERSION)/arm-linux-androideabi
	(cd extras && zip -r ../ruby_extras_r$(RELEASE).zip ruby)
