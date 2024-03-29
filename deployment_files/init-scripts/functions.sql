CREATE OR REPLACE FUNCTION NombreDeLignes (NOM_TABLE VARCHAR) RETURNS INTEGER AS 
$$
DECLARE 
    Query VARCHAR(2000);
    NbLignes INTEGER;
BEGIN 
    Query := 'SELECT COUNT (*) FROM ' || NOM_TABLE ;
    EXECUTE Query INTO NbLignes;
    RETURN NbLignes; 
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION NombreDeColonnes (NOM_TABLE VARCHAR) RETURNS INTEGER AS 
$$
DECLARE 
    Query VARCHAR(2000);
    NbColonnes INTEGER;
BEGIN 
    Query := 'SELECT COUNT (*) FROM information_schema.columns WHERE table_name = ''' || LOWER(NOM_TABLE) || '''';
    EXECUTE Query INTO NbColonnes;
    RETURN NbColonnes; 
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION NomsDesColonnes(tableName VARCHAR) RETURNS SETOF VARCHAR AS
$$
DECLARE
    col_name VARCHAR;
BEGIN
    FOR col_name IN (SELECT column_name FROM information_schema.columns WHERE table_name = LOWER(tableName))
    LOOP
        RETURN NEXT col_name;
    END LOOP;

    RETURN;
END;
$$ LANGUAGE plpgsql;


--cette fonction permet de récupérer le type d'une colonne d'une table
CREATE OR REPLACE FUNCTION TypeDesColonne(tableName VARCHAR, columnName VARCHAR)
   RETURNS VARCHAR AS
$$
DECLARE
    columnType VARCHAR(100);
BEGIN
    SELECT data_type INTO columnType
    FROM information_schema.columns
    WHERE table_name = lower(tableName) AND column_name = columnName;

    RETURN columnType;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION NombreDeNULLs (NOMTAB VARCHAR, Nom_COL VARCHAR) RETURNS INTEGER AS 
$$
DECLARE
    Query VARCHAR(2000);
    NbValNulles INTEGER;
BEGIN 
    Query := 'SELECT COUNT (*) FROM ' || NOMTAB || ' WHERE ' ||  Nom_COL || ' IS NULL';

    IF (TypeDesColonne(NOMTAB, NOM_COL) = 'character varying') THEN
        Query := Query || ' OR (' || Nom_COL || '  IN (''MISSINGVALUE'',''NULL'', ''-'', ''='', ''!'', ''?'',''nan'', ''''))';
    END IF;
    EXECUTE Query INTO NbValNulles;
    RETURN NbValNulles; 
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION NombreDeNONNULLs (NOMTAB VARCHAR, Nom_COL VARCHAR) RETURNS INTEGER AS 
$$
DECLARE
    Query VARCHAR(2000);
    NbValNONNulles INTEGER;
