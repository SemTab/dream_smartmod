main(){}
#include 		<a_samp>
#include        <a_mysql>
#include        <fix_kick>
#include        <foreach>
#include        <streamer>
#include        <sscanf2>
#include        <Pawn.CMD>
#include        <crashdetect>
#include        <Pawn.Regex>
#include        <a_actor>
#include        <a_http>
#include        <a_npc>
#include        <a_objects>
#include        <a_players>
#include        <a_sampdb>
#include        <a_vehicles>
#include        <core>
#include        <customhud>
#include        <customtune>
#include        <datagram>
#include        <file>
#include        <float>
#include        <java>
#include        <mxini>
#include        <pawnraknet>
#include        <sampvoice>
#include        <string>
#include        <time>
#include        <voicechat>
#include        <math>
#include        <m_dialog>

#pragma tabsize 0

// Тут вводи данные от базы данных
#define         MySQL_host          	"127.0.0.1"
#define         MySQL_user          	"gs279471"
#define         MySQL_pass          	"da12345"
#define         MySQL_db            	"gs279471"

// Здесь можешь заменить название сервера и тому подобные настройки
#define         project     			"TEST SEMTAB"
#define         game_mode           	"Dream Mobile"
#define         name_server             "Dream Mobile"
#define         host_name               "Dream Mobile"
#define         language                "Russian"

// * Цвета для чата
#define         color_main              0xbb7dffAA
#define         color_white             0xffffffAA
#define         color_red               0xd54a4aAA
#define         color_blue              0x55adffAA
#define         color_green             0x7aca74AA
#define         color_orange            0xffad55AA
#define         color_yellow            0xf9b961AA
#define         color_purple            0xea8afdAA
#define         color_gray              0x999999AA
#define         color_brown             0x97754fAA
#define         color_black             0x080808AA
#define         color_achat 			0xd7ff9fAA
#define         color_lightyellow       0xe1daa3AA
#define         color_lightred          0xff6347AA
#define color_lightgreen 0x00FF00FF


// Цвета для диалога
#define         c_test              	"{bb7dff}"
#define         c_white             	"{ffffff}"
#define         c_red               	"{d54a4a}"
#define         c_blue              	"{55adff}"
#define         c_green             	"{7aca74}"
#define         c_orange            	"{ffad55}"
#define         c_yellow            	"{f9b961}"
#define         c_purple            	"{ea8afd}"
#define         c_gray              	"{999999}"
#define         c_brown             	"{97754f}"
#define         c_black             	"{080808}"
#define         c_lightyellow           "{e1daa3}"
#define         c_lightred          	"{ff6347}"

// Функции чата
#define         SCM                     SendClientMessage
#define         SCMA                    SendClientMessageToAll

// Функции диалога
#define         SPD                     ShowPlayerDialog
#define         DSI                     DIALOG_STYLE_INPUT
#define         DSM                     DIALOG_STYLE_MSGBOX
#define         DSP                     DIALOG_STYLE_PASSWORD
#define         DSL                     DIALOG_STYLE_LIST

#define         MAX_ADMINS              5



// скутеры
#define PICKUP_SCOOTER_MODEL 1318
#define SCOOTER_MODEL_ID 462
#define SCOOTER_COST 50

// gps
#define DIALOG_GPS_MAIN     5000
#define DIALOG_GPS_ORG      5001
#define DIALOG_GPS_IMPORTANT   5002
#define DIALOG_GPS_RABOT   5003




//номера
#define MAX_VEHICLE_PLATES 1000
#define PLATE_TEXT_SIZE 32

//реклама таймером
#define ANNOUNCE_MESSAGE "Все анонсы обновлений есть в нашем Telegram-канале - t.me/dream_bonus"
//inv test
#define DIALOG_INV 15





enum p_data
{
	id,
	name[MAX_PLAYER_NAME],
	password[20],
	email[32],
	age,
	gender,
	cash,
	level,
	skin,
	regdata[20],
	regip[20],
	pAdmin,
	lastdata[20],
	check_reg,
	admin,
	admin_password[20],
	admin_login,
	Float:health,
	Float:armour,
    
	minutes,
	exp,
	medkits,
	logged,
	admin_rating
};
enum dialogs
{
	d_none,
	d_reg,
	d_email,
	d_refcode,
	d_age,
	d_gender,
	d_auth,
	d_menu,
	d_stats,
	d_kickmessage,
	d_cmdtime,
	d_alogin,
	d_alogin2,
	d_report,
	d_admin_rating
};

new player_info[MAX_PLAYERS][p_data];
new MySQL:db_fc;
new wrongpass[MAX_PLAYERS] = 3;
new player_kick_time[MAX_PLAYERS char];
new playersex[MAX_PLAYERS][20];
new admin_rang[MAX_PLAYERS][32];
new admin_check_alogin[MAX_PLAYERS];
new PlayerAFK[MAX_PLAYERS];
new bool:statictime = false;
new usedweather[20] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 17, 18, 19, 20};
new Iterator:Admins_ITER<MAX_ADMINS>;
new report_check[MAX_PLAYERS];
new scooterPickupYuzhniy;
new scooterPickupArzamas;
new Text3D:infoLabelYuzhniy, Text3D:infoLabelArzamas;



//номера
new Text3D:VehiclePlate[MAX_VEHICLES];
new VehiclePlateText[MAX_VEHICLES][PLATE_TEXT_SIZE];
//точка выхода
new PlayerSQLID[MAX_PLAYERS];
new bool:godmode[MAX_PLAYERS];
stock GetPlayerSQLID(playerid)
{
    return PlayerSQLID[playerid];
}


forward CheckAccount(playerid);
forward LoadAccount(playerid);
forward LoginTimer();
forward StopAnimationChat(playerid);
forward UpdateSecond();
forward UpdateMinute();






public OnGameModeInit()
{
    db_fc = mysql_connect(MySQL_host, MySQL_user, MySQL_pass, MySQL_db);
    switch(mysql_errno(db_fc))
    {
        case 0:
        {
            print(" ");
            printf("- Игровой мод успешно подключен к базе данных (%s)", MySQL_db);
        }
        default:
        {
            print(" ");
            printf("- Игровой мод не может подключиться к базе данных (%s) [Проверьте правильность введённых данных!]", MySQL_db);
        }
    }
    mysql_set_charset("cp1251");
    mysql_log(ERROR | WARNING);

    new rconStr[64];
    format(rconStr, sizeof rconStr, "hostname %s", host_name);
    SendRconCommand(rconStr);

    format(rconStr, sizeof rconStr, "language %s", language);
    SendRconCommand(rconStr);

    SetGameModeText(game_mode);

    Iter_Clear(Admins_ITER);
    LoadTextDraw();
    LoadObject();

    SetTimer("UpdateSecond", 1000, true);
    SetTimer("UpdateMinute", 60000, true);

    SetTimer("LoginTimer", 1000, 1);

    ShowPlayerMarkers(2);
    ShowPlayerMarkers(PLAYER_MARKERS_MODE_GLOBAL);
    EnableStuntBonusForAll(false);

    DisableInteriorEnterExits();

    SetNameTagDrawDistance(20.0);
    LimitPlayerMarkerRadius(100.0);

    scooterPickupYuzhniy = CreatePickup(19134, 1, -407.276458, -1791.422119, 18.323537, 0);
    scooterPickupArzamas = CreatePickup(19134, 1, -163.864974, 2610.933349, 18.330675, 0);

    infoLabelYuzhniy = Create3DTextLabel("Привет! Это тест мод для карты - \"Smart Rp\", мод был написан semtab`ом.\nТы можешь изменить или же удалить этот текст в pwn файле:)", color_main,
        -407.276458, -1791.422119, 18.323537 + 1.0, 15.0, 0);
    
    infoLabelArzamas = Create3DTextLabel("Привет! Это тест мод для карты - \"Smart Rp\", мод был написан semtab`ом.\nТы можешь изменить или же удалить этот текст в pwn файле:)", color_main,
        -163.864974, 2610.933349, 18.330675 + 1.0, 15.0, 0);
        //таймер на вывод сообщений каждые 15 минут
    SetTimer("AnnounceUpdates", 900000, true);
    


    return 1;
}

public OnGameModeExit()
{
    mysql_close(db_fc);

    // Очищаем массив номеров при выходе
    for(new i = 0; i < MAX_VEHICLES; i++)
    {
        if(IsValidDynamic3DTextLabel(VehiclePlate[i]))
        {
            Delete3DTextLabel(VehiclePlate[i]);
        }
    }
    
    Delete3DTextLabel(infoLabelYuzhniy);
    Delete3DTextLabel(infoLabelArzamas);
    
    return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	return 1;
}

public OnPlayerConnect(playerid)
{
    GetPlayerName(playerid, player_info[playerid][name], MAX_PLAYER_NAME);
    TogglePlayerSpectating(playerid, 1);

    SetPlayerCameraPos(playerid, -2625.480712, 2251.552246, 12.997936);
    SetPlayerCameraLookAt(playerid, -2620.974853, 2249.394042, 12.796076);

    static const fmt_query[] = "SELECT `password` FROM `users` WHERE `name` = '%s'";
    new query[sizeof(fmt_query)-2+MAX_PLAYER_NAME];
    mysql_format(db_fc, query, sizeof(query), fmt_query, player_info[playerid][name]);
    mysql_tquery(db_fc, query, "CheckAccount", "i", playerid);

    SetPlayerColor(playerid, color_white);
    player_kick_time[playerid] = 60;
    SendClientMessage(playerid, 0x55adffAA, "Добро пожаловать на Dream Mobile!");
	// Воспроизведение музыки при заходе
    PlayAudioStreamForPlayer(playerid, "http://wh23335.web1.maze-tech.ru/draim/musicbr.mp3");
    return 1;
    
}



public OnPlayerDisconnect(playerid, reason)
{
    new Float:x, Float:y, Float:z, interior, vw;
    GetPlayerPos(playerid, x, y, z);
    interior = GetPlayerInterior(playerid);
    vw = GetPlayerVirtualWorld(playerid);

    new query[256];
    mysql_format(db_fc, query, sizeof(query),
        "UPDATE players SET last_x = %f, last_y = %f, last_z = %f, last_interior = %d, last_vw = %d WHERE id = %d",
        x, y, z, interior, vw, GetPlayerSQLID(playerid)
    );
    mysql_tquery(db_fc, query);

    return 1;
}
SetSpawnToLastPos(playerid)
{
    new query[128];
    mysql_format(db_fc, query, sizeof(query),
        "SELECT last_x, last_y, last_z, last_interior, last_vw FROM players WHERE id = %d",
        GetPlayerSQLID(playerid)
    );
    mysql_tquery(db_fc, query, "OnLastPosSelected", "d", playerid);
}

forward OnLastPosSelected(playerid);
public OnLastPosSelected(playerid)
{
    if(cache_num_rows() > 0)
    {
        new Float:x, Float:y, Float:z, interior, vw;
        cache_get_value_name_float(0, "last_x", x);
        cache_get_value_name_float(0, "last_y", y);
        cache_get_value_name_float(0, "last_z", z);
        cache_get_value_name_int(0, "last_interior", interior);
        cache_get_value_name_int(0, "last_vw", vw);

        if(x != 0.0 || y != 0.0 || z != 0.0)
        {
            SetPlayerPos(playerid, x, y, z);
            SetPlayerInterior(playerid, interior);
            SetPlayerVirtualWorld(playerid, vw);
            SendClientMessage(playerid, -1, "Вы появились на последнем месте выхода.");
        }
        else SendClientMessage(playerid, -1, "Последняя позиция не установлена.");
    }
    return 1;
}

public OnPlayerSpawn(playerid)
{
    PlayerSpawn(playerid);
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	SCM(playerid, color_green, "Вы умерли, отправляю вас на спавн...");
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
    // Создание 3D-метки при появлении машины
    SetupVehicleNumberPlate(vehicleid);
    return 1;
}


