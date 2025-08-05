#include <a_samp>
#if defined _SYSTEM_VEHICLE
	#endinput
#endif
#define _SYSTEM_VEHICLE

#define GetVehicleInfo(%0,%1)		g_vehicle_info[%0][%1]
#define GetVehicleName(%0)			GetVehicleInfo(GetVehicleData(%0, V_MODELID)-400, VI_NAME)

#define GetVehicleData(%0,%1)		g_vehicle_data[%0][%1]
#define SetVehicleData(%0,%1,%2)	g_vehicle_data[%0][%1] = %2
#define ClearVehicleData(%0)		g_vehicle_data[%0] = g_vehicle_default_values
#define IsValidVehicleID(%0)		(1 <= %0 < MAX_VEHICLES)

#define GetVehicleParamEx(%0,%1) g_vehicle_params[%0][%1]

#define VEHICLE_ACTION_TYPE_NONE 	-1
#define VEHICLE_ACTION_ID_NONE 		-1

#define VEHICLE_PARAM_ON	(1)
#define VEHICLE_PARAM_OFF	(0)

native IsValidVehicle(vehicleid);

enum E_VEHICLE_STRUCT
{
	V_MODELID,
	Float: V_SPAWN_X,
	Float: V_SPAWN_Y,
	Float: V_SPAWN_Z,
	Float: V_SPAWN_ANGLE,
	V_COLOR_1,
	V_COLOR_2,
	V_RESPAWN_DELAY,
	V_ADDSIREN,
	V_ACTION_TYPE,
	V_ACTION_ID,
	V_DRIVER_ID,
	V_LIMIT,
	V_ALARM,
	Float: V_FUEL,
	Float: V_MILEAGE,
	Text3D: V_LABEL,
	Float: V_HEALTH,
	V_LAST_LOAD_TIME,
	V_ACTION_OWNER,
};

// ------------------------------------
enum E_VEHICLE_PARAMS_STRUCT
{
	V_ENGINE, 	// äâèãàòåëü
	V_LIGHTS, 	// ôàðû
	V_ALARM,	// ñèãíàëèçàöèÿ
	V_LOCK, 	// äâåðè
	V_BONNET, 	// êàïîò
	V_BOOT, 	// áàãàæíèê
	V_OBJECTIVE // îòîáðàæåíå ñòðåëêè
};

// ------------------------------------
enum E_VEHICE_INFO_STRUCT
{
	VI_NAME[99],	// íàçâàíèå
 	VI_PRICE,		// ãîñ. ñòîèìîñòü
	VT_RENT_PRICE,	// ñòîèìîñòü àðåíäû
	VI_TYPE,		// òèï
	VI_MAXSP,       //ìàêñ ñêîðîñòü
 	VI_USCOR        //óñêîðåíèå 0-100
};

// ------------------------------------
new g_vehicle_data[MAX_VEHICLES][E_VEHICLE_STRUCT];
new 
	g_vehicle_default_values[E_VEHICLE_STRUCT] = 
{
	0,
	0.0,
	0.0,
	0.0,
	0.0,
	0,
	0,
	0,
	0,
	VEHICLE_ACTION_TYPE_NONE,
	VEHICLE_ACTION_ID_NONE,
	INVALID_PLAYER_ID,
	false,
	false,
	40.0,
	0.0,
	Text3D:-1,
	1000.0,
	0
};
new g_vehicle_params[MAX_VEHICLES][E_VEHICLE_PARAMS_STRUCT];