BEGIN 
    Query := 'SELECT COUNT (*) FROM ' || NOMTAB || ' WHERE ' ||  Nom_COL || ' IS NOT NULL';

    IF (TypeDesColonne(NOMTAB, NOM_COL) = 'character varying') THEN
        Query := Query || ' OR (' || Nom_COL || ' NOT  IN (''MISSINGVALUE'',''NULL'', ''-'', ''='', ''!'', ''?'', ''''))';
    END IF;
    EXECUTE Query INTO NbValNONNulles;
    RETURN NbValNONNulles; 
END;
$$ LANGUAGE plpgsql;


-- Get Language
CREATE OR REPLACE FUNCTION getDatabaseLanguage() RETURNS VARCHAR AS
$$
DECLARE
    db_lang VARCHAR(30);
BEGIN
    -- Utilisez la fonction current_setting pour récupérer la langue du système
    SELECT current_setting('lc_messages') INTO db_lang;
    RETURN db_lang;
EXCEPTION
    WHEN OTHERS THEN RETURN 'FR';
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION CountUppercaseNames(NOMTAB VARCHAR, Nom_COL VARCHAR) RETURNS INTEGER AS
$$
DECLARE
    Query VARCHAR;
    nbMaj INTEGER;
BEGIN
	IF (TypeDesColonne(NOMTAB, Nom_COL) = 'character varying') THEN
		Query := 'SELECT COUNT(' || Nom_COL || ') FROM ' || NOMTAB || ' WHERE UPPER(' || Nom_COL || ') = ' || Nom_COL;
		EXECUTE Query INTO nbMaj;
		RETURN nbMaj;
	END IF;
	RETURN 0;
END;
$$ LANGUAGE plpgsql;

-- Nombre de data minuscule dans une table avec une colonne spécifiée
CREATE OR REPLACE FUNCTION CountLowercaseNames(NOMTAB VARCHAR, Nom_COL VARCHAR) RETURNS INTEGER AS
$$
DECLARE
    Query VARCHAR;
    CountLowercase INTEGER;
BEGIN
	IF (TypeDesColonne(NOMTAB, Nom_COL) = 'character varying') THEN
		Query := 'SELECT COUNT(*) FROM ' || NOMTAB || ' WHERE ' || Nom_COL || ' = LOWER(' || Nom_COL || ')';
		EXECUTE Query INTO CountLowercase;
		RETURN CountLowercase;
	END IF;
	RETURN 0;
END;
$$ LANGUAGE plpgsql;

-- Nombre de data en initcap dans une table avec une colonne spécifiée
CREATE OR REPLACE FUNCTION CountInitcapNames(NOMTAB VARCHAR, Nom_COL VARCHAR) RETURNS INTEGER AS
$$
DECLARE
    Query VARCHAR;
    CountInitcap INTEGER;
BEGIN
	IF (TypeDesColonne(NOMTAB, Nom_COL) = 'character varying') THEN
		Query := 'SELECT COUNT(*) FROM ' || NOMTAB || ' WHERE ' || Nom_COL || ' = INITCAP(' || Nom_COL || ')';
		EXECUTE Query INTO CountInitcap;
		RETURN CountInitcap;
	END IF;
	RETURN 0;
END;
$$ LANGUAGE plpgsql;




-- Function to get the maximum date from a column in a table
CREATE OR REPLACE FUNCTION get_max_dates (Nom_COL VARCHAR, NOMTAB VARCHAR) RETURNS VARCHAR AS 
$$
DECLARE
  Query   VARCHAR(2000);
  dateMax VARCHAR(50);
BEGIN 
  Query := 'SELECT MAX(' || Nom_COL || ') FROM ' || NOMTAB;
  EXECUTE Query INTO dateMax;
  RETURN dateMax; 
END;
$$ LANGUAGE plpgsql;

-- Function to get the maximum length of a string column in a table
CREATE OR REPLACE FUNCTION get_max_characters(Nom_COL VARCHAR, NOMTAB VARCHAR) RETURNS INTEGER AS 
$$
DECLARE
  Query   VARCHAR(2000);
  MaxChar INTEGER;
BEGIN
  Query := 'SELECT MAX(LENGTH(' || Nom_COL || ')) FROM ' || NOMTAB;
  EXECUTE Query INTO MaxChar;
  RETURN MaxChar; 
END;
$$ LANGUAGE plpgsql;

-- Function to get the maximum length of a numeric column in a table
CREATE OR REPLACE FUNCTION get_max_numerics(column_name VARCHAR, table_name VARCHAR) RETURNS INTEGER AS
$$
DECLARE
    min_value INTEGER;
BEGIN
    EXECUTE 'SELECT MAX(' || column_name || ') FROM ' || table_name INTO min_value;
    RETURN min_value;
EXCEPTION
    WHEN OTHERS THEN
        -- Handle exceptions if needed
        RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Function to get the maximum value based on column type
CREATE OR REPLACE FUNCTION get_max_value(Nom_COL VARCHAR, NOMTAB VARCHAR) RETURNS VARCHAR AS
$$
DECLARE
  ColType VARCHAR(20);
  maxValue VARCHAR(4000);
BEGIN
  -- Determine the data type of the column
  SELECT DATA_TYPE INTO ColType
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_NAME = LOWER(NOMTAB) AND COLUMN_NAME = LOWER(Nom_COL);

  -- Use the appropriate sub-function based on the column type
  IF ColType = 'character varying' OR ColType = 'character' THEN
    -- String column
    maxValue := get_max_characters(Nom_COL, NOMTAB)::VARCHAR;
  ELSIF ColType = 'integer' THEN
    -- Numeric column
    maxValue := get_max_numerics(Nom_COL, NOMTAB)::VARCHAR;
  ELSIF ColType = 'date' THEN
    -- Date column
    maxValue := get_max_dates(Nom_COL, NOMTAB)::VARCHAR;
  ELSE
    -- Handle other data types if necessary
    maxValue := NULL;
  END IF;

  RETURN maxValue;
END;
$$ LANGUAGE plpgsql;

-- Function to get the minimum length of a string column in a table
CREATE OR REPLACE FUNCTION get_min_characters (Nom_COL VARCHAR, NOMTAB VARCHAR) RETURNS INTEGER AS 
$$
DECLARE
  Query   VARCHAR(2000);
  MinChar INTEGER;
BEGIN
  Query := 'SELECT MIN(LENGTH(' || Nom_COL || ')) FROM ' || NOMTAB;
  EXECUTE Query INTO MinChar;
  RETURN MinChar; 
END;
$$ LANGUAGE plpgsql;

-- Function to get the minimum length of a numeric column in a table
CREATE OR REPLACE FUNCTION get_min_numerics(column_name VARCHAR, table_name VARCHAR) RETURNS INTEGER AS
$$
DECLARE
    min_value INTEGER;
BEGIN
    EXECUTE 'SELECT MIN(' || column_name || ') FROM ' || table_name INTO min_value;
    RETURN min_value;
EXCEPTION
    WHEN OTHERS THEN
        -- Handle exceptions if needed
        RETURN NULL;
END;
$$ LANGUAGE plpgsql;


-- Function to get the minimum date from a column in a table
CREATE OR REPLACE FUNCTION get_min_dates (Nom_COL VARCHAR, NOMTAB VARCHAR) RETURNS VARCHAR AS 
$$
DECLARE
  Query   VARCHAR(2000);
  dateMin VARCHAR(50);
BEGIN 
  Query := 'SELECT MIN(' || Nom_COL || ') FROM ' || NOMTAB;
  EXECUTE Query INTO dateMin;
  RETURN dateMin; 
END;
$$ LANGUAGE plpgsql;

-- Function to get the minimum value based on column type
CREATE OR REPLACE FUNCTION get_min_value(Nom_COL VARCHAR, NOMTAB VARCHAR) RETURNS VARCHAR AS
$$
DECLARE
  ColType VARCHAR(20);
  minValue VARCHAR(4000);
BEGIN
  -- Vérifiez d'abord que le nom de la colonne et de la table sont corrects
  RAISE NOTICE 'Recherche du type pour la colonne % dans la table %', Nom_COL, NOMTAB;

  -- Determine the data type of the column
  SELECT DATA_TYPE INTO ColType
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = 'public' -- Remplacez par le schéma approprié si nécessaire
  AND TABLE_NAME = NOMTAB 
  AND COLUMN_NAME = Nom_COL;

  -- Si le type de colonne n'est pas trouvé, renvoyez NULL
  IF ColType IS NULL THEN
    RAISE NOTICE 'Type de colonne non trouvé pour % dans %', Nom_COL, NOMTAB;
    RETURN NULL;
  END IF;

  RAISE NOTICE 'Type de colonne trouvé: %', ColType;

  -- Use the appropriate sub-function based on the column type
  IF ColType = 'character varying' OR ColType = 'character' THEN
    minValue := get_min_characters(Nom_COL, NOMTAB)::VARCHAR;
  ELSIF ColType = 'integer' THEN
    minValue := get_min_numerics(Nom_COL, NOMTAB)::VARCHAR;
  ELSIF ColType = 'date' THEN
    minValue := get_min_dates(Nom_COL, NOMTAB)::VARCHAR;
  ELSE
    RAISE NOTICE 'Type de données non géré: %', ColType;
    minValue := NULL;
  END IF;

  RETURN minValue;
EXCEPTION
  WHEN OTHERS THEN
    RAISE NOTICE 'Erreur dans get_min_value: %', SQLERRM;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;


-- Function to compute the mean of numeric values in a column
CREATE OR REPLACE FUNCTION compute_mean_numeric (Nom_COL VARCHAR, NOMTAB VARCHAR) RETURNS NUMERIC AS
$$
DECLARE
  Query    VARCHAR(2000);
  avg_num  NUMERIC(10,2);
BEGIN 
  Query := 'SELECT AVG(CASE WHEN ' || Nom_COL || ' IS NULL THEN 0 ELSE LENGTH(SUBSTRING(' || Nom_COL || ' FROM regexp_instr(' || Nom_COL || ', ''[[:digit:]]*$'') FOR LENGTH(' || Nom_COL || ') - regexp_instr(' || Nom_COL || ', ''[[:digit:]]*$'') + 1)) END) FROM ' || NOMTAB;
  EXECUTE Query INTO avg_num;
  RETURN avg_num; 
END;
$$ LANGUAGE plpgsql;

-- Function to compute the standard deviation of numeric values in a column
CREATE OR REPLACE FUNCTION compute_std_numeric (Nom_COL VARCHAR, NOMTAB VARCHAR) RETURNS NUMERIC AS
$$
DECLARE
  Query VARCHAR(2000);
  std NUMERIC(10,2);
BEGIN 
  Query := 'SELECT STDDEV(TO_NUMBER(NVL(' || Nom_COL || ', ''0''))) FROM ' || NOMTAB;
  EXECUTE Query INTO std;
  RETURN std; 
EXCEPTION
  WHEN OTHERS THEN
    RETURN -1;
END;
$$ LANGUAGE plpgsql;

-- Function to count outliers based on the z-score
CREATE OR REPLACE FUNCTION count_outliers(NOMTAB VARCHAR, Nom_COL VARCHAR, z_threshold NUMERIC) RETURNS INTEGER AS
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
    RETURN -1; -- Replace -1 with the desired default value in case of an error.
  END IF;

  -- Calculate the z-score and count outliers
  Query := 'SELECT COUNT(*) FROM ' || NOMTAB || ' WHERE ABS((TO_NUMBER(NVL(' || Nom_COL || ', ''0'')) - $1) / $2) > $3';
  EXECUTE Query INTO outlier_count USING mean_num, std_dev, z_threshold;

  RETURN outlier_count;
EXCEPTION
  WHEN OTHERS THEN
    RETURN -1;
END;
$$ LANGUAGE plpgsql;


-- Function to get the primary key of a table
CREATE OR REPLACE FUNCTION get_primary_key(table_name VARCHAR) RETURNS VARCHAR AS
$$
DECLARE
    pk_name VARCHAR(100);
BEGIN
    EXECUTE 'SELECT column_name FROM information_schema.key_column_usage WHERE table_name = LOWER($1)' INTO pk_name USING table_name;
    
    IF pk_name IS NOT NULL THEN
        RETURN pk_name;
    ELSE
        RAISE EXCEPTION 'La table fournie ne possède pas de clé primaire.';
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
END;
$$ LANGUAGE plpgsql;


-- Function to find special characters in a column
CREATE OR REPLACE FUNCTION trouver_caracteres_speciaux(p_table_name VARCHAR, p_column_name VARCHAR) RETURNS VARCHAR AS
$$
DECLARE
    v_special_characters VARCHAR(1000) := '';
    v_sql_query VARCHAR(1000);
    v_cursor REFCURSOR;
    v_column_value VARCHAR(4000);
BEGIN
    -- Build the SQL query to select column values
    v_sql_query := 'SELECT ' || p_column_name || ' FROM ' || p_table_name;

    -- Open the cursor
    OPEN v_cursor FOR EXECUTE v_sql_query;

    -- Loop through column values
    LOOP
        FETCH v_cursor INTO v_column_value;
        EXIT WHEN NOT FOUND;

        v_column_value := COALESCE(v_column_value, '');

        -- Use regular expression to extract special characters and concatenate them
        v_special_characters := v_special_characters || REGEXP_REPLACE(v_column_value, '[^[:punct:]]', '', 'g');
    END LOOP;

    -- Close the cursor
    CLOSE v_cursor;

    -- Return the string containing all concatenated special characters
    RETURN v_special_characters;
EXCEPTION
    WHEN OTHERS THEN
        -- Handle errors (e.g., table or column not found)
        RETURN '';
END;
$$ LANGUAGE plpgsql;

-- Function to retrieve the total number of anomalies identified in a column
CREATE OR REPLACE FUNCTION RECUP_NOMBRE_ANOMALIE(NOM_TABLE VARCHAR, NOM_COLONNE VARCHAR) RETURNS INTEGER AS
$$
DECLARE
    NOMBRE_VALEUR_MANQUANTE INTEGER;
    NOMBRE_OUTLIERS INTEGER;
    NOMBRE_SPECIAL_CARACTERES INTEGER;
    v_NOMBRE_ANOMALIE INTEGER;
BEGIN
    v_NOMBRE_ANOMALIE := 0;

    NOMBRE_VALEUR_MANQUANTE := NombreDeNULLs(NOM_TABLE, NOM_COLONNE);
    NOMBRE_OUTLIERS := count_outliers(NOM_TABLE, NOM_COLONNE, 1.5);
    NOMBRE_SPECIAL_CARACTERES := LENGTH(trouver_caracteres_speciaux(NOM_TABLE, NOM_COLONNE));

    IF NOMBRE_VALEUR_MANQUANTE IS NOT NULL THEN
        v_NOMBRE_ANOMALIE := NOMBRE_VALEUR_MANQUANTE;
    END IF;

    IF NOMBRE_SPECIAL_CARACTERES IS NOT NULL THEN
        v_NOMBRE_ANOMALIE := v_NOMBRE_ANOMALIE + NOMBRE_SPECIAL_CARACTERES;
    END IF;

    IF NOMBRE_OUTLIERS > 0 THEN
        v_NOMBRE_ANOMALIE := v_NOMBRE_ANOMALIE + NOMBRE_OUTLIERS;
    END IF;

    RETURN v_NOMBRE_ANOMALIE;
END;
$$ LANGUAGE plpgsql;


-- Function to retrieve the table name from ID_META_TABLE
CREATE OR REPLACE FUNCTION RECUP_NOM_TABLE(v_ID_META_TABLE INTEGER) RETURNS VARCHAR AS
$$
DECLARE
    v_NOM_TABLE VARCHAR(100);
BEGIN
    SELECT DISTINCT NOM_TABLE INTO v_NOM_TABLE FROM META_TABLE WHERE ID_META_TABLE = v_ID_META_TABLE;
    RETURN v_NOM_TABLE;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error: impossible de récupérer le nom de la table.';
        RETURN '';
END;
$$ LANGUAGE plpgsql;

-- Function to insert values into the META_TABLE table
CREATE OR REPLACE FUNCTION INSERTION_META_TABLE(NOM_TABLE VARCHAR) RETURNS INTEGER AS $$
DECLARE
    nb_lignes INTEGER;
    nb_colonnes INTEGER;
    v_id INTEGER; -- id_meta_table to be returned
BEGIN
    -- Retrieve the number of rows in the table
    nb_lignes := NombreDeLignes(NOM_TABLE);
    
    -- Retrieve the number of columns in the table
    nb_colonnes := NombreDeColonnes(NOM_TABLE);
    
    -- Insert information into the 'META_TABLE' table
    EXECUTE 'INSERT INTO META_TABLE (NOM_TABLE, NOMBRE_COLONNE, NOMBRE_LIGNE) VALUES ($1, $2, $3) RETURNING ID_META_TABLE'
    INTO v_id
    USING NOM_TABLE, nb_colonnes, nb_lignes;
    
    RETURN v_id;
EXCEPTION
    WHEN OTHERS THEN
        RETURN -1;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION INSERTION_META_SPECIAL_CAR(CARACTERES VARCHAR) RETURNS INTEGER AS
$$
DECLARE
    v_id_special_car INTEGER;
BEGIN
    -- Insert values into the 'META_SPECIAL_CAR' table
    EXECUTE 'INSERT INTO META_SPECIAL_CAR (CARACTERES) VALUES ($1) RETURNING ID_META_SPECIAL_CAR'
    INTO v_id_special_car
    USING CARACTERES;
    
    RETURN v_id_special_car;
EXCEPTION
    WHEN OTHERS THEN
        RETURN -1;
END;
$$ LANGUAGE plpgsql;


-- insertion dans metacolonne
CREATE OR REPLACE FUNCTION INSERTION_META_COLONNE(
    ID_META_TABLE INTEGER,
    NOM_COLONNE VARCHAR,
    ID_META_SPECIAL_CAR INTEGER
) RETURNS INTEGER AS
$$
DECLARE
    v_ID_META_COLONNE INTEGER;
    ID_TABLE_ORIGIN VARCHAR(100);
    TYPE_DONNEE VARCHAR(200);
    NOMBRE_VALEUR INTEGER;
    NOMBRE_VALEUR_MANQUANTE INTEGER;
    NOMBRE_OUTLIERS INTEGER;
    SEMANTIQUE VARCHAR(100);
    LANGUE VARCHAR(100);
    NOMBRE_ANOMALIE INTEGER;
    NOMBRE_MAJUSCULES INTEGER;
    NOMBRE_MINUSCULES INTEGER;
    NOMBRE_INITCAP INTEGER;
    COL_MIN VARCHAR(100);
    COL_MAX VARCHAR(100);
    NOM_TABLE VARCHAR(100);
BEGIN
    -- récupérer le nom d'une table
    NOM_TABLE := RECUP_NOM_TABLE(ID_META_TABLE);
    -- récupération des valeurs des colonnes à partir des fonctions
    ID_TABLE_ORIGIN := get_primary_key(NOM_TABLE);
    TYPE_DONNEE := TypeDesColonne(NOM_TABLE, NOM_COLONNE);
    NOMBRE_VALEUR := NombreDeNONNULLs(NOM_TABLE, NOM_COLONNE);
    NOMBRE_VALEUR_MANQUANTE := NombreDeNULLs(NOM_TABLE, NOM_COLONNE);
    NOMBRE_OUTLIERS := count_outliers(NOM_TABLE,NOM_COLONNE, 1.5);
    SEMANTIQUE := NULL;
    LANGUE := getDatabaseLanguage();
    NOMBRE_ANOMALIE := RECUP_NOMBRE_ANOMALIE(NOM_TABLE, NOM_COLONNE);
    NOMBRE_MAJUSCULES := CountUppercaseNames(NOM_TABLE, NOM_COLONNE);
    NOMBRE_MINUSCULES := CountLowercaseNames(NOM_TABLE, NOM_COLONNE);
    NOMBRE_INITCAP := CountInitcapNames(NOM_TABLE, NOM_COLONNE);
    COL_MIN := get_min_value(NOM_COLONNE, NOM_TABLE);
    COL_MAX := get_max_value(NOM_COLONNE, NOM_TABLE);

    -- Insertion dans la table META_COLONNE
    INSERT INTO META_COLONNE (
        ID_META_TABLE,
        ID_META_SPECIAL_CAR,
        ID_TABLE_ORIGIN,
        NOM_COLONNE,
        TYPE_DONNEE,
        NOMBRE_VALEUR,
        NOMBRE_VALEUR_MANQUANTE,
        NOMBRE_OUTLIERS,
        SEMANTIQUE,
        LANGUE,
        NOMBRE_ANOMALIE,
        NOMBRE_MAJUSCULES,
        NOMBRE_MINUSCULES,
        NOMBRE_INITCAP,
        COL_MIN,
        COL_MAX
    ) VALUES (
        ID_META_TABLE,
        ID_META_SPECIAL_CAR,
        ID_TABLE_ORIGIN,
        NOM_COLONNE,
        TYPE_DONNEE,
        NOMBRE_VALEUR,
        NOMBRE_VALEUR_MANQUANTE,
        NOMBRE_OUTLIERS,
        SEMANTIQUE,
        LANGUE,
        NOMBRE_ANOMALIE,
        NOMBRE_MAJUSCULES,
        NOMBRE_MINUSCULES,
        NOMBRE_INITCAP,
        COL_MIN,
        COL_MAX
    ) RETURNING ID_META_COLONNE INTO v_ID_META_COLONNE;

    RETURN v_ID_META_COLONNE;
EXCEPTION
    WHEN OTHERS THEN
        -- Output error message to the console
		RAISE EXCEPTION 'ERROR: %', SQLERRM::VARCHAR;
        RETURN -1;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION UPDATE_DATE_DIAGNOSTIC(v_ID_META_TABLE INTEGER, v_ID_META_COLONNE INTEGER, v_DATE_DIAGNOSTIC TIMESTAMPTZ) RETURNS INTEGER AS
$$
BEGIN
    UPDATE META_TABLE SET DATE_DIAGNOSTIC = v_DATE_DIAGNOSTIC WHERE ID_META_TABLE = v_ID_META_TABLE;
    UPDATE META_COLONNE SET DATE_DIAGNOSTIC = v_DATE_DIAGNOSTIC WHERE ID_META_COLONNE = v_ID_META_COLONNE;

    RETURN 1;
    
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Error: %', SQLERRM;
            RETURN 0;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION INSERTION_DES_DIAGNOSTICS(v_NOM_TABLE VARCHAR) RETURNS INTEGER AS
$$
DECLARE
    ID_META_TABLE INTEGER;
    ID_META_SPECIAL_CAR INTEGER;
    ID_META_COLONNE INTEGER;
    CARACTERES_SPECIAUX VARCHAR(255);
    COL_NAME VARCHAR(255);
    NOM_TABLE VARCHAR(255);
    colRecord RECORD;
    has_update_date INTEGER;
    count_errors INTEGER;
BEGIN
    NOM_TABLE := UPPER(v_NOM_TABLE);
    count_errors := 0;

    -- Insertion into the META_TABLE
    ID_META_TABLE := INSERTION_META_TABLE(NOM_TABLE);

    IF ID_META_TABLE > 0 THEN
  
      FOR colRecord IN (SELECT * FROM NomsDesColonnes(NOM_TABLE))
      LOOP
        COL_NAME := colRecord.NomsDesColonnes;
        CARACTERES_SPECIAUX := trouver_caracteres_speciaux(NOM_TABLE, COL_NAME);
              ID_META_SPECIAL_CAR := INSERTION_META_SPECIAL_CAR(CARACTERES_SPECIAUX);

              IF ID_META_SPECIAL_CAR > 0 THEN
                  -- Insertion into the META_COLONNE
                  ID_META_COLONNE := INSERTION_META_COLONNE(ID_META_TABLE, COL_NAME, ID_META_SPECIAL_CAR);

                  IF ID_META_COLONNE > 0 THEN
                      -- After insertion into all tables, update the diagnostic date
                      has_update_date := UPDATE_DATE_DIAGNOSTIC(ID_META_TABLE, ID_META_COLONNE, NOW());
                      IF has_update_date = 0 THEN
                        count_errors := count_errors + 1;
                      END IF;
                  ELSE
                      RAISE NOTICE 'Error inserting into META_SPECIAL_CAR for column %', COL_NAME;
                      count_errors := count_errors + 1;
                  END IF;
              ELSE
                RAISE NOTICE 'Error inserting into META_COLONNE for column %', COL_NAME;
                count_errors := count_errors + 1;
              END IF;

      END LOOP;

    ELSE
      RAISE NOTICE 'Error inserting into META_TABLE for column %', COL_NAME;
     count_errors := count_errors + 1;
    END IF;

    IF count_errors = 0 THEN
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error: %', SQLERRM;
        RETURN 0;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION count_values_not_matching_regex(p_table_name VARCHAR, p_column_name VARCHAR, p_regex VARCHAR) RETURNS INTEGER AS
$$
DECLARE
    v_sql_query VARCHAR(1000);
    v_cursor REFCURSOR;
    v_column_value VARCHAR(4000);
    v_count INTEGER := 0;
BEGIN
    -- Build the SQL query to select column values
    v_sql_query := 'SELECT ' || p_column_name || ' FROM ' || p_table_name;

    -- Open the cursor
    OPEN v_cursor FOR EXECUTE v_sql_query;

    -- Loop through column values
    LOOP
        FETCH v_cursor INTO v_column_value;
        EXIT WHEN NOT FOUND;

        v_column_value := COALESCE(v_column_value, '');

        -- Check if the value does not match the regular expression
        IF NOT v_column_value !~ p_regex THEN
            -- Increment the counter
            v_count := v_count + 1;
        END IF;
    END LOOP;

    -- Close the cursor
    CLOSE v_cursor;

    RETURN v_count;
END;
$$ LANGUAGE plpgsql;CREATE OR REPLACE FUNCTION NombreDeLignes (NOM_TABLE VARCHAR) RETURNS INTEGER AS 
$$
DECLARE 
    Query VARCHAR(2000);
    NbLignes INTEGER;
BEGIN 
    Query := 'SELECT COUNT (*) FROM ' || NOM_TABLE ;
    EXECUTE Query INTO NbLignes;
    RETURN NbLignes; 
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION NombreDeColonnes (NOM_TABLE VARCHAR) RETURNS INTEGER AS 
$$
DECLARE 
    Query VARCHAR(2000);
    NbColonnes INTEGER;
BEGIN 
    Query := 'SELECT COUNT (*) FROM information_schema.columns WHERE table_name = ''' || LOWER(NOM_TABLE) || '''';
    EXECUTE Query INTO NbColonnes;
    RETURN NbColonnes; 
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION NomsDesColonnes(tableName VARCHAR) RETURNS SETOF VARCHAR AS
$$
DECLARE
    col_name VARCHAR;
BEGIN
    FOR col_name IN (SELECT column_name FROM information_schema.columns WHERE table_name = LOWER(tableName))
    LOOP
        RETURN NEXT col_name;
    END LOOP;

    RETURN;
END;
$$ LANGUAGE plpgsql;


--cette fonction permet de récupérer le type d'une colonne d'une table
CREATE OR REPLACE FUNCTION TypeDesColonne(tableName VARCHAR, columnName VARCHAR)
   RETURNS VARCHAR AS
$$
DECLARE
    columnType VARCHAR(100);
BEGIN
    SELECT data_type INTO columnType
    FROM information_schema.columns
    WHERE table_name = lower(tableName) AND column_name = columnName;

    RETURN columnType;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION NombreDeNULLs (NOMTAB VARCHAR, Nom_COL VARCHAR) RETURNS INTEGER AS 
$$
DECLARE
    Query VARCHAR(2000);
    NbValNulles INTEGER;
BEGIN 
    Query := 'SELECT COUNT (*) FROM ' || NOMTAB || ' WHERE ' ||  Nom_COL || ' IS NULL';

    IF (TypeDesColonne(NOMTAB, NOM_COL) = 'character varying') THEN
        Query := Query || ' OR (' || Nom_COL || '  IN (''MISSINGVALUE'',''NULL'', ''-'', ''='', ''!'', ''?'',''nan'', ''''))';
    END IF;
    EXECUTE Query INTO NbValNulles;
    RETURN NbValNulles; 
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION NombreDeNONNULLs(NOMTAB VARCHAR, Nom_COL VARCHAR) RETURNS INTEGER AS 
$$
DECLARE
    Query VARCHAR(2000);
    NbValNONNulles INTEGER;