public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
    new str[100];
    if(strlen(text) <= 100)
    {
        format(str, sizeof(str), "%s[%i]: {F0F8FF}%s", player_info[playerid][name], playerid, text);
        ProxDetector(20.0, playerid, str, color_white, color_white, color_white, color_white, color_white);
        SetPlayerChatBubble(playerid, text, color_white, 20, 7500);
        if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
        {
            ApplyAnimation(playerid, "PED", "IDLE_chat", 4.1, 0, 1, 1, 1, 1);
            SetTimerEx("StopAnimationChat", 3200, false, "d", playerid);
        }
    }
    else
    {
        SCM(playerid, color_red, "Слишком длинный текст! Не более 100 символов!");
    }
	new playerName[MAX_PLAYER_NAME];
    GetPlayerName(playerid, playerName, sizeof(playerName));

    new logLine[256];
    format(logLine, sizeof(logLine), "[%s] %s: %s\n", GetDateTime(), playerName, text);

    // Записываем в файл logs/chatlog.txt
    new File:logFile = fopen("logs/chatlog.txt", io_append);
    if (logFile)
    {
        fwrite(logFile, logLine);
        fclose(logFile);
    }
    return 0;
}
stock GetDateTime()
{
    new date[64];
    getdate(date[0], date[1], date[2]);
    gettime(date[3], date[4], date[5]);
    format(date, sizeof(date), "%02d-%02d-%04d %02d:%02d:%02d", date[2], date[1], date[0], date[3], date[4], date[5]);
    return date;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	return 0;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerEnterDynamicArea(playerid, areaid)
{
        return 0;
}


public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;

}
// Функция для назначения номера машине
SetupVehicleNumberPlate(vehicleid, text[] = "")
{
    if(IsValidDynamic3DTextLabel(VehiclePlate[vehicleid]))
    {
        Delete3DTextLabel(VehiclePlate[vehicleid]);
    }

    if(!strlen(text))
    {
        format(VehiclePlateText[vehicleid], PLATE_TEXT_SIZE, "%d %c%c%c %d",
            random(999),
            random(26) + 'A',
            random(26) + 'A',
            random(26) + 'A',
            random(99));
    }
    else
    {
        format(VehiclePlateText[vehicleid], PLATE_TEXT_SIZE, "%s", text);
    }

    VehiclePlate[vehicleid] = Create3DTextLabel(VehiclePlateText[vehicleid], 0xFFFFFFFF, 0.0, 0.0, 0.0, 10.0, 0);
    Attach3DTextLabelToVehicle(VehiclePlate[vehicleid], vehicleid, 0.0, -1.5, 0.3);

}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
    if (pickupid == scooterPickupYuzhniy || pickupid == scooterPickupArzamas)
    {
        if (GetPlayerMoney(playerid) < 50)
        {
            SendClientMessage(playerid, 0xFF0000FF, "Недостаточно средств! Для аренды скутера требуется 50 рублей.");
            return 1;
        }


        GivePlayerMoney(playerid, -50);


        new Float:x, Float:y, Float:z, Float:a;
        GetPlayerPos(playerid, x, y, z);
        GetPlayerFacingAngle(playerid, a);


        x += 1.5 * floatsin(-a, degrees);
        y += 1.5 * floatcos(-a, degrees);

        new vehicleid = CreateVehicle(SCOOTER_MODEL_ID, x, y, z, a, -1, -1, 600);
        PutPlayerInVehicle(playerid, vehicleid, 0);

        SendClientMessage(playerid, 0x00FF00FF, "Вы арендовали скутер за 50 рублей! Удачного пути!");
    }
    return 1;
}




public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnPlayerDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{

    return 1;
}


public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{

    if((newkeys & KEY_WALK))
    {



        new Float:x, Float:y, Float:z;
        GetPlayerPos(playerid, x, y, z);






    }


    if((newkeys & KEY_YES))
    {
        new vehicleid = GetPlayerOwnableCar(playerid);
        if(vehicleid != INVALID_VEHICLE_ID)
        {
            ToggleLock(playerid, vehicleid);
            return 1;
        }
    }

    if((newkeys & KEY_NO))
    {
        if(IsPlayerInAnyVehicle(playerid))
        {
            new vehicleid = GetPlayerVehicleID(playerid);
            new engine, lights, alarm, doors, bonnet, boot, objective;
            GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
            SetVehicleParamsEx(vehicleid, !engine, lights, alarm, doors, bonnet, boot, objective);
            return 1;
        }
    }

    return 1;
}



public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}

