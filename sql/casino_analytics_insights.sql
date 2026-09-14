-- PREGUNTA 1
-- ¿Qué proveedor combina mayor variedad de juegos,
-- presencia en casinos y un RTP competitivo?

SELECT
    provider,
    COUNT(DISTINCT game) AS juegos_distintos,
    COUNT(DISTINCT casino) AS casinos_presentes,
    ROUND(AVG(rtp), 2) AS rtp_promedio
FROM casino_games_clean
GROUP BY provider
ORDER BY casinos_presentes DESC, juegos_distintos DESC
LIMIT 10;

-- OBJETIVO DE NEGOCIO:
-- Identificar qué proveedores ofrecen una propuesta más sólida,
-- combinando variedad de juegos, presencia en casinos
-- y un RTP promedio competitivo.

-- ¿PARA QUÉ SIRVE?
-- Permite detectar qué proveedores aportan mayor cobertura
-- y diversidad de catálogo sin perder atractivo para el jugador.
-- Esto puede ayudar a priorizar proveedores dentro de la oferta del casino.

-- INSIGHT 1:
-- Nolimit City se destaca por ofrecer la mayor variedad de juegos
-- entre los proveedores analizados, con 5.731 juegos distintos,
-- presencia en los 85 casinos y un RTP promedio de 96,22%.

-- PREGUNTA 2
-- ¿Qué tipo de juego ofrece el mejor equilibrio
-- entre RTP, premio máximo y multiplicador?

SELECT
    game_type,
    COUNT(DISTINCT game) AS juegos_distintos,
    ROUND(AVG(rtp), 2) AS rtp_promedio,
    ROUND(AVG(max_win), 2) AS premio_maximo_promedio,
    ROUND(AVG(max_multiplier), 2) AS multiplicador_promedio
FROM casino_games_clean
GROUP BY game_type
ORDER BY rtp_promedio DESC;

-- OBJETIVO DE NEGOCIO:
-- Comparar los distintos tipos de juego para identificar
-- cómo se comportan en términos de RTP, potencial de premio
-- y multiplicador, considerando también la variedad del catálogo.

-- ¿PARA QUÉ SIRVE?
-- Permite entender qué tipos de juego pueden resultar más atractivos
-- según diferentes objetivos: mayor retorno al jugador,
-- mayor potencial de premio o mayor diversidad de oferta.
-- Esto puede ayudar a diseñar un catálogo más equilibrado.

-- INSIGHT 2:
-- Poker presenta el RTP promedio más alto (98,62%),
-- mientras que los juegos Live se destacan por un potencial
-- de premio y multiplicador considerablemente superior.
-- Por su parte, Slots concentra la mayor variedad de catálogo,
-- con 32.482 juegos distintos.
--
-- Esto muestra que no existe un único tipo de juego superior:
-- cada categoría aporta un valor diferente dentro de la oferta.

-- PREGUNTA 3
-- ¿En los juegos de tipo Slot, Free Spins y Bonus Buy
-- están asociados a mejores métricas de retorno y potencial de premio?

SELECT
    free_spins_feature,
    bonus_buy_available,
    COUNT(DISTINCT game) AS juegos_distintos,
    ROUND(AVG(rtp), 2) AS rtp_promedio,
    ROUND(AVG(max_win), 2) AS premio_maximo_promedio,
    ROUND(AVG(max_multiplier), 2) AS multiplicador_promedio
FROM casino_games_clean
WHERE game_type = 'slot'
GROUP BY free_spins_feature, bonus_buy_available
ORDER BY rtp_promedio DESC;

-- OBJETIVO DE NEGOCIO:
-- Evaluar si las funciones Free Spins y Bonus Buy
-- están asociadas a mejores métricas en los juegos Slot.

-- ¿PARA QUÉ SIRVE?
-- Permite determinar si estas funcionalidades aportan
-- una mejora medible en retorno, premio máximo o multiplicador,
-- o si su valor es principalmente comercial y de experiencia de usuario.

-- INSIGHT 3:
-- Dentro de los juegos Slot, las diferencias de RTP,
-- premio máximo y multiplicador entre las distintas combinaciones
-- de Free Spins y Bonus Buy son mínimas.
--
-- Esto sugiere que estas funciones no garantizan mejores métricas
-- matemáticas del juego y podrían aportar valor principalmente
-- desde la experiencia y el atractivo comercial.

-- PREGUNTA 4
-- ¿Qué características tienen los juegos con mayor alcance internacional?