BEGIN 
    Query := 'SELECT COUNT (*) FROM ' || NOMTAB || ' WHERE ' ||  Nom_COL || ' IS NOT NULL';

    IF (TypeDesColonne(NOMTAB, NOM_COL) = 'character varying') THEN
        Query := Query || ' OR (' || Nom_COL || ' NOT  IN (''MISSINGVALUE'',''NULL'', ''-'', ''='', ''!'', ''?'', ''''))';
    END IF;
    EXECUTE Query INTO NbValNONNulles;
    RETURN NbValNONNulles; 
END;
$$ LANGUAGE plpgsql;


-- Get Language
CREATE OR REPLACE FUNCTION getDatabaseLanguage() RETURNS VARCHAR AS
$$
DECLARE
    db_lang VARCHAR(30);
BEGIN
    -- Utilisez la fonction current_setting pour récupérer la langue du système
    SELECT current_setting('lc_messages') INTO db_lang;
    RETURN db_lang;
EXCEPTION
    WHEN OTHERS THEN RETURN 'FR';
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION CountUppercaseNames(NOMTAB VARCHAR, Nom_COL VARCHAR) RETURNS INTEGER AS
$$
DECLARE
    Query VARCHAR;
    nbMaj INTEGER;
BEGIN
	IF (TypeDesColonne(NOMTAB, Nom_COL) = 'character varying') THEN
		Query := 'SELECT COUNT(' || Nom_COL || ') FROM ' || NOMTAB || ' WHERE UPPER(' || Nom_COL || ') = ' || Nom_COL;
		EXECUTE Query INTO nbMaj;
		RETURN nbMaj;
	END IF;
	RETURN 0;
END;
$$ LANGUAGE plpgsql;

-- Nombre de data minuscule dans une table avec une colonne spécifiée
CREATE OR REPLACE FUNCTION CountLowercaseNames(NOMTAB VARCHAR, Nom_COL VARCHAR) RETURNS INTEGER AS
$$
DECLARE
    Query VARCHAR;
    CountLowercase INTEGER;
BEGIN
	IF (TypeDesColonne(NOMTAB, Nom_COL) = 'character varying') THEN
		Query := 'SELECT COUNT(*) FROM ' || NOMTAB || ' WHERE ' || Nom_COL || ' = LOWER(' || Nom_COL || ')';
		EXECUTE Query INTO CountLowercase;
		RETURN CountLowercase;
	END IF;
	RETURN 0;
END;
$$ LANGUAGE plpgsql;

-- Nombre de data en initcap dans une table avec une colonne spécifiée
CREATE OR REPLACE FUNCTION CountInitcapNames(NOMTAB VARCHAR, Nom_COL VARCHAR) RETURNS INTEGER AS
$$
DECLARE
    Query VARCHAR;
    CountInitcap INTEGER;
BEGIN
	IF (TypeDesColonne(NOMTAB, Nom_COL) = 'character varying') THEN
		Query := 'SELECT COUNT(*) FROM ' || NOMTAB || ' WHERE ' || Nom_COL || ' = INITCAP(' || Nom_COL || ')';
		EXECUTE Query INTO CountInitcap;
		RETURN CountInitcap;
	END IF;
	RETURN 0;
END;
$$ LANGUAGE plpgsql;




-- Function to get the maximum date from a column in a table
CREATE OR REPLACE FUNCTION get_max_dates (Nom_COL VARCHAR, NOMTAB VARCHAR) RETURNS VARCHAR AS 
$$
DECLARE
  Query   VARCHAR(2000);
  dateMax VARCHAR(50);
BEGIN 
  Query := 'SELECT MAX(' || Nom_COL || ') FROM ' || NOMTAB;
  EXECUTE Query INTO dateMax;
  RETURN dateMax; 
END;
$$ LANGUAGE plpgsql;

-- Function to get the maximum length of a string column in a table
CREATE OR REPLACE FUNCTION get_max_characters (Nom_COL VARCHAR, NOMTAB VARCHAR) RETURNS INTEGER AS 
$$
DECLARE
  Query   VARCHAR(2000);
  MaxChar INTEGER;
BEGIN
  Query := 'SELECT MAX(LENGTH(' || Nom_COL || ')) FROM ' || NOMTAB;
  EXECUTE Query INTO MaxChar;
  RETURN MaxChar; 
END;
$$ LANGUAGE plpgsql;

-- Function to get the maximum length of a numeric column in a table
CREATE OR REPLACE FUNCTION get_max_numerics(column_name VARCHAR, table_name VARCHAR) RETURNS INTEGER AS
$$
DECLARE
    min_value INTEGER;
BEGIN
    EXECUTE 'SELECT MAX(' || column_name || ') FROM ' || table_name INTO min_value;
    RETURN min_value;
EXCEPTION
    WHEN OTHERS THEN
        -- Handle exceptions if needed
        RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Function to get the maximum value based on column type
CREATE OR REPLACE FUNCTION get_max_value(Nom_COL VARCHAR, NOMTAB VARCHAR) RETURNS VARCHAR AS
$$
DECLARE
  ColType VARCHAR(20);
  maxValue VARCHAR(4000);
BEGIN
  -- Determine the data type of the column
  SELECT DATA_TYPE INTO ColType
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_NAME = LOWER(NOMTAB) AND COLUMN_NAME = LOWER(Nom_COL);

  -- Use the appropriate sub-function based on the column type
  IF ColType = 'character varying' OR ColType = 'character' THEN
    -- String column
    maxValue := get_max_characters(Nom_COL, NOMTAB)::VARCHAR;
  ELSIF ColType = 'integer' THEN
    -- Numeric column
    maxValue := get_max_numerics(Nom_COL, NOMTAB)::VARCHAR;
  ELSIF ColType = 'date' THEN
    -- Date column
    maxValue := get_max_dates(Nom_COL, NOMTAB)::VARCHAR;
  ELSE
    -- Handle other data types if necessary
    maxValue := NULL;
  END IF;

  RETURN maxValue;
END;
$$ LANGUAGE plpgsql;

-- Function to get the minimum length of a string column in a table
CREATE OR REPLACE FUNCTION get_min_characters (Nom_COL VARCHAR, NOMTAB VARCHAR) RETURNS INTEGER AS 
$$
DECLARE
  Query   VARCHAR(2000);
  MinChar INTEGER;
BEGIN
  Query := 'SELECT MIN(LENGTH(' || Nom_COL || ')) FROM ' || NOMTAB;
  EXECUTE Query INTO MinChar;
  RETURN MinChar; 
END;
$$ LANGUAGE plpgsql;

-- Function to get the minimum length of a numeric column in a table
CREATE OR REPLACE FUNCTION get_min_numerics(column_name VARCHAR, table_name VARCHAR) RETURNS INTEGER AS
$$
DECLARE
    min_value INTEGER;
BEGIN
    EXECUTE 'SELECT MIN(' || column_name || ') FROM ' || table_name INTO min_value;
    RETURN min_value;
EXCEPTION
    WHEN OTHERS THEN
        -- Handle exceptions if needed
        RETURN NULL;
END;
$$ LANGUAGE plpgsql;


-- Function to get the minimum date from a column in a table
CREATE OR REPLACE FUNCTION get_min_dates (Nom_COL VARCHAR, NOMTAB VARCHAR) RETURNS VARCHAR AS 
$$
DECLARE
  Query   VARCHAR(2000);
  dateMin VARCHAR(50);
BEGIN 
  Query := 'SELECT MIN(' || Nom_COL || ') FROM ' || NOMTAB;
  EXECUTE Query INTO dateMin;
  RETURN dateMin; 
END;
$$ LANGUAGE plpgsql;

-- Function to get the minimum value based on column type
CREATE OR REPLACE FUNCTION get_min_value(Nom_COL VARCHAR, NOMTAB VARCHAR) RETURNS VARCHAR AS
$$
DECLARE
  ColType VARCHAR(20);
  minValue VARCHAR(4000);
BEGIN
  -- Determine the data type of the column
  SELECT DATA_TYPE INTO ColType
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_NAME = LOWER(NOMTAB) AND COLUMN_NAME = LOWER(Nom_COL);

  -- Use the appropriate sub-function based on the column type
  IF ColType = 'character varying' OR ColType = 'character' THEN
    -- String column
    minValue := get_min_characters(Nom_COL, NOMTAB)::VARCHAR;
  ELSIF ColType = 'integer' THEN
    -- Numeric column
    minValue := get_min_numerics(Nom_COL, NOMTAB)::VARCHAR;
  ELSIF ColType = 'date' THEN
    -- Date column
    minValue := get_min_dates(Nom_COL, NOMTAB)::VARCHAR;
  ELSE
    -- Handle other data types if necessary
    minValue := NULL;
  END IF;

  RETURN minValue;
END;
$$ LANGUAGE plpgsql;

-- Function to get the primary key of a table
CREATE OR REPLACE FUNCTION get_primary_key(table_name VARCHAR) RETURNS VARCHAR AS
$$
DECLARE
    pk_name VARCHAR(100);
BEGIN
    EXECUTE 'SELECT column_name FROM information_schema.key_column_usage WHERE table_name = LOWER($1)' INTO pk_name USING table_name;
    
    IF pk_name IS NOT NULL THEN
        RETURN pk_name;
    ELSE
        RAISE EXCEPTION 'La table fournie ne possède pas de clé primaire.';
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
END;
$$ LANGUAGE plpgsql;


-- Function to find special characters in a column
CREATE OR REPLACE FUNCTION trouver_caracteres_speciaux(p_table_name VARCHAR, p_column_name VARCHAR) RETURNS VARCHAR AS
$$
DECLARE
    v_special_characters VARCHAR(1000) := '';
    v_sql_query VARCHAR(1000);
    v_cursor REFCURSOR;
    v_column_value VARCHAR(4000);
BEGIN
    -- Build the SQL query to select column values
    v_sql_query := 'SELECT ' || p_column_name || ' FROM ' || p_table_name;

    -- Open the cursor
    OPEN v_cursor FOR EXECUTE v_sql_query;

    -- Loop through column values
    LOOP
        FETCH v_cursor INTO v_column_value;
        EXIT WHEN NOT FOUND;

        v_column_value := COALESCE(v_column_value, '');

        -- Use regular expression to extract special characters and concatenate them
        v_special_characters := v_special_characters || REGEXP_REPLACE(v_column_value, '[^[:punct:]]', '', 'g');
    END LOOP;

    -- Close the cursor
    CLOSE v_cursor;

    -- Return the string containing all concatenated special characters
    RETURN v_special_characters;
EXCEPTION
    WHEN OTHERS THEN
        -- Handle errors (e.g., table or column not found)
        RETURN '';
END;
$$ LANGUAGE plpgsql;

-- Function to retrieve the total number of anomalies identified in a column
CREATE OR REPLACE FUNCTION RECUP_NOMBRE_ANOMALIE(NOM_TABLE VARCHAR, NOM_COLONNE VARCHAR) RETURNS INTEGER AS
$$
DECLARE
    NOMBRE_VALEUR_MANQUANTE INTEGER;
    NOMBRE_OUTLIERS INTEGER;
    NOMBRE_SPECIAL_CARACTERES INTEGER;
    v_NOMBRE_ANOMALIE INTEGER;
BEGIN
    v_NOMBRE_ANOMALIE := 0;

    NOMBRE_VALEUR_MANQUANTE := NombreDeNULLs(NOM_TABLE, NOM_COLONNE);
    NOMBRE_OUTLIERS := count_outliers(NOM_TABLE, NOM_COLONNE, 1.5);
    NOMBRE_SPECIAL_CARACTERES := LENGTH(trouver_caracteres_speciaux(NOM_TABLE, NOM_COLONNE));

    IF NOMBRE_VALEUR_MANQUANTE IS NOT NULL THEN
        v_NOMBRE_ANOMALIE := NOMBRE_VALEUR_MANQUANTE;
    END IF;

    IF NOMBRE_SPECIAL_CARACTERES IS NOT NULL THEN
        v_NOMBRE_ANOMALIE := v_NOMBRE_ANOMALIE + NOMBRE_SPECIAL_CARACTERES;
    END IF;

    IF NOMBRE_OUTLIERS > 0 THEN
        v_NOMBRE_ANOMALIE := v_NOMBRE_ANOMALIE + NOMBRE_OUTLIERS;
    END IF;

    RETURN v_NOMBRE_ANOMALIE;
END;
$$ LANGUAGE plpgsql;


-- Function to retrieve the table name from ID_META_TABLE
CREATE OR REPLACE FUNCTION RECUP_NOM_TABLE(v_ID_META_TABLE INTEGER) RETURNS VARCHAR AS
$$
DECLARE
    v_NOM_TABLE VARCHAR(100);
BEGIN
    SELECT DISTINCT NOM_TABLE INTO v_NOM_TABLE FROM META_TABLE WHERE ID_META_TABLE = v_ID_META_TABLE;
    RETURN v_NOM_TABLE;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error: impossible de récupérer le nom de la table.';
        RETURN '';
END;
$$ LANGUAGE plpgsql;

-- Function to insert values into the META_TABLE table
CREATE OR REPLACE FUNCTION INSERTION_META_TABLE(NOM_TABLE VARCHAR) RETURNS INTEGER AS $$
DECLARE
    nb_lignes INTEGER;
    nb_colonnes INTEGER;
    v_id INTEGER; -- id_meta_table to be returned
BEGIN
    -- Retrieve the number of rows in the table
    nb_lignes := NombreDeLignes(NOM_TABLE);
    
    -- Retrieve the number of columns in the table
    nb_colonnes := NombreDeColonnes(NOM_TABLE);
    
    -- Insert information into the 'META_TABLE' table
    EXECUTE 'INSERT INTO META_TABLE (NOM_TABLE, NOMBRE_COLONNE, NOMBRE_LIGNE) VALUES ($1, $2, $3) RETURNING ID_META_TABLE'
    INTO v_id
    USING NOM_TABLE, nb_colonnes, nb_lignes;
    
    RETURN v_id;
EXCEPTION
    WHEN OTHERS THEN
        RETURN -1;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION INSERTION_META_SPECIAL_CAR(CARACTERES VARCHAR) RETURNS INTEGER AS
$$
DECLARE
    v_id_special_car INTEGER;
BEGIN
    -- Insert values into the 'META_SPECIAL_CAR' table
    EXECUTE 'INSERT INTO META_SPECIAL_CAR (CARACTERES) VALUES ($1) RETURNING ID_META_SPECIAL_CAR'
    INTO v_id_special_car
    USING CARACTERES;
    
    RETURN v_id_special_car;
EXCEPTION
    WHEN OTHERS THEN
        RETURN -1;
END;
$$ LANGUAGE plpgsql;


-- insertion dans metacolonne
CREATE OR REPLACE FUNCTION INSERTION_META_COLONNE(
    ID_META_TABLE INTEGER,
    NOM_COLONNE VARCHAR,
    ID_META_SPECIAL_CAR INTEGER
) RETURNS INTEGER AS
$$
DECLARE
    v_ID_META_COLONNE INTEGER;
    ID_TABLE_ORIGIN VARCHAR(100);
    TYPE_DONNEE VARCHAR(200);
    NOMBRE_VALEUR INTEGER;
    NOMBRE_VALEUR_MANQUANTE INTEGER;
    NOMBRE_OUTLIERS INTEGER;
    SEMANTIQUE VARCHAR(100);
    LANGUE VARCHAR(100);
    NOMBRE_ANOMALIE INTEGER;
    NOMBRE_MAJUSCULES INTEGER;
    NOMBRE_MINUSCULES INTEGER;
    NOMBRE_INITCAP INTEGER;
    COL_MIN VARCHAR(100);
    COL_MAX VARCHAR(100);
    NOM_TABLE VARCHAR(100);
BEGIN
    -- récupérer le nom d'une table
    NOM_TABLE := RECUP_NOM_TABLE(ID_META_TABLE);
    -- récupération des valeurs des colonnes à partir des fonctions
    ID_TABLE_ORIGIN := get_primary_key(NOM_TABLE);
    TYPE_DONNEE := TypeDesColonne(NOM_TABLE, NOM_COLONNE);
    NOMBRE_VALEUR := NombreDeNONNULLs(NOM_TABLE, NOM_COLONNE);
    NOMBRE_VALEUR_MANQUANTE := NombreDeNULLs(NOM_TABLE, NOM_COLONNE);
    NOMBRE_OUTLIERS := count_outliers(NOM_TABLE,NOM_COLONNE, 1.5);
    SEMANTIQUE := NULL;
    LANGUE := getDatabaseLanguage();
    NOMBRE_ANOMALIE := RECUP_NOMBRE_ANOMALIE(NOM_TABLE, NOM_COLONNE);
    NOMBRE_MAJUSCULES := CountUppercaseNames(NOM_TABLE, NOM_COLONNE);
    NOMBRE_MINUSCULES := CountLowercaseNames(NOM_TABLE, NOM_COLONNE);
    NOMBRE_INITCAP := CountInitcapNames(NOM_TABLE, NOM_COLONNE);
    COL_MIN := get_min_value(NOM_COLONNE, NOM_TABLE);
    COL_MAX := get_max_value(NOM_COLONNE, NOM_TABLE);

    -- Insertion dans la table META_COLONNE
    INSERT INTO META_COLONNE (
        ID_META_TABLE,
        ID_META_SPECIAL_CAR,
        ID_TABLE_ORIGIN,
        NOM_COLONNE,
        TYPE_DONNEE,
        NOMBRE_VALEUR,
        NOMBRE_VALEUR_MANQUANTE,
        NOMBRE_OUTLIERS,
        SEMANTIQUE,
        LANGUE,
        NOMBRE_ANOMALIE,
        NOMBRE_MAJUSCULES,
        NOMBRE_MINUSCULES,
        NOMBRE_INITCAP,
        COL_MIN,
        COL_MAX
    ) VALUES (
        ID_META_TABLE,
        ID_META_SPECIAL_CAR,
        ID_TABLE_ORIGIN,
        NOM_COLONNE,
        TYPE_DONNEE,
        NOMBRE_VALEUR,
        NOMBRE_VALEUR_MANQUANTE,
        NOMBRE_OUTLIERS,
        SEMANTIQUE,
        LANGUE,
        NOMBRE_ANOMALIE,
        NOMBRE_MAJUSCULES,
        NOMBRE_MINUSCULES,
        NOMBRE_INITCAP,
        COL_MIN,
        COL_MAX
    ) RETURNING ID_META_COLONNE INTO v_ID_META_COLONNE;

    RETURN v_ID_META_COLONNE;
EXCEPTION
    WHEN OTHERS THEN
        -- Output error message to the console
		RAISE EXCEPTION 'ERROR: %', SQLERRM::VARCHAR;
        RETURN -1;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION UPDATE_DATE_DIAGNOSTIC(v_ID_META_TABLE INTEGER, v_ID_META_COLONNE INTEGER, v_DATE_DIAGNOSTIC TIMESTAMPTZ) RETURNS INTEGER AS
$$
BEGIN
    UPDATE META_TABLE SET DATE_DIAGNOSTIC = v_DATE_DIAGNOSTIC WHERE ID_META_TABLE = v_ID_META_TABLE;
    UPDATE META_COLONNE SET DATE_DIAGNOSTIC = v_DATE_DIAGNOSTIC WHERE ID_META_COLONNE = v_ID_META_COLONNE;

    RETURN 1;
    
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Error: %', SQLERRM;
            RETURN 0;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION INSERTION_DES_DIAGNOSTICS(v_NOM_TABLE VARCHAR) RETURNS INTEGER AS
$$
DECLARE
    ID_META_TABLE INTEGER;
    ID_META_SPECIAL_CAR INTEGER;
    ID_META_COLONNE INTEGER;
    CARACTERES_SPECIAUX VARCHAR(255);
    COL_NAME VARCHAR(255);
    NOM_TABLE VARCHAR(255);
    colRecord RECORD;
    has_update_date INTEGER;
    count_errors INTEGER;
BEGIN
    NOM_TABLE := UPPER(v_NOM_TABLE);
    count_errors := 0;

    -- Insertion into the META_TABLE
    ID_META_TABLE := INSERTION_META_TABLE(NOM_TABLE);

    IF ID_META_TABLE > 0 THEN
  
      FOR colRecord IN (SELECT * FROM NomsDesColonnes(NOM_TABLE))
      LOOP
        COL_NAME := colRecord.NomsDesColonnes;
        CARACTERES_SPECIAUX := trouver_caracteres_speciaux(NOM_TABLE, COL_NAME);
              ID_META_SPECIAL_CAR := INSERTION_META_SPECIAL_CAR(CARACTERES_SPECIAUX);

              IF ID_META_SPECIAL_CAR > 0 THEN
                  -- Insertion into the META_COLONNE
                  ID_META_COLONNE := INSERTION_META_COLONNE(ID_META_TABLE, COL_NAME, ID_META_SPECIAL_CAR);

                  IF ID_META_COLONNE > 0 THEN
                      -- After insertion into all tables, update the diagnostic date
                      has_update_date := UPDATE_DATE_DIAGNOSTIC(ID_META_TABLE, ID_META_COLONNE, NOW());
                      IF has_update_date = 0 THEN
                        count_errors := count_errors + 1;
                      END IF;
                  ELSE
                      RAISE NOTICE 'Error inserting into META_SPECIAL_CAR for column %', COL_NAME;
                      count_errors := count_errors + 1;
                  END IF;
              ELSE
                RAISE NOTICE 'Error inserting into META_COLONNE for column %', COL_NAME;
                count_errors := count_errors + 1;
              END IF;

      END LOOP;

    ELSE
      RAISE NOTICE 'Error inserting into META_TABLE for column %', COL_NAME;
     count_errors := count_errors + 1;
    END IF;

    IF count_errors = 0 THEN
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error: %', SQLERRM;
        RETURN 0;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION count_values_not_matching_regex(p_table_name VARCHAR, p_column_name VARCHAR, p_regex VARCHAR) RETURNS INTEGER AS
$$
DECLARE
    v_sql_query VARCHAR(1000);
    v_cursor REFCURSOR;
    v_column_value VARCHAR(4000);
    v_count INTEGER := 0;
BEGIN
    -- Build the SQL query to select column values
    v_sql_query := 'SELECT ' || p_column_name || ' FROM ' || p_table_name;

    -- Open the cursor
    OPEN v_cursor FOR EXECUTE v_sql_query;

    -- Loop through column values
    LOOP
        FETCH v_cursor INTO v_column_value;
        EXIT WHEN NOT FOUND;

        v_column_value := COALESCE(v_column_value, '');

        -- Check if the value does not match the regular expression
        IF NOT v_column_value !~ p_regex THEN
            -- Increment the counter
            v_count := v_count + 1;
        END IF;
    END LOOP;

    -- Close the cursor
    CLOSE v_cursor;

    RETURN v_count;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION isColumnIn1NF(tableName VARCHAR, columnName VARCHAR)
RETURNS VARCHAR AS $$
DECLARE
    notIn1NF VARCHAR(100);
    colType VARCHAR;
    strValue VARCHAR;
    queryStr TEXT;
BEGIN
    notIn1NF := 'Yes';

    -- Récupérer le type de données de la colonne spécifiée
    SELECT data_type INTO colType
    FROM information_schema.columns
    WHERE table_name = tableName AND column_name = columnName;

    -- Vérifier si le type de données est non atomique
    IF colType IN ('USER-DEFINED', 'ARRAY') THEN
        notIn1NF := 'No';
    ELSIF colType = 'character varying' OR colType = 'char' THEN
        -- Préparer la requête dynamique
        queryStr := 'SELECT ' || quote_ident(columnName) || ' FROM ' || quote_ident(tableName);
        FOR strValue IN EXECUTE queryStr LOOP
            -- Recherche de patterns qui suggèrent des données non atomiques
            IF strValue ~ '[a-zA-Z0-9]+,\s+([a-zA-Z0-9]+\s+)*' OR strValue ~ '[a-zA-Z0-9]+;\s+([a-zA-Z0-9]+\s+)*' OR strValue ~ '[a-zA-Z0-9]+-\s+([a-zA-Z0-9]+\s+)*' OR strValue ~ '[a-zA-Z0-9]+,\s+([a-zA-Z0-9]+\s+)*' OR strValue ~ '[a-zA-Z0-9]+\s+([a-zA-Z0-9]+\s+)*' THEN
                notIn1NF := 'No';
                EXIT;
            END IF;
        END LOOP;
    END IF;

    RETURN notIn1NF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'Column or Table not found';
    WHEN OTHERS THEN
        RETURN 'Error: ' || SQLERRM;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION VerifierDuplication(tableName VARCHAR, columnName VARCHAR)
RETURNS TABLE(duplicatedWith VARCHAR[]) AS $$
DECLARE
    columnInfo RECORD;
    otherColumnInfo RECORD;
    isDuplicatedFlag BOOLEAN;
    duplicatedColumns VARCHAR[];
BEGIN
    -- Get the information of the specified column
    SELECT column_name::VARCHAR, ordinal_position, data_type INTO columnInfo
    FROM information_schema.columns WHERE table_name = lower(tableName) AND column_name = lower(columnName);

    FOR otherColumnInfo IN SELECT column_name::VARCHAR FROM information_schema.columns WHERE table_name = lower(tableName) AND ordinal_position > columnInfo.ordinal_position
        AND data_type = columnInfo.data_type LOOP
        EXECUTE format('SELECT NOT EXISTS (SELECT 1 FROM %I WHERE (%I IS DISTINCT FROM %I) 
        OR (%I IS NULL AND %I IS NOT NULL) OR (%I IS NOT NULL AND %I IS NULL))', tableName, columnInfo.column_name, otherColumnInfo.column_name, columnInfo.column_name, otherColumnInfo.column_name, 
                                                    columnInfo.column_name, otherColumnInfo.column_name) INTO isDuplicatedFlag;
        IF isDuplicatedFlag THEN
            duplicatedColumns := array_append(duplicatedColumns, otherColumnInfo.column_name);
        END IF;
    END LOOP;

    RETURN QUERY SELECT duplicatedColumns;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION compute_mean_numeric(Nom_COL VARCHAR, NOMTAB VARCHAR) RETURNS NUMERIC AS
$$
DECLARE
  Query    VARCHAR(2000);
  avg_num  NUMERIC(10,2);
BEGIN 
  Query := 'SELECT AVG(' || Nom_COL || '::NUMERIC) FROM ' || NOMTAB;
  EXECUTE Query INTO avg_num;
  RETURN avg_num; 
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION compute_std_numeric (Nom_COL VARCHAR, NOMTAB VARCHAR) RETURNS NUMERIC AS
$$
DECLARE
  Query VARCHAR(2000);
  std NUMERIC(10,2);
BEGIN 
  Query := 'SELECT STDDEV(' || Nom_COL || '::NUMERIC) FROM ' || NOMTAB;
  EXECUTE Query INTO std;
  RETURN std; 
EXCEPTION
  WHEN OTHERS THEN
    RETURN -1;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION count_outliers(NOMTAB VARCHAR, Nom_COL VARCHAR, z_threshold NUMERIC) RETURNS INTEGER AS
$$
DECLARE
    Query VARCHAR(2000);
    mean_num NUMERIC(10,2);
    std_dev NUMERIC(10,2);
    outlier_count INTEGER := 0;
    column_type VARCHAR;
BEGIN

    column_type := TypeDesColonne(NOMTAB, Nom_COL);
    IF column_type NOT IN ('integer', 'bigint', 'numeric', 'real', 'double precision') THEN
        RETURN -1; 
    END IF;

    -- calcule la moyenne et l'écart type
    mean_num := compute_mean_numeric(Nom_COL, NOMTAB);
    std_dev := compute_std_numeric(Nom_COL, NOMTAB);


    --Calcule le z-score et compte les outliers
    Query := 'SELECT COUNT(*) FROM ' || NOMTAB || ' WHERE ABS((' || Nom_COL || '::NUMERIC - $1) / $2) > $3';
    EXECUTE Query INTO outlier_count USING mean_num, std_dev, z_threshold;

    RETURN outlier_count;

END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION COUNT_DOUBLONS(NomTab VARCHAR, AttributsCle TEXT DEFAULT '')
RETURNS INT AS $$
DECLARE
    ConcatAttributsCle VARCHAR(1000);
    DoublonsCount INT;
    Query VARCHAR(1000);
BEGIN
    ConcatAttributsCle := REPLACE(AttributsCle, ',', ' || ');
 
    -- Count the number of duplicates
    Query := 'SELECT COUNT(*) FROM (
                  SELECT ' || ConcatAttributsCle || ', COUNT(*) as count
                  FROM ' || NomTab || '
                  GROUP BY ' || ConcatAttributsCle || '
                  HAVING COUNT(*) > 1
              ) as duplicates';
    EXECUTE Query INTO DoublonsCount;
 
    RETURN DoublonsCount;
END;
$$ LANGUAGE plpgsql;



-- update function
CREATE OR REPLACE FUNCTION DiagnoticDeNULLs (NOMTAB VARCHAR, Nom_COL VARCHAR) RETURNS
TABLE(id_ligne INTEGER, Nom_colonne TEXT)
AS
$$
DECLARE
Q VARCHAR(2000);
NbValNulles INTEGER;
BEGIN
Q := 'SELECT ' || NOMTAB || '_id, ''' || Nom_COL || ''' FROM ' || NOMTAB || ' WHERE ' || Nom_COL || ' IS NULL';
IF (TypeDesColonne(NOMTAB, NOM_COL) = 'character varying') THEN
Q := Q || ' OR (' || Nom_COL || ' IN (''MISSINGVALUE'',''NULL'', ''-'', ''='', ''!'', ''?'',''nan'', ''''))';
END IF;
RETURN QUERY EXECUTE Q;
END;
$$ LANGUAGE plpgsql;

