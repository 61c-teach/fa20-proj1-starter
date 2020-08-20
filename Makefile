CC = gcc
CFLAGS = -lm -g

imageloader: imageloader.o imageloadertester.o
	$(CC) -o imageloadertester imageloader.o imageloadertester.o $(CFLAGS)
	echo "Running imageloadertest"
	./imageloadertester testInputs/JohnConway.ppm > studentOutputs/JohnConway.ppm
	diff testInputs/JohnConway.ppm studentOutputs/JohnConway.ppm
	echo "Diff check: The above lines were different than expected. If no lines show up, then this passed"

imagememcheck: imageloader
	echo "Running memory check on imageloadertest"
	valgrind --tool=memcheck --leak-check=full --dsymutil=yes --track-origins=yes ./imageloadertester testInputs/JohnConway.ppm > studentOutputs/JohnConway.ppm


steganography: imageloader.o steganography.o
	echo "Running steganography"
	$(CC) -o steganography steganography.o imageloader.o $(CFLAGS)
	./steganography testInputs/JohnConway.ppm > studentOutputs/secretMessage.ppm

steganographymemcheck:  steganography
	valgrind --tool=memcheck --leak-check=full --dsymutil=yes --track-origins=yes ./steganography testInputs/JohnConway.ppm > studentOutputs/secretMessage.ppm

gameoflife: imageloader.o gameoflife.o
	$(CC) -o gameOfLife gameoflife.o imageloader.o $(CFLAGS)
	echo "Successfully compiled"
	echo "Run ./frames.csh for various tests"

gameoflifememcheck: gameoflife
	valgrind --tool=memcheck --leak-check=full --dsymutil=yes --track-origins=yes ./gameOfLife testInputs/JohnConway.ppm 0x1808 > studentOutputs/temp.ppm


%.o: %.c
	$(CC) -c $< $(CFLAGS)

clean:
	rm -f *.o
	rm -f gameOfLife
	rm -f steganography
	rm -f imageloadertester
