/*
Elabore um bloco PL/SQL que compute a remuneração total (salário + salário * bônus). As variáveis salário anual e a porcentagem do bônus anual devem ser inicializadas na seção executável do bloco. O valor da porcentagem precisa ser convertido de um número inteiro para um decimal (por exemplo, 10 para 0.10). Execute o bloco PL/SQL. Copie e cole o código e o resultado.

Exemplo:

Salário anual: 50000

Percentual de bônus: 10

PL/SQL procedure successfully completed.
V_TOTAL
-------
55000
*/

DECLARE
    V_SUBTOTAL1 NUMBER(8,2);
    V_SUBTOTAL2 NUMBER(8,2);
    V_TOTAL NUMBER(8,2);
BEGIN
    SELECT SUM(e1.SALARY + e1.SALARY * e1.COMMISSION_PCT)
    INTO V_SUBTOTAL1
    FROM OEHR_EMPLOYEES e1
    WHERE e1.COMMISSION_PCT IS NOT NULL;

    SELECT SUM(e2.SALARY)
    INTO V_SUBTOTAL2
    FROM OEHR_EMPLOYEES e2
    WHERE e2.COMMISSION_PCT IS NULL;

    V_TOTAL := V_SUBTOTAL1 + V_SUBTOTAL2;
    
    dbms_output.put_line(V_TOTAL);
END;