-- FUNCTION 3:
DROP FUNCTION IF EXISTS values_not_matching_regex(VARCHAR, VARCHAR, VARCHAR);
CREATE OR REPLACE FUNCTION values_not_matching_regex(NOMTAB VARCHAR, NOMCOL VARCHAR, REGEX VARCHAR)
RETURNS TABLE (id_ligne INTEGER, nom_colonne TEXT, valeur_colonne VARCHAR)
AS
$$
DECLARE
    Q VARCHAR(1000);
BEGIN
    Q := 'SELECT ' || NOMTAB || '_id, ''' || NOMCOL || ''', ' || NOMCOL || ' FROM ' || NOMTAB || ' WHERE ' || NOMCOL || ' ~ ''' || REGEX || '''';
    RAISE NOTICE 'Query: %', Q; 
    RETURN QUERY EXECUTE Q;
END;
$$ LANGUAGE plpgsql;


DROP FUNCTION IF EXISTS email_not_matching_regex(VARCHAR, VARCHAR);
CREATE OR REPLACE FUNCTION email_not_matching_regex(NOMTAB VARCHAR, NOMCOL VARCHAR)
RETURNS TABLE (id_ligne INTEGER, nom_colonne TEXT, valeur_colonne VARCHAR)
AS
$$
DECLARE
    Q VARCHAR(1000);
BEGIN
    Q := 'SELECT ' || NOMTAB || '_id, ''' || NOMCOL || ''', ' || NOMCOL || ' FROM ' || NOMTAB || ' WHERE LOWER(' || NOMCOL || ') !~ ''^([a-zA-Z0-9_\-]+\.)*[a-zA-Z0-9_\-]+@([a-zA-Z0-9_\-]+\.)+(com|org|edu|net|ca|au|coop|de|ee|es|fm|fr|gr|ie|in|it|jp|me|nl|nu|ru|uk|us|za)$''';
    RAISE NOTICE 'Query: %', Q; 
    RETURN QUERY EXECUTE Q;
