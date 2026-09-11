SELECT current_database();
CREATE TABLE aeronave (
    id_aeronave INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    matricula VARCHAR(20) NOT NULL,
    estado VARCHAR(20) NOT NULL
);

CREATE TABLE orden_trabajo (
    id_orden INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_aeronave INTEGER NOT NULL,
    fecha_apertura DATE NOT NULL,
    tipo_mantenimiento VARCHAR(30) NOT NULL,
    prioridad VARCHAR(20) NOT NULL,
    descripcion_problema VARCHAR(200) NOT NULL,
    estado VARCHAR(20) NOT NULL,
    autorizado_operacion BOOLEAN DEFAULT FALSE,

    FOREIGN KEY (id_aeronave)
        REFERENCES aeronave(id_aeronave)
);

CREATE TABLE actividad (
    id_actividad INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_orden INTEGER NOT NULL,
    descripcion VARCHAR(200) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE,
    resultado VARCHAR(100),

    FOREIGN KEY (id_orden)
        REFERENCES orden_trabajo(id_orden)
);

CREATE TABLE tecnico (
    id_tecnico INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    especialidad VARCHAR(50)
);

CREATE TABLE actividad_tecnico (
    id_actividad INTEGER NOT NULL,
    id_tecnico INTEGER NOT NULL,

    PRIMARY KEY (id_actividad, id_tecnico),

    FOREIGN KEY (id_actividad)
        REFERENCES actividad(id_actividad),

    FOREIGN KEY (id_tecnico)
        REFERENCES tecnico(id_tecnico)
);

CREATE TABLE falla (
    id_falla INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_orden INTEGER NOT NULL,
    descripcion VARCHAR(200),
    fecha_deteccion DATE,

    FOREIGN KEY (id_orden)
        REFERENCES orden_trabajo(id_orden)
);

CREATE TABLE componente (
    id_componente INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    numero_serie VARCHAR(50) NOT NULL
);

CREATE TABLE historial_componente (
    id_historial INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_componente INTEGER NOT NULL,
    id_actividad INTEGER NOT NULL,
    tipo_movimiento VARCHAR(30) NOT NULL,
    fecha_movimiento DATE NOT NULL,

    FOREIGN KEY (id_componente)
        REFERENCES componente(id_componente),

    FOREIGN KEY (id_actividad)
        REFERENCES actividad(id_actividad)
);
INSERT INTO aeronave (matricula, estado)
VALUES
('OB-2010', 'Operativa'),
('OB-2025', 'Mantenimiento'),
('OB-2038', 'Operativa'),
('OB-2050', 'Desactivada');

INSERT INTO orden_trabajo
(id_aeronave, fecha_apertura, tipo_mantenimiento, prioridad,
 descripcion_problema, estado, autorizado_operacion)
VALUES
(1, '2026-08-05', 'Preventivo', 'Baja',
 'Inspeccion general programada', 'Finalizada', TRUE),
(2, '2026-08-15', 'Correctivo', 'Alta',
 'Falla detectada en sistema hidraulico', 'En proceso', FALSE),
(3, '2026-08-22', 'Preventivo', 'Media',
 'Revision programada del motor', 'Finalizada', TRUE),
(2, '2026-09-02', 'Correctivo', 'Alta',
 'Falla en el tren de aterrizaje', 'En proceso', FALSE),
(4, '2026-09-08', 'Correctivo', 'Media',
 'Problema detectado en sistema electrico', 'Pendiente', FALSE);

INSERT INTO actividad
(id_orden, descripcion, fecha_inicio, fecha_fin, resultado)
VALUES
(1, 'Inspeccion general de motores', '2026-08-05', '2026-08-05',
 'Sin fallas relevantes'),
(1, 'Revision del sistema electrico', '2026-08-05', '2026-08-06',
 'Sistema operativo'),
(2, 'Revision del sistema hidraulico', '2026-08-15', NULL,
 'Se detecto fuga de fluido'),
(3, 'Inspeccion del motor principal', '2026-08-22', '2026-08-23',
 'Motor en buen estado'),
(4, 'Revision del tren de aterrizaje', '2026-09-02', NULL,
 'Desgaste en componente'),
(5, 'Pruebas electricas generales', '2026-09-08', NULL, NULL);

INSERT INTO tecnico (nombre, especialidad)
VALUES
('Carlos Mendoza', 'Motores'),
('Luis Ramirez', 'Sistema hidraulico'),
('Ana Torres', 'Sistema electrico'),
('Miguel Salazar', 'Tren de aterrizaje'),
('Diego Rojas', 'Mantenimiento general');

