/*
Crie um bloco PL/SQL anônimo que identifica o empregado que começou a trabalhar há mais tempo na empresa.
Em seguida, imprima na tela a situação do empregado em relação à aposentadoria.

Por exemplo, se ele já trabalhou mais de 25 anos, imprima "Apto"; "Inapto", caso contrário.

 Copie e cole o código-fonte e o resultado da execução do bloco.
*/

DECLARE
    data_atual DATE;
    mais_antigo DATE;
    id_empregado NUMBER(6,0);
    situacao VARCHAR2(6);
BEGIN
    data_atual := SYSDATE;
    SELECT min(HIRE_DATE)
    INTO mais_antigo
    FROM OEHR_EMPLOYEES;
    
    SELECT EMPLOYEE_ID
    INTO id_empregado
    FROM OEHR_EMPLOYEES
    WHERE mais_antigo = HIRE_DATE;

    IF ((months_between(data_atual, mais_antigo) / 12) > 25) THEN
        situacao := 'Apto';
    ELSE
        situacao := 'Inapto';
    END IF;

    dbms_output.put_line(id_empregado);
    dbms_output.put_line(situacao);
END;
