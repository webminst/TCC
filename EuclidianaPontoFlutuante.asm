.data
# Defina as coordenadas dos pontos em quatro dimensões como números de ponto flutuante
ponto1: .float 18.0, 6.0, 12.0, 24.0  # Ponto 1: (18.0, 6.0, 12.0, 24.0)
ponto2: .float 2.0, 4.0, 8.0, 16.0    # Ponto 2: (2.0, 4.0, 8.0, 16.0)
resultado_distancia: .float 0.0        # Inicialize o resultado da distância como ponto flutuante

.text
.globl main

main:
    # Carregue os endereços dos pontos na memória
    la $t0, ponto1
    la $t1, ponto2

    # Calcule a distância euclidiana
    li $t2, 4  # Número de dimensões
    loop:
        lwc1 $f2, 0($t0)  # Carregue a coordenada do ponto 1 como ponto flutuante
        lwc1 $f4, 0($t1)  # Carregue a coordenada do ponto 2 como ponto flutuante
        sub.s $f2, $f2, $f4  # Calcule a diferença
        mul.s $f2, $f2, $f2  # Eleve ao quadrado
        add.s $f0, $f0, $f2  # Adicione à soma
        addi $t0, $t0, 4    # Avance para a próxima coordenada do ponto 1
        addi $t1, $t1, 4    # Avance para a próxima coordenada do ponto 2
        addi $t2, $t2, -1   # Decrementa o contador de dimensões
        bnez $t2, loop      # Repita até processar todas as dimensões

    # Calcule a raiz quadrada da soma
    sqrt.s $f0, $f0

    # Guarde o resultado na memória
    s.s $f0, resultado_distancia

    # Terminar o programa
    li $v0, 10  # Código de saída do programa
    syscall
