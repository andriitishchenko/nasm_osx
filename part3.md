# Function call

#### For INTEGER args
```
method(int a1,int a2,int a3,int a4,int a5,int a6,int a7,int a8){
    a1 ⟶ RDI
    a2 ⟶ RSI
    a3 ⟶ RDX
    a4 ⟶ RCX
    a5 ⟶ R8
    a6 ⟶ R9
    push a7
    push a8
}
```
> Integer return values are passed in RAX and RDX, in that order.

#### For Floating-point  args
```
method(float a0,float a1,float a2,float a3,...){
    XMM0 to XMM7; return is XMM0 and XMM1,
    a0 ⟶ XMM0
    a1 ⟶ XMM1
    ...

}
```
> return is XMM0 and XMM1

**long double** are passed on the stack, and returned in ST0 and ST1.


```
void foo(long a, double b, int c){
    a ⟶ RDI
    b ⟶ XMM0
    c ⟶ ESI
}

```



# Example

> main.m
```

#import <Foundation/Foundation.h>

/**
void method(int a1,int a2,int a3,int a4,int a5,int a6,int a7,int a8){
    a1 === RDI
    a2 === RSI
    a3 === RDX
    a4 === RCX
    a5 === R8
    a6 === R9
    push a7
    push a8
}
 */


__attribute__ ((naked)) int add2_naked(int i){
    __asm{
        push    rbp
        mov     rbp, rsp
        mov     eax, edi
        add     eax,2
        pop     rbp
        ret
    }
//    return 1; Non-ASM statement in naked function is not supported
}


int add_ab(int a, int b){
//    return a+b

//    edi -> [rbp - 4]
//    esi -> [rbp - 8]
    int result;
    asm{ add esi, edi }
    asm{ mov result, esi }
    return result;
}

int max_ab(int a, int b){
//        return max(a,b)

//    edi -> [rbp - 4]
//    esi -> [rbp - 8]
    int result;
    asm{ cmp edi, esi }
    asm{ cmovge esi, edi }
    asm{ mov result, esi }
    return result;
}

int mul_ab(int a, int b) {
//    return a*b;

//    edi -> [rbp - 4]
//    esi -> [rbp - 8]
    int result;
    asm{ imul esi, edi }
    asm{ mov result, esi }
    return result;
}

float div_float_ab(float a, float b){
//    float r = 0;
//    if(b!=0){
//        r = a/b;
//    }
//    return r;

//    xmm0  ->  [rbp - 4]
//    xmm1  ->  [rbp - 8]

    float res; // if assign a value above the asm{}, it clears xmm0
    asm { xorps xmm3,xmm3 } //xmm3 = 0

    asm { ucomiss xmm1, xmm3}
    asm { je Finished // if xmm1 == 0 -> goto Finished

          divss xmm0, xmm1
          movss xmm3, xmm0

          Finished:
    }
    asm{
      movss  res, xmm3 // xmm3 is 0
    }
    return res;
}

double div_double_ab(double a, double b){
//    return a/b;

//    xmm0  ->  [rbp - 8]
//    xmm1  ->  [rbp - 16]
    float res;
    asm{ divss xmm0, xmm1 }
    asm{ movss res, xmm0 }
    return res;
}


// Pointers
int add_ab_point(int *a, int *b){
//    return *a + *b;

//    rdi  ->  [rbp - 8]
//    rsi  ->  [rbp - 16]
    int result;
    asm{ mov rax, [rdi] }
    asm{ add rax, [rsi] }
    asm{ mov result, rax }
    return result;
}


void move_b_to_a(int *a, int b){
//    *a = b;

//    rdi -> [rbp - 8]
//    esi -> [rbp - 12]
    asm{ mov [rdi], esi }
}

void move_b_to_a_qword(double *a, double b){
//   *a = b;

//    rdi -> [rbp - 8]
//    xmm0 -> [rbp - 16]
    asm{ movsd [rdi] , xmm0 }
}


int main(int argc, const char * argv[]) {
    @autoreleasepool {

        int r = 0,a = 7, b = 5;

        r= add2_naked(a);
        printf("%i\n",r);

        r = add_ab(a, b);
        printf("%i\n",r);

        r = mul_ab(a, b);
        printf("%i\n",r);

        r = max_ab(a,b);
        printf("%i\n",r);

        r = add_ab_point(&a, &b);
        printf("%i\n",r);

        move_b_to_a(&r, 20);
        printf("%i\n",r);

        float ff = 0;
        float dword_af = 2.2, dword_bf = 2.0;
        ff = div_float_ab(dword_af, dword_bf);
        printf("%.5f\n",ff);

        ff = div_float_ab(dword_af, 0);
        printf("%.5f\n",ff);


        double dword_a = 7, dword_b = 5;
        move_b_to_a_qword(&dword_a, dword_b);
        printf("%.5f\n",dword_a);

    }
    return 0;
}

```