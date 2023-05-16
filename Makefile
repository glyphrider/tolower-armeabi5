EXE=tolower
OBJS=tolower.o

$(EXE): $(OBJS)
	ld -o $@ $^

%.o : %.s
	as -g -o $@ $^

.phony: clean

clean:
	rm -f $(EXE) $(OBJS)