new const
    g_vehicle_info[212][E_VEHICE_INFO_STRUCT] = 
{//öåíà â òûñÿ÷àõ
    {"BMW X6M F16",              8200000,     8500, 2, 284, 4},     // 400
    {"VAZ 2101",             60000,      500,    0, 142, 22},     // 401
    {"Neesedes-Benz GT63s",          7000000,     6000,   2, 313, 3},     // 402
    {"Renault Premium",           1500000,          0,      0, 150, 15},     // 403
    {"VAZ 2107",            75000,      800,    0, 158, 17},     // 404
    {"Audi RS6 C7",   10000000,     8000,   1, 310, 4},     // 405
    {"ÇÈË 131 Ñàìîñâàë",    0,          0,      0},     // 406
    {"Ïîæàðêà",             0,          0,      0},     // 407
    {"Ìóñîðîâîç",           0,          0,      0},     // 408
    {"Ëèìóçèí",              0,   50000, 2},     // 409
    {"Mercedes-Benz CLS 2018",  10300000,     7800,   1, 305, 4},     // 410
    {"Aston Martin DB11",         18500000,     3800,   0, 322, 4},     // 411
    {"VAZ 2106",            83000,      600,    0, 160, 17},     // 412
    {"Gazelle 3221",             1500000,          0,      0, 130, 11},     // 413
    {"Àâòîáóñ",           0,          0,      0},     // 414
    {"Lamborghini Aventador S",             20000000,    15000,  2, 351, 3},     // 415
    {"Ñêîðàÿ",              0,          0,      0},     // 416
    {"Leviathn",            0,          0,      0},     // 417
    {"Volkswagen Multivan T6",            4000000,     6400,   0, 183, 9},     // 418
    {"Mercedes-Benz E420 W210",           700000,     5000,   1, 250, 6},     // 419
    {"Ïîä çàìåíó (405)",               0,          0,      0},     // 420
    {"Mercedes-Benz  S600 W140",          900000,     8000,   2, 250, 6},     // 421
    {"Chevrole. t",         0,     1000,   0},     // 422
    {"MrWhoop",             0,          0,      0},     // 423
    {"CMÇ",                 0,      100,    0},     // 424
    {"Hunter",              0,          0,      0},     // 425
    {"BMW M5 E39",            800000,    38000,  2, 246, 5},     // 426
    {"Èíêàñàòîð",            0,          0,      0},     // 427
    {"Èíêàñàòîð",           0,          0,      0},     // 428
    {"Mercedes-Benz GT-R",              13500000,    18000,  0, 319, 4},     // 429
    {"Predator",            0,          0,      0},     // 430
    {"Ëèàç 677",            0,          0,      0},     // 431
    {"Òàíê",                0,          0,      0},     // 432
    {"Ìàòû âîåíêà",        0,          0,      0},     // 433
    {"Hotknife",            0,     7000,   1},     // 434
    {"Ïðèöåï",              0,          0,      0},     // 435
    {"Mitsubishi Lancer Evo X",         2000000,    16500,  1, 239, 5},     // 436
    {"Èêàðóñ",              0,          0,      0},     // 437
    {"Òàêñè",               0,          0,      0},     // 438
    {"VAZ 2108",         170000,      350,    0, 160, 14},     // 439
    {"Mercedes-Benz V-Class W447",               6300000,     0,      0, 205, 9},     // 440
    {"RCcar",               0,          0,      0},     // 441
    {"Volvo V60",              3500000,      100,    0, 235, 6},     // 442
    {"Àâòîâîç",             0,          0,      0},     // 443
    {"Ìîíñòð",              0,          0,      0},     // 444
    {"Acura TSX",              1150000,     2400,   0, 256, 6},     // 445
    {"Squalo",              0,          0,      0},     // 446
    {"Âîäíûé âåðò",         0,          0,      0},     // 447
    {"Pizzaboy",            0,          0,      0},     // 448
    {"Ïðèöåï",            0,          0,      0},     // 449
    {"êðàø",              0,          0,      0},     // 450
    {"McLaren 600LT",             14000000,    22000,  2, 329, 3},     // 451
    {"Speeder",             0,          0,      0},     // 452
    {"Reefer",              0,          0,      0},     // 453
    {"ßõòà",                0,          0,      0},     // 454
    {"Ãðåéäåð",             0,          0,      0},     // 455
    {"ôñèí",            0,          0,      0},     // 456
    {"Ãîëüô êàð",           0,          0,      0},     // 457
    {"VAZ 2114",           195000,     2400,   0, 160, 13},     // 458
    {"èíêî",              0,          0,      0},     // 459
    {"Âîäí ñàìîëåò",        0,          0,      0},     // 460
    {"Ducati SuperSport S",            1830000,      700,    0, 240, 4},     // 461
    {"Racer Sport",          20000,      200,    0, 130, 10},     // 462
    {"Ducati XDiavel S",              3000000,     1200,   1, 260, 3},     // 463
    {"RCplane",             0,          0,      0},     // 464
    {"RCheli",              0,          0,      0},     // 465
    {"BMW M5 F90",             9500000,    28000,  2, 312, 3},     // 466
    {"Mercedes-Benz  S600 W140",              900000,      350,    0, 250, 6},     // 467
    {"Aprilla MXV 450",              90000,      400,    0, 200, 4},     // 468
    {"Sparrow",             0,          0,      0},     // 469
    {"òèãð",               0,          0,      0},     // 470
    {"Êâàäðîöèêë",          0,     1200,   1},     // 471
    {"Coastg",              0,          0,      0},     // 472
    {"Dinghy",              0,          0,      0},     // 473
    {"ñàìïîâêàÿ",              0,      600,    0},     // 474
    {"Audi Q7",   7000000,    14500,  1, 238, 6},     // 475
    {"Èñòðåáèòåëü",         0,          0,      0},     // 476
    {"Mazda RX-7",              1000000,     9000,   2, 249, 5},     // 477
    {"ñàìï",            0,      450,    0},     // 478
    {"GAZ Volga 2410",           80000,     2400,   0, 170, 17},     // 479
    {"BMW Z4 M40i",               4900000,    28000,  2, 259, 5},     // 480
    {"Âåëîñèïåä Àèñò",      0,       100,    0},     // 481
    {"èíêî",             0,     520000, 0},     // 482
    {"Mercedes-Benz Sprinter 319CDL",            5000000,          0,      0, 182, 10},     // 483
    {"Òåïëîõîä",            0,          0,      0},     // 484
    {"Ãàç Àýðî",            0,          0,      0},     // 485
    {"Áóëüäîçåð",           0,          0,      0},     // 486
    {"Âåðò",                0,          0,      0},     // 487
    {"News Âåðò",           0,          0,      0},     // 488
    {"Volvo XC90",      4200000,    19000,  1, 248, 6},     // 489
    {"Range Rover SVR",  10000000,    59000,  0, 262, 5},     // 490
    {"VAZ 2110",               190000,     8000,   1, 160, 13},     // 491
    {"VAZ 2109",            180000,     1800,   0, 162, 14},     // 492
    {"Jetmax",              0,          0,      0},     // 493
    {"BMW I8 EDrive",             12600000,    56000,  0, 320, 4},     // 494
    {"Ford Raptor F-150",          5757000,    15000,  1, 211, 6},     // 495
    {"Volkswagen Golf GTI2",              140000,      700,    0, 197, 8},     // 496
    {"Ïîë Âåðò",            0,          0,      0},     // 497
    {"Mercedes-Benz Sprinter",             300000,          0,      0, 137, 12},     // 498
    {"ÃÀÇ 53",              0,          0,      0},     // 499
    {"ÃÀÇ 69",              0,      400,    0},     // 500
    {"RCgobl",              0,          0,      0},     // 501
    {"Nissan GT-R R35",             7900000,    56000,  0, 319, 3},     // 502
    {"Dodge Demon SRT",             6100000,    56000,  0, 322, 3},     // 503
    {"Bloodra",             0,          0,      0},     // 504
    {"Cadillac Escalade",            7200000,    42000,  2, 248, 6},     // 505
    {"Porsche 911 Carrera S",            9000000,    29000,  2, 309, 4},     // 506
    {"Audi A4",              750000,     2400,   0, 238, 7},     // 507
    {"ÓÀÇ Áóõàíêà",         0,     1000,   0},     // 508
    {"Âåëîñèïåä 'Óðàë'",    0,       150,    0},     // 509
    {"Ãîðíûé Âåëîñèïåä",    0,      300,    0},     // 510
    {"Beagle",              0,          0,      0},     // 511
    {"Cropdast",            0,          0,      0},     // 512
    {"Stunt",               0,          0,      0},     // 513
    {"Êàìàç 54115",         0,          0,      0},     // 514
    {"ÊÀÇ",                 0,          0,      0},     // 515
    {"Volkswagen Polo",           850000,     1800,   0, 238, 8},     // 516
    {"ÐÀÔ Ëàòâèÿ",          0,     1500,   0},     // 517
    {"ÅÐÀÇ 977",            0,     1000,   0},     // 518
    {"Shamal",              0,          0,      0},     // 519
    {"Èñòðåáèòåëü",         0,          0,      0},     // 520
    {"BMW S 1000 RR",        7000000,      350,    0, 295, 3},     // 521
    {"Kawasaki Ninja H2R",             10000000,     6000,   2, 340, 3},     // 522
    {"Yamaha FZ-10",            4500000,      320,    0, 257, 3},     // 523
    {"Öåìåíòîâîç",          0,          0,      0},     // 524
    {"Ýâàêóàòîð",           0,          0,      0},     // 525
    {"Infiniti Q60S",             3200000,     1600,   0, 266, 5},     // 526
    {"BMW M3 E46",             1050000,     2400,   0, 246, 5},     // 527
    {"Òðóïîâîç",            0,          0,      0},     // 528
    {"VAZ 2172",             300000,     2500,   0, 183, 11},     // 529
    {"Ïîãðóçùèê",           0,          0,      0},     // 530
    {"Òðàêòîð",             0,          0,      0},     // 531
    {"Êîìáàéí",             0,          0,      0},     // 532
    {"Audi R8 V10",             11000000,    15000,  1, 322, 3},     // 533
    {"BMW M3 E30",           300000,     4000,   1, 239, 7},     // 534
    {"Slamvan",             0,     4000,   1},     // 535
    {"Volvo 242DL",               250000,     3500,   1, 176, 11},     // 536
    {"Ïîåçä",               0,          0,      0},     // 537
    {"Ïîåçä",               0,          0,      0},     // 538
    {"Âîçä Ïîäóøêà",        0,          0,      0},     // 539
    {"Mazda Sedan 3",            380000,     1800,   0, 218, 8},     // 540
    {"Ferrari 488 GTB",              17500000,    42000,  2, 336, 3},     // 541
    {"Niva Urban",            350000,     1300,   0, 140, 17},     // 542
    {"Chevrolette Camaro ZL1",              4600000,    48000,  0, 315, 4},     // 543
    {"Ïîæàðêà",             0,          0,      0},     // 544
    {"Ìîñêâè÷ 400",         0,      100,    0},     // 545
    {"Hyundai Solaris 2021",            830000,      600,    0, 200, 9},     // 546
    {"Toyota Mark II",           420000,      600,    0, 223, 9},     // 547
    {"Âîåí Âåðò",           0,          0,      0},     // 548
    {"VAZ 1111",             30000,      35,     0, 120, 24},     // 549
    {"Toyota Camry 3.5",             2400000,     1400,   0, 247, 6},     // 550
    {"Alfa Romeo Gullia",           3000000,     110,    0, 306, 4},     // 551
    {"Ôóðãîí óáîðù",        0,     2100,   0},     // 552
    {"Êóêóðóçíèê",          0,          0,      0},     // 553
    {"ÓÀÇ 3303",            0,          0,      0},     // 554
    {"ZAZ 968",             20000,      50,     0, 118, 32},     // 555
    {"Ìîíñòð",              0,          0,      0},     // 556
    {"Ìîíñòð",              0,          0,      0},     // 557
    {"BMW M4 F84",              5500000,     4500,   1, 261, 4},     // 558
    {"òî æå, ÷òî è 547",       0,    16000,  1},     // 559
    {"Subaru WRX STI",              2200000,    26500,  1, 246, 6},     // 560
    {"Ìîñêâè÷ 427",         0,      600,    0},     // 561
    {"Nissan Skyline R34",               680000,    25000,  2, 250, 5},     // 562
    {"Ñïàñ âåðò",           0,          0,      0},     // 563
    {"RCtank",              0,          0,      0},     // 564
    {"Mercedes-Benz A45 AMG",            2800000,     1700,   0, 250, 5},     // 565
    {"ÂÀÇ 2104",            0,     1000,   0},     // 566
    {"Savana",              0,     2000,   0},     // 567
    {"Bandito",             0,      500,    0},     // 568
    {"Âàãîí",               0,          0,      0},     // 569
    {"Âàãîí",               0,          0,      0},     // 570
    {"Êàðò",                0,          0,      0},     // 571
    {"Ãàçîíîêîñèëêà",       0,          0,      0},     // 572 
    {"Ðàëëè Ãðóçîâêè",      0,    20000,  0},     // 573
    {"Óáîðø óëèö",          0,          0,      0},     // 574
    {"ÃÀÇ 20",              0,      600,    0},     // 575
    {"ÀÇËÊ 408",            0,      600,    0},     // 576
    {"AT 400",              0,          0,      0},     // 577
    {"ÇÈË Áîðò",            0,          0,      0},     // 578
    {"Mercedes-Benz G65 AMG",             17050000,    48000,  0, 223, 5},     // 579
    {"ÃÀÇ 13",              0,    15000,  0},     // 580
    {"Suzuki GSX-R750",              8000000,      700,    0, 276, 3},     // 581
    {"ÑÌÈ Ôóðã",          0,          0,      0},     // 582
    {"Tug",                 0,          0,      0},     // 583
    {"Öèñòåðíà",            0,          0,      0},     // 584
    {"VAZ 2115",             210000,     2800,   0, 160, 13},     // 585
    {"Yamaha YZF-R6",   5000000,      400,    0, 260, 3},     // 586
    {"Ford Focus RS",               1800000,    24000,  0, 265, 5},     // 587
    {"Ëèàç Êàôå",           0,          0,      0},     // 588
    {"Volkswagen Golf GTI",                1400000,    12400,  0, 250, 7},     // 589
    {"Âàãîí",               0,          0,      0},     // 590
    {"Ïðèöåï",              0,          0,      0},     // 591
    {"Androm",              0,          0,      0},     // 592
    {"Dodo",                0,          0,      0},     // 593
    {"RCcam",               0,          0,      0},     // 594
    {"Launch",              0,          0,      0},     // 595
    {"BMW M5 F90 (ÏÏÑ)",             0,          0,      0},     // 596
    {"VAZ 2170 (ÏÏÑ)",             0,          0,      0},     // 597
    {"Volkswagen Polo (ÏÏÑ)",             0,          0,      0},     // 598
    {"samp ìèë",             0,          0,      0},     // 599
    {"ÀÇËÊ 2335",           0,      800,    0},     // 600
    {"ÁÄÐÌ",                0,          0,      0},     // 601
    {"Àlpha",               0,    34000,  0},     // 602
    {"Ford Mustang GT",             2600000,    17000,  0, 277, 4},     // 603
    {"Porsche Panamera S",            8400000,          0,      0, 310, 4},     // 604
    {"Êîñìîà âòî",          0,          0,      0},     // 605
    {"Ïðèöåï ",             0,          0,      0},     // 606
    {"Ïðèöåï ",             0,          0,      0},     // 607
    {"Ëåñòíèöà",            0,          0,      0},     // 608
    {"Àâèà",                0,          0,      0},     // 609
    {"Ïëóã",                0,          0,      0},     // 610
    {"Ïðèöåï óáîðù",        0,          0,      0}      // 611
};