END;
$$ LANGUAGE plpgsql;


DROP FUNCTION IF EXISTS numerique_not_matching_regex(VARCHAR, VARCHAR);
CREATE OR REPLACE FUNCTION numerique_not_matching_regex(NOMTAB VARCHAR, NOMCOL VARCHAR)
RETURNS TABLE (id_ligne INTEGER, nom_colonne TEXT, valeur_colonne VARCHAR)
AS
$$
DECLARE
    Q VARCHAR(1000);
BEGIN
    Q := 'SELECT ' || NOMTAB || '_id, ''' || NOMCOL || ''', ' || NOMCOL || ' FROM ' || NOMTAB || ' WHERE LOWER(' || NOMCOL || ') !~ ''^-?\d*\.?\d+$''';
    RAISE NOTICE 'Query: %', Q; 
    RETURN QUERY EXECUTE Q;
END;
$$ LANGUAGE plpgsql;


-- cette fonction permet de récupérer les anomalies en fonction d'une base de faits
--paramètres:
    -- NOMTAB : table contenant des anomalies
    -- COl1: colonne de la table NOMTAB pouvant contenir des anomalies
    -- NOMTAB_BF : une table contenant la base de faits 
    -- COL2: colonne de la table NOMTAB_BF avec qui on compare avec COL 1