SELECT
    game,
    provider,
    game_type,
    mobile_compatible,
    
    1 + LENGTH(country_availability) 
      - LENGTH(REPLACE(country_availability, '|', '')) AS cantidad_paises,
      
    1 + LENGTH(currency)
      - LENGTH(REPLACE(currency, '|', '')) AS cantidad_monedas,
      
    1 + LENGTH(languages)
      - LENGTH(REPLACE(languages, '|', '')) AS cantidad_idiomas,
      
    ROUND(rtp, 2) AS rtp

FROM casino_games_clean

ORDER BY
    cantidad_paises DESC,
    cantidad_idiomas DESC,
    cantidad_monedas DESC

LIMIT 20;

-- OBJETIVO DE NEGOCIO:
-- Identificar qué características comparten los juegos
-- con mayor alcance internacional.

-- ¿PARA QUÉ SIRVE?
-- Permite detectar qué atributos favorecen una mayor cobertura
-- en distintos mercados, considerando países, monedas,
-- idiomas y compatibilidad mobile.
-- Esto puede ayudar a priorizar juegos con mayor potencial
-- de distribución internacional.

-- INSIGHT 4:
-- Los juegos con mayor alcance del dataset llegan hasta 56 países,
-- admiten 8 monedas y ofrecen soporte para 12 idiomas.
-- Además, los principales juegos del ranking son compatibles con mobile.
--
-- El RTP varía considerablemente entre estos juegos,
-- por lo que una mayor cobertura internacional no parece depender
-- exclusivamente de ofrecer un retorno más alto al jugador.

-- PREGUNTA 5
-- ¿Qué combinación de volatilidad ofrece el mejor equilibrio
-- entre RTP, premio máximo y multiplicador?

SELECT
    volatility,
    COUNT(DISTINCT game) AS juegos_distintos,
    ROUND(AVG(rtp), 2) AS rtp_promedio,
    ROUND(AVG(max_win), 2) AS premio_maximo_promedio,
    ROUND(AVG(max_multiplier), 2) AS multiplicador_promedio
FROM casino_games_clean
GROUP BY volatility
ORDER BY rtp_promedio DESC;

-- OBJETIVO DE NEGOCIO:
-- Analizar cómo cambia el comportamiento de los juegos
-- según su nivel de volatilidad.

-- ¿PARA QUÉ SIRVE?
-- Permite entender qué perfil de volatilidad ofrece
-- un mejor equilibrio entre retorno al jugador,
-- potencial de premio y multiplicador.
-- Esto puede ayudar a segmentar el catálogo según
-- distintos perfiles de jugador.

-- INSIGHT 5:
-- En este dataset, los juegos de volatilidad Low presentan
-- el RTP promedio más alto (96,60%) y también lideran
-- en premio máximo y multiplicador promedio.
--
-- Esto indica que, dentro de los datos analizados,
-- una mayor volatilidad no está asociada necesariamente
-- con un mayor potencial de premio.

-- PREGUNTA 6
-- ¿Qué juegos deberían priorizarse según una combinación
-- de RTP, alcance, compatibilidad mobile y potencial de premio?

SELECT
    game,
    provider,
    game_type,
    rtp,
    max_win,
    max_multiplier,
    mobile_compatible,

    1 + LENGTH(country_availability)
      - LENGTH(REPLACE(country_availability, '|', '')) AS cantidad_paises,

    CASE
        WHEN rtp >= 97 THEN 3
        WHEN rtp >= 95 THEN 2
        ELSE 1
    END
    +
    CASE
        WHEN mobile_compatible = 'True' THEN 2
        ELSE 0
    END
    +
    CASE
        WHEN (1 + LENGTH(country_availability)
             - LENGTH(REPLACE(country_availability, '|', ''))) >= 40 THEN 3
        WHEN (1 + LENGTH(country_availability)
             - LENGTH(REPLACE(country_availability, '|', ''))) >= 20 THEN 2
        ELSE 1
    END
    +
    CASE
        WHEN max_multiplier >= 5000 THEN 2
        WHEN max_multiplier >= 1000 THEN 1
        ELSE 0
    END
    AS score_prioridad

FROM casino_games_clean

ORDER BY score_prioridad DESC, rtp DESC
LIMIT 20;

-- OBJETIVO DE NEGOCIO:
-- Crear un criterio automático de priorización que permita
-- identificar rápidamente los juegos con características
-- consideradas estratégicas para el catálogo.

-- ¿PARA QUÉ SIRVE?
-- Reduce la revisión manual de grandes volúmenes de información
-- y permite ordenar los juegos según variables como RTP,
-- alcance internacional, compatibilidad mobile y multiplicador.
-- El modelo puede ajustarse cambiando los criterios y pesos
-- según las prioridades del negocio.