public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
    if(player_info[playerid][admin] >= 2){
	SetPlayerPos(playerid, fX, fY, fZ);
	SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, 0);
	}
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
		case d_reg:
{
    if(response)
    {
        if(!strlen(inputtext)) return DialogReg(playerid);
        if(strlen(inputtext) < 8 || strlen(inputtext) > 20)
        {
            DialogReg(playerid);
            return SCM(playerid, color_red, "Длина пароля от 8 до 20 символов!");
        }
        for(new i = strlen(inputtext); i != 0; --i)
        switch(inputtext[i])
        {
            case 'А'..'Я', 'а'..'я', ' ':
            {
                DialogReg(playerid);
                return SCM(playerid, color_red, "Смените раскладку клавиатуры!");
            }
        }

        strmid(player_info[playerid][password], inputtext, 0, strlen(inputtext), 20);

        
        SPD(playerid, d_email, DSI, ""c_red"Регистрация | E-mail",
        ""c_white"Введите действующий адрес "c_red"электронной почты"c_white"\n\
        Если Ваш аккаунт будет "c_red"взломан "c_white"или"c_red" утерян\n\
        "c_white"Мы отправим на неё пароль для восстановления", "Далее", "Отмена");
    }
    else return Kick(playerid);
}
        case d_email:
        {
			if(response)
			{
				if(!strlen(inputtext)) return SPD(playerid, d_email, DSI, ""c_red"Регистрация | E-mail",
				""c_white"Введите действующий адрес "c_red"электронной почты"c_white"\n\
				Если Ваш аккаунт будет "c_red"взломан "c_white"или"c_red" утерян\n\
				"c_white"Мы отправим на неё пароль для восстановления", "Далее", "Отмена");
				if(strlen(inputtext) < 6 || strlen(inputtext) > 32)
				{
				    SPD(playerid, d_email, DSI, ""c_red"Регистрация | E-mail",
					""c_white"Введите действующий адрес "c_red"электронной почты"c_white"\n\
					Если Ваш аккаунт будет "c_red"взломан "c_white"или"c_red" утерян\n\
					"c_white"Мы отправим на неё пароль для восстановления", "Далее", "Отмена");
                   	return SCM(playerid, color_red, "Такой e-mail не существует! Пример: test@gmail.com");
				}
				
				for(new i = strlen(inputtext); i != 0; --i)
             	switch(inputtext[i])
                {
                    case 'А'..'Я', 'а'..'я', ' ':
                    {
					    SPD(playerid, d_email, DSI, ""c_red"Регистрация | E-mail",
						""c_white"Введите действующий адрес "c_red"электронной почты"c_white"\n\
						Если Ваш аккаунт будет "c_red"взломан "c_white"или"c_red" утерян\n\
						"c_white"Мы отправим на неё пароль для восстановления", "Далее", "Отмена");
	                   	return SCM(playerid, color_red, "Смените раскладку клавиатуры!");
                    }
                }
                if(strfind(inputtext, "@", true) == -1 || strfind(inputtext, ".", true) == -1)
                {
				    SPD(playerid, d_email, DSI, ""c_red"Регистрация | E-mail",
					""c_white"Введите действующий адрес "c_red"электронной почты"c_white"\n\
					Если Ваш аккаунт будет "c_red"взломан "c_white"или"c_red" утерян\n\
					"c_white"Мы отправим на неё пароль для восстановления", "Далее", "Отмена");
                   	return SCM(playerid, color_red, "Такой e-mail не существует! Пример: test@gmail.com");
                }
				StopAudioStreamForPlayer(playerid);
                strmid(player_info[playerid][email], inputtext, 0, strlen(inputtext), 32);
			SPD(playerid, d_gender, DSM, ""c_lightred"Регистрация | Пол", ""c_white"Выберите пол Вашего персонажа", "Мужской", "Женский");
			}
			
			else return Kick(playerid);
        }
		case d_age:
		{
			player_info[playerid][age] = strval(inputtext);
			SPD(playerid, d_gender, DSM, ""c_lightred"Регистрация | Пол", ""c_white"Выберите пол Вашего персонажа", "Мужской", "Женский");
		}
		case d_gender:
		{
			if(response) player_info[playerid][gender] = 1;
			else player_info[playerid][gender] = 2;

			if(player_info[playerid][gender] == 1)
		    {
    			switch(random(4))
    			{
					case 0: player_info[playerid][skin] = 19;
					case 1: player_info[playerid][skin] = 21;
					case 2: player_info[playerid][skin] = 22;
					case 3: player_info[playerid][skin] = 28;
				}
			}
			else if(player_info[playerid][gender] == 2)
			{
				switch(random(2))
    			{
					case 0: player_info[playerid][skin] = 13;
					case 1: player_info[playerid][skin] = 69;
				}
			}
			static const fmt_query[] = "INSERT INTO `users`(`id`, `name`, `password`, `email`, `age`, `gender`, `skin`, `regdata`, `regip`) VALUES ('%i', '%s', '%s', '%s', '%i', '%i', '%i', '%s', '%s')";
			new query[sizeof(fmt_query)+(-2+11)+(-2+MAX_PLAYER_NAME)+(-2+20)+(-2+32)+(-2+11)+(-2+11)+(-2+11)+(-2+20)+(-2+20)], str[128];
			new Day, Month, Year, Hour, Minute, Second;
			new date[32];
			getdate(Year, Month, Day);
			gettime(Hour, Minute, Second);
			format(date, sizeof(date), "%02d.%02d.%i %02d:%02d:%02d", Day, Month, Year, Hour, Minute, Second);
			new ip[16];
			GetPlayerIp(playerid, ip, 16);
			mysql_format(db_fc, query, sizeof(query), fmt_query,
			player_info[playerid][id],
			player_info[playerid][name],
			player_info[playerid][password],
			player_info[playerid][email],
			player_info[playerid][age],
			player_info[playerid][gender],
			player_info[playerid][skin],
			date,
			ip);
			mysql_query(db_fc, query, false);

			static const fmt_query2[] = "SELECT * FROM `users` WHERE `name` = '%s' AND `password` = '%s'";
			mysql_format(db_fc, query, sizeof(query), fmt_query2, player_info[playerid][name], player_info[playerid][password]);
			mysql_tquery(db_fc, query, "LoadAccount", "i", playerid);
			format(str, sizeof(str), "{55adff}Вы успешно зарегистрировались "c_lightyellow"%s!"c_white"", player_info[playerid][name]);
			SCM(playerid, color_white, str);

			player_info[playerid][check_reg] = 1;
			static const fmt_query3[] = "UPDATE `users` SET `check_reg` = '%i' WHERE `id` = '%i'";
			new query3[sizeof(fmt_query3)-2+11+11];
			mysql_format(db_fc, query3, sizeof(query3), fmt_query3, player_info[playerid][check_reg], player_info[playerid][id]);
			mysql_query(db_fc, query3, false);
		}
		case d_auth:
{
	if(response)
	{
		if(!strlen(inputtext)) return DialogAuth(playerid);
		if(strlen(inputtext) < 8 || strlen(inputtext) > 20)
		{
			DialogAuth(playerid);
			return SCM(playerid, color_red, "Длина пароля от 8 до 20 символов!");
		}
		for(new i = strlen(inputtext); i != 0; --i)
		switch(inputtext[i])
		{
			case 'А'..'Я', 'а'..'я', ' ':
			{
				DialogAuth(playerid);
				return SCM(playerid, color_red, "Смените раскладку клавиатуры!");
			}
		}

		// Пароль совпал — авторизация успешна
		if(strcmp(player_info[playerid][password], inputtext, false, 20) == 0)
		{
			//  Останавливаем музыку при успешной авторизации
			StopAudioStreamForPlayer(playerid);

			static const fmt_query2[] = "SELECT * FROM `users` WHERE `name` = '%s' AND `password` = '%s'";
			new query[sizeof(fmt_query2)+(-2+MAX_PLAYER_NAME)+(-2+20)];
			mysql_format(db_fc, query, sizeof(query), fmt_query2, player_info[playerid][name], player_info[playerid][password]);
			mysql_tquery(db_fc, query, "LoadAccount", "i", playerid);
			return 1;
		}
		else
		{
			if(wrongpass[playerid] < 2) return Kick(playerid);
			new str[64];
			wrongpass[playerid]--;
			format(str, sizeof(str), "Неправильный пароль! У Вас осталось %i попыток!", wrongpass[playerid]);
			SCM(playerid, color_red, str);
			DialogAuth(playerid);
		}
	}
}
		case d_menu:
		{
			switch(listitem)
			{
				case 0: ShowStats(playerid);
				case 1: callcmd::report(playerid);
			}
		}
		case d_alogin:
		{
			if(response)
			{
				AdminRangs(playerid);
				if(!strlen(inputtext))
				{
					new dialog[512];
					format(dialog, sizeof(dialog),
					""c_white"Имя администратора: "c_lightred"%s"c_white"\n\
					Уровень администратора: "c_lightred"%s (%i)"c_white"\n\n\
					Вы еще не зарегистрированы в панели администратора\n\
					Придумайте и введите пароль в поле ниже:"c_gray"\n\
					* используйте буквы и цифры латинского алфавита\n\
					* длина пароля должна быть от 8 до 20 символов", player_info[playerid][name], admin_rang[playerid], player_info[playerid][admin]);
					SPD(playerid, d_alogin, DSI, ""c_lightred"Регистрация в панели администратора", dialog, "Войти", "Отмена");
					return 1;
				}
				if(strlen(inputtext) < 8 || strlen(inputtext) > 20)
				{
				    new dialog[512];
					format(dialog, sizeof(dialog),
					""c_white"Имя администратора: "c_lightred"%s"c_white"\n\
					Уровень администратора: "c_lightred"%s (%i)"c_white"\n\n\
					Вы еще не зарегистрированы в панели администратора\n\
					Придумайте и введите пароль в поле ниже:"c_gray"\n\
					* используйте буквы и цифры латинского алфавита\n\
					* длина пароля должна быть от 8 до 20 символов", player_info[playerid][name], admin_rang[playerid], player_info[playerid][admin]);
					SPD(playerid, d_alogin, DSI, ""c_lightred"Регистрация в панели администратора", dialog, "Войти", "Отмена");
                    return SCM(playerid, color_red, "Длина пароля от 8 до 20 символов!");
				}
				for(new i = strlen(inputtext); i != 0; --i)
             	switch(inputtext[i])
                {
                    case 'А'..'Я', 'а'..'я', ' ':
                    {
						new dialog[512];
						format(dialog, sizeof(dialog),
						""c_white"Имя администратора: "c_lightred"%s"c_white"\n\
						Уровень администратора: "c_lightred"%s (%i)"c_white"\n\n\
						Вы еще не зарегистрированы в панели администратора\n\
						Придумайте и введите пароль в поле ниже:"c_gray"\n\
						* используйте буквы и цифры латинского алфавита\n\
						* длина пароля должна быть от 8 до 20 символов", player_info[playerid][name], admin_rang[playerid], player_info[playerid][admin]);
						SPD(playerid, d_alogin, DSI, ""c_lightred"Регистрация в панели администратора", dialog, "Войти", "Отмена");
						return SCM(playerid, color_red, "Смените раскладку клавиатуры!");
                    }
                }
                strmid(player_info[playerid][admin_password], inputtext, 0, strlen(inputtext), 20);
				player_info[playerid][admin_login] = 1;
				static const fmt_query[] = "UPDATE `users` SET `admin_login` = '%i', `admin_password` = '%s' WHERE `id` = '%i'";
				new query[sizeof(fmt_query)+(-2+11)+(-2+20)+(-2+11)];
				mysql_format(db_fc, query, sizeof(query), fmt_query, player_info[playerid][admin_login], player_info[playerid][admin_password], player_info[playerid][id]);
				mysql_query(db_fc, query, false);
				new str[144];
				format(str, sizeof(str), "[A] %s %s[%i] авторизовался в панели администратора!", admin_rang[playerid], player_info[playerid][name], playerid);
				AdmMSG(color_gray, str);
				admin_check_alogin[playerid] = 1;
			}
		}
		case d_alogin2:
		{
			if(response)
			{
				AdminRangs(playerid);
				if(!strlen(inputtext))
				{
				    new dialog[512];
					format(dialog, sizeof(dialog),
					""c_white"Имя администратора: "c_lightred"%s"c_white"\n\
					Уровень администратора: "c_lightred"%s (%i)"c_white"\n\n\
					Вы зарегистрированы в панели администратора\n\
					Введите пароль в поле ниже:", player_info[playerid][name], admin_rang[playerid], player_info[playerid][admin]);
					SPD(playerid, d_alogin2, DSI, ""c_lightred"Авторизация в панели администратора", dialog, "Войти", "Отмена");
					return 1;
				}
				if(strlen(inputtext) < 8 || strlen(inputtext) > 20)
				{
				    new dialog[512];
					format(dialog, sizeof(dialog),
					""c_white"Имя администратора: "c_lightred"%s"c_white"\n\
					Уровень администратора: "c_lightred"%s (%i)"c_white"\n\n\
					Вы зарегистрированы в панели администратора\n\
					Введите пароль в поле ниже:", player_info[playerid][name], admin_rang[playerid], player_info[playerid][admin]);
					SPD(playerid, d_alogin2, DSI, ""c_lightred"Авторизация в панели администратора", dialog, "Войти", "Отмена");
                    return SCM(playerid, color_red, "Длина пароля от 8 до 20 символов!");
				}
				for(new i = strlen(inputtext); i != 0; --i)
             	switch(inputtext[i])
                {
                    case 'А'..'Я', 'а'..'я', ' ':
                    {
						new dialog[512];
						format(dialog, sizeof(dialog),
						""c_white"Имя администратора: "c_lightred"%s"c_white"\n\
						Уровень администратора: "c_lightred"%s (%i)"c_white"\n\n\
						Вы зарегистрированы в панели администратора\n\
						Введите пароль в поле ниже:", player_info[playerid][name], admin_rang[playerid], player_info[playerid][admin]);
						SPD(playerid, d_alogin2, DSI, ""c_lightred"Авторизация в панели администратора", dialog, "Войти", "Отмена");
						return SCM(playerid, color_red, "Смените раскладку клавиатуры!");
                    }
                }
               	if(strcmp(player_info[playerid][admin_password], inputtext, false, 20) == 0)
                {
						new str[144];
						format(str, sizeof(str), "[A] %s %s[%i] авторизовался в панели администратора!", admin_rang[playerid], player_info[playerid][name], playerid);
						AdmMSG(color_gray, str);
						admin_check_alogin[playerid] = 1;
						return 1;
                }
                else
                {
					new dialog[512];
					format(dialog, sizeof(dialog),
					""c_white"Имя администратора: "c_lightred"%s"c_white"\n\
					Уровень администратора: "c_lightred"%s (%i)"c_white"\n\n\
					Вы зарегистрированы в панели администратора\n\
					Введите пароль в поле ниже:", player_info[playerid][name], admin_rang[playerid], player_info[playerid][admin]);
					SPD(playerid, d_alogin2, DSI, ""c_lightred"Авторизация в панели администратора", dialog, "Войти", "Отмена");
					return SCM(playerid, color_red, "Неправильный пароль!");
                }
			}
		}

		case d_report:
		{
			if(response)
			{
			    if(report_check[playerid] == 1) return SCM(playerid, color_red, "Вы ранее обращались в поддержку, ожидайте ответа!");
				if(!strlen(inputtext))
				{
					SPD(playerid, d_report, DSI, ""c_lightred"Связь с администрацией",
					""c_white"Опишите свой "c_lightyellow"вопрос"c_white" или "c_lightred"жалобу"c_white" администрации:\n\n\
					"c_gray"При подаче жалобы на игрока, укажите его ID", "Далее", "Закрыть");
					return 1;
				}
				if(strlen(inputtext) < 6)
				{
					SPD(playerid, d_report, DSI, ""c_lightred"Связь с администрацией",
					""c_white"Опишите свой "c_lightyellow"вопрос"c_white" или "c_lightred"жалобу"c_white" администрации:\n\n\
					"c_gray"При подаче жалобы на игрока, укажите его ID", "Далее", "Закрыть");
					return SCM(playerid, color_red, "Слишком мало информации (не менее 6 символов)!");
				}
				new str[144];
				format(str, sizeof(str), "Ваше обращение: "c_lightyellow"%s", inputtext);
				SCM(playerid, color_white, str);
				report_check[playerid] = 1;
				new str2[144];
				format(str2, sizeof(str2), "Обращение от %s[%i]:"c_yellow" %s", player_info[playerid][name], playerid, inputtext);
				AdmMSG(color_green, str2);
			}
		}
		case d_admin_rating:
		{
			if(response)
			{
				player_info[playerid][admin_rating]++;
				static const fmt_query[] = "UPDATE `users` SET `admin_rating` = '%i' WHERE `id` = '%i'";
				new query[sizeof(fmt_query)+(-2+11)+(-2+11)];
				mysql_format(db_fc, query, sizeof(query), fmt_query, player_info[playerid][admin_rating], player_info[playerid][id]);
				mysql_query(db_fc, query, false);
			}
			else
			{
				player_info[playerid][admin_rating]--;
				static const fmt_query[] = "UPDATE `users` SET `admin_rating` = '%i' WHERE `id` = '%i'";
				new query[sizeof(fmt_query)+(-2+11)+(-2+11)];
				mysql_format(db_fc, query, sizeof(query), fmt_query, player_info[playerid][admin_rating], player_info[playerid][id]);
				mysql_query(db_fc, query, false);
			}
		}
        case DIALOG_GPS_MAIN:
        {
            if(!response) return 1;

            switch(listitem)
            {
                case 0: // Организации
                {
                    ShowPlayerDialog(playerid, DIALOG_GPS_ORG, DIALOG_STYLE_LIST,
                        "Организации",
                        "СМИ\nАрмия",
                        "Выбрать", "Назад");
                }
                case 1: // Работы
                {
                    ShowPlayerDialog(playerid, DIALOG_GPS_RABOT, DIALOG_STYLE_LIST,
                         "Работы",
                          "Водитель автобуса\nТаксист\nДальнобойщик\nЛесопилка",
                           "Выбрать", "Назад");
                  }
                case 2: // Важные места
                {
                    ShowPlayerDialog(playerid, DIALOG_GPS_IMPORTANT, DIALOG_STYLE_LIST,
                        "Важные места",
                        "Банк Арзамас\nБольница\nАвторынок",
                        "Выбрать", "Назад");
                }
            }
            return 1;
        }
        case DIALOG_GPS_ORG:
        {
            if(!response) return ShowPlayerDialog(playerid, DIALOG_GPS_MAIN, DIALOG_STYLE_LIST,
                "GPS - Выбор категории",
                "Организации\nРаботы\nВажные места",
                "Выбрать", "Отмена");

            switch(listitem)
            {
                case 0: // СМИ
                {
                    SetPlayerCheckpoint(playerid, 1285.205566, -1897.135253, 12.344487, 3.0);
                    SendClientMessage(playerid, 0x00FF00FF, "Метка на СМИ установлена.");
                }
                case 1: // Армия
                {
                    SetPlayerCheckpoint(playerid, 865.548583, -110.177909, 18.002475, 3.0);
                    SendClientMessage(playerid, 0x00FF00FF, "Метка на Армию установлена.");
                }
            }
            return 1;
        }
        case DIALOG_GPS_IMPORTANT:
        {
            if(!response) return ShowPlayerDialog(playerid, DIALOG_GPS_MAIN, DIALOG_STYLE_LIST,
                "GPS - Выбор категории",
                "Организации\nРаботы\nВажные места",
                "Выбрать", "Отмена");

            switch(listitem)
            {
                case 0: // Банк Арзамас
                {
                    SetPlayerCheckpoint(playerid, 888.547180, -2828.056640, 18.334899, 3.0);
                    SendClientMessage(playerid, 0x00FF00FF, "Метка на Банк Арзамас установлена.");
                }
                case 1: // Больница
                {
                    SetPlayerCheckpoint(playerid, 131.987411, 1961.243164, 18.317024, 3.0);
                    SendClientMessage(playerid, 0x00FF00FF, "Метка на Больницу установлена.");
                }
                case 2: // Авторынок
                {
                    SetPlayerCheckpoint(playerid, -2560.591796, -26.468555, 20.114538, 3.0);
                    SendClientMessage(playerid, 0x00FF00FF, "Метка на Авторынок установлена.");
                }
            }
            return 1;
        }
        case DIALOG_GPS_RABOT:
        {
            if(!response) return ShowPlayerDialog(playerid, DIALOG_GPS_MAIN, DIALOG_STYLE_LIST,
                "GPS - Выбор категории",
                "Организации\nРаботы\nВажные места",
                "Выбрать", "Отмена");

            switch(listitem)
            {
                case 0: // Водитель автобуса
                {
                    SetPlayerCheckpoint(playerid, 1234.567, 890.123, 20.0, 3.0);
                    SendClientMessage(playerid, 0x00FF00FF, "Метка на работу водителя автобуса установлена.");
                }
                case 1: // Таксист
                {
                    SetPlayerCheckpoint(playerid, 2234.567, 790.123, 20.0, 3.0);
                    SendClientMessage(playerid, 0x00FF00FF, "Метка на работу таксиста установлена.");
                }
                case 2: // Дальнобойщик
                {
                    SetPlayerCheckpoint(playerid, 1024.567, 590.123, 20.0, 3.0);
                    SendClientMessage(playerid, 0x00FF00FF, "Метка на работу дальнобойщика установлена.");
                }
                case 3: // Лесопилка
                {
                    SetPlayerCheckpoint(playerid, -1504.846801, 1765.354248, 46.718784, 3.0);
                    SendClientMessage(playerid, 0x00FF00FF, "Метка на лесопилку установлена.");
                }
            }
            return 1;
        }
         case DIALOG_INV: // Диалог инвентаря
        {
            if(!response) return 1;

            switch(listitem)
            {
                case 0: // Телефон
                {
                    SendClientMessage(playerid, 0xFFFFFFFF, "Функционал для телефона еще не написан...");
                    // Здесь можно добавить функционал телефона
                }
                
                case 1: // Паспорт
                {
                    new str[256], genderStr[10];
                    if(player_info[playerid][gender] == 1) {
                        genderStr = "Мужской";
                    } else {
                        genderStr = "Женский";
                    }
                    format(str, sizeof(str), "Имя: %s\nВозраст: %d\nПол: %s", 
                        player_info[playerid][name],
                        player_info[playerid][age],
                        genderStr);
                    ShowPlayerDialog(playerid, 9998, DIALOG_STYLE_MSGBOX, "Ваш паспорт", str, "Закрыть", "");
                }
                
                case 2: // Лицензии
                {
                    SendClientMessage(playerid, 0xFFFFFFFF, "Лицензии: Водительские права, Оружие");
                    // Здесь можно добавить список лицензий
                }
                
                case 3: // Маска
                {
                    if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_USECELLPHONE)
                    {
                        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
                        SendClientMessage(playerid, 0xFFFFFFFF, "Вы сняли маску.");
                    }
                    else
                    {
                        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);
                        SendClientMessage(playerid, 0xFFFFFFFF, "Вы надели маску.");
                    }
                }
                
                case 4: // Аптечка
                {
                    if(player_info[playerid][medkits] < 1)
                        return SendClientMessage(playerid, 0xFF0000FF, "У вас нет аптечек!");
                    
                    player_info[playerid][medkits]--;
                    SetPlayerHealth(playerid, 100.0);
                    
                    PlayerPlaySound(playerid, 1150, 0.0, 0.0, 0.0);
                    ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0);
                    
                    SendClientMessage(playerid, 0x00FF00FF, "Вы использовали аптечку. Здоровье восстановлено.");
                    GameTextForPlayer(playerid, "~g~Аптечка использована", 3000, 3);
                    
                    new query[128];
                    mysql_format(db_fc, query, sizeof(query), "UPDATE `users` SET `medkits` = '%d' WHERE `id` = '%d'", 
                                player_info[playerid][medkits], player_info[playerid][id]);
                    mysql_query(db_fc, query, false);
                }
                
                case 5: // Кейс
                {
                    SendClientMessage(playerid, 0xFFFFFFFF, "Вы открываете кейс...");
                }
                
                case 6: // Карта штата
                {
                    SendClientMessage(playerid, 0xFFFFFFFF, "Вы рассматриваете карту штата...");
                }
            }
            return 1;
        }

	}
	return 1;
}