stock SetVehicleDataAll(vehicleid, modelid, Float:x, Float:y, Float:z, Float:angle, color1, color2, respawn_delay, addsiren=0, action_type, action_id)
{
	if(IsValidVehicleID(vehicleid))
	{
		SetVehicleData(vehicleid, V_MODELID, modelid);
		
		SetVehicleData(vehicleid, V_SPAWN_X, 		x);
		SetVehicleData(vehicleid, V_SPAWN_Y, 		y);
		SetVehicleData(vehicleid, V_SPAWN_Z, 		z);
		SetVehicleData(vehicleid, V_SPAWN_ANGLE, 	angle);
		
		SetVehicleData(vehicleid, V_COLOR_1, 	color1);
		SetVehicleData(vehicleid, V_COLOR_2, 	color2);
		
		SetVehicleData(vehicleid, V_RESPAWN_DELAY, 	respawn_delay);
		SetVehicleData(vehicleid, V_ADDSIREN, 		addsiren);
		
		SetVehicleData(vehicleid, V_ACTION_TYPE, 	action_type);
		SetVehicleData(vehicleid, V_ACTION_ID, 		action_id);
		SetVehicleData(vehicleid, V_DRIVER_ID, 		INVALID_PLAYER_ID);
		
		SetVehicleData(vehicleid, V_FUEL, 40.0);
		SetVehicleData(vehicleid, V_MILEAGE, 0.0);
		SetVehicleData(vehicleid, V_LIMIT, true);

		SetVehicleData(vehicleid, V_HEALTH, 1000.0);
		}
}

