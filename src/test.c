#include "test.h"
void call_fact() {
 sp = sp - r0;
 raddr_count = raddr_count - r0;
 r2 = *sp;
 r3 = 1;
 r4 = r2 == r3 ;
 if (!r4) goto label1;
 r5 = 1;
 *fp = r5;
goto label2;                                
label1:
 r6 = 1;
 r7 = r2 - r6;
fp = sp;
sp = sp +1;
raddr_count = raddr_count + r0;
*sp = r7;
sp = sp + r0; 
raddr_count = raddr_count + r0;
call_fact();
r8 = *fp;
sp = sp - r0;
raddr_count = raddr_count - r0;
fp = fp - raddr_count;
 r9 = r2 * r8;
 *fp = r9;
label2:
;}
void call_main() {
 r11 = 5;
fp = sp;
sp = sp +1;
raddr_count = raddr_count + r0;
*sp = r11;
sp = sp + r0; 
raddr_count = raddr_count + r0;
call_fact();
r12 = *fp;
sp = sp - r0;
raddr_count = raddr_count - r0;
fp = fp - raddr_count;
 *fp = r12;
}
int main() {
 fp = pile; 
 sp= pile;
 raddr_count = 0;
 r0 = 1;
 call_main();
 return 0; }
