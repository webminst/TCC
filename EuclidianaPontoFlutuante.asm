.data
# Defina as coordenadas dos pontos em quatro dimens�es como n�meros de ponto flutuante
ponto1: .float 18.0, 6.0, 12.0, 24.0  # Ponto 1: (18.0, 6.0, 12.0, 24.0)
ponto2: .float 2.0, 4.0, 8.0, 16.0    # Ponto 2: (2.0, 4.0, 8.0, 16.0)
resultado_distancia: .float 0.0        # Inicialize o resultado da dist�ncia como ponto flutuante

.text
.globl main

main:
    # Carregue os endere�os dos pontos na mem�ria
    la $t0, ponto1
    la $t1, ponto2

    # Calcule a dist�ncia euclidiana
    li $t2, 4  # N�mero de dimens�es
    loop:
        lwc1 $f2, 0($t0)  # Carregue a coordenada do ponto 1 como ponto flutuante
        lwc1 $f4, 0($t1)  # Carregue a coordenada do ponto 2 como ponto flutuante
        sub.s $f2, $f2, $f4  # Calcule a diferen�a
        mul.s $f2, $f2, $f2  # Eleve ao quadrado
        add.s $f0, $f0, $f2  # Adicione � soma
        addi $t0, $t0, 4    # Avance para a pr�xima coordenada do ponto 1
        addi $t1, $t1, 4    # Avance para a pr�xima coordenada do ponto 2
        addi $t2, $t2, -1   # Decrementa o contador de dimens�es
        bnez $t2, loop      # Repita at� processar todas as dimens�es

    # Calcule a raiz quadrada da soma
    sqrt.s $f0, $f0

    # Guarde o resultado na mem�ria
    s.s $f0, resultado_distancia

    # Terminar o programa
    li $v0, 10  # C�digo de sa�da do programa
    syscall