stock n_veh_AddStaticVehicleEx(modelid, Float:x, Float:y, Float:z, Float:angle, color1, color2, respawn_delay, addsiren=0, action_type=VEHICLE_ACTION_TYPE_NONE, action_id=VEHICLE_ACTION_ID_NONE)
{
	static n_veh_vehicleid = INVALID_VEHICLE_ID;
	
	n_veh_vehicleid = AddStaticVehicleEx(modelid, x, y, z, angle, color1, color2, respawn_delay);
	SetVehicleDataAll(n_veh_vehicleid, modelid, x, y, z, angle, color1, color2, respawn_delay, addsiren, action_type, action_id);

	return n_veh_vehicleid;
	
	// The vehicle ID of the vehicle created (1 - MAX_VEHICLES).
	// INVALID_VEHICLE_ID (65535) if vehicle was not created (vehicle limit reached or invalid vehicle model ID passed).
}
#if defined _ALS_AddStaticVehicleEx
    #undef AddStaticVehicleEx
#else
    #define _ALS_AddStaticVehicleEx
#endif
#define AddStaticVehicleEx n_veh_AddStaticVehicleEx

stock n_veh_AddStaticVehicle(modelid, Float:x, Float:y, Float:z, Float:angle, color1, color2, action_type=VEHICLE_ACTION_TYPE_NONE, action_id=VEHICLE_ACTION_ID_NONE)
{
	static n_veh_vehicleid = INVALID_VEHICLE_ID;
	
	n_veh_vehicleid = AddStaticVehicle(modelid, x, y, z, angle, color1, color2);
	SetVehicleDataAll(n_veh_vehicleid, modelid, x, y, z, angle, color1, color2, 0, 0, action_type, action_id);

	return n_veh_vehicleid;
	
	// The vehicle ID of the vehicle created (1 - MAX_VEHICLES).
	// INVALID_VEHICLE_ID (65535) if vehicle was not created (vehicle limit reached or invalid vehicle model ID passed).
}
#if defined _ALS_AddStaticVehicle
    #undef AddStaticVehicle
