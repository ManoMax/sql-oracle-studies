/*
Crie um bloco PL/SQL anônimo que declare duas variáveis e imprima os resultados das variáveis na tela. Execute o bloco PL/SQL. Copie e cole o código e o resultado.

V_CHAR                             Character (variable length)

V_NUM                             Number

Atribua valores a essas variáveis do seguinte modo:

Variable              Value

--------                  -------------------------------------

V_CHAR              O literal a seguir: '42 é a resposta'
V_NUM              Os primeiros dois caracteres de V_CHAR
*/

DECLARE
    V_CHAR VARCHAR(20);
    V_NUM Number;
BEGIN
    V_CHAR := '42 é a resposta';
    V_NUM := TO_NUMBER(SUBSTR(V_CHAR, 0, 2));
    dbms_output.put_line(V_CHAR);
    dbms_output.put_line(V_NUM);
END;
