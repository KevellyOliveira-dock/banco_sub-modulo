#!/bin/bash

/opt/mssql/bin/sqlservr &
# Inicia o SQL Server em segundo plano para que o restante do script possa continuar executando

echo "Aguardando SQL Server iniciar..."

# Loop que tenta se conectar ao SQL Server até obter sucesso
until /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P 'A!ntegr@ti0n_DB4241' -Q "SELECT 1" &>/dev/null; do
  sleep 1
done

echo "Restaurando bases..."

# IMPORTANTE:
# Por que fazer o RESTORE?
# - Arquivos .bak são cópias compactadas dos bancos de dados.
# - Eles precisam ser "restaurados" para gerar arquivos físicos reais: .mdf (dados), .ldf (log) e .ndf (dados adicionais).
# - O SQL Server só consegue acessar bancos que estejam nesses formatos e nos caminhos corretos.
# - Por isso usamos a cláusula WITH MOVE para indicar onde os arquivos devem ser recriados dentro do container.

# O comando abaixo restaura os dois bancos de dados usando sqlcmd
/opt/mssql-tools/bin/sqlcmd -b -S localhost -U SA -P 'A!ntegr@ti0n_DB4241' -Q "
-- Restaura o banco PIER_BASE_CONTAINER
RESTORE DATABASE PIER_BASE_CONTAINER
FROM DISK = '/var/opt/mssql/backup/PIER_BASE_CONTAINER.bak'
WITH
  MOVE 'PIER_HMLG_EXT' TO '/var/opt/mssql/data/PIER_BASE_CONTAINER_Data01.mdf',
  MOVE 'PIER_HMLG_EXT_log' TO '/var/opt/mssql/data/PIER_BASE_CONTAINER_Log.ldf',
  REPLACE;

-- Restaura o banco EMISSOR_BASE_CONTAINER (possui múltiplos arquivos de dados e índices)
RESTORE DATABASE EMISSOR_BASE_CONTAINER
FROM DISK = '/var/opt/mssql/backup/EMISSOR_BASE_CONTAINER.bak'
WITH
  MOVE 'DockBaaS_Data01'      TO '/var/opt/mssql/data/EMISSOR_BASE_CONTAINER_Data01.mdf',
  MOVE 'DockBaaS_Data02'      TO '/var/opt/mssql/data/EMISSOR_BASE_CONTAINER_Data02.ndf',
  MOVE 'DockBaaS_Data03'      TO '/var/opt/mssql/data/EMISSOR_BASE_CONTAINER_Data03.ndf',
  MOVE 'DockBaaS_Data04'      TO '/var/opt/mssql/data/EMISSOR_BASE_CONTAINER_Data04.ndf',
  MOVE 'DockBaaS_DataCDC01'   TO '/var/opt/mssql/data/EMISSOR_BASE_CONTAINER_DataCDC01.ndf',
  MOVE 'DockBaaS_DataCDC02'   TO '/var/opt/mssql/data/EMISSOR_BASE_CONTAINER_DataCDC02.ndf',
  MOVE 'DockBaaS_DataCDC03'   TO '/var/opt/mssql/data/EMISSOR_BASE_CONTAINER_DataCDC03.ndf',
  MOVE 'DockBaaS_DataCDC04'   TO '/var/opt/mssql/data/EMISSOR_BASE_CONTAINER_DataCDC04.ndf',
  MOVE 'DockBaaS_Index01'     TO '/var/opt/mssql/data/EMISSOR_BASE_CONTAINER_Index01.ndf',
  MOVE 'DockBaaS_Index02'     TO '/var/opt/mssql/data/EMISSOR_BASE_CONTAINER_Index02.ndf',
  MOVE 'DockBaaS_Index03'     TO '/var/opt/mssql/data/EMISSOR_BASE_CONTAINER_Index03.ndf',
  MOVE 'DockBaaS_Index04'     TO '/var/opt/mssql/data/EMISSOR_BASE_CONTAINER_Index04.ndf',
  MOVE 'DockBaaS_Log'         TO '/var/opt/mssql/data/EMISSOR_BASE_CONTAINER_Log.ldf',
  REPLACE;
"


# Ele espera até que o banco fique ONLINE. Assim que a condição for verdadeira (ONLINE aparece), o loop para.
echo "Esperando PIER_BASE_CONTAINER ficar online..."
until /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P 'A!ntegr@ti0n_DB4241' -Q "
SELECT state_desc FROM sys.databases WHERE name = 'PIER_BASE_CONTAINER'
" | grep -q "ONLINE";
do
  sleep 1
done

echo "Executando UPDATE após RESTORE..."
/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P 'A!ntegr@ti0n_DB4241' -d PIER_BASE_CONTAINER -Q "
UPDATE bases
SET servidor = 'bancos-pier-emissor',
    servidor_controle_acesso = 'bancos-pier-emissor',
    nome_base = 'EMISSOR_BASE_CONTAINER',
    servidor_usuarios = 'bancos-pier-emissor',
    usuario = 'SA',
    senha = 'A!ntegr@ti0n_DB4241'
