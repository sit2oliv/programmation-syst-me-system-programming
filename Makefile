SHELL=/bin/bash
CC = gcc
CFLAGS= -Wall -Werror -Wextra -g -std=c89

HEADER = $(wildcard *.h)
SRC = $(filter-out main.c, $(wildcard *.c))
OBJ = $(patsubst %.c,%.o,$(SRC))

BIN = a.out
TESTS = test_open test_cpy test_perf test_memory

.PHONY: all clean

all: $(BIN) $(TESTS)

$(BIN): main.o $(OBJ)
	$(CC) $(CFLAGS) $^ -o $@

$(OBJ): $(SRC)
	$(CC) $(CFLAGS) -c $^

main.o: main.c
	$(CC) $(CFLAGS) -c $^

clean:
	@/bin/rm -f $(OBJ) main.c main.o titi toto tata script.sh $(BIN)

main.c:
	@which indent > /dev/null || (echo "Package indent is missing, please install it via apt install indent" && exit 1)
	@echo -e '#include "$(HEADER)"\n' > main.c
	@echo "void raler(const char *msg) {" >> main.c
	@echo "perror(msg);" >> main.c
	@echo "exit(EXIT_FAILURE);" >> main.c
	@echo -e "}\n" >> main.c
	@echo "int main(int argc, char **argv) {" >> main.c
	@echo "int i, j, c;" >> main.c
	@echo "int nb_file = argc / 2;" >> main.c
	@echo "int nb_f_r = 0, nb_f_w = 0;" >> main.c
	@echo "MY_FILE *f_r[nb_file], **p_r;" >> main.c
	@echo "MY_FILE *f_w[nb_file], **p_w;" >> main.c
	@echo -e "MY_FILE **p;\n" >> main.c
	@echo "if(argc == 1 || (argc%2) != 1) {" >> main.c
	@echo 'fprintf(stderr,"USAGE: %s file1 mode1 [file2 mode2...]\n", argv[0]);' >> main.c
	@echo "exit(EXIT_FAILURE);" >> main.c
	@echo -e "}\n" >> main.c
	@echo "p_r = f_r;" >> main.c
	@echo "p_w = f_w;" >> main.c
	@echo "for (i = 1 ; i < argc - 1 ; i+=2) {" >> main.c
	@echo "if (*argv[i+1] == 'r') {" >> main.c
	@echo "p = p_r++;" >> main.c
	@echo "nb_f_r++;" >> main.c
	@echo "}" >> main.c
	@echo "else {" >> main.c
	@echo "p = p_w++;" >> main.c
	@echo "nb_f_w++;" >> main.c
	@echo -e "}\n" >> main.c
	@echo "if ((*p = my_open (argv[i], argv[i+1])) == NULL) {" >> main.c
	@echo 'raler ("pb my_open");' >> main.c
	@echo "}" >> main.c
	@echo -e "}\n" >> main.c
	@echo "for (i = 0 ; i < nb_f_r ; i++) {" >> main.c
	@echo "while ((c = my_getc (f_r[i])) != MY_EOF) {" >> main.c
	@echo "for (j = 0 ; j < nb_f_w ; j++) {" >> main.c
	@echo "if (my_putc (c, f_w[j]) == MY_EOF) {" >> main.c
	@echo 'raler ("putc");' >> main.c
	@echo "}" >> main.c
	@echo "}" >> main.c
	@echo "}" >> main.c
	@echo -e "}\n" >> main.c
	@echo "for(i = 0 ; i < nb_f_r ; i++) {" >> main.c
	@echo "if (my_close (f_r[i]) == MY_EOF) {" >> main.c
	@echo 'raler ("my_close");' >> main.c
	@echo "}" >> main.c
	@echo -e "}\n" >> main.c
	@echo "for(i = 0 ; i < nb_f_w ; i++) {" >> main.c
	@echo "if (my_close (f_w[i]) == MY_EOF) {" >> main.c
	@echo 'raler ("my_close");' >> main.c
	@echo "}" >> main.c
	@echo -e "}\n" >> main.c
	@echo "return 0;" >> main.c
	@echo "}" >> main.c
	@indent -bad -bap -bbb -bbo -brf -br -brs -bli0 -bs -c40 -cbi4 -cli4 -i4 -l80 -nce -nprs -pcs -saf -sai -saw -sbi0 main.c
	@rm main.c~

test_open:
	@echo "[32m################### TESTING: opening file[0m"
	@cp main.c toto
	./$(BIN) toto r || exit 1
	./$(BIN) toto w || exit 1
	./$(BIN) toto a 2> /dev/null && exit 1 || exit 0
	./$(BIN) abcde r  2> /dev/null && exit 1 || exit 0
	chmod -r toto ; ./$(BIN) toto r 2> /dev/null && exit 1 || exit 0 ;
	@chmod +r toto
	chmod -w toto ; ./$(BIN) toto w 2> /dev/null && exit 1 || exit 0 ;
	@chmod +w toto
	@rm toto
	@echo -e "[32m################### TESTING: passed - Note = 1/3\n[0m"

test_cpy:
	@echo "[32m################### TESTING: copying file[0m"
	@cp main.c titi
	./$(BIN) titi r toto w && cmp titi toto 2> /dev/null || exit 1
	dd if=/dev/urandom of=titi count=2096 2> /dev/null ; ./$(BIN) titi r toto w && cmp titi toto || exit 1
	./$(BIN) titi r titi r toto w ; cat titi titi > tata ; cmp toto tata 2> /dev/null || exit 1
	./$(BIN) titi r toto w tata w ; cmp toto tata 2> /dev/null || exit 1
	./$(BIN) titi r titi r titi r toto w tata w tutu w ; cat titi titi titi > ploup ; cmp ploup toto 2> /dev/null && cmp ploup tata 2> /dev/null && cmp ploup tutu 2> /dev/null || exit 1
	@rm titi toto tata tutu ploup
	@echo -e "[32m################### TESTING: passed - Note = 2/3\n[0m"

test_perf:
	@echo "[32m################### TESTING: performance[0m"
	@echo "#!/bin/bash" > script.sh
	@echo "dd if=/dev/urandom of=titi count=8192 2> /dev/null" >> script.sh
	@echo 'START=$$(date +%s)' >> script.sh
	@echo "./a.out titi r toto w && cmp titi toto || exit 1" >> script.sh
	@echo 'END=$$(date +%s)' >> script.sh
	@echo 'DIFF=$$(echo "$$END - $$START" | bc)' >> script.sh
	@echo 'if [ $$DIFF -le 1 ]; then exit 0; else exit 1; fi' >> script.sh
	/bin/bash script.sh || exit 1
	@rm titi toto script.sh
	@echo -e "[32m################### TESTING: passed[0m"

test_memory:
	@echo "[32m################### TESTING: memory leak or error[0m"
	@dd if=/dev/urandom of=titi count=1024 2> /dev/null
	valgrind --leak-check=full --error-exitcode=1 ./$(BIN) titi r titi r titi r toto w tata w tutu w > /dev/null 2>&1 || exit 1
	@rm titi toto tata tutu
	@echo -e "[32m################### TESTING: passed - Note = 3/3\n[0m"
