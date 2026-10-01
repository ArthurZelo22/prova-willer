CREATE TABLE aeronaves (
	id serial PRIMARY KEY,
	modelo VARCHAR(100) NOT NULL,
	codigo_cauda VARCHAR(10) NOT NULL UNIQUE,
	capacidade INT CHECK (capacidade > 0) NOT NULL
)

CREATE TABLE pilotos (
	id serial PRIMARY KEY,
	nome VARCHAR(100) NOT NULL,
	codigo_anac VARCHAR(10) NOT NULL UNIQUE,
	horas_voo INT DEFAULT 0 CHECK(horas_voo >= 0)
)

CREATE TABLE voos (
	id serial PRIMARY KEY,
	aeronave_id INT REFERENCES aeronaves(id),
	piloto_id INT REFERENCES pilotos(id),
	numero_voo VARCHAR (50) NOT NULL,
	origem VARCHAR (100) NOT NULL,
	destino VARCHAR (100) NOT NULL,
	data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	status VARCHAR(50) CHECK(status in('Agendado', 'Em Voo', 'Concluido', 'Cancelado')) DEFAULT 'Agendado'
)

CREATE TABLE passageiros (
	id serial PRIMARY KEY,
	nome VARCHAR(100) NOT NULL,
	cpf VARCHAR(11) NOT NULL UNIQUE,
	email VARCHAR(100) NOT NULL UNIQUE
)

CREATE TABLE passagens (
	id serial PRIMARY KEY,
	voo_id INT REFERENCES voos(id),
	passageiro_id INT REFERENCES passageiros(id),
	assento VARCHAR(4) NOT NULL,
	classe VARCHAR(50) CHECK(classe in('Economica', 'Executiva')) DEFAULT 'Economica',
	valor DECIMAL(10,2) CHECK(valor > 0) NOT NULL
)

----------------------------------------

INSERT INTO aeronaves (modelo, codigo_cauda, capacidade ) VALUES
('amarelo', 'AAA-111', 100 ),
('vermelho', 'BBB-222', 200 ),
('laranja', 'CCC-333', 300 ),
('azul', 'DDD-444', 400 ),
('rosa', 'FFF-555', 500 )    

INSERT INTO pilotos(nome, codigo_anac, horas_voo) VALUES
('Arthur', '111111', '11'),
('Bruno', '222222', '22'),
('Vieira', '333333', '33'),
('Ravi', '444444', '44'),
('Joaquin', '555555', '55')

INSERT INTO passageiros(nome, cpf, email) VALUES
('Marco', '11111111111', 'marco@gmail'),
('Vitor', '22222222222', 'vitor@gmail'),
('Enzo', '33333333333', 'enzo@gmail'),
('Eduardo', '44444444444', 'eduardo@gmail'),
('Renato', '55555555555', 'renato@gmail')

INSERT INTO voos (aeronave_id, piloto_id, numero_voo, origem, destino, status ) VALUES
(1, 1, '111', 'Santa Catarina', 'Paris', 'Agendado' ),
(2, 2, '222', 'Rio de Janeiro', 'Holanda', 'Em Voo' ),
(3, 3, '333', 'São Paulo', 'Portugal', 'Concluido' ),
(4, 4, '444', 'Minas Gerais', 'Porto', 'Cancelado' ),
(5, 5, '555', 'Pará', 'Argentina', 'Agendado' )

INSERT INTO passagens (voo_id, passageiro_id, assento, classe, valor) VALUES
(1, 1, '1A', 'Economica', 111.00),
(2, 2, '2B', 'Executiva', 222.00),
(3, 3, '3C', 'Economica', 333.00),
(4, 4, '4D', 'Executiva', 444.00),
(5, 5, '5E', 'Economica', 555.00)

----------------------------------------------

Q1
SELECT
	v.numero_voo AS voo,
	v.origem,
	v.destino,
	a.modelo,
	p.nome AS piloto
FROM aeronaves a
JOIN voos v ON v.aeronave_id = a.id
JOIN pilotos p ON v.piloto_id = p.id
WHERE v.status IN ('Agendado', 'Voo')

Q2

SELECT 
    p.classe,
    SUM(p.valor) AS total_arrecadado 
FROM passagens p
GROUP BY p.classe

Q3
SELECT 
    pa.nome AS passageiro,
    voos.numero_voo,
    p.assento,
    p.valor
FROM passagens p
JOIN passageiros pa ON p.passageiro_id = pa.id
JOIN voos ON p.voo_id = voos.id
WHERE p.classe = 'Executiva' 
  AND p.valor > 800.00
  ORDER BY p.valor DESC;

----------------

VIEW 1
CREATE VIEW vw_painel_aeroporto AS
SELECT
	v.id,
	v.data_hora,
	v.origem,
	v.destino,
	a.modelo,
	a.codigo_cauda,
	v.status
FROM voos v
JOIN aeronaves a on v.aeronave_id = a.id

VIEW 2