CREATE OR REPLACE FUNCTION GetAnomaliesBasedOn (NOMTAB VARCHAR, COL1 VARCHAR, NOMTAB_BF VARCHAR, COL2 VARCHAR) RETURNS TABLE (id_ligne INTEGER, anomalies VARCHAR) AS 
$$
DECLARE 
    Q VARCHAR(1000);
BEGIN 
    Q:= 'SELECT ' || NOMTAB || '_id,' || COL1 || ' FROM ' || NOMTAB || ' WHERE ' || COL1 || ' IN (
            SELECT ' || COL1 || ' FROM ' || NOMTAB ||  ' EXCEPT SELECT ' || COL2 || ' FROM ' || NOMTAB_BF || ')';


    RETURN QUERY EXECUTE Q;
    
END;
$$ LANGUAGE plpgsql;



-- cette fonction permet de traduire le nom d'un pays dans une autre langue (fr, en)
--paramètres:
    -- country : le nom du pays
    -- langue : la langue souhaitée ('fr', 'en')
DROP FUNCTION IF EXISTS GetAnomaliesBasedOn(VARCHAR, VARCHAR, VARCHAR, VARCHAR);
CREATE OR REPLACE FUNCTION GetAnomaliesBasedOn (NOMTAB VARCHAR, COL1 VARCHAR, NOMTAB_BF VARCHAR, COL2 VARCHAR) RETURNS TABLE (id_ligne INTEGER, anomalies TEXT) AS 
$$
DECLARE 
    Q VARCHAR(1000);