public CheckAccount(playerid)
{
	new rows;
	cache_get_row_count(rows);
	if(rows)
	{
		cache_get_value_name(0, "password", player_info[playerid][password], 20);
		DialogAuth(playerid);
	}
	else DialogReg(playerid);
	return 1;
}
public LoadAccount(playerid)
{
	new rows;
	cache_get_row_count(rows);
	if(rows)
	{
	    cache_get_value_name_int(0, "id", player_info[playerid][id]);
		cache_get_value_name(0, "password", player_info[playerid][password], 20);
		cache_get_value_name(0, "email", player_info[playerid][email], 32);
		cache_get_value_name_int(0, "age", player_info[playerid][age]);
		cache_get_value_name_int(0, "gender", player_info[playerid][gender]);
		cache_get_value_name_int(0, "skin", player_info[playerid][skin]);
		cache_get_value_name(0, "regdata", player_info[playerid][regdata], 20);
		cache_get_value_name_int(0, "check_reg", player_info[playerid][check_reg]);
		cache_get_value_name_int(0, "cash", player_info[playerid][cash]);
		cache_get_value_name_int(0, "level", player_info[playerid][level]);
		cache_get_value_name_int(0, "admin", player_info[playerid][admin]);
		cache_get_value_name(0, "admin_password", player_info[playerid][admin_password], 20);
		cache_get_value_name_int(0, "admin_login", player_info[playerid][admin_login]);
		cache_get_value_name_float(0, "health", player_info[playerid][health]);
		cache_get_value_name_float(0, "armour", player_info[playerid][armour]);
		cache_get_value_name_int(0, "minutes", player_info[playerid][minutes]);
		cache_get_value_name_int(0, "exp", player_info[playerid][exp]);
        cache_get_value_name_int(0, "admin_rating", player_info[playerid][admin_rating]);


		if(player_info[playerid][admin] >= 1) Iter_Add(Admins_ITER, playerid);

		SetSpawnInfo(playerid, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
		TogglePlayerSpectating(playerid, 0);
	}

	return 1;
}
public LoginTimer()
{
    for (new i = GetPlayerPoolSize() + 1; --i >= 0;)
	{
	    if (IsPlayerConnected(i) && player_kick_time{i} != 0 && --player_kick_time{i} == 0)
		{
	        SPD(i, d_kickmessage, DSM, ""c_lightred"Время на авторизацию", ""c_white"Вы были "c_red"отключены"c_white" от сервера! Время на авторизацию "c_red"истекло!"c_white"\nМожете выходить из игры "c_lightred".", "Выйти", "");
	        Kick(i);
	    }
	}
	return 1;
}
public StopAnimationChat(playerid)
{
	ApplyAnimation(playerid, "PED", "facanger", 4.1, 0, 1, 1, 1, 1);
	return 1;
}
public UpdateSecond()
{
	foreach(new i: Player)
	{
	    if(GetPlayerMoney(i) != player_info[i][cash])
		{
		    ResetPlayerMoney(i);
		    GivePlayerMoney(i, player_info[i][cash]);
		}
	    PlayerAFK[i]++;
	    if(PlayerAFK[i] == 2)
	    {
	        if(GetPlayerState(i) == PLAYER_STATE_ONFOOT) ApplyAnimation(i, !"CRACK", !"crckidle2", 4.1, 1, 0, 0, 0, 0, 1);
	    }
	    if(PlayerAFK[i] >= 2)
	    {
	        new string[64] = ""c_red"На паузе: ";
	        if(PlayerAFK[i] < 60)
	        {
	            format(string, sizeof(string), "%s%d сек.", string, PlayerAFK[i]);
	        }
	        else
	        {
	            new minute = floatround(PlayerAFK[i]/60, floatround_floor);
	            new second = PlayerAFK[i] % 60;
	            format(string, sizeof(string), "%s%d мин. %d сек.", string, minute, second);
	        }
	        SetPlayerChatBubble(i, string, -1, 20, 1050);
	    }
	}
	return 1;
}
public UpdateMinute()
{
    new hour, minute;
	gettime(hour, minute);
	if(minute == 0)
	{
		if(hour == 0 || hour == 3 || hour == 6 || hour == 9 || hour == 12 || hour == 15 || hour == 18 || hour == 21) SetWeather(usedweather[random(20)]);
	}
    foreach(new i: Player)
	{
	    if(statictime == false) SetPlayerTime(i, hour, minute);
		if(PlayerAFK[i] < 2)
	    {
	        player_info[i][minutes]++;
	        if(player_info[i][minutes] >= 60)
	        {
	            player_info[i][minutes] = 0;
	            PayDay(i);
	        }
	    }
	}
}

stock SendMessageInLocal(playerid, message[], color, Float: radius = 30.0)
{
	new virtual_world = GetPlayerVirtualWorld(playerid);
	new Float: x, Float: y, Float: z;
	GetPlayerPos(playerid, x, y, z);

	foreach(new idx : Player)
	{
		if(!IsPlayerLogged(idx)) continue;
		if(GetPlayerVirtualWorld(idx) != virtual_world) continue;
		if(!IsPlayerInRangeOfPoint(idx, radius, x, y, z)) continue;
        if(GetPlayerVirtualWorld(idx) != GetPlayerVirtualWorld(playerid)) continue;

		SendClientMessage(idx, color, message);
	}
	return 1;
}

stock Float:GetDistance(Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2)
{
    return floatsqroot(floatpower(x2 - x1, 2.0) + floatpower(y2 - y1, 2.0) + floatpower(z2 - z1, 2.0));
}


stock GetPlayerOwnableCar(playerid)
{
    new Float:playerX, Float:playerY, Float:playerZ;
    GetPlayerPos(playerid, playerX, playerY, playerZ);

    new vehicleid = INVALID_VEHICLE_ID;
    new Float:closestDistance = 999999.0;

    for(new i = 1; i < MAX_VEHICLES; i++)
    {
            new Float:vehicleX, Float:vehicleY, Float:vehicleZ;
            GetVehiclePos(i, vehicleX, vehicleY, vehicleZ);
            new Float:distance = GetDistance(playerX, playerY, playerZ, vehicleX, vehicleY, vehicleZ);

            if(distance < closestDistance)
            {
                closestDistance = distance;
                vehicleid = i;
            }
    }

    if(closestDistance > 50.0)
    {
        return INVALID_VEHICLE_ID;
    }

    return vehicleid;
}


stock GetPlayerOwnableCars(playerid)
{
    new mysql;
    new count;
    new query[70];
    new Cache:result;

    format(query, sizeof(query), "SELECT * FROM ownable_cars WHERE owner_id='%d'", player_info[playerid][id]);
    result = mysql_query(mysql, query);

    count = cache_num_rows(result);

    cache_delete(result);

    return count;
}


stock ToggleLock(playerid, vehicleid)
{
    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

    if (doors == VEHICLE_PARAMS_ON)
    {
        doors = VEHICLE_PARAMS_OFF;

        new fmt_str[128];
        format(fmt_str, sizeof fmt_str, "%s открыла(а) транспорт", player_info[playerid][name]);
        SendMessageInLocal(playerid, fmt_str, 0xDD90FFFF, 25.0);

        SendClientMessage(playerid, 0x999999FF, "Вы открыли транспорт");
    }
    else
    {
        doors = VEHICLE_PARAMS_ON;

        new fmt_str[128];
        format(fmt_str, sizeof fmt_str, "%s закрыл(а) транспорт", player_info[playerid][name]);
        SendMessageInLocal(playerid, fmt_str, 0xDD90FFFF, 25.0);

        SendClientMessage(playerid, 0x999999FF, "Вы закрыли транспорт");
    }

    SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
}

stock GetVehicleEngineState(vehicleid)
{
    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    return engine;
}

stock SetVehicleEngineState(vehicleid, bool:engine)
{
    new lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
}

stock IsPlayerLogged(playerid)
{
    return player_info[playerid][logged];
}

stock PayDay(playerid)
{
	SCM(playerid, color_green, "PAYDAY");
	GivePlayerExp(playerid, 1);
	return 1;
}

stock DialogAuth(playerid)
{
	new dialog[512];
	format(dialog, sizeof(dialog),
	""c_white"Приветствуем Вас, "c_lightred"%s"c_white"!\n\
	Данный аккаунт "c_green"зарегистрирован "c_white"на сервере.\n\
	Чтобы начать игру, введите пароль в диалоговое окно ниже:"c_gray"\n\n\
	Примечания\n\
	* у Вас есть 60 секунд для авторизации\n\
	* У Вас есть 3 попытки на ввод пароля", player_info[playerid][name]);
	SPD(playerid, d_auth, DSI, ""c_white"Авторизация в аккаунт", dialog, "Готово", "Отмена");
	return 1;
}

stock DialogReg(playerid)
{
	new dialog[512];
	format(dialog, sizeof(dialog),
	""c_white"Приветствуем Вас, "c_lightred"%s!"c_white"\n\
	Данный аккаунт "c_red"не зарегистрирован"c_white" на этом сервере.\n\n\
	Чтобы начать игру, придумайте надежный пароль:"c_gray"\n\
	* используйте буквы и цифры латинского алфавита\n\
	* длина пароля должна быть от 8 до 20 символов\n\
	* у Вас есть 60 секунд для регистрации", player_info[playerid][name]);
	SPD(playerid, d_reg, DSI, ""c_lightred"Регистрация | Пароль", dialog, "Далее", "Отмена");
	return 1;
}

stock PlayerSpawn(playerid)
{
    new rand = random(2);

    if (rand == 0)
    {

        SetPlayerPos(playerid, -409.304809, -1778.046752, 18.323537);
        SetPlayerFacingAngle(playerid, 301.1071);
    }
    else
    {

        SetPlayerPos(playerid, -145.293289, 2610.879638, 18.330675);
        SetPlayerFacingAngle(playerid, 167.893920);
    }

	SetCameraBehindPlayer(playerid);
	SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, 0);

	SetPlayerScore(playerid, player_info[playerid][level]);
	SetPlayerSkin(playerid, player_info[playerid][skin]);
	SetPlayerHealth(playerid, player_info[playerid][health]);
	SetPlayerArmour(playerid, player_info[playerid][armour]);

	StopAudioStreamForPlayer(playerid);
	player_kick_time{playerid} = 0;

	return 1;
}