#else
    #define _ALS_AddStaticVehicle
#endif
#define AddStaticVehicle n_veh_AddStaticVehicle

stock n_veh_CreateVehicle(modelid, Float:x, Float:y, Float:z, Float:angle, color1, color2, respawn_delay, addsiren=0, action_type=VEHICLE_ACTION_TYPE_NONE, action_id=VEHICLE_ACTION_ID_NONE)
{
	static n_veh_vehicleid = INVALID_VEHICLE_ID;
	
	n_veh_vehicleid = CreateVehicle(modelid, x, y, z, angle, color1, color2, respawn_delay);
	SetVehicleDataAll(n_veh_vehicleid, modelid, x, y, z, angle, color1, color2, respawn_delay, addsiren, action_type, action_id);

	return n_veh_vehicleid;
	
	// The vehicle ID of the vehicle created (1 - MAX_VEHICLES).
	// INVALID_VEHICLE_ID (65535) if vehicle was not created (vehicle limit reached or invalid vehicle model ID passed).
}
#if defined _ALS_CreateVehicle
    #undef CreateVehicle
#else
    #define _ALS_CreateVehicle
#endif
#define CreateVehicle n_veh_CreateVehicle

stock n_veh_DestroyVehicle(vehicleid)
{
	if(IsValidVehicleID(vehicleid))
	{
		ClearVehicleData(vehicleid);
	}
	return DestroyVehicle(vehicleid);
}
#if defined _ALS_DestroyVehicle
    #undef DestroyVehicle
