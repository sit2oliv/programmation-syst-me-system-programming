# programmation-systeme / system-programming

在这个练习中，您将使用系统原语实现新版本的标准输入/输出库。为此，您必须定义新类型MY_FILE并编写以下函数：

— MY_FILE * my_open(const char *pathname, const char *mode)
	这个函数的作用与fopen是一样的. 为了简便，我们只考虑开放模式是“r”和“w”

— int my_getc(MY_FILE *stream)
	这个函数的作用与fgetc是一样的

— int my_putc(int c, MY_FILE *stream)
	这个函数的作用与fputc是一样的

— int my_close(MY_FILE *stream)
	这个函数的作用跟fclose是一样的

提醒一下，fgetc和fputc函数分别执行读写缓存。 不要忘记在MY_FILE类型中提供此输入/输出缓存。 如果对其中一个功能的运行存在疑问，则必须在机器上对其原始版本的操作建模（fopen，fgetc，fputc，fclose）。

程序必须使用gcc -Wall -Wextra -Werror进行编译。不使用此命令编译的程序将不得分。程序还需要释放所有已分配的内存。

必须以tar.gz格式呈现存档，该格式将包含2个文件：
 - 头文件，包括MY_FILE类型的定义，宏的定义（如果有的话）以及函数my_open，my_getc，my_putc，my_fclose的签名
 - 包含上述功能主体的.c文件