BEGIN 
    Q:= 'SELECT ' || NOMTAB || '_id,' || COL1 || '::TEXT FROM ' || NOMTAB || ' WHERE UPPER(' || COL1 || ') IN (
            SELECT UPPER(' || COL1 || ') AS '|| COL1 || ' FROM ' || NOMTAB ||  ' EXCEPT SELECT UPPER(' || COL2 || ') AS '|| COL1 || ' FROM ' || NOMTAB_BF || ')';

	RAISE NOTICE '%', Q;
    RETURN QUERY EXECUTE Q;
    
END;
$$ LANGUAGE plpgsql;


-- translate

CREATE OR REPLACE FUNCTION translateCountryName(country TEXT, langue TEXT)
RETURNS TEXT AS $$
DECLARE
    traduction TEXT;
BEGIN
    IF langue = 'fr' THEN
        SELECT nom_pays_fr INTO traduction FROM bf_pays_continent WHERE UPPER(nom_pays_en) = UPPER(country) LIMIT 1;
    ELSIF langue = 'en' THEN
        SELECT nom_pays_en INTO traduction FROM bf_pays_continent WHERE UPPER(nom_pays_fr) = UPPER(country) LIMIT 1;
    END IF;

    IF traduction IS NOT NULL THEN
        RETURN traduction;
    ELSE
        RETURN '';
    END IF;