#else
    #define _ALS_DestroyVehicle
#endif
#define DestroyVehicle n_veh_DestroyVehicle

public OnGameModeInit()
{
    for(new idx = 0; idx < MAX_VEHICLES; idx ++)
	{
		ClearVehicleData(idx);
	}
	
#if defined n_veh_OnGameModeInit
    n_veh_OnGameModeInit();
#endif
    return 1;
}
#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit n_veh_OnGameModeInit
#if defined n_veh_OnGameModeInit
forward n_veh_OnGameModeInit();
#endif  

// ---------------------------------------------------
stock SetVehicleParamsInit(vehicleid)
{	
	GetVehicleParamsEx
	(
		vehicleid, 
		g_vehicle_params[vehicleid][V_ENGINE],
		g_vehicle_params[vehicleid][V_LIGHTS],
		g_vehicle_params[vehicleid][V_ALARM],
		g_vehicle_params[vehicleid][V_LOCK],
		g_vehicle_params[vehicleid][V_BONNET],
		g_vehicle_params[vehicleid][V_BOOT],
		g_vehicle_params[vehicleid][V_OBJECTIVE]
	);
}

stock GetVehicleParam(vehicleid, E_VEHICLE_PARAMS_STRUCT:paramid)
{
	SetVehicleParamsInit(vehicleid);
	return g_vehicle_params[vehicleid][paramid];
}

stock SetVehicleParam(vehicleid, E_VEHICLE_PARAMS_STRUCT:paramid, set_value)
{
	SetVehicleParamsInit(vehicleid);
	g_vehicle_params[vehicleid][paramid] = bool: set_value;
	
	SetVehicleParamsEx
	(
		vehicleid,
		g_vehicle_params[vehicleid][V_ENGINE],
		g_vehicle_params[vehicleid][V_LIGHTS],
		g_vehicle_params[vehicleid][V_ALARM],
		g_vehicle_params[vehicleid][V_LOCK],
		g_vehicle_params[vehicleid][V_BONNET],
		g_vehicle_params[vehicleid][V_BOOT],
		g_vehicle_params[vehicleid][V_OBJECTIVE]
	);
}