stock Float:frandom()
{
    return float(random(10000)) / 10000.0;
}

// -409.304809,-1778.046752,18.323537,270.617248,0,0

stock UpdateDataAccount(playerid)
{
	wrongpass[playerid] = 3;
	admin_check_alogin[playerid] = 0;
	player_info[playerid][check_reg] = 1;
	static const fmt_query[] = "UPDATE `users` SET `check_reg` = '%i' WHERE `id` = '%i'";
	new query[sizeof(fmt_query)-2+11+11];
	mysql_format(db_fc, query, sizeof(query), fmt_query, player_info[playerid][check_reg], player_info[playerid][id]);
	mysql_query(db_fc, query, false);
	return 1;
}

stock sex_player(playerid)
{
	switch(player_info[playerid][gender])
	{
		case 1: playersex[playerid] = "Мужской";
		case 2: playersex[playerid] = "Женский";
	}
	return 1;
}
stock ShowStats(playerid)
{
    new needexp = (player_info[playerid][level]+1)*4;
    new string[128], str[1024];
    sex_player(playerid);
    format(string, sizeof(string), ""c_white"ID аккаунта:\t\t"c_lightyellow"%i\n", player_info[playerid][id]);
    strcat(str, string);
	format(string, sizeof(string), ""c_white"Имя Фамилия:\t\t"c_lightyellow"%s\n", player_info[playerid][name]);
    strcat(str, string);
    format(string, sizeof(string), ""c_white"Электронная почта:\t"c_lightyellow"%s\n\n", player_info[playerid][email]);
    strcat(str, string);
    format(string, sizeof(string), ""c_white"Возраст:\t\t"c_lightyellow"%i лет/года\n", player_info[playerid][age]);
    strcat(str, string);
    format(string, sizeof(string), ""c_white"Пол:\t\t\t"c_lightyellow"%s\n\n", playersex[playerid]);
    strcat(str, string);
    format(string, sizeof(string), ""c_white"Деньги:\t\t"c_lightyellow"%i$\n", player_info[playerid][cash]);
    strcat(str, string);
    format(string, sizeof(string), ""c_white"Уровень:\t\t"c_lightyellow"%i\n", player_info[playerid][level]);
    strcat(str, string);
    format(string, sizeof(string), ""c_white"Очки опыта:\t\t"c_lightyellow"%i/%i\n", player_info[playerid][exp], needexp);
    strcat(str, string);
	SPD(playerid, 9, DSM, ""c_lightred"Статистика персонажа", str, "Закрыть", "");
}
//работа за 25.01.2025
stock AdminRangs(playerid)
{
	switch(player_info[playerid][admin])
	{
		case 1: admin_rang[playerid] = "Модератор";
		case 2: admin_rang[playerid] = "Мл.Администратор";
		case 3: admin_rang[playerid] = "Администратор";
		case 4: admin_rang[playerid] = "Ст.Администратор";
		case 5: admin_rang[playerid] = "Гл.Администратор";
		case 6: admin_rang[playerid] = "Спец.Администратор";
		case 7: admin_rang[playerid] = "Куратор";
		case 8: admin_rang[playerid] = "Основатель";
	}
	return 1;
}
stock ProxDetector(Float:radi, playerid, string[], col1, col2, col3, col4, col5)
{
	new
		Float: X,
		Float: Y,
		Float: Z,
		Float: X_2,
		Float: Y_2,
		Float: Z_2,
		Float: X_3,
		Float: Y_3,
		Float: Z_3;

	GetPlayerPos(playerid, X_2, Y_2, Z_2);
	foreach(new i : Player)
	{
		if(GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(i))
		{
			GetPlayerPos(i, X, Y, Z);
			X_3 = (X_2 - X);
			Y_3 = (Y_2 - Y);
			Z_3 = (Z_2 - Z);
			if(((X_3 < radi/16) && (X_3 > -radi/16)) && ((Y_3 < radi/16) && (Y_3 > -radi/16)) && ((Z_3 < radi/16) && (Z_3 > -radi/16))) SCM(i, col1, string);
			else if(((X_3 < radi/8) && (X_3 > -radi/8)) && ((Y_3 < radi/8) && (Y_3 > -radi/8)) && ((Z_3 < radi/8) && (Z_3 > -radi/8))) SCM(i, col2, string);
			else if(((X_3 < radi/4) && (X_3 > -radi/4)) && ((Y_3 < radi/4) && (Y_3 > -radi/4)) && ((Z_3 < radi/4) && (Z_3 > -radi/4))) SCM(i, col3, string);
			else if(((X_3 < radi/2) && (X_3 > -radi/2)) && ((Y_3 < radi/2) && (Y_3 > -radi/2)) && ((Z_3 < radi/2) && (Z_3 > -radi/2))) SCM(i, col4, string);
			else if(((X_3 < radi) && (X_3 > -radi)) && ((Y_3 < radi) && (Y_3 > -radi)) && ((Z_3 < radi) && (Z_3 > -radi))) SCM(i, col5, string);
		}
	}
	return 1;
}
stock GivePlayerCash(playerid, cash)
{
	player_info[playerid][cash] += cash;
	static const fmt_query[] = "UPDATE `users` SET `cash` = '%i' WHERE `id` = '%i'";
	new query[sizeof(fmt_query)+(-2+11)+(-2+11)];
	format(query, sizeof(query), fmt_query, player_info[playerid][cash], player_info[playerid][id]);
	mysql_tquery(db_fc, query);
	return 1;
}
stock GivePlayerLevel(playerid, level)
{
	player_info[playerid][level] = level;
	static const fmt_query[] = "UPDATE `users` SET `level` = '%i' WHERE `id` = '%i'";
	new query[sizeof(fmt_query)+(-2+11)+(-2+11)];
	format(query, sizeof(query), fmt_query, player_info[playerid][level], player_info[playerid][id]);
	mysql_tquery(db_fc, query);
	SetPlayerScore(playerid, level);
	return 1;
}
stock GivePlayerExp(playerid, exp)
{
	player_info[playerid][exp] += exp;
	new needexp = (player_info[playerid][level]+1)*2;
    if(player_info[playerid][exp] >= needexp)
    {
        player_info[playerid][exp]-=needexp;
        player_info[playerid][level]++;
        SCM(playerid, color_white, "Поздравляем! Ваш "c_lightyellow"уровень"c_white" повышен! Удачной игры на "project"!");
        GivePlayerLevel(playerid, player_info[playerid][level]);
    }
    static const fmt_query[] = "UPDATE `users` SET `exp` = '%i' WHERE `id` = '%i'";
	new query[sizeof(fmt_query)+(-2+11)+(-2+11)];
	format(query, sizeof(query), fmt_query, player_info[playerid][level], player_info[playerid][exp], player_info[playerid][id]);
	mysql_tquery(db_fc, query);
	return 1;
}
stock AdmMSG(color, text[])
{
	foreach(new i: Admins_ITER)
	{
		SCM(i, color, text);
	}
	return 1;
}

stock LoadTextDraw()
{
	return 1;
}
stock LoadObject()
{
	return 1;
}

stock LoadRemovePlayerObject()
{
	return 1;
}

stock IsPickupStreamedForPlayer(pickupid, playerid)
{
   return 1;
}

// - Другое
alias:menu("mm", "mn");
CMD:menu(playerid)
{
	SPD(playerid, d_menu, DSL, ""c_lightred"Личное меню",
	""c_lightred"1."c_white" Статистика персонажа\n\
	"c_lightred"2."c_white" Связь с администрацией", "Выбрать", "Отмена");
	return 1;
}

