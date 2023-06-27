AS = as
LD = ld

ASFLAGS =  
LDFLAGS = 

SRC = thrift.s
OBJ = $(SRC:.s=.o)
EXECUTABLE = thrift

all: $(EXECUTABLE)

$(EXECUTABLE): $(OBJ)
	$(LD) $(LDFLAGS) -o $@ $^

%.o: %.s
	$(AS) $(ASFLAGS) -o $@ $<
run: all
	./$(EXECUTABLE)
trace: all
	strace ./$(EXECUTABLE)

clean:
	rm -f $(OBJ) $(EXECUTABLE)
