# mantenimiento-aeronaves

Sistema de base de datos desarrollado en PostgreSQL para gestionar el mantenimiento de aeronaves.

## Descripción

El proyecto permite registrar aeronaves, órdenes de trabajo, actividades de mantenimiento, técnicos, fallas, componentes y el historial de movimientos de los componentes.

## Tecnologías utilizadas

- PostgreSQL
- pgAdmin
- SQL

## Tablas principales

- aeronave
- orden_trabajo
- actividad
- tecnico
- actividad_tecnico
- falla
- componente
- historial_componente

## Funcionalidades

- Registro de aeronaves.
- Gestión de órdenes de mantenimiento.
- Registro de actividades realizadas.
- Asignación de técnicos a actividades.
- Registro de fallas detectadas.
- Control de componentes.
- Historial de instalación, retiro y reemplazo de componentes.
- Consultas SQL para obtener información relevante del mantenimiento.

## Archivos

- `mantenimiento_aeronaves.sql`: script completo de la base de datos.
- `mantenimiento_aeronaves.pgerd`: diagrama ER generado en pgAdmin.
