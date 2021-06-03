/*
Crie uma stored procedure chamada QueryEmp que aceita como parâmetro de entrada um employee_id e
como parâmetro de saída um registro cuja estrutura é igual à estrutura da tabela EMPLOYEES.

A procedure deve realizar uma consulta à tabela EMPLOYEES para carregar o parâmetro de saída de acordo o employee_id fornecido.
Em seguida, crie uma stored procedure GetEmp que chama a procedure QueryEmp fornecendo como employee_id o valor 101.
A procedure GetEmp deve imprimir na tela o sobrenome (last_name) do empregado selecionado por QueryEmp. Execute GetEmp a partir de um bloco anônimo.
Mostre o código-fonte e o resultado da execução.

Obs.: Não use procedures internas.
*/
