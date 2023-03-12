MKDIR  = mkdir -p
REMOVE = rm -rf

CC     = clang
CFLAGS = -std=c2x -g -Wall -Wextra -Wpedantic -Wfloat-equal -Wformat

AR      = ar
ARFLAGS = -cvrs

PROJECT_NAME = ctemplate

PROJECT_DIR = $(CURDIR)

INCLUDE_DIR = $(PROJECT_DIR)/include
SOURCES_DIR = $(PROJECT_DIR)/src
BUILD_DIR   = $(PROJECT_DIR)/build
TESTS_DIR   = $(PROJECT_DIR)/tests

EXEC        = $(BUILD_DIR)/$(PROJECT_NAME)

OBJ_DIR       = $(BUILD_DIR)/objs
TESTS_BIN_DIR = $(BUILD_DIR)/tests

TESTS_SOURCES = $(wildcard $(TESTS_DIR)/*.c)
TESTS_BINS    = $(patsubst $(TESTS_DIR)/%.c, $(TESTS_BIN_DIR)/%, $(TESTS_SOURCES))

SOURCES = $(wildcard $(SOURCES_DIR)/*.c)
HEADERS = $(wildcard $(INCLUDE_DIR)/**/*.h)
OBJS    = $(patsubst $(SOURCES_DIR)/%.c, $(OBJ_DIR)/%.o, $(SOURCES))

FORMATTER = clang-format
FORMATTER_FLAGS = -i


default: all
all: $(EXEC)

release: CFLAGS=-Wall -Werror -O3 -DNDEBUG
release: clean
release: $(EXEC)


$(EXEC): $(BUILD_DIR) $(OBJ_DIR) $(OBJS)
	$(CC) $(CFLAGS) $(OBJS) -o $@

$(BUILD_DIR):
	$(MKDIR) $@

$(OBJ_DIR):
	$(MKDIR) $@

$(OBJ_DIR)/%.o: $(SOURCES_DIR)/%.c $(INCLUDE_DIR)/$(PROJECT_NAME)/%.h
	$(CC) $(CFLAGS) -c $< -o $@ -I$(INCLUDE_DIR)

$(OBJ_DIR)/%.o: $(SOURCES_DIR)/%.c
	$(CC) $(CFLAGS) -c $< -o $@ -I$(INCLUDE_DIR)


tests: $(LIBRARY) $(TESTS_BIN_DIR) $(TESTS_BINS)
	@for test in $(TESTS_BINS); do $$test ; done

$(TESTS_BIN_DIR)/%: $(TESTS_DIR)/%.c
	$(CC) $(CFLAGS) $< $(OBJS) -o $@ -lcriterion -I$(INCLUDE_DIR)

$(TESTS_BIN_DIR):
	$(MKDIR) $@


clean veryclean:
	$(REMOVE) $(BUILD_DIR)

run: $(EXEC)
	$(EXEC)

format-source:
	$(FORMATTER) $(FORMATTER_FLAGS) $(SOURCES)
	$(FORMATTER) $(FORMATTER_FLAGS) $(HEADERS)

format-tests:
	$(FORMATTER) $(FORMATTER_FLAGS) $(TESTS_SOURCES)

format: format-source format-tests


.PHONY: default, all, main, clean, veryclean, format, format-source, format-tests

