Ruby for Android 5
===

This is a project to compile Ruby 2.2 as position independent executable (PIE) for Android 5. 
It originated from https://github.com/chrisistuff/ruby-for-android that has been created in 2013 but is now abandoned.
The compiled Ruby comes with SSL support and the full set of Ruby's stdlib. It will run on Android 4.1+.

Preparation
===

1. Download the Android NDK [here](http://developer.android.com/tools/sdk/ndk/index.html). Version r10e was the latest at the time of this writing, it works well.
2. Unpack the NDK
3. Create a standalone toolchain using the following command: 
`$NDKDIR/build/tools/make-standalone-toolchain.sh --platform=android-19`--toolchain=arm-linux-androideabi-4.9 --install-dir=/tmp/toolchain
4. Add the toolchain to your PATH: `export PATH=/tmp/toolchain/bin:$PATH`
 
Compilation
===
No patches are required any more. The `Makefile` essentially just calls `configure` with the necessary parameters.

Two zip files will be generated:
- ruby_r3.zip, holding the executables and shared libraries
- ruby_extras_r3.zip, holding the stdlib

There is no reason to separate the stdlib from the binaries except that the original project was targeted at SL4A that encouraged this separation.

To build the zip files simply run `make` in `ruby-build`.

Usage
===

Once deployed on the Android device (either manually or as part of an APK) ruby needs to know 
about the libraries. Call Ruby like this:
`<RUBYROOT>/bin/ruby -I<RUBYROOT>/lib/ruby/2.2.0 -I<RUBYROOT>/lib/ruby/2.2.0/arm-linux-androideabi <ruby options>`
