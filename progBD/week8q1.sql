/*
Crie um bloco PL/SQL anônimo que recupera o e-mail de um empregado cujo valor do código (employee_id) deve ser fornecido por intermédio de uma variável local numérica.
Imprima o e-mail recuperado. Caso nenhuma email seja recuperado, o bloco deve tratar o erro imprimindo a mensagem "Empregado inexistente".
Caso seja atribuído um valor não numérico à variável local, o bloco também deve tratar o erro imprimindo a mensagem "Código inválido".
NÃO use o handler OTHERS. Execute o bloco PL/SQL três vezes atribuindo os seguintes valores à variável local em cada execução: 101, 999 e '101a'.
Copie e cole o código produzido, bem como o resultado das três execuções. Faça apenas o que está sendo pedido.
*/

-- Código 1:

DECLARE
    e_email OEHR_EMPLOYEES.EMAIL%TYPE;
    variavel_local INTEGER;
BEGIN
    variavel_local := 101;
    SELECT EMAIL
    INTO e_email
    FROM OEHR_EMPLOYEES e
    WHERE e.EMPLOYEE_ID = variavel_local;
    dbms_output.put_line(e_email);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('Empregado inexistente');
    WHEN INVALID_NUMBER THEN
        dbms_output.put_line('Código inválido');
END;

-- Código 2:

DECLARE
    e_email OEHR_EMPLOYEES.EMAIL%TYPE;
    variavel_local INTEGER;
BEGIN
    variavel_local := 999;
    SELECT EMAIL
    INTO e_email
    FROM OEHR_EMPLOYEES e
    WHERE e.EMPLOYEE_ID = variavel_local;
    dbms_output.put_line(e_email);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('Empregado inexistente');
    WHEN INVALID_NUMBER THEN
        dbms_output.put_line('Código inválido');
END;

-- Código 3:

DECLARE
    e_email OEHR_EMPLOYEES.EMAIL%TYPE;
    variavel_local VARCHAR(4);
BEGIN
    variavel_local := '101a';
    SELECT EMAIL
    INTO e_email
    FROM OEHR_EMPLOYEES e
    WHERE e.EMPLOYEE_ID = variavel_local;
    dbms_output.put_line(e_email);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('Empregado inexistente');
    WHEN INVALID_NUMBER THEN
        dbms_output.put_line('Código inválido');
END;