WHERE id_emissor IN (8,14,26,30,31,32,55,63,64,68,69,73,81,83,84,85,
                    86,87,88,89,92,96,97,101,103,104,106,108,109,110,
                    111,112,113,114,116,117,118,119,120,121,122,123,
                    126,127,128,129,130,131,132,135,136,137,138,139,
                    140,141,143,144,145,146,147,148,149,150,151,152,
                    154,155,156,157,158,159,161,162,163,164,165,166,
                    168,169,170,171,172,173,174,175,177,178,180,182,
                    183,184,185,186,187,188,189,190,191,194,195,196,
                    197,198,199,200,201,202,203,204,205,206,207,208,
                    209,210,211,212,213,214,215,216,217,218,219,220,
                    221,222,223,224,225,227,228,229,230,231,232,233,
                    234,235,236,238,239,240,241,242,243,244,246,247,
                    249,250,251,255,256,258,260,261,262,263,264,265,
                    266,269,270,271,272,273,274,275,276,278,279,280,
                    281,282,283,285,287,288,289,290,291,292,293,318,
                    295,296,297,298,299,300,302,303,304,305,306,307,
                    310,311,312,313,314,315,316,317,318,319,360,364,
                    366,367,383,413,414,415,416,417,419,434,435,436,
                    437,438,440,441,442,444,446,447,448,449,450,451,
                    452,453,454,455,456,457,458,459,460,461,462,463,
                    464,465,466,467,468,470,471,472,473,475,476,477,
                    478,479,480,482,483,484,485,486,487,488,489,490,
                    119,168,147,155,109,216,184,173,208,152,194,175,
                    166,192,167,183,180,209,1142,189,153,220,165,222,
                    113,213,140,237,219,218,156,232,133,182,234,145,
                    215,112,123,148,176,190,221,207,226,231,229,157,
                    195,193,171,141,164,174,210,199,128,103,106,127,
                    137,130,138,120,197,96,108,118,135,101,104,114,
                    142,154,129,185,121,144,211,163,243,240,200,143,
                    136,159,245,246,251,249,244,227,214,248,252,73,
                    64,212,89,253,162,5,63,250,236,300,260,235,202,
                    205,261,262,263,264,87,255,87,246,32,266,276,225,
                    1195,265,270,271,258,88,272,1501,110,291,274,279,
                    278,280,293,291,1800,282,296,86,87,32,87,315,14,
                    316,360,420,392,366,88,159,367,86,419,32,239,295,
                    275,32,285,246,87,246,287,301,256,247,97,88,116,
                    293,64,285,85,32,86,116,89,86,317,240,438,313,307
                    ,97,291,103,32,599,299,64,73,73,14,295,428,419,246,
                    437,440,159,116,116,116,116,437,283,238,419,244,305,
                    444,419,84,298,432,242,304,275,85,299,383,448,238,
                    159,441,88,3562,450,299,415,88,88,88,159,87,455,89,
                    289,416,442,311,458,454,316,310,414,451,456,137,456,
                    413,437,32,4,8,81,73,87,85,103,14,106,137,144,116,105,
                    84,86,118,154,97,92,8866,2250,23816,138,185,239,240,96,
                    64164,55,225166,8823,248166,1434,119,247166,14131,83,
                    7344,7340,258,217,25891,255166,88,235166,2551660,870,89,
                    3252,8692,6435,680,2471,69,2690,276,225,242,238,126,2830,
                    8591,2461,2870,246,689,88,8888,139,730,890,198,64,64,109,
                    247,283,215,920,1370,2761,161,241,292,2930,222,70,140,0,
                    20549,266,291,777,3151,1492,318,1001,155,301,16789,392,
                    419,367,311,141,199,428,1164,415,10857,313,10866,2421,
                    3041,437,3251,3253,295,256,444,841,122,2380,432,1666,
                    28501,383,26516,448,2851,32123,32712,450,23452,455,159,
                    1000,249,460,449,461,462,464,417,466,314,463,312,14,159,
                    159,32,448,84,116,467,238,242,238,238,468,470,471,103,159,
                    159,2400,223,31,291,291,453,475,281,281,477,476,256,478,32,
                    480,85,481,20999,223,281,444,92,137,92,383,432,430,482,472,
                    109,109,109,287,485,103,97,97,97,483,455,460,486,87,87,291,
                    294,318,484,488,419,8,225,64,87,92,86,222,137,92,14,242,73,
                    238,239,3302,489,235,494,175,305,448,490,491,383,490,291,223,
                    238,238,417,310,491,496,486,417,116,495,15601560,492,242,281,
                    495,493,144,159,493,498,246,223,496,103,503,137,499,498,492,
                    211,502,32,503,497,497,497,501,492,441,501,492,504,275,505,
                    103,419,192,502,504,505,281,366,291,223,129,242,455,455,383,
                    507,416,463,505,239,240,508,448,420,420,509,510,60020,185,85,
                    506,185,185,88,287,512,88,511,64,175,8,85,14,87,513,513,513,
                    513,242,514,515,516,83,73,256,258,484,518,517,519,247,499,499,
                    507,521,522,73,73,420,523,524,311,299,525,526,520,511,14,87,88,
                    413,527,242,103,238,520,9090,64,528,294,275,87,242,85,86,238,32,
                    501,88,530,530,86,294,318,532,116,534,64,536,535,537,539,88,501,538);"

echo "Bases restauradas e atualização concluída com sucesso!"

# Observação:
# A cláusula REPLACE força a sobrescrita do banco de dados se ele já existir.
# Isso é útil em ambientes de desenvolvimento ou teste, onde você quer garantir que os dados sejam sempre restaurados do zero.

wait
# Aguarda o processo do SQL Server que está rodando em segundo plano
# Isso impede que o container finalize a execução imediatamente após o script terminar
