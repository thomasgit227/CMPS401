#include <sys/wait.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#define LSH_TOK_BUFSIZE 1024

char *Line_read(void);
char **parse(char *line);
int mydir(char **args);
int launch(char **args);
int execute(char **args);
int launch(char **args);


char *Line_read(void) {
  char *line = NULL;
  ssize_t bufsize = 0;

  if (getline(&line, &bufsize, stdin) == -1) {
    if (feof(stdin)) {
      exit(EXIT_SUCCESS);
    } else {
      perror("readline");
      exit(EXIT_FAILURE);
    }
  }

  return line;
}

#define LSH_TOK_DELIM " \t\r\n\a"
char **parse(char *line) {

  int bufsize = LSH_TOK_BUFSIZE, position = 0;
  char **tokens = malloc(bufsize * sizeof(char*));
  char *token;

  if (!tokens) {
    fprintf(stderr, "lsh: allocation error\n");
    exit(EXIT_FAILURE);
  }

  token = strtok(line, LSH_TOK_DELIM);
  while (token != NULL) {
    tokens[position] = token;
    position++;

    if (position >= bufsize) {
      bufsize += LSH_TOK_BUFSIZE;
      tokens = realloc(tokens, bufsize * sizeof(char*));
      if (!tokens) {
        fprintf(stderr, "lsh: allocation error\n");
        exit(EXIT_FAILURE);
      }
    }

    token = strtok(NULL,LSH_TOK_DELIM);
  }
  tokens[position] = NULL;
  return tokens;
}

int mydir(char **args);
int myquit(char **args);

char *builtin_str[] = {
  "mydir",
  "myquit"
};

int (*builtin_func[]) (char **) = {
  &mydir,
  &myquit
};

int lsh_num_builtins() {
  return sizeof(builtin_str) / sizeof(char *);
}

int mydir(char **args) {
  if (args[1] == NULL) {
    fprintf(stderr, "lsh: expected argument to \"cd\"\n");
  } else {
    if (chdir(args[1]) != 0) {
      perror("lsh");
    }
  }
  return 1;
}

int myquit(char **args) {
  return 0;
}


int execute(char **args) {
  int i;

  if (args[0] == NULL) {
    return 1;
  }

  for (i = 0; i < lsh_num_builtins(); i++) {
    if (strcmp(args[0], builtin_str[i]) == 0) {
      return (*builtin_func[i])(args);
    }
  }

  return launch(args);
}

int launch(char **args) {
  pid_t pid, wpid;
  int status;

  pid = fork();
  if (pid == 0) {
    // Child process
    if (execvp(args[0], args) == -1) {
      perror("lsh");
    }
    exit(EXIT_FAILURE);
  } else if (pid < 0) {
    // Error forking
    perror("lsh");
  } else {
    // Parent process
    do {
      wpid = waitpid(pid, &status, WUNTRACED);
    } while (!WIFEXITED(status) && !WIFSIGNALED(status));
  }

  return 1;
}

void loop(void) {
  char * line;
  char ** args;
  int status;

  do {
    printf("%s",">");
    line = Line_read();
    printf("%s", line);
    args = parse(line);
    status = execute(args);
  } while(status);
}


int main(int argc, char** argv) {
  loop();

  return 0;
}