END;
$$ LANGUAGE plpgsql;
-- cette fonction permet de suggérer des corrections pour les pays en fonction de la table contenant des anomalies
--paramètres:
    -- nom_table: la table contenant des anomalies
    -- col1 : reprèsente la colonne pays contenant des anomalies
    -- seuil: entre (0 et 1) pour choisir les scores de similarité superieur à celui ci
    -- langue : la langue souhaitée pour la suggestion

DROP FUNCTION IF EXISTS GetAnomaliesSuggestionsForCountry(VARCHAR, VARCHAR, FLOAT, VARCHAR);
CREATE OR REPLACE FUNCTION GetAnomaliesSuggestionsForCountry(
    nom_table VARCHAR,
    col1 VARCHAR,
    seuil FLOAT,
    langue VARCHAR DEFAULT 'fr'
) RETURNS TABLE (
    id_ligne INTEGER,
    anomaly TEXT,
    suggest VARCHAR,
    code_2l VARCHAR,
    code_3l VARCHAR,
    jw_nom_pays FLOAT,
    jw_nom_pays_traduit FLOAT,
    jw_code_2l FLOAT,
    jw_code_3l FLOAT,
	jw_sans_car_spec FLOAT
) AS $$
DECLARE
    nom_pays_col VARCHAR;
    query VARCHAR;
BEGIN


     IF langue = 'fr' THEN
        nom_pays_col := 'nom_pays_fr';
    ELSE
        nom_pays_col := 'nom_pays_en';
    END IF;

    query := '

        SELECT * FROM 

    (SELECT
        an.id_ligne,
        an.anomalies, '
        || nom_pays_col || ',
        bf.code_2l,
        bf.code_3l,
        jarowinkler(bf.' || nom_pays_col || ', an.anomalies) AS jw_nom_pays,
        jarowinkler(bf.' || nom_pays_col || ', translateCountryName(an.anomalies, ''' || langue || ''')) AS jw_nom_pays_traduit,
        jarowinkler(bf.code_2l, an.anomalies) AS jw_code_2l,
        jarowinkler(bf.code_3l, an.anomalies) AS jw_code_3l,
		jarowinkler(bf.' || nom_pays_col || ', regexp_replace(an.anomalies, ''[^A-Za-z0-9]+'', '''', ''g'')) AS jw_sans_car_spec
    FROM
        GetAnomaliesBasedOn(''' || nom_table || ''', ''' || col1 || ''', '' bf_pays_continent '', ''' || nom_pays_col || ''') an
    CROSS JOIN
        bf_pays_continent bf ) R
    WHERE
        R.jw_code_2l = 1.0 OR
        R.jw_code_3l = 1.0 OR
        R.jw_nom_pays_traduit = 1.0 OR
        R.jw_nom_pays > ' || seuil || ' OR 
        R.jw_sans_car_spec > ' || seuil || '
    ORDER BY
        GREATEST(R.jw_nom_pays,R.jw_nom_pays_traduit, R.jw_code_2l, R.jw_code_3l, R.jw_sans_car_spec) DESC;';
    


    RETURN QUERY EXECUTE query;

END;
$$ LANGUAGE plpgsql;


-- cette fonction  générique permet de suggérer des corrections pour une colonne données en fonction de la table contenant des anomalies et la base des faits
--paramètres:
    -- nom_table: la table contenant des anomalies
    -- col1 : reprèsente la colonne pays contenant des anomalies
    -- nom_table_faits : une table contenant la base de faits 
    -- col2: colonne de la table nom_table_faits avec qui on compare avec COL 1
    -- seuil: entre (0 et 1) pour choisir les scores de similarité superieur à celui ci

DROP FUNCTION IF EXISTS GetAnomaliesSuggestions(VARCHAR, VARCHAR, VARCHAR, VARCHAR, FLOAT);
CREATE OR REPLACE FUNCTION GetAnomaliesSuggestions(
    nom_table VARCHAR,
    col1 VARCHAR,
    nom_table_faits VARCHAR,
    col2 VARCHAR,
    seuil FLOAT

) RETURNS TABLE (
    id_ligne INTEGER,
    anomaly TEXT,
    suggest VARCHAR,
    jw FLOAT
    
) AS $$
DECLARE
    query VARCHAR;
BEGIN

    query := '

        SELECT DISTINCT * FROM 

    (SELECT
        an.id_ligne,
        an.anomalies, '
        || col2 || ',
        jarowinkler(' || col2 || ', an.anomalies) AS jw
    
    FROM
        GetAnomaliesBasedOn(''' || nom_table || ''', ''' || col1 || ''', ''' || nom_table_faits || ''', ''' || col2 || ''') an
    CROSS JOIN
        ' || nom_table_faits ||') R
    WHERE
        R.jw > ' || seuil || '
    ORDER BY R.jw DESC;';
    

    RETURN QUERY EXECUTE query;

END;
$$ LANGUAGE plpgsql;