-- INSIGHT 6:
-- El modelo permitió identificar automáticamente un grupo
-- de juegos con score máximo de prioridad.
-- Los primeros candidatos combinan RTP de 99,5%,
-- compatibilidad mobile, presencia en 56 países
-- y multiplicadores elevados.

-- El score funciona como una herramienta de apoyo a la decisión:
-- no determina por sí solo qué juego incorporar,
-- sino que reduce el universo de análisis y permite
-- enfocar la revisión en los candidatos más relevantes.

-- CLASIFICACIÓN AUTOMÁTICA DE PRIORIDAD

SELECT
    game,
    provider,
    game_type,
    rtp,
    max_win,
    max_multiplier,
    mobile_compatible,

    1 + LENGTH(country_availability)
      - LENGTH(REPLACE(country_availability, '|', '')) AS cantidad_paises,

    CASE
        WHEN rtp >= 97 THEN 3
        WHEN rtp >= 95 THEN 2
        ELSE 1
    END
    +
    CASE
        WHEN mobile_compatible = 'True' THEN 2
        ELSE 0
    END
    +
    CASE
        WHEN (1 + LENGTH(country_availability)
             - LENGTH(REPLACE(country_availability, '|', ''))) >= 40 THEN 3
        WHEN (1 + LENGTH(country_availability)
             - LENGTH(REPLACE(country_availability, '|', ''))) >= 20 THEN 2
        ELSE 1
    END
    +
    CASE
        WHEN max_multiplier >= 5000 THEN 2
        WHEN max_multiplier >= 1000 THEN 1
        ELSE 0
    END AS score_prioridad,

    CASE
        WHEN (
            CASE WHEN rtp >= 97 THEN 3
                 WHEN rtp >= 95 THEN 2
                 ELSE 1 END
            +
            CASE WHEN mobile_compatible = 'True' THEN 2 ELSE 0 END
            +
            CASE
                WHEN (1 + LENGTH(country_availability)
                     - LENGTH(REPLACE(country_availability, '|', ''))) >= 40 THEN 3
                WHEN (1 + LENGTH(country_availability)
                     - LENGTH(REPLACE(country_availability, '|', ''))) >= 20 THEN 2
                ELSE 1
            END
            +
            CASE
                WHEN max_multiplier >= 5000 THEN 2
                WHEN max_multiplier >= 1000 THEN 1
                ELSE 0
            END
        ) >= 8 THEN 'ALTA PRIORIDAD'

        WHEN (
            CASE WHEN rtp >= 97 THEN 3
                 WHEN rtp >= 95 THEN 2
                 ELSE 1 END
            +
            CASE WHEN mobile_compatible = 'True' THEN 2 ELSE 0 END
            +
            CASE
                WHEN (1 + LENGTH(country_availability)
                     - LENGTH(REPLACE(country_availability, '|', ''))) >= 40 THEN 3
                WHEN (1 + LENGTH(country_availability)
                     - LENGTH(REPLACE(country_availability, '|', ''))) >= 20 THEN 2
                ELSE 1
            END
            +
            CASE
                WHEN max_multiplier >= 5000 THEN 2
                WHEN max_multiplier >= 1000 THEN 1
                ELSE 0
            END
        ) >= 5 THEN 'PRIORIDAD MEDIA'

        ELSE 'REVISAR'
    END AS nivel_prioridad

FROM casino_games_clean

ORDER BY score_prioridad DESC, rtp DESC
LIMIT 50;

-- OBJETIVO DE NEGOCIO:
-- Automatizar la clasificación de juegos según criterios estratégicos,
-- reduciendo la necesidad de revisar manualmente grandes volúmenes de datos.

-- ¿PARA QUÉ SIRVE?
-- Permite transformar múltiples variables en una prioridad simple
-- y accionable: ALTA PRIORIDAD, PRIORIDAD MEDIA o REVISAR.
-- Esto facilita la selección inicial de juegos para análisis comercial,
-- incorporación al catálogo o revisión posterior.

-- INSIGHT FINAL:
-- La clasificación automática permite reducir un universo de
-- 1.200.000 registros a grupos priorizados según reglas de negocio.
-- Los juegos con mayor score combinan RTP elevado, amplia cobertura
-- internacional, compatibilidad mobile y alto multiplicador.

-- La herramienta funciona como apoyo a la decisión:
-- automatiza el primer filtro y permite que el equipo concentre
-- la revisión manual en los candidatos más relevantes.