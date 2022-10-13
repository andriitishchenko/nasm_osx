all:
	nasm -f macho64 $(source).asm -DDARWIN
	ld $(source).o -o $(source) -demangle -dynamic -macosx_version_min 11.0 -L/usr/local/lib -syslibroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -lSystem -no_pie
	rm $(source).o