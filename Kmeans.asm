.data
# Defina as coordenadas do ponto em quatro dimens�es como n�meros de ponto flutuante
ponto: .float 18.0, 6.0, 12.0, 24.0  # Ponto: (18.0, 6.0, 12.0, 24.0)

# Defina as coordenadas dos centroides em quatro dimens�es como n�meros de ponto flutuante
centroide1: .float 18.0, 6.0, 8.0, 16.0      # Centroide 1: (2.0, 4.0, 8.0, 16.0)
centroide2: .float 10.0, 12.0, 14.0, 18.0    # Centroide 2: (10.0, 12.0, 14.0, 18.0)
centroide3: .float 5.0, 7.0, 9.0, 11.0       # Centroide 3: (5.0, 7.0, 9.0, 11.0)
centroide4: .float 20.0, 22.0, 24.0, 26.0    # Centroide 4: (20.0, 22.0, 24.0, 26.0)
zero: .float 0.0

# Vari�vel para armazenar a menor dist�ncia
menor_distancia: .float 0.0

# Vari�vel para armazenar o �ndice do centroide mais pr�ximo
indice_centroide_mais_proximo: .word 0

# Vari�vel para armazenar o valor da dist�ncia do centroide mais pr�ximo
valor_distancia_mais_proxima: .float 0.0

.text
.globl main

main:
    # Carregue o endere�o do ponto na mem�ria
    la $t0, ponto

    # Inicialize um registrador para o �ndice do centroide atual
    li $t2, 1  # Come�amos com o centroide 1

calcula_distancia:
    # Carregue o endere�o do centroide atual na mem�ria
    la $t1, centroide1  # Suponha que come�amos com o centroide 1
    beq $t2, 2, centroide2
    beq $t2, 3, centroide3
    beq $t2, 4, centroide4

    # Inicialize a soma das diferen�as ao quadrado
    lwc1 $f0, zero  # $f0 armazena a soma como ponto flutuante

    # Calcule a dist�ncia euclidiana
    li $t3, 4  # N�mero de dimens�es
    loop:
        lwc1 $f2, 0($t0)  # Carregue a coordenada do ponto como ponto flutuante
        lwc1 $f4, 0($t1)  # Carregue a coordenada do centroide como ponto flutuante
        sub.s $f2, $f2, $f4  # Calcule a diferen�a
        mul.s $f2, $f2, $f2  # Eleve ao quadrado
        add.s $f0, $f0, $f2  # Adicione � soma
        addi $t0, $t0, 4    # Avance para a pr�xima coordenada do ponto
        addi $t1, $t1, 4    # Avance para a pr�xima coordenada do centroide
        addi $t3, $t3, -1   # Decrementa o contador de dimens�es
        bnez $t3, loop      # Repita at� processar todas as dimens�es

    # Calcule a raiz quadrada da soma
    sqrt.s $f0, $f0

    # Compare com a menor dist�ncia atual
    lwc1 $f6, menor_distancia  # Carregue a menor dist�ncia atual
    c.lt.s $f0, $f6  # Compare a dist�ncia atual com a menor dist�ncia
    bc1t update_menor_distancia  # Se for menor, atualize a menor dist�ncia, o �ndice e o valor da dist�ncia do centroide mais pr�ximo

    # Pr�ximo centroide
    addi $t2, $t2, 1
    bnez $t2, calcula_distancia

    # Carregue o �ndice e o valor da dist�ncia do centroide mais pr�ximo ap�s o �ltimo c�lculo
update_menor_distancia:
    sw $t7, indice_centroide_mais_proximo  # Defina o �ndice do centroide mais pr�ximo
    s.s $f0, valor_distancia_mais_proxima  # Defina o valor da dist�ncia do centroide mais pr�ximo

    # Terminar o programa
    li $v0, 10  # C�digo de sa�da do programa
    syscall
