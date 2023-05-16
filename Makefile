EXE=tolower
OBJS=tolower.o

$(EXE): $(OBJS)
	ld -s -o $@ $^

.phony: clean

clean:
	rm -f $(EXE) $(OBJS)
