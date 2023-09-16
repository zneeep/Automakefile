#!/bin/bash

PROJECT_DIR=$(grep "PROJECT_DIR;" "$1" | cut -d ';' -f2)
SOURCES_DIR=$(grep "SOURCES_DIR;" "$1" | cut -d ';' -f2)
LIBS_DIR=$(grep "LIBS_DIR;" "$1" | cut -d ';' -f2)
HEADERS_DIR=$(grep "HEADERS_DIR;" "$1" | cut -d ';' -f2)
EXEC=$(grep "EXEC;" "$1" | cut -d ';' -f2)
CFLAGS=$(grep "CFLAGS;" "$1" | cut -d ';' -f2)
CC=$(grep "CC;" "$1" | cut -d ';' -f2)
LDFLAGS=$(grep "LDFLAGS;" "$1" | cut -d ';' -f2)
HEADERS_FILES=$(grep "\.h" "$1" | cut -d ';' -f2 | tr '\n' ' ')
SOURCE_FILES=$(grep "\.c" "$1" | cut -d ';' -f1 | tr '\n' ' ')
IFS=" " read -ra  HEADERS_FILES <<< "$HEADERS_FILES"
IFS=" " read -ra SOURCE_FILES <<< "$SOURCE_FILES"
HEADERS=()
SOURCE=()

for i in "${HEADERS_FILES[@]}"; do
    if [[ ! "${HEADERS[*]}" =~ ${i} ]]
    then
      HEADERS+=("$i")
    fi
done

for i in "${SOURCE_FILES[@]}"; do
    if [[ ! "${SOURCE[*]}" =~ ${i} ]]
    then
      SOURCE+=("$i")
    fi
done

touch "$PROJECT_DIR"/Makefile
chmod 777 "$PROJECT_DIR"/Makefile
printf "SRC\t=\t" > "$PROJECT_DIR"/Makefile
for i in "${SOURCE[@]}"; do
  printf "%s/%s " "$SOURCES_DIR" "$i" >> "$PROJECT_DIR"/Makefile
  done

printf "\n\nOBJ\t=\t\$(SRC:.c=.o)" >> "$PROJECT_DIR"/Makefile
printf "\n\nINCLUDE\t=\t%s./%s" "-I" "$HEADERS_DIR" >> "$PROJECT_DIR"/Makefile
printf "\n\nCFLAGS\t=\t%s" "$CFLAGS" >> "$PROJECT_DIR"/Makefile
printf "\n\nLDFLAGS\t=\t%s" "$LDFLAGS" >> "$PROJECT_DIR"/Makefile
printf "\n\nLIBS_DIR\t=\t%s" "$LIBS_DIR" >> "$PROJECT_DIR"/Makefile
printf "\n\nCC\t=\t%s" "$CC" >> "$PROJECT_DIR"/Makefile
printf "\n\nNAME\t=\t%s" "$EXEC" >> "$PROJECT_DIR"/Makefile
printf "\n\n\$(NAME): \$(OBJ)\n\t\$(CC) -o \$(NAME) \$(OBJ) \$(CFLAGS) \$(LDFLAGS) \$(INCLUDE)" >> "$PROJECT_DIR"/Makefile
printf "\n\nall: \$(NAME)" >> "$PROJECT_DIR"/Makefile
printf "\n\nclean:\n\trm -f \$(OBJ) *.gcno" >> "$PROJECT_DIR"/Makefile
printf "\n\nfclean: clean\n\trm -f \$(NAME)" >> "$PROJECT_DIR"/Makefile
printf "\n\nre: fclean all" >> "$PROJECT_DIR"/Makefile

