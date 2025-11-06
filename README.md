Debe realizar un fork de este repositorio para desarrollar y entregar su trabajo.  

---

## Ejercicio Practico para Dataops

Este reto tiene como objetivo evaluar la capacidad para diseñar e implementar un **ciclo completo de datos** que asegure:

1. **Calidad del software**, reflejada en la implementación de scripts robustos y probados para la gestión de metadatos.  
2. **Calidad y gobierno de datos**, con validaciones automáticas en dbt y registro de resultados en un catálogo central.  
3. **Trazabilidad completa**, desde la fuente hasta los indicadores finales, con **Dataplex** como punto de observabilidad.  
4. **Orquestación y control de calidad continua**, mediante prácticas de CI/CD orientadas a DataOps.

---

## 🗂️ Dataset y dominio del caso

El caso se basa en datos públicos de Google BigQuery:  
**`bigquery-public-data.thelook_ecommerce`**

Estas tablas simulan la operación de una tienda en línea y permiten modelar clientes, productos y ventas.  
El flujo debe cubrir desde la ingesta hasta la visualización analítica.

Tablas base:  
- `orders`  
- `order_items`  
- `users`  
- `products`

---

## 🧱 Capa Staging

La capa **staging** tiene como finalidad limpiar, estandarizar y preparar los datos para su análisis.  

### Requisitos:
- Estandarizar nombres y tipos de columnas.  
- Convertir fechas a formato `TIMESTAMP` y valores numéricos a `NUMERIC`.  
- Eliminar duplicados.  
- Validar relaciones referenciales entre tablas:
  - Cada orden debe tener un cliente (`user_id` en `users`).  
  - Cada artículo debe corresponder a un producto (`product_id` en `products`).  
  - Cada orden de `order_items` debe existir en `orders`.  

### Resultados esperados:
- Datos coherentes, limpios y con tipos consistentes.  
- Reporte de calidad de datos documentando:
  - Registros válidos y errores detectados.  
  - Relaciones validadas y resultados de integridad.  
  - Estado general de los **tests de dbt** para cada modelo de staging.

---

## 🏗️ Capa Mart

La capa **mart** consolida la información para el análisis de negocio.

### Modelos requeridos:
- `dim_customer`: catálogo único de clientes con país, género y fecha de registro.  
- `dim_product`: catálogo de productos con categoría y precios promedio.  
- `fact_order_items`: detalle de ventas, uniendo órdenes, artículos y productos.  
- `fct_daily_sales`: resumen diario de ventas y comportamiento del cliente.

### Métricas principales:
| Indicador | Definición |
|------------|------------|
| **Item Revenue** | Cantidad × Precio unitario |
| **Total Revenue** | Suma de ingresos diarios |
| **Orders Count** | Total de órdenes únicas |
| **Average Order Value (AOV)** | Revenue total ÷ Número de órdenes |
| **Revenue por País** | Ingreso agrupado por país |
| **Distribución por Género** | Porcentaje de ventas por género del cliente |

### Pruebas esperadas:
- not_null sobre order_id (todas las órdenes deben tener identificador).
- unique sobre order_id en stg_orders (no debe repetirse).
- relationships entre stg_order_items.order_id y stg_orders.order_id (cada artículo pertenece a una orden).
- accepted_values sobre stg_orders.status con valores válidos: 'Complete', 'Cancelled', 'Returned'.
- Verificar que`item_revenue = quantity * sale_price`.  
- Evaluación y documentación del resultado de los tests:  
  - Identificar modelos con fallas o reglas incumplidas.
	- Describir el tipo de error (integridad, dominio o negocio).
	- Registrar el porcentaje global de cumplimiento (Data Quality Score) como parte de los metadatos del modelo.

---

## 🗃️ Gobierno y Metadatos (Dataplex)

La capa de **gobierno** debe centralizar la información técnica y de negocio de todo el flujo de datos.

### Requisitos:
- Publicar en Dataplex, si no se cuenta con acceso a Dataplex, podrá entregar los metadatos en formato JSON/YAML:
  - Modelos de la capa staging y mart.  
  - Estado de los **tests de dbt** .  