INSERT INTO actividad_tecnico (id_actividad, id_tecnico)
VALUES
(1, 1),
(1, 5),
(2, 3),
(3, 2),
(3, 5),
(4, 1),
(5, 4),
(5, 5),
(6, 3);

INSERT INTO falla (id_orden, descripcion, fecha_deteccion)
VALUES
(2, 'Fuga de fluido en el sistema hidraulico', '2026-08-15'),
(2, 'Baja presion en el sistema hidraulico', '2026-08-15'),
(4, 'Desgaste en mecanismo del tren de aterrizaje', '2026-09-02'),
(5, 'Falla en el cableado electrico', '2026-09-08');

INSERT INTO componente (nombre, numero_serie)
VALUES
('Bomba hidraulica', 'BH-1001'),
('Valvula de presion', 'VP-2002'),
('Cable electrico', 'CE-3003'),
('Amortiguador tren de aterrizaje', 'ATA-4004'),
('Filtro de combustible', 'FC-5005');

INSERT INTO historial_componente
(id_componente, id_actividad, tipo_movimiento, fecha_movimiento)
VALUES
(1, 3, 'Retiro', '2026-08-15'),
(2, 3, 'Reemplazo', '2026-08-15'),
(5, 4, 'Instalacion', '2026-08-22'),
(4, 5, 'Reemplazo', '2026-09-02'),
(3, 6, 'Retiro', '2026-09-08');

-- CONSULTA 1
-- Ordenes pendientes o en proceso
SELECT *
FROM orden_trabajo
WHERE estado = 'Pendiente'
   OR estado = 'En proceso';

-- CONSULTA 2
-- Ordenes de trabajo con la aeronave correspondiente
SELECT
    o.id_orden,
    a.matricula,
    o.tipo_mantenimiento,
    o.prioridad,
    o.estado
FROM orden_trabajo o
INNER JOIN aeronave a
    ON o.id_aeronave = a.id_aeronave;

-- CONSULTA 3
-- Fallas detectadas y aeronave afectada
SELECT
    f.id_falla,
    a.matricula,
    f.descripcion,
    f.fecha_deteccion
FROM falla f
INNER JOIN orden_trabajo o
    ON f.id_orden = o.id_orden
INNER JOIN aeronave a
    ON o.id_aeronave = a.id_aeronave;

-- CONSULTA 4
-- Tecnicos que participaron en cada actividad
SELECT
    a.id_actividad,
    a.descripcion AS actividad,
    t.nombre AS tecnico,
    t.especialidad
FROM actividad a
INNER JOIN actividad_tecnico atc
    ON a.id_actividad = atc.id_actividad
INNER JOIN tecnico t
    ON atc.id_tecnico = t.id_tecnico;

-- CONSULTA 5
-- Movimientos realizados sobre los componentes
SELECT
    c.nombre AS componente,
    c.numero_serie,
    h.tipo_movimiento,
    h.fecha_movimiento,
    a.descripcion AS actividad
FROM historial_componente h
INNER JOIN componente c
    ON h.id_componente = c.id_componente
INNER JOIN actividad a
    ON h.id_actividad = a.id_actividad;

-- CONSULTA 6
-- Cantidad de ordenes de trabajo por aeronave
SELECT
    a.matricula,
    COUNT(o.id_orden) AS total_ordenes
FROM aeronave a
INNER JOIN orden_trabajo o
    ON a.id_aeronave = o.id_aeronave
GROUP BY a.matricula;


-- CONSULTA 7
-- Ordenes de prioridad alta que aun no finalizaron
SELECT
    id_orden,
    id_aeronave,
    fecha_apertura,
    tipo_mantenimiento,
    prioridad,
    estado
FROM orden_trabajo
WHERE prioridad = 'Alta'
  AND estado <> 'Finalizada';


-- CONSULTA 8
-- Historial de mantenimiento de cada aeronave
SELECT
    a.matricula,
    o.id_orden,
    o.tipo_mantenimiento,
    ac.descripcion AS actividad,
    ac.fecha_inicio,
    ac.fecha_fin,
    ac.resultado
FROM aeronave a
INNER JOIN orden_trabajo o
    ON a.id_aeronave = o.id_aeronave
INNER JOIN actividad ac
    ON o.id_orden = ac.id_orden
ORDER BY a.matricula, ac.fecha_inicio;