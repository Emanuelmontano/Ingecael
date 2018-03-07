DROP VIEW MITHRA_ADMINIS2.M06V_IOR_OTROS_COBROS;

/* Formatted on 2017/10/17 15:57 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW mithra_adminis2.m06v_ior_otros_cobros (regs,
                                                                    id_cobro,
                                                                    tipo_negocio,
                                                                    negocio,
                                                                    empresa,
                                                                    id_comerc,
                                                                    comercializador,
                                                                    fecha_registro,
                                                                    periodo_facturacion,
                                                                    obs_otros_cobros,
                                                                    id_concepto,
                                                                    concepto,
                                                                    cantidad,
                                                                    valor_sin_iva,
                                                                    porcentaje_iva,
                                                                    valor_iva,
                                                                    valor_total,
                                                                    obs_concepto,
                                                                    facturacion
                                                                   )
AS
   SELECT   ROWNUM regs, m.id_cobro, m.tipo_negocio, n.nombre_negocio negocio,
            m.id_empresa empresa, m.id_comerc, a.abreviatura comercializador,
            m.fecha_registro, m.periodo_factura periodo_facturacion,
            m.observaciones obs_otros_cobros, d.id_concepto, c.concepto,
            d.cantidad, d.valor_sin_iva, d.porcentaje_iva, d.valor_iva,
            ROUND (NVL (d.valor_con_iva, d.valor_sin_iva)) valor_total,
            d.observaciones obs_concepto,
            CASE
               WHEN m.tipo_negocio = 8
                  THEN DECODE ((SELECT COUNT (*)
                                  FROM m06_ior_factura_sdl f
                                 WHERE f.agente_empresa = m.id_comerc
                                   AND f.periodo = m.periodo_factura
                                   AND f.estado = 'Abierta'
                                   AND f.empresa = m.id_empresa),
                               0, 'Sin Facturar',
                               'Facturado'
                              )
               WHEN m.tipo_negocio = 9
                  THEN DECODE ((SELECT COUNT (*)
                                  FROM m06_ior_factura_stn f
                                 WHERE f.agente = m.id_comerc
                                   AND f.periodo = m.periodo_factura
                                   AND f.estado = 'A'
                                   AND f.empresa = m.id_empresa),
                               0, 'Sin Facturar',
                               'Facturado'
                              )
               ELSE 'Sin Estado'
            END facturacion
       FROM m06_ior_otros_cobros m,
            m06_ior_otros_cobros_det d,
            m06_apr_tipo_negocio n,
            m06_agentes_mem a,
            m06_ior_conceptos_facturacion c
      WHERE m.id_cobro = d.id_cobro
        AND n.ID = m.tipo_negocio
        AND a.ID = m.id_comerc
        AND c.ID = d.id_concepto
   ORDER BY m.id_cobro DESC;
COMMENT ON TABLE MITHRA_ADMINIS2.M06V_IOR_OTROS_COBROS IS 'Vista Otros cobros Ingresos OR';


GRANT SELECT ON MITHRA_ADMINIS2.M06V_IOR_OTROS_COBROS TO CONSULTA_MITHRA;

GRANT SELECT ON MITHRA_ADMINIS2.M06V_IOR_OTROS_COBROS TO ROL_MITHRA;