- Incluir metadatos clave:
  - Propietario, dominio, sensibilidad, dataset y fuente original.  
  - Última actualización (`last_update`) y estado del test dbt (`passed`, `failed`).  
  - Puntaje de calidad global (DQ Score).  
- Representar relaciones:
  - Fuente → Staging → Mart → Semántica → Dashboard.  

El objetivo es que **Dataplex refleje visualmente la trazabilidad completa**, permitiendo observar:
- Qué modelos tienen relacion o dependencia.  
- Qué tests de dbt están asociados y cuál fue su resultado.  
- Qué equipos o personas son responsables de cada objeto.

---

## 💻 Calidad del Software

El reto incluye la evaluación de la calidad **exclusivo para scripts de metadatos** desarrollados para alimentar Dataplex.

### Aspectos a evaluar:
- **Estructura modular:** el código debe estar separado en módulos para lectura, procesamiento y publicación de metadatos.  
- **Pruebas unitarias:** todos los componentes deben contar con pruebas que validen el comportamiento esperado.  
- **Cobertura mínima:** se espera una cobertura de pruebas **superior al 85 %** en el módulo de metadatos.  
- **Linting y convenciones:** se aplican normas PEP8 y herramientas de validación de estilo.  
- **Idempotencia:** las ejecuciones repetidas no deben duplicar ni alterar datos existentes.  
- **Errores controlados:** los fallos deben ser manejados con mensajes claros y no interrumpir la ejecución total del flujo.

---

## 🔁 CI/CD orientado a DataOps

1) Pipeline de Software (módulo de metadatos)
	•	Alcance: código de metadata_loader (parsers, normalizadores, publicadores a Dataplex).  
  •	Linting & estilo: cumplimiento de convenciones (PEP8/estilo definido).  
  •	Pruebas unitarias: cobertura mínima ≥ 85% del módulo.  
  •	Contratos de entrada/salida: validación estructural de metadatos (entries, lineage, estados de tests).  
  •	Idempotencia básica: dos ejecuciones consecutivas con la misma entrada producen la misma salida (sin duplicados).  
  •	Artefactos esperados: reporte de pruebas, reporte de cobertura y resumen de metadatos validados.  
  •	Criterio de aprobación (gate): el pipeline falla si la cobertura está por debajo del umbral, si hay pruebas unitarias fallidas o si la validación de contratos de metadatos no es satisfactoria.  

2) Pipeline de Datos (dbt)
	•	Alcance: modelos stg_*, dim_*, fact_*, fct_* y sus tests de datos en dbt.
	•	Pruebas de datos: not_null, unique, relationships, accepted_values y pruebas de negocio (p. ej., item_revenue = quantity * sale_price).
	•	Contratos y documentación: tipos, descripciones y ownership declarados en schema.yml.
	•	Publicación de calidad: registrar como metadatos el estado de cada test (passed/failed), porcentaje de cumplimiento (Data Quality Score) y última ejecución.
	•	Criterio de aprobación (gate): el pipeline falla si existe cualquier test de datos fallido en los modelos obligatorios.
	•	(Opcional) Permitir advertencias no bloqueantes para pruebas marcadas como informativas, siempre que estén documentadas.
	•	Artefactos esperados: resultados de pruebas, resumen de calidad por modelo y actualización de metadatos (incluyendo lineage) visibles en Dataplex.  


## 📦 Entregables
- Repositorio (GitHub/Bitbucket/GitLab) con todo los artefactos necesarios para la implementacion del ejercicio.

## 🧮 Criterios de Evaluación

| Dimensión | Ponderación | Descripción |
|------------|-------------|--------------|
| 🧠 **Calidad técnica del código (modularidad, pruebas, cobertura)** | **30%** | Revisión de código del módulo `metadata_loader`. |
| 🧱 **Implementación de modelos y pruebas en dbt** | **30%** | Estructura, tests y documentación del proyecto `dbt`. |
| 🗃️ **Gobierno y trazabilidad (Dataplex o YAML)** | **25%** | Correcta representación de metadatos, lineage y estados de calidad. |
| 🔁 **CI/CD y reproducibilidad** | **15%** | Pipelines funcionales, gates de validación y reportes generados. |
