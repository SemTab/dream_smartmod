
#define PACKET_CUSTOMRPC    			        251
			
#define RPC_SHOW_SPAWN_SELECTOR_WINDOW  0x24
#define RPC_SHOW_FUEL_STATION 0x88
#define RPC_SHOW_CAR 0x50
#define RPC_ADMIN_SPEC 0x43
#define RPC_SPEC_NAME 0x44
#define RPC_SHOW_PERSON 0x90
#define RPC_HIDE_PERSON 0x91
#define RPC_SHOW_RECON 0x92
#define RPC_HIDE_RECON 0x93
#define RPC_SHOW_TAXI 0x50
#define RPC_SHOW_FAMILY 0x51
#define RPC_SHOW_INFOFAM 0x52
#define RPC_SHOW_ULUCFAM 0x53
#define RPC_AUTO_SHOP 0x54
#define RPC_UPD_SHOP 0x55
#define RPC_HIDE_AUTO 0x200
#define RPC_SHOW_PASS 0x77
#define RPC_SHOW_SHOP 0x78
#define RPC_HIDE_SHOP 0x79


#define MAX_STREAM_SOURCES				1000




stock ShowFuelStation(playerid, type, price1, price2, price3, price4, price5, maxCount)
{
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, RPC_SHOW_FUEL_STATION);

    BS_WriteValue(bitstream, PR_INT32, type);
    BS_WriteValue(bitstream, PR_INT32, price1);
    BS_WriteValue(bitstream, PR_INT32, price2);
    BS_WriteValue(bitstream, PR_INT32, price3);
    BS_WriteValue(bitstream, PR_INT32, price4);
    BS_WriteValue(bitstream, PR_INT32, price5);
    BS_WriteValue(bitstream, PR_INT32, maxCount);

    PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);

    BS_Delete(bitstream);

    return true;
}

stock ShowSpawnSelectorForPlayer(playerid, isHouse, isFraction)
{
	SendCustomRPC(playerid, RPC_SHOW_SPAWN_SELECTOR_WINDOW, isHouse, isFraction);
}

stock ShowCar(playerid, id, const name[])
{
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, RPC_SHOW_CAR);
    
    BS_WriteValue(bitstream, PR_INT32, id);
	BS_WriteValue(bitstream, PR_UINT16, strlen(name));
	BS_WriteValue(bitstream, PR_STRING, name);
    PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);

    BS_Delete(bitstream);

    return true;
}

stock ShowSpec(playerid, toplayer)
{
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, RPC_ADMIN_SPEC);

	BS_WriteValue(bitstream, PR_INT32, toplayer);
    PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);

    BS_Delete(bitstream);

    return true;
}

stock ShowName(playerid, const player_name[])
{
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, RPC_SPEC_NAME);

	BS_WriteValue(bitstream, PR_UINT16, strlen(player_name));
	BS_WriteValue(bitstream, PR_STRING, player_name);
    PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);

    BS_Delete(bitstream);

    return true;
}

stock ShowPerson(playerid)
{
    SendCustomRPC(playerid, RPC_SHOW_PERSON);
}

stock HidePerson(playerid)
{ 
    SendCustomRPC(playerid, RPC_HIDE_PERSON);
}

stock ShowRecon(playerid, const name[], toplayer)
{
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, RPC_SHOW_RECON);

	BS_WriteValue(bitstream, PR_UINT16, strlen(name));
	BS_WriteValue(bitstream, PR_STRING, name);

    BS_WriteValue(bitstream, PR_INT32, toplayer);
    PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);

    BS_Delete(bitstream);

    return true;
}

stock HideRecon(playerid)
{
    SendCustomRPC(playerid, RPC_HIDE_RECON);
}

stock ShowTaxi(playerid, id, num, cash, price, rast)
{
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, RPC_SHOW_TAXI);

    BS_WriteValue(bitstream, PR_INT32, id);
    BS_WriteValue(bitstream, PR_INT32, num);
    BS_WriteValue(bitstream, PR_INT32, cash);
    BS_WriteValue(bitstream, PR_INT32, price);
    BS_WriteValue(bitstream, PR_INT32, rast);

    PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);

    BS_Delete(bitstream);

    return true;
}

