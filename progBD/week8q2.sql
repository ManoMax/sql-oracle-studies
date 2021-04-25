/*
Crie um bloco PL/SQL que recupere o maior salário e a média salarial.
Se a diferença entre o maior salário e a média dos salários for menor que a constante 5000, imprima 'Dentro da lei';
caso contrário, dispare uma exceção definida pelo usuário e imprima 'Lei violada'. NÃO use o handler OTHERS.
Execute o bloco PL/SQL duas vezes atribuindo os seguintes valores à constante em cada execução: 15000 e 25000.
Copie e cole o código produzido, bem como o resultado das duas execuções. Faça apenas o que está sendo pedido.
*/

-- Código 1:

DECLARE
    max_salario OEHR_EMPLOYEES.SALARY%TYPE;
    avg_salario OEHR_EMPLOYEES.SALARY%TYPE;
    fora_da_lei EXCEPTION;
BEGIN
    SELECT AVG(SALARY), MAX(SALARY)
    INTO avg_salario, max_salario
    FROM OEHR_EMPLOYEES e;

    IF max_salario - avg_salario < 15000 THEN
        dbms_output.put_line('Dentro da lei');
    ELSE
        RAISE fora_da_lei;
    END IF;
EXCEPTION
    WHEN fora_da_lei THEN
        dbms_output.put_line('Lei violada');
END;

-- Código 2:

DECLARE
    max_salario OEHR_EMPLOYEES.SALARY%TYPE;
    avg_salario OEHR_EMPLOYEES.SALARY%TYPE;
    fora_da_lei EXCEPTION;
BEGIN
    SELECT AVG(SALARY), MAX(SALARY)
    INTO avg_salario, max_salario
    FROM OEHR_EMPLOYEES e;

    IF max_salario - avg_salario < 25000 THEN
        dbms_output.put_line('Dentro da lei');
    ELSE
        RAISE fora_da_lei;
    END IF;
EXCEPTION
    WHEN fora_da_lei THEN
        dbms_output.put_line('Lei violada');
END;
