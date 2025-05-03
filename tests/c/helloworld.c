extern void printf(const char *format, ...);
extern void eot_sequence();

void _start() {
    printf("Hello, World!\n");
    eot_sequence();
}