stock ShowFamily(playerid, const name[], num, num2)
{
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, RPC_SHOW_FAMILY);

	BS_WriteValue(bitstream, PR_UINT16, strlen(name));
	BS_WriteValue(bitstream, PR_STRING, name);

    BS_WriteValue(bitstream, PR_INT32, num);
    BS_WriteValue(bitstream, PR_INT32, num2);
    PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);

    BS_Delete(bitstream);

    return true;
}

stock ShowInfoFam(playerid, const name[], const statys[], repa, colivo, lvl1, lvl2, lvl3, cash, mater, masks, fuels, ammos, armors)
{
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, RPC_SHOW_INFOFAM);

	BS_WriteValue(bitstream, PR_UINT16, strlen(name));
	BS_WriteValue(bitstream, PR_STRING, name);

    BS_WriteValue(bitstream, PR_UINT16, strlen(statys));
	BS_WriteValue(bitstream, PR_STRING, statys);

    BS_WriteValue(bitstream, PR_INT32, repa);
    BS_WriteValue(bitstream, PR_INT32, colivo);
    BS_WriteValue(bitstream, PR_INT32, lvl1);
    BS_WriteValue(bitstream, PR_INT32, lvl2);
    BS_WriteValue(bitstream, PR_INT32, lvl3);
    BS_WriteValue(bitstream, PR_INT32, cash);
    BS_WriteValue(bitstream, PR_INT32, mater);
    BS_WriteValue(bitstream, PR_INT32, masks);
    BS_WriteValue(bitstream, PR_INT32, fuels);
    BS_WriteValue(bitstream, PR_INT32, ammos);
    BS_WriteValue(bitstream, PR_INT32, armors);
    PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);

    BS_Delete(bitstream);

    return true;
}

stock ShowUluc(playerid, lvl1, lvl2, lvl3, cash, maxcash, mats, mask, fuels, ammos, puples)
{
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, RPC_SHOW_ULUCFAM);

    BS_WriteValue(bitstream, PR_INT32, lvl1);
    BS_WriteValue(bitstream, PR_INT32, lvl2);
    BS_WriteValue(bitstream, PR_INT32, lvl3);
    BS_WriteValue(bitstream, PR_INT32, cash);
    BS_WriteValue(bitstream, PR_INT32, maxcash);
    BS_WriteValue(bitstream, PR_INT32, mats);
    BS_WriteValue(bitstream, PR_INT32, mask);
    BS_WriteValue(bitstream, PR_INT32, fuels);
    BS_WriteValue(bitstream, PR_INT32, ammos);
    BS_WriteValue(bitstream, PR_INT32, puples);
    PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);

    BS_Delete(bitstream);

    return true;
}

stock HideAuto(playerid)
{
	new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, RPC_HIDE_AUTO);

    PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);

    BS_Delete(bitstream);

    return true;
}

stock ShowAuto(playerid)
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_AUTO_SHOP);

	PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);

	BS_Delete(bitstream);

	return 1;
}

stock UpdateAuto(playerid, const name[], price, count, maxspeed, acceleration, gear)
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_UPD_SHOP);

	BS_WriteValue(bitstream, PR_UINT8, strlen(name));
    BS_WriteValue(bitstream, PR_STRING, name);

	BS_WriteValue(bitstream, PR_UINT32, price);
	BS_WriteValue(bitstream, PR_UINT32, count);

	BS_WriteValue(bitstream, PR_FLOAT, maxspeed);
	BS_WriteValue(bitstream, PR_FLOAT, acceleration);

	BS_WriteValue(bitstream, PR_UINT32, gear);

	PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);

	BS_Delete(bitstream);
}

stock ShowPass(playerid, lvvl, prem, lvlstand)
{
   new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, RPC_SHOW_PASS);

    BS_WriteValue(bitstream, PR_UINT32, lvvl);
    BS_WriteValue(bitstream, PR_BOOL, prem);
    BS_WriteValue(bitstream, PR_UINT32, lvlstand);
    PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);

    BS_Delete(bitstream);

    return true;
}

stock ShowShop(playerid, price)
{
   new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, RPC_SHOW_SHOP);

    BS_WriteValue(bitstream, PR_UINT32, price);
    PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);

    BS_Delete(bitstream);

    return true;
}
stock HideShop(playerid)
{
    SendCustomRPC(playerid, RPC_HIDE_SHOP);
}