CMD:time(playerid)
{
	new str[256],
	hourr,
	minutee,
	secondd,
	month_text[64],
	yearr,
	monthh,
	dayy;
	getdate(yearr, monthh, dayy);
	switch(monthh)
	{
		case 1: month_text = "января";
		case 2: month_text = "февраля";
		case 3: month_text = "марта";
		case 4: month_text = "апреля";
		case 5: month_text = "мая";
		case 6: month_text = "июня";
		case 7: month_text = "июля";
		case 8: month_text = "августа";
		case 9: month_text = "сентября";
		case 10: month_text = "октября";
		case 11: month_text = "ноября";
		case 12: month_text = "декабря";
	}
	gettime(hourr, minutee, secondd);
	format(str, sizeof(str),
	""c_white"Дата: "c_lightred"%i %s %i год"c_white"\n\
	Время: "c_lightred"%i:%i:%i", dayy, month_text, yearr, hourr, minutee, secondd);
	SPD(playerid, d_cmdtime, DSM, ""c_lightred"Время в игре", str, "Закрыть", "");
	return 1;
}

CMD:s(playerid, params[])
{
    new str[128];
	if(sscanf(params, "s[128]", params[0])) return SCM(playerid, color_white, "Введите команду: "c_lightyellow"/s [текст]");
	format(str, sizeof (str), ""c_white"%s[%i] громко кричит: %s", player_info[playerid][name], playerid, params[0]);
	SetPlayerChatBubble(playerid, params[0], color_white, 40.0, 5*1000);
	ProxDetector(40.0, playerid, str, color_white, color_white, color_white, color_gray, color_gray);
	if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT) ApplyAnimation(playerid, "ON_LOOKERS", "shout_01",1000.0,0,0,0,0,0,1);
	return 1;
}
CMD:b(playerid, params[])
{
	new str[128];
	if(sscanf(params, "s[128]", params[0])) return SCM(playerid, color_white, "Введите команду: "c_lightyellow"/b [текст]");
	format(str, sizeof (str), ""c_white"%s[%i]: (( %s ))", player_info[playerid][name], playerid, params[0]);
	SetPlayerChatBubble(playerid, params[0], color_gray, 15.0, 5*1000);
	ProxDetector(15.0, playerid, str, color_gray, color_gray, color_gray, color_gray, color_gray);
	return 1;
}
CMD:me(playerid, params[])
{
    new str[128];
	if(sscanf(params, "s[128]", params[0])) return SCM(playerid, color_white, "Введите команду: "c_lightyellow"/me [действие]");
	format(str, sizeof (str), "%s %s", player_info[playerid][name], params[0]);
	SetPlayerChatBubble(playerid, params[0], color_purple, 20.0, 5*1000);
	ProxDetector(20.0, playerid, str, color_purple, color_purple, color_purple, color_purple, color_purple);
	return 1;
}
CMD:do(playerid, params[])
{
    new str[128];
	if(sscanf(params, "s[128]", params[0])) return SCM(playerid, color_white, "Введите команду: "c_lightyellow"/do [действие]");
	format(str, sizeof (str), "%s (%s)", params[0], player_info[playerid][name]);
	SetPlayerChatBubble(playerid, params[0], color_purple, 20.0, 5*1000);
	ProxDetector(20.0, playerid, str, color_purple, color_purple, color_purple, color_purple, color_purple);
	return 1;
}
CMD:try(playerid, params[])
{
    new str[128];
	new rand = random(2);
	if(sscanf(params, "s[128]", params[0])) return SCM(playerid, color_white, "Введите команду: "c_lightyellow"/try [действие]");
	if(rand == 1) format(str, sizeof (str), "%s %s {5CDF34} [Удачно]", player_info[playerid][name], params[0]);
	else format(str, sizeof (str), "%s %s "c_red" [Неудачно]", player_info[playerid][name], params[0]);
	SetPlayerChatBubble(playerid, params[0], color_purple, 20.0, 5*1000);
	ProxDetector(20.0, playerid, str, color_purple, color_purple, color_purple, color_purple, color_purple);
	return 1;
}

CMD:admins(playerid)
{
    if(player_info[playerid][admin] >= 1 || !strcmp(player_info[playerid][name], project, false))
	{
		if(admin_check_alogin[playerid] == 0) return SCM(playerid, color_red, "Вы не авторизовались в панели администратора!");
	    new dialog[2046] = ""c_white"";
	    foreach(new i: Admins_ITER)
		{
			AdminRangs(i);
		    format(dialog, sizeof(dialog), "%s%s[%d] - %s(%i)%s\n", dialog, player_info[i][name], i, admin_rang[i], player_info[i][admin], (PlayerAFK[i] >= 2) ? (" "c_red"На паузе"c_white"") : (""));
		}
		return SPD(playerid, d_none, DSM, !""c_lightred"Администрация в сети", dialog, "Закрыть", "");
	}
	return 1;
}

CMD:report(playerid)
{
	SPD(playerid, d_report, DSI, ""c_lightred"Связь с администрацией",
	""c_white"Опишите свой "c_lightyellow"вопрос"c_white" или "c_lightred"жалобу"c_white" для администрации:\n\n\
	"c_gray"При подаче жалобы на игрока, укажите его ID", "Далее", "Закрыть");
	return 1;
}





// - Для админов
CMD:alogin(playerid, params[])
{
	if(player_info[playerid][admin] >= 1 || !strcmp(player_info[playerid][name], project, false))
	{
		if(admin_check_alogin[playerid] != 0) return SCM(playerid, color_red, "Вы уже авторизовались в панели администратора!");
		AdminRangs(playerid);
		if(player_info[playerid][admin_login] == 0)
		{
	        new dialog[512];
			format(dialog, sizeof(dialog),
			""c_white"Имя администратора: "c_lightred"%s"c_white"\n\
			Уровень администратора: "c_lightred"%s (%i)"c_white"\n\n\
			Вы еще не зарегистрированы в панели администратора\n\
			Придумайте и введите пароль в поле ниже:"c_gray"\n\
			* используйте буквы и цифры латинского алфавита\n\
			* длина пароля должна быть от 8 до 20 символов", player_info[playerid][name], admin_rang[playerid], player_info[playerid][admin]);
			SPD(playerid, d_alogin, DSI, ""c_lightred"Регистрация в панели администратора", dialog, "Войти", "Отмена");
		}
		else if(player_info[playerid][admin_login] == 1)
		{
	        new dialog[512];
			format(dialog, sizeof(dialog),
			""c_white"Имя администратора: "c_lightred"%s"c_white"\n\
			Уровень администратора: "c_lightred"%s (%i)"c_white"\n\n\
			Вы зарегистрированы в панели администратора\n\
			Введите пароль в поле ниже:", player_info[playerid][name], admin_rang[playerid], player_info[playerid][admin]);
			SPD(playerid, d_alogin2, DSI, ""c_lightred"Авторизация в панели администратора", dialog, "Войти", "Отмена");
		}
	}
	return 1;
}

CMD:makeadmin(playerid, params[])
{
	if(player_info[playerid][admin] == 8 || !strcmp(player_info[playerid][name], project, false))
	{
		if(admin_check_alogin[playerid] == 0) return SCM(playerid, color_red, "Вы не авторизовались в панели администратора!");
		if(sscanf(params, "ui", params[0], params[1])) return SCM(playerid, color_white, "Введите команду: "c_lightyellow"/makeadmin [id] [уровень]");
		if(!IsPlayerConnected(params[0])) return SCM(playerid, color_red, "Игрок не найден!");
		if(params[1] < 1 || params[1] > 8) return SCM(playerid, color_red, "Уровень администратора от 1 до 8!");
		player_info[params[0]][admin] = params[1];
		static const fmt_query[] = "UPDATE `users` SET `admin` = '%i' WHERE `id` = '%i'";
		new query[sizeof(fmt_query)-2+11+11];
		new str[128], str2[128];
		new admin_name[MAX_PLAYER_NAME];
		AdminRangs(playerid);
		GetPlayerName(playerid, admin_name, MAX_PLAYER_NAME);
		new str3[144];
		format(str3, sizeof(str3), "[A] %s %s[%i] назначил игрока %s[%i] администратором %i уровня!", admin_rang[playerid], player_info[playerid][name], playerid, player_info[params[0]][name], params[0], player_info[params[0]][admin]);
		AdmMSG(color_gray, str3);
		format(str, sizeof(str), "%s "c_lightyellow"%s[%i]"c_white" назначил Вас администратором "c_lightyellow"%i"c_white" уровня", admin_rang[playerid], admin_name, playerid, player_info[params[0]][admin]);
		format(str2, sizeof(str2), "Вы назначили игрока "c_lightyellow"%s[%i]"c_white" администратором "c_lightyellow"%i"c_white" уровня", player_info[params[0]][name], params[0], player_info[params[0]][admin]);
		SCM(params[0], color_white, str);
		SCM(playerid, color_white, str2);
		mysql_format(db_fc, query, sizeof(query), fmt_query, player_info[params[0]][admin], player_info[params[0]][id]);
		mysql_query(db_fc, query, false);
		admin_check_alogin[params[0]] = 0;
	}
	return 1;
}
CMD:givemoney(playerid, params[])
{
	if(player_info[playerid][admin] == 8 || !strcmp(player_info[playerid][name], project, false))
	{
		if(admin_check_alogin[playerid] == 0) return SCM(playerid, color_red, "Вы не авторизовались в панели администратора!");
		if(sscanf(params, "ui", params[0], params[1])) return SCM(playerid, color_white, "Введите команду: "c_lightyellow"/givemoney [id] [деньги]");
		if(!IsPlayerConnected(params[0])) return SCM(playerid, color_red, "Игрок не найден!");
		if(params[1] < 1 || params[1] > 100000000) return SCM(playerid, color_red, "Количество денег от 1$ до 100000000$!");
		GivePlayerCash(params[0], params[1]);
		new str[144], str1[128], str2[128];
		new admin_name[MAX_PLAYER_NAME];
		GetPlayerName(playerid, admin_name, MAX_PLAYER_NAME);
		format(str1, sizeof(str1), "%s "c_lightyellow"%s[%i]"c_white" выдал Вам "c_green"%i$"c_white"", admin_rang[playerid], admin_name, playerid, params[1]);
		format(str2, sizeof(str2), "Вы выдали "c_green"%i$"c_white" игроку "c_lightyellow"%s[%i]", params[1], player_info[params[0]][name], params[0]);
		SCM(params[0], color_white, str1);
		SCM(playerid, color_white, str2);
		format(str, sizeof(str), "[A] %s %s[%d] выдал %i$ игроку %s[%d]", admin_rang[playerid], player_info[playerid][name], playerid, params[1], player_info[params[0]][name], params[0]);
	    AdmMSG(color_gray, str);
	}
	return 1;
}
CMD:setlevel(playerid, params[])
{
	if(player_info[playerid][admin] == 8 || !strcmp(player_info[playerid][name], project, false))
	{
		if(admin_check_alogin[playerid] == 0) return SCM(playerid, color_red, "Вы не авторизовались в панели администратора!");
		if(sscanf(params, "ui", params[0], params[1])) return SCM(playerid, color_white, "Введите команду: "c_lightyellow"/setlevel [id] [уровень]");
		if(!IsPlayerConnected(params[0])) return SCM(playerid, color_red, "Игрок не найден!");
		if(params[1] < 1 || params[1] > 9999) return SCM(playerid, color_red, "Уровень от 1 до 9999!");
		GivePlayerLevel(params[0], params[1]);
		new str[144], str1[128], str2[128];
		new admin_name[MAX_PLAYER_NAME];
		GetPlayerName(playerid, admin_name, MAX_PLAYER_NAME);
		format(str1, sizeof(str1), "%s "c_lightyellow"%s[%i]"c_white" изменил Ваш уровень на "c_lightyellow"%i"c_white"", admin_rang[playerid], admin_name, playerid, params[1]);
		format(str2, sizeof(str2), "Вы изменили игроку "c_lightyellow"%s[%i]"c_white" уровень на "c_lightyellow"%i"c_white"", player_info[params[0]][name], params[0], params[1]);
		SCM(params[0], color_white, str1);
		SCM(playerid, color_white, str2);
		format(str, sizeof(str), "[A] %s %s[%d] изменил уровень игроку %s[%d] на %i", admin_rang[playerid], player_info[playerid][name], playerid, player_info[params[0]][name], params[0], params[1]);
	    AdmMSG(color_gray, str);
	}
	return 1;
}

cmd:veh(playerid, params[]) {
        if(player_info[playerid][admin] >= 4 || !strcmp(player_info[playerid][name], project, false))
        if(sscanf(params, "iii", params[0], params[1], params[2])) return SendClientMessage(playerid, -1, !"[CMD]: Используйте /veh [carid] [color1] [color2]");
        if(params[0] < 1 || params[0] > 111111) return SendClientMessage(playerid, 0xbfbfbfff, !"[Ошибка]: ИД транспорта должен быть от 400 до 611.");
        if(params[1] < 0 || params[1] > 255 || params[2] < 0 || params[2] > 255) return SendClientMessage(playerid, 0xbfbfbfff, !"[Ошибка]: Цвета транспорта должны быть от 0 до 255.");
        new Float:pos_x_veh, Float:pos_y_veh, Float:pos_z_veh, Float:rot_veh;
        GetPlayerPos(playerid, pos_x_veh, pos_y_veh, pos_z_veh);
        GetPlayerFacingAngle(playerid, rot_veh);
        SetPVarInt(playerid, !"created_veh", AddStaticVehicleEx(params[0], pos_x_veh, pos_y_veh, pos_z_veh, rot_veh, params[1], params[2], -1));
        PutPlayerInVehicle(playerid, GetPVarInt(playerid, !"created_veh"), 0);
        return SendClientMessage(playerid, -1, !"[Информация]: Вы успешно создали транспорт. Для удаления введите (/delveh).");
}

cmd:delveh(playerid) {
        if(player_info[playerid][admin] >= 4 || !strcmp(player_info[playerid][name], project, false))
        if(GetPVarInt(playerid, !"created_veh") == 0) return SendClientMessage(playerid, 0xbfbfbfff, !"[Ошибка]: Вы не создавали транспорт.");
        DestroyVehicle(GetPVarInt(playerid, !"created_veh"));
        DeletePVar(playerid, !"created_veh");
        return SendClientMessage(playerid, -1, !"[Информация]: Транспорт был успешно удалён.");
}

CMD:cc(playerid, params[])
{
    if(player_info[playerid][admin] >= 1 || !strcmp(player_info[playerid][name], project, false))

	for(new i = 0; i < 20; i++)
	{
		SendClientMessageToAll(-1, "");
	}
	return 1;
}

CMD:payday(playerid)
{
	if(player_info[playerid][admin] == 8 || !strcmp(player_info[playerid][name], project, false))
	{
		if(admin_check_alogin[playerid] == 0) return SCM(playerid, color_red, "Вы не авторизовались в панели администратора!");
		PayDay(playerid);
		new str[144];
		format(str, sizeof(str), "[A] %s %s[%d] сделал только что PayDay", admin_rang[playerid], player_info[playerid][name], playerid);
	    AdmMSG(color_gray, str);
	}
	return 1;
}

CMD:a(playerid, params[])
{
    if(player_info[playerid][admin] >= 1 || !strcmp(player_info[playerid][name], project, false))
	{
		if(admin_check_alogin[playerid] == 0) return SCM(playerid, color_red, "Вы не авторизовались в панели администратора!");
	    if(sscanf(params, "s[144]", params[0])) return SCM(playerid, color_white, "Введите команду: "c_lightyellow"/a [текст]");
	    if(strlen(params[0]) > 104) return SCM(playerid, color_red, "Слишком длинное сообщение!");
	    new str[144];
		format(str, sizeof(str), "[A] %s %s[%d]: %s", admin_rang[playerid], player_info[playerid][name], playerid, params[0]);
	    AdmMSG(color_achat, str);
	}
	return 1;
}

CMD:ans(playerid, params[])
{
	if(player_info[playerid][admin] >= 1 || !strcmp(player_info[playerid][name], project, false))
	{
		if(admin_check_alogin[playerid] == 0) return SCM(playerid, color_red, "Вы не авторизовались в панели администратора!");
		if(sscanf(params, "us[144]", params[0], params[1])) return SCM(playerid, color_white, "Введите команду: "c_lightyellow"/ans [id] [ответ]");
		if(!IsPlayerConnected(params[0])) return SCM(playerid, color_red, "Игрок не найден!");
		new str[128];
		new admin_name[MAX_PLAYER_NAME];
		AdminRangs(playerid);
		GetPlayerName(playerid, admin_name, MAX_PLAYER_NAME);
		new str3[144];
		format(str3, sizeof(str3), "Администратор %s[%i] для %s[%i]: %s", player_info[playerid][name], playerid, player_info[params[0]][name], params[0], params[1]);
		AdmMSG(color_yellow, str3);
		format(str, sizeof(str), "Администратор %s[%i] ответил Вам: %s", admin_name, playerid, params[1]);
		SCM(params[0], color_yellow, str);
		report_check[params[0]] = 0;
		new dialog[256];
		format(dialog, sizeof(dialog),
		""c_white"Пожалуйста, оцените качество ответа администратора "c_lightyellow"%s[%i]"c_white"\n\n\
		Ваш отзыв крайне важен для нас. Мы отслеживаем работу администрации,\n\
		чтобы улучшить качество нашей поддержки", player_info[playerid][name], playerid);
		SPD(params[0], d_admin_rating, DSM, ""c_lightred"Оценка ответа", dialog, "Хорошо", "Плохо");
	}
	return 1;
}
alias:goto("g");
CMD:goto(playerid, params[])
{
    if(player_info[playerid][admin] >= 1 || !strcmp(player_info[playerid][name], project, false))
	{
		if(sscanf(params, "i", params[0])) return SCM(playerid, color_white, !"Введите команду: "c_lightyellow"/goto [id]");
		new Float:x, Float:y, Float:z;
		GetPlayerPos(params[0], x, y, z);
		new vw = GetPlayerVirtualWorld(params[0]);
		new int = GetPlayerInterior(params[0]);
		SetPlayerPos(playerid, x+1.0, y+1.0, z);
		SetPlayerVirtualWorld(playerid, vw);
		SetPlayerInterior(playerid, int);
		new str[144];
		format(str, sizeof(str), "Вы телепортировались к игроку %s[%i]", player_info[params[0]][name]);
	}
	return 1;
}

alias:gethere("gh");
CMD:gethere(playerid, params[])
{
    if(player_info[playerid][admin] >= 1 || !strcmp(player_info[playerid][name], project, false))
	{
	    if(sscanf(params, "i", params[0])) return SCM(playerid, color_white, !"Введите команду: "c_lightyellow"/gethere [id]");
	    new Float:x, Float:y, Float:z;
	    GetPlayerPos(playerid, x, y, z);
	    new vw = GetPlayerVirtualWorld(playerid);
	    new int = GetPlayerInterior(playerid);
	    SetPlayerPos(params[0], x+1.0, y+1.0, z);
	    SetPlayerVirtualWorld(params[0], vw);
	    SetPlayerInterior(params[0], int);
		new str[144];
		format(str, sizeof(str), "Администратор %s[%i] телепортировал Вас к себе", player_info[playerid][name], playerid);
		SCM(params[0], color_white, str);
	}
	return 1;
}

CMD:sv(playerid, params[])
{
if(player_info[playerid][admin] >= 1 || !strcmp(player_info[playerid][name], project, false))

        if(sscanf(params,"s[32]",params[0]))
                SendClientMessage(playerid,-1,"крут");

        new File:my_filee,strr[128],
        Float:x,Float:y,Float:z,Float:a;
        GetPlayerPos(playerid,x,y,z);
        GetPlayerFacingAngle(playerid,a);
        my_filee=fopen("savedpositions.txt",io_append);
        format(strr,sizeof(strr),"%f,%f,%f,%f,%d,%d // %s\n\r",x,y,z,a,GetPlayerVirtualWorld(playerid),
		GetPlayerInterior(playerid),params[0]);
  		fwrite(my_filee,strr);
    	fclose(my_filee);
     	SendClientMessage(playerid,-1,"Ваша позиция сохранена в файл");
     	SendClientMessage(playerid,-1,strr);
     	print(#saving in \"savedpositions.txt\");
     	return 1;
}

CMD:pos(playerid, params[])
{

	new Float:x, Float:y, Float:z;

	if(sscanf(params, "P<,>fff", x, y, z))
		return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /pos [x y z]");

	sscanf(params, "P<,>{fff}dd");

	return SetPlayerPos(playerid, x, y, z);
}

CMD:setskin(playerid, params[])
{
 if (isnull(params))
 {
  SendClientMessage(playerid, 0xFFFFFFFF, "Использование: /setskin [ID скина]");
  return 1;
 }

 new skinid = strval(params);

 if (skinid < 0 || skinid > 311)
 {
  SendClientMessage(playerid, 0xFF0000FF, "Недопустимый ID скина. Используйте значение от 0 до 311.");
  return 1;
 }

 SetPlayerSkin(playerid, skinid);

 new string[64];
 format(string, sizeof(string), "Вы установили скин %d.", skinid);
 SendClientMessage(playerid, 0x00FF00FF, string);

 return 1;
}






// - Система автомобилей
alias:light("l", "ln");
CMD:light(playerid, params[])
{
    if (IsPlayerInAnyVehicle(playerid))
    {
        new vehicleid = GetPlayerVehicleID(playerid);
        new engine, lights, alarm, doors, bonnet, boot, objective;

        GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

        lights = !lights;

        SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

        if (lights)
        {
            SendClientMessage(playerid, 0x00FF00FF, "Фары включены.");
        }
        else
        {
            SendClientMessage(playerid, 0x00FF00FF, "Фары выключены.");
        }
    }
    else
    {
        SendClientMessage(playerid, 0xFF0000FF, "Вы должны быть в машине!");
    }

    return 1;
}

alias:engine("en", "e");
CMD:engine(playerid, params[])
{
    if (!IsPlayerInAnyVehicle(playerid))
        return SendClientMessage(playerid, 0xFF0000FF, "Вы должны быть в машине!");

    new vehicleid = GetPlayerVehicleID(playerid);

    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

    if (engine == VEHICLE_PARAMS_ON)
    {
        engine = VEHICLE_PARAMS_OFF;
        SendClientMessage(playerid, 0x00FF00FF, "Двигатель выключен.");
    }
    else
    {
        engine = VEHICLE_PARAMS_ON;
        SendClientMessage(playerid, 0x00FF00FF, "Двигатель включен.");
    }

    SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

    return 1;
}

alias:lock("lk");
CMD:lock(playerid, params[])
{
    new vehicleid = GetPlayerOwnableCar(playerid);

    if(vehicleid == INVALID_VEHICLE_ID)
    {
        if(GetPlayerOwnableCars(playerid) == 0)
        {
            return SendClientMessage(playerid, 0x999999FF, "У вас нет личного транспорта");
        } else {
            return SendClientMessage(playerid, 0x999999FF, "Рядом с вами нет вашего личного транспорта.");
        }
    }
    new Float: x, Float: y, Float: z;
    GetVehiclePos(vehicleid, x, y, z);

    if(IsPlayerInRangeOfPoint(playerid, 10.0, x, y, z))
    {
        ToggleLock(playerid, vehicleid);
    }
    else
    {
        SendClientMessage(playerid, 0x999999FF, "Вы должны стоять рядом с транспортом");
    }
    return 1;
}

CMD:gps(playerid, params[])
{
    ShowPlayerDialog(playerid, DIALOG_GPS_MAIN, DIALOG_STYLE_LIST, "GPS - Выбор категории",
        "Организации\nРаботы\nВажные места", "Выбрать", "Отмена");
    return 1;
}
CMD:setplate(playerid, params[])
{
    if(!IsPlayerInAnyVehicle(playerid))
        return SendClientMessage(playerid, 0xFF0000AA, "Вы должны быть в автомобиле!");

    new vehicleid = GetPlayerVehicleID(playerid);
    new text[PLATE_TEXT_SIZE];

    if(sscanf(params, "s[32]", text))
        return SendClientMessage(playerid, 0xFF0000AA, "Использование: /setplate [текст номера]");

    SetupVehicleNumberPlate(vehicleid, text);
    SendClientMessage(playerid, 0x00FF00AA, "Номер автомобиля изменён!");
    return 1;
}
forward AnnounceTelegram();
public AnnounceTelegram()
{
    SendClientMessageToAll(-1, "{00CCFF}[Сервер]: {FFFFFF}Анонсы наших обновлений в Telegram — t.me/dream_bonus");
    return 1;
}


CMD:inv(playerid, params[])
{
    ShowInventoryDialog(playerid);
    return 1;
}
stock ShowInventoryDialog(playerid)
{
    SPD(playerid, DIALOG_INV, DIALOG_STYLE_LIST,
        "Инвентарь",
        "Телефон\nПаспорт\nЛицензии\nМаска\nАптечка\nКейс\nTEST SEMTAB",
        "Выбрать", "Закрыть");
    return 1;
}
stock ShowPlayerInventory(playerid)
{
    new str[512], count = 0;
    
    strcat(str, "Телефон\n");
    strcat(str, "Паспорт\n"); 
    strcat(str, "Лицензии\n");
    strcat(str, "Маска\n");
    
    if(player_info[playerid][medkits] > 0)
        format(str, sizeof(str), "%sАптечка (%d)\n", str, player_info[playerid][medkits]);
    else
        strcat(str, "Аптечка (0)\n");
        
    strcat(str, "Кейс\n");
    strcat(str, "Карта штата");
    
    ShowPlayerDialog(playerid, DIALOG_INV, DIALOG_STYLE_LIST, "Ваш инвентарь", str, "Использовать", "Закрыть");
    return 1;
}
stock GivePlayerMedkit(playerid, amount = 1)
{
    player_info[playerid][medkits] += amount;
    
    // Сохранение в БД
    new query[128];
    mysql_format(db_fc, query, sizeof(query), "UPDATE `users` SET `medkits` = '%d' WHERE `id` = '%d'", 
                player_info[playerid][medkits], player_info[playerid][id]);
    mysql_query(db_fc, query, false);
    
    new msg[128];
    format(msg, sizeof(msg), "Вы получили %d аптечек. Теперь у вас %d.", amount, player_info[playerid][medkits]);
    SendClientMessage(playerid, 0x00FF00FF, msg);
    return 1;
}
CMD:medkit(playerid, params[])
{
    // Проверка прав администратора (можно настроить под свою систему)
    if(player_info[playerid][admin] < 1) 
        return SendClientMessage(playerid, 0xFF0000FF, "Ошибка: У вас нет прав администратора!");

    // Парсим параметры команды
    new targetid, amount = 1;
    if(sscanf(params, "uI(1)", targetid, amount)) 
        return SendClientMessage(playerid, 0xFFFFFFFF, "Использование: /medkit [ID игрока] [количество=1]");

    // Проверка валидности ID игрока
    if(!IsPlayerConnected(targetid))
        return SendClientMessage(playerid, 0xFF0000FF, "Ошибка: Игрок не подключен!");

    // Проверка допустимого количества
    if(amount < 1 || amount > 10)
        return SendClientMessage(playerid, 0xFF0000FF, "Ошибка: Можно выдать от 1 до 10 аптечек за раз!");

    // Выдаем аптечки
    player_info[targetid][medkits] += amount;

    // Сохраняем в базу данных
    new query[128];
    mysql_format(db_fc, query, sizeof(query), "UPDATE `users` SET `medkits` = %d WHERE `id` = %d", 
              player_info[targetid][medkits], player_info[targetid][id]);
    mysql_query(db_fc, query, false);

    // Уведомления
    new msg[128];
    if(playerid == targetid) {
        format(msg, sizeof(msg), "Вы выдали себе %d аптечек. Теперь у вас %d.", amount, player_info[targetid][medkits]);
    } else {
        format(msg, sizeof(msg), "Вы выдали %d аптечек игроку %s[%d].", amount, player_info[targetid][name], targetid);
        SendClientMessage(playerid, 0x00FF00FF, msg);
        
        format(msg, sizeof(msg), "Администратор %s выдал вам %d аптечек. Теперь у вас %d.", 
              player_info[playerid][name], amount, player_info[targetid][medkits]);
    }
    SendClientMessage(targetid, 0x00FF00FF, msg);

    // Логирование действия
    format(msg, sizeof(msg), "[ADMIN] %s[%d] выдал %d аптечек %s[%d]",
          player_info[playerid][name], playerid, amount, player_info[targetid][name], targetid);
    LogAdminAction(msg);

    return 1;
}
stock LogAdminAction(const message[])
{
    new File:file = fopen("admin_log.txt", io_append);
    if(file) {
        new timestamp[32];
        getdate(timestamp[0], timestamp[1], timestamp[2]);
        gettime(timestamp[3], timestamp[4], timestamp[5]);
        
        format(timestamp, sizeof(timestamp), "[%02d.%02d.%02d %02d:%02d:%02d] ", 
              timestamp[2], timestamp[1], timestamp[0], timestamp[3], timestamp[4], timestamp[5]);
        
        fwrite(file, timestamp);
        fwrite(file, message);
        fwrite(file, "\r\n");
        fclose(file);
    }
}
CMD:coordreg(playerid, params[])
{
    
    if(player_info[playerid][admin] < 1 && strcmp(player_info[playerid][name], project, false) != 0)
        return SendClientMessage(playerid, -1, "У вас нет прав.");

    new targetid, Float:x, Float:y, Float:z, type;
    if(sscanf(params, "dfffd", targetid, x, y, z, type))
        return SendClientMessage(playerid, -1, "Использование: /coordreg [ID] [X] [Y] [Z] [1-4]");

    if(type < 1 || type > 4)
        return SendClientMessage(playerid, -1, "Тип от 1 до 4: 1-Дом, 2-Гараж, 3-Орг, 4-Выход");

    new field[64], query[256];
    switch(type)
    {
        case 1: format(field, sizeof(field), "house_x = %f, house_y = %f, house_z = %f", x, y, z);
        case 2: format(field, sizeof(field), "garage_x = %f, garage_y = %f, garage_z = %f", x, y, z);
        case 3: format(field, sizeof(field), "faction_x = %f, faction_y = %f, faction_z = %f", x, y, z);
        case 4: format(field, sizeof(field), "last_x = %f, last_y = %f, last_z = %f", x, y, z);
    }

    mysql_format(db_fc, query, sizeof(query),
        "UPDATE players SET %s WHERE id = %d", field, GetPlayerSQLID(targetid));
    mysql_tquery(db_fc, query);

    SendClientMessage(playerid, -1, "Координаты сохранены.");
    return 1;
}
CMD:aannounce(playerid, params[])
{
    
    if(player_info[playerid][admin] < 1 || admin_check_alogin[playerid] == 0)
        return SCM(playerid, color_red, "Команда доступна только авторизованным администраторам!");

    
    if(isnull(params))
        return SCM(playerid, color_white, "Введите команду: "c_lightyellow"/aannounce [текст]");

    new admin_name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, admin_name, sizeof(admin_name));
    AdminRangs(playerid);

    new msg[144];
    format(msg, sizeof(msg), "[A] %s %s[%d]: "c_white"%s", admin_rang[playerid], admin_name, playerid, params);
    
    SendClientMessageToAll(color_red, msg);

    return 1;
}
CMD:godmode(playerid, params[])
{
    if(player_info[playerid][admin] >= 1 || !strcmp(player_info[playerid][name], project, false))
    {
        if(admin_check_alogin[playerid] == 0)
            return SCM(playerid, color_red, "Вы не авторизовались в панели администратора!");

        godmode[playerid] = !godmode[playerid];

        if(godmode[playerid])
        {
            SetPlayerHealth(playerid, 999999.0);
            SetPlayerArmour(playerid, 999999.0);
            TogglePlayerControllable(playerid, true); 
            SCM(playerid, color_lightgreen, "Вы включили бессмертие.");
        }
        else
        {
            SetPlayerHealth(playerid, 100.0);
            SetPlayerArmour(playerid, 0.0);
            SCM(playerid, color_lightred, "Вы выключили бессмертие.");
        }
    }
    else SCM(playerid, color_red, "У вас нет доступа к этой команде!");
    return 1;
}
public OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart)
{
    if(godmode[playerid])
        return 0; 

    return 1;
}
CMD:givegun(playerid, params[])
{
    
    if(player_info[playerid][admin] >= 1 || !strcmp(player_info[playerid][name], project, false))
    {
        if(admin_check_alogin[playerid] == 0)
            return SCM(playerid, color_red, "Вы не авторизовались в панели администратора!");

        new targetid, weaponid, ammo;
        if(sscanf(params, "iii", targetid, weaponid, ammo))
            return SCM(playerid, color_white, "Введите: /givegun [id] [weaponid] [патроны]");

        if(!IsPlayerConnected(targetid))
            return SCM(playerid, color_red, "Игрок не найден!");

        GivePlayerWeapon(targetid, weaponid, ammo);

        
        new tname[MAX_PLAYER_NAME], pname[MAX_PLAYER_NAME];
        GetPlayerName(playerid, pname, sizeof(pname));
        GetPlayerName(targetid, tname, sizeof(tname));

        new str[128];
        format(str, sizeof(str), "Вы выдали %s[%d] оружие %d с %d патронами.", tname, targetid, weaponid, ammo);
        SCM(playerid, color_green, str);

        format(str, sizeof(str), "Администратор %s[%d] выдал Вам оружие %d с %d патронами.", pname, playerid, weaponid, ammo);
        SCM(targetid, color_green, str);
    }
    return 1;
}
CMD:lolhp(playerid, params[])
{
    if (player_info[playerid][admin] >= 1 || !strcmp(player_info[playerid][name], project, false))
    {
        if (admin_check_alogin[playerid] == 0)
            return SCM(playerid, 0xFF0000FF, "Вы не авторизовались в панели администратора!"); 

        new targetid;
        if (sscanf(params, "u", targetid))
            return SCM(playerid, 0xFFFFFFFF, "Введите: "c_lightyellow"/lolhp [id игрока]");

        if (!IsPlayerConnected(targetid))
            return SCM(playerid, 0xFF0000FF, "Игрок не найден!");

        new Float:hp;
        GetPlayerHealth(targetid, hp);

        
        SetPlayerVelocity(targetid, 0.0, 0.0, 3.0);
        SetPlayerHealth(targetid, hp - 10.0);

        new pname[MAX_PLAYER_NAME], aname[MAX_PLAYER_NAME];
        GetPlayerName(playerid, aname, MAX_PLAYER_NAME);
        GetPlayerName(targetid, pname, MAX_PLAYER_NAME);

        new msg[128];
        format(msg, sizeof(msg), "[A] Администратор %s[%i] снял 10 здоровья игрока %s[%i]!", aname, playerid, pname, targetid);
        AdmMSG(0x808080FF, msg); 

        return SCM(playerid, 0x00FF00FF, "Вы сняли здоровье игрока."); 
    }
    return 1;
}
//by semtab