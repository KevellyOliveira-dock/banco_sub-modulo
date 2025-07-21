#!/bin/bash

/opt/mssql/bin/sqlservr &

echo "Aguardando SQL Server iniciar..."

until /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P 'A!ntegr@ti0n_DB4241' -Q "SELECT 1" &>/dev/null; do
  sleep 1
done

echo "Restaurando bases... "

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
WHERE id_emissor IN (0, 4, 5, 8, 14, 26, 30, 31, 32, 55, 63, 64, 68, 69, 70, 73, 81, 83, 84, 85, 86, 87, 88,
                     89, 92, 96, 97, 101, 103, 104, 105, 106, 108, 109, 110, 111, 112, 113, 114, 116,
                     117, 118, 119, 120, 121, 122, 123, 126, 127, 128, 129, 130, 131, 132, 133, 135,
                     136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151,
                     152, 153, 154, 155, 156, 157, 158, 159, 161, 162, 163, 164, 165, 166, 167, 168,
                     169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 180, 182, 183, 184, 185, 186,
                     187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202,
                     203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218,
                     219, 220, 221, 222, 223, 224, 225, 226, 227, 228, 229, 230, 231, 232, 233, 234,
                     235, 236, 237, 238, 239, 240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250,
                     251, 252, 253, 255, 256, 258, 260, 261, 262, 263, 264, 265, 266, 269, 270, 271,
                     272, 273, 274, 275, 276, 278, 279, 280, 281, 282, 283, 285, 287, 288, 289, 290,
                     291, 292, 293, 294, 295, 296, 297, 298, 299, 300, 301, 302, 303, 304, 305, 306,
                     307, 310, 311, 312, 313, 314, 315, 316, 317, 318, 319, 360, 364, 366, 367, 383,
                     392, 413, 414, 415, 416, 417, 419, 420, 428, 430, 432, 434, 435, 436, 437, 438,
                     440, 441, 442, 444, 446, 447, 448, 449, 450, 451, 452, 453, 454, 455, 456, 457,
                     458, 459, 460, 461, 462, 463, 464, 465, 466, 467, 468, 470, 471, 472, 473, 475,
                     476, 477, 478, 479, 480, 481, 482, 483, 484, 485, 486, 487, 488, 489, 490, 491,
                     492, 493, 494, 495, 496, 497, 498, 499, 501, 502, 503, 504, 505, 506, 507, 508,
                     509, 510, 511, 512, 513, 514, 515, 516, 517, 518, 519, 520, 521, 522, 523, 524,
                     525, 526, 527, 528, 530, 532, 534, 535, 536, 537, 538, 539, 599, 680, 689, 730,
                     777, 841, 870, 890, 920, 1000, 1001, 1142, 1164, 1195, 1370, 1434, 1492, 1501,
                     1666, 1800, 2870, 2930, 16789, 3041, 28501, 20999, 20549, 2250, 23452, 2380,
                     23816, 2400, 2421, 2461, 2471, 26516, 2690, 2761, 2830, 2851, 3151, 32123, 3251,
                     3252, 3253, 32712, 3302, 3562, 4200, 6435, 8591, 8692, 8823, 8888, 9090, 10857,
                     10866, 14131, 255166, 247166, 64164, 225166, 235166, 248166, 7344, 7340, 25891,
                     2551660, 8866, 60020, 15601560);"

echo "Bases restauradas e atualização concluída com sucesso!"

wait