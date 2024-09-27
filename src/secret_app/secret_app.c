/*
 * This is a simple example program that keeps a secret in a string in memory and otherwise does nothing.
 * It is used to test confidential computing where a dump of memory outside of the enclave does not reveal it.
 */

#include <stdio.h>

int main(int argc, const char* argv[]) { 

    char secret[17] = "mysecurepassword";
    while (1) {};
}
