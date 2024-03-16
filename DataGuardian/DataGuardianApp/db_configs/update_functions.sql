--FUNCTION 1: trouver_caracteres_speciaux_et_ligne3
CREATE OR REPLACE FUNCTION trouver_caracteres_speciaux_et_ligne3(p_table_name VARCHAR, p_column_name VARCHAR, p_id_column_name VARCHAR) 
RETURNS TABLE(ligne_id VARCHAR, special_characters VARCHAR, correction_code VARCHAR) AS
$$
DECLARE
    v_special_characters VARCHAR(1000) := '';
    v_sql_query VARCHAR(1000);
    v_cursor REFCURSOR;
    v_column_value VARCHAR(4000);
    v_correction_code VARCHAR(100) := 'trouver_caracteres_speciaux_et_ligne3::'; -- Code de correction statique
BEGIN
    -- Construction de la requête SQL dynamique pour sélectionner les IDs et les valeurs de la colonne spécifiée 
    v_sql_query := 'SELECT ' || p_id_column_name || ', ' || p_column_name || ' FROM ' || p_table_name;
    v_correction_code := v_correction_code || p_table_name || '::' || p_column_name || '::' || p_id_column_name;

    -- Ouverture du curseur pour exécuter la requête SQL
    OPEN v_cursor FOR EXECUTE v_sql_query;

    LOOP
        -- Récupération de l'ID de la ligne et des valeurs de la colonne une par une
        FETCH v_cursor INTO ligne_id, v_column_value; -- Utilisez directement la variable de sortie 'ligne_id'
        EXIT WHEN NOT FOUND;

        -- Traitement des valeurs NULL
        v_column_value := COALESCE(v_column_value, '');

        -- Extraction des caractères spéciaux
        v_special_characters := REGEXP_REPLACE(v_column_value, '[^[:punct:]]', '', 'g');

        -- Si des caractères spéciaux sont trouvés, assignez les valeurs aux colonnes de sortie et utilisez RETURN NEXT sans paramètres
        IF v_special_characters != '' THEN
            special_characters := v_special_characters; -- Assignez à la variable de sortie 'special_characters'
            correction_code := v_correction_code; -- Assignez à la variable de sortie 'correction_code'
            RETURN NEXT;
        END IF;
    END LOOP;

    -- Fermeture du curseur
    CLOSE v_cursor;

    RETURN;
EXCEPTION
    -- Gestion des exceptions
    WHEN OTHERS THEN
        -- En cas d'erreur, initialisez les variables de sortie à des valeurs par défaut et utilisez RETURN NEXT
        ligne_id := '';
        special_characters := '';
        correction_code := '';
        RETURN NEXT;
END;
$$ LANGUAGE plpgsql;

--VUES
-- 
CREATE OR REPLACE VIEW vue_caracteres_speciaux AS
SELECT * FROM trouver_caracteres_speciaux_et_ligne3(
    'public.clients_20240201094337',  -- Remplacez ceci par le nom réel de votre table
    'column_2',  -- Remplacez ceci par le nom réel de la colonne à analyser
    'column_0'  -- Remplacez ceci par le nom réel de la colonne d'ID
);
SELECT * FROM vue_caracteres_speciaux;


-- FUNCTION 2:
CREATE OR REPLACE FUNCTION count_outliers2(NOMTAB VARCHAR, Nom_COL VARCHAR, z_threshold NUMERIC) 
RETURNS TABLE (Nom_Colonne VARCHAR, valeur_Outlier NUMERIC) AS
$$
DECLARE
  Query VARCHAR(2000);
  mean_num NUMERIC(10,2);
  std_dev NUMERIC(10,2);
  outlier_count INTEGER := 0;
BEGIN
  -- Calculate the mean and standard deviation
  mean_num := compute_mean_numeric(Nom_COL, NOMTAB);
  std_dev := compute_std_numeric(Nom_COL, NOMTAB);

  -- Check if the mean and standard deviation calculations were successful
  IF (mean_num = -1 OR std_dev = -1) THEN
    RAISE NOTICE 'Mean or standard deviation calculation failed';
    RETURN QUERY SELECT 'Error', -1; -- Return error indication
  END IF;

  -- Calculer le score z et sélectionner les valeurs aberrantes
  RETURN QUERY EXECUTE 'SELECT $1, ' || Nom_COL || ' FROM ' || NOMTAB || ' WHERE ABS((' || Nom_COL || ' - $2) / $3) > $4'
  USING Nom_COL, mean_num, std_dev, z_threshold;

END;
$$ LANGUAGE plpgsql;





-- important
-- appel de la fonction et stockage dans une vue des résultats sous forme de table et retourne le nom de la vue créée
-- le nom de la vue doit etre en fonction du user, de la table et de la colonne _timestamp
CREATE OR REPLACE FUNCTION creer_vue_dynamique(vue_nom VARCHAR, fonction_nom VARCHAR, parametres TEXT[])
RETURNS VARCHAR AS
$$
DECLARE
    parametres_liste TEXT := '';
    commande_sql TEXT;
BEGIN
    -- Convertir le tableau de paramètres en une liste de chaînes séparées par des virgules
    SELECT INTO parametres_liste string_agg(quote_literal(p), ', ') FROM unnest(parametres) AS t(p);

    -- Construire la commande SQL pour créer la vue
    commande_sql := format('CREATE OR REPLACE VIEW %I AS SELECT * FROM %I(%s);', vue_nom, fonction_nom, parametres_liste);

    -- Exécuter la commande SQL dynamique
    EXECUTE commande_sql;

    -- Retourner le nom de la vue créée
    RETURN vue_nom;
EXCEPTION WHEN OTHERS THEN
    -- Gérer les exceptions et retourner NULL ou un message d'erreur si nécessaire
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

SELECT creer_vue_dynamique('ma_vue', 'trouver_caracteres_speciaux_et_ligne2', ARRAY['clients_20240315004907', 'column_2','clients_20240315004907_id']);