.data
# Defina as coordenadas do ponto em quatro dimensões como números de ponto flutuante
ponto: .float 18.0, 6.0, 12.0, 24.0  # Ponto: (18.0, 6.0, 12.0, 24.0)

# Defina as coordenadas dos centroides em quatro dimensões como números de ponto flutuante
centroide1: .float 18.0, 6.0, 8.0, 16.0      # Centroide 1: (2.0, 4.0, 8.0, 16.0)
centroide2: .float 10.0, 12.0, 14.0, 18.0    # Centroide 2: (10.0, 12.0, 14.0, 18.0)
centroide3: .float 5.0, 7.0, 9.0, 11.0       # Centroide 3: (5.0, 7.0, 9.0, 11.0)
centroide4: .float 20.0, 22.0, 24.0, 26.0    # Centroide 4: (20.0, 22.0, 24.0, 26.0)
zero: .float 0.0

# Variável para armazenar a menor distância
menor_distancia: .float 0.0

# Variável para armazenar o índice do centroide mais próximo
indice_centroide_mais_proximo: .word 0

# Variável para armazenar o valor da distância do centroide mais próximo
valor_distancia_mais_proxima: .float 0.0

.text
.globl main

main:
    # Carregue o endereço do ponto na memória
    la $t0, ponto

    # Inicialize um registrador para o índice do centroide atual
    li $t2, 1  # Começamos com o centroide 1

calcula_distancia:
    # Carregue o endereço do centroide atual na memória
    la $t1, centroide1  # Suponha que começamos com o centroide 1
    beq $t2, 2, centroide2
    beq $t2, 3, centroide3
    beq $t2, 4, centroide4

    # Inicialize a soma das diferenças ao quadrado
    lwc1 $f0, zero  # $f0 armazena a soma como ponto flutuante

    # Calcule a distância euclidiana
    li $t3, 4  # Número de dimensões
    loop:
        lwc1 $f2, 0($t0)  # Carregue a coordenada do ponto como ponto flutuante
        lwc1 $f4, 0($t1)  # Carregue a coordenada do centroide como ponto flutuante
        sub.s $f2, $f2, $f4  # Calcule a diferença
        mul.s $f2, $f2, $f2  # Eleve ao quadrado
        add.s $f0, $f0, $f2  # Adicione à soma
        addi $t0, $t0, 4    # Avance para a próxima coordenada do ponto
        addi $t1, $t1, 4    # Avance para a próxima coordenada do centroide
        addi $t3, $t3, -1   # Decrementa o contador de dimensões
        bnez $t3, loop      # Repita até processar todas as dimensões

    # Calcule a raiz quadrada da soma
    sqrt.s $f0, $f0

    # Compare com a menor distância atual
    lwc1 $f6, menor_distancia  # Carregue a menor distância atual
    c.lt.s $f0, $f6  # Compare a distância atual com a menor distância
    bc1t update_menor_distancia  # Se for menor, atualize a menor distância, o índice e o valor da distância do centroide mais próximo

    # Próximo centroide
    addi $t2, $t2, 1
    bnez $t2, calcula_distancia

    # Carregue o índice e o valor da distância do centroide mais próximo após o último cálculo
update_menor_distancia:
    sw $t7, indice_centroide_mais_proximo  # Defina o índice do centroide mais próximo
    s.s $f0, valor_distancia_mais_proxima  # Defina o valor da distância do centroide mais próximo

    # Terminar o programa
    li $v0, 10  # Código de saída do programa
    